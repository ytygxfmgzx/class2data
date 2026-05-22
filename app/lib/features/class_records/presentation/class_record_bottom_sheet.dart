import 'dart:io';

import 'package:class2data/core/result/result.dart';
import 'package:class2data/data/database/app_database.dart';
import 'package:class2data/domain/services/credit_balance_service.dart';
import 'package:class2data/domain/services/default_value_service.dart';
import 'package:class2data/domain/services/package_selection_service.dart';
import 'package:class2data/domain/services/schedule_occurrence_service.dart';
import 'package:class2data/features/attachments/providers/attachment_providers.dart';
import 'package:class2data/features/packages/providers/package_providers.dart';
import 'package:class2data/shared/providers/database_provider.dart';
import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

/// 记录上课底部弹层。
///
/// 从首页点击待处理课程弹出，快速完成记录。
class ClassRecordBottomSheet extends ConsumerStatefulWidget {
  final ScheduleOccurrence occurrence;

  const ClassRecordBottomSheet({super.key, required this.occurrence});

  @override
  ConsumerState<ClassRecordBottomSheet> createState() =>
      _ClassRecordBottomSheetState();
}

class _ClassRecordBottomSheetState
    extends ConsumerState<ClassRecordBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _creditsController = TextEditingController();
  final _notesController = TextEditingController();

  String _status = 'attended';
  int? _selectedPackageId;
  bool _isLoading = false;
  final List<String> _pendingPhotos = [];

  late String _classDate;
  late String _startTime;
  late String _endTime;
  int? _defaultDurationMinutes;

  static const _statusOptions = [
    ('attended', '已上课'),
    ('leave', '请假'),
    ('cancelled', '取消'),
    ('absent', '缺课'),
    ('makeup', '补课'),
  ];

  static const _statusColors = <String, ({Color fg, Color bg})>{
    'attended': (fg: Color(0xFF52C41A), bg: Color(0xFFF6FFED)),
    'leave': (fg: Color(0xFF999999), bg: Color(0x00000000)),
    'cancelled': (fg: Color(0xFF999999), bg: Color(0x00000000)),
    'absent': (fg: Color(0xFFF5222D), bg: Color(0xFFFFF1F0)),
    'makeup': (fg: Color(0xFF1890FF), bg: Color(0xFFE6F7FF)),
  };

  static const _statusIcons = <String, IconData>{
    'attended': Icons.check_circle_outline,
    'leave': Icons.pause_circle_outline,
    'cancelled': Icons.cancel_outlined,
    'absent': Icons.error_outline,
    'makeup': Icons.replay_circle_filled_outlined,
  };

  bool get _shouldDeductCredits =>
      _status == 'attended' || _status == 'makeup' || _status == 'absent';

  @override
  void initState() {
    super.initState();
    _classDate = widget.occurrence.date;
    _startTime = widget.occurrence.startTime;
    _endTime = widget.occurrence.endTime;
    _loadDefaults();
  }

  static String _computeEndTimeFromStart(
    String startTime,
    int durationMinutes,
  ) {
    final start = _parseTime(startTime);
    if (start == null) return startTime;
    final end = start.add(Duration(minutes: durationMinutes));
    return DateFormat('HH:mm').format(end);
  }

  static TimeOfDay? _parseTimeOfDay(String hhmm) {
    final parts = hhmm.split(':');
    if (parts.length != 2) return null;
    return TimeOfDay(
      hour: int.tryParse(parts[0]) ?? 0,
      minute: int.tryParse(parts[1]) ?? 0,
    );
  }

  static DateTime? _parseTime(String hhmm) {
    final tod = _parseTimeOfDay(hhmm);
    if (tod == null) return null;
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
  }

  Future<void> _loadDefaults() async {
    final courseId = widget.occurrence.kidCourseId;

    // 获取课程信息
    final courseRepo = ref.read(kidCourseRepositoryProvider);
    final courseResult = await courseRepo.getById(courseId);
    final course = switch (courseResult) {
      Ok(:final value) => value,
      Err() => null,
    };
    if (course == null || !mounted) return;

    // 获取历史上课记录
    final recordRepo = ref.read(classRecordRepositoryProvider);
    final recordsResult = await recordRepo.getByCourseId(courseId);
    final records = switch (recordsResult) {
      Ok(:final value) => value,
      Err() => <ClassRecord>[],
    };

    // 获取可用课包
    final packageRepo = ref.read(packageRepositoryProvider);
    final packagesResult = await packageRepo
        .watchActiveByCourseId(courseId)
        .first;
    final packages = switch (packagesResult) {
      Ok(:final value) => value,
      Err() => <Package>[],
    };

    // 查询每个课包的余额
    final creditRepo = ref.read(creditTransactionRepositoryProvider);
    final packageBalances = <int, int>{};
    for (final p in packages) {
      if (p.totalCredits != null) {
        final txResult = await creditRepo.getByPackageId(p.id);
        final txs = switch (txResult) {
          Ok(:final value) => value,
          Err() => <CreditTransaction>[],
        };
        packageBalances[p.id] = CreditBalanceService().packageBalance(txs);
      }
    }

    // 默认值
    final defaults = DefaultValueService().getDefaults(
      historyRecords: records,
      course: course,
      classType: widget.occurrence.classType,
    );

    // 课包推荐
    final recommendedPkg = PackageSelectionService().recommendPackage(
      packages: packages,
      classRecords: records,
      classDate: widget.occurrence.date,
      packageBalances: packageBalances,
    );

    if (mounted) {
      setState(() {
        if (defaults.creditUnitsCost != null) {
          _creditsController.text = CreditBalanceService().formatCredits(
            defaults.creditUnitsCost!,
          );
        }
        if (defaults.durationMinutes != null) {
          _defaultDurationMinutes = defaults.durationMinutes;
          _endTime = _computeEndTimeFromStart(
            _startTime,
            defaults.durationMinutes!,
          );
        }
        _selectedPackageId = recommendedPkg ?? defaults.packageId;
      });
    }
  }

  @override
  void dispose() {
    _creditsController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final now = DateTime.now();
    final repo = ref.read(classRecordRepositoryProvider);
    final isManual = widget.occurrence.scheduleId <= 0;

    int? creditUnitsCost;
    if (_creditsController.text.trim().isNotEmpty && _shouldDeductCredits) {
      creditUnitsCost = (double.parse(_creditsController.text.trim()) * 100)
          .round();
    } else if (!_shouldDeductCredits) {
      creditUnitsCost = 0;
    }

    int? durationMinutes;
    final startDt = _parseTime(_startTime);
    final endDt = _parseTime(_endTime);
    if (startDt != null && endDt != null) {
      durationMinutes = endDt.difference(startDt).inMinutes;
      if (durationMinutes < 0) durationMinutes += 24 * 60;
    }

    final record = ClassRecordsCompanion(
      kidCourseId: Value(widget.occurrence.kidCourseId),
      scheduleId: isManual
          ? const Value.absent()
          : Value(widget.occurrence.scheduleId),
      status: Value(_status),
      classType: Value(widget.occurrence.classType),
      classNameSnapshot: Value(widget.occurrence.classNameSnapshot),
      classDate: Value(_classDate),
      startTime: Value(_startTime),
      endTime: Value(_endTime),
      durationMinutes: Value(durationMinutes),
      creditUnitsCost: Value(creditUnitsCost ?? 0),
      packageId: Value(_shouldDeductCredits ? _selectedPackageId : null),
      scheduleOccurrenceKey: isManual
          ? const Value.absent()
          : Value(widget.occurrence.occurrenceKey),
      scheduleOccurrenceDate: isManual
          ? const Value.absent()
          : Value(_classDate),
      scheduleOccurrenceStartTime: isManual
          ? const Value.absent()
          : Value(_startTime),
      notes: Value(
        _notesController.text.trim().isEmpty
            ? null
            : _notesController.text.trim(),
      ),
      createdAt: Value(now),
      updatedAt: Value(now),
    );

    CreditTransactionsCompanion? creditTx;
    if (_shouldDeductCredits &&
        creditUnitsCost != null &&
        creditUnitsCost > 0) {
      creditTx = CreditTransactionsCompanion(
        kidCourseId: Value(widget.occurrence.kidCourseId),
        packageId: Value(_selectedPackageId),
        type: const Value('consume'),
        creditUnitsDelta: Value(-creditUnitsCost),
        transactionDate: Value(now),
        createdAt: Value(now),
      );
    }

    final result = await repo.insertRecordWithTransaction(record, creditTx);

    // 保存附件
    if (_pendingPhotos.isNotEmpty) {
      final recordId = switch (result) {
        Ok(:final value) => value,
        Err() => null,
      };
      if (recordId != null) {
        await _saveAttachments(recordId);
      }
    }

    if (mounted) {
      setState(() => _isLoading = false);
      Navigator.pop(context, true);
    }
  }

  Future<void> _showImageSourceActionSheet() async {
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('从相册选择'),
              onTap: () => Navigator.pop(ctx, ImageSource.gallery),
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('拍照'),
              onTap: () => Navigator.pop(ctx, ImageSource.camera),
            ),
          ],
        ),
      ),
    );
    if (source == null) return;

    final picker = ImagePicker();
    if (source == ImageSource.camera) {
      final xFile = await picker.pickImage(
        source: source,
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 85,
      );
      if (xFile == null) return;
      setState(() {
        _pendingPhotos.add(xFile.path);
      });
    } else {
      final xFiles = await picker.pickMultiImage(
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 85,
      );
      if (xFiles.isEmpty) return;
      setState(() {
        _pendingPhotos.addAll(xFiles.map((f) => f.path));
      });
    }
  }

  Future<void> _saveAttachments(int recordId) async {
    final fileService = ref.read(attachmentFileServiceProvider);
    final attachRepo = ref.read(attachmentRepositoryProvider);

    for (final photoPath in _pendingPhotos) {
      try {
        // 先读取源文件信息（复制后源文件会被删除）
        final file = File(photoPath);
        final fileName = photoPath.split('/').last.split('\\').last;
        final fileSize = await file.length();

        final relativePath = await fileService.copyToPrivateDirectory(
          sourcePath: photoPath,
          ownerType: 'class_record',
          ownerId: recordId,
        );

        await attachRepo.insertAttachment(
          AttachmentsCompanion(
            ownerType: const Value('class_record'),
            ownerId: Value(recordId),
            fileType: const Value('photo'),
            originalFileName: Value(fileName),
            relativePath: Value(relativePath),
            fileSizeBytes: Value(fileSize),
            createdAt: Value(DateTime.now()),
          ),
        );
      } catch (_) {
        // 附件保存失败不阻塞主流程
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final packagesAsync = ref.watch(
      activePackagesByCourseProvider(widget.occurrence.kidCourseId),
    );
    final theme = Theme.of(context);

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 拖拽条
          Center(
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 8),
              width: 32,
              height: 4,
              decoration: BoxDecoration(
                color: theme.colorScheme.outlineVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          // 标题
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    widget.occurrence.classNameSnapshot ?? '记录上课',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: _isLoading ? null : _save,
                  child: const Text('保存'),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          // 表单
          Flexible(
            child: Form(
              key: _formKey,
              child: ListView(
                shrinkWrap: true,
                padding: const EdgeInsets.all(16),
                children: [
                  // 状态选择
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: _statusOptions.map((opt) {
                        final isSelected = _status == opt.$1;
                        final colors = _statusColors[opt.$1]!;
                        final icon = _statusIcons[opt.$1]!;
                        return Padding(
                          padding: const EdgeInsets.only(right: 4),
                          child: GestureDetector(
                            onTap: () => setState(() => _status = opt.$1),
                            child: Container(
                              height: 32,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(
                                  color: isSelected
                                      ? colors.fg
                                      : const Color(0xFFE8E8E8),
                                ),
                                color: isSelected ? colors.bg : Colors.white,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    icon,
                                    size: 16,
                                    color: isSelected
                                        ? colors.fg
                                        : const Color(0xFF666666),
                                  ),
                                  const SizedBox(width: 3),
                                  Text(
                                    opt.$2,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: isSelected
                                          ? FontWeight.w500
                                          : null,
                                      color: isSelected
                                          ? colors.fg
                                          : const Color(0xFF666666),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // 上课日期
                  const _Label(label: '上课日期'),
                  const SizedBox(height: 4),
                  _DatePickerField(
                    dateText: _classDate,
                    onDateChanged: (d) {
                      setState(() => _classDate = d);
                    },
                  ),
                  const SizedBox(height: 16),

                  // 上课时间：开始 — 结束
                  const _Label(label: '上课时间'),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Expanded(
                        child: _TimePickerField(
                          timeText: _startTime,
                          onTimeChanged: (t) {
                            setState(() {
                              _startTime = t;
                              if (_defaultDurationMinutes != null) {
                                _endTime = _computeEndTimeFromStart(
                                  t,
                                  _defaultDurationMinutes!,
                                );
                              }
                            });
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          '—',
                          style: TextStyle(
                            fontSize: 14,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                      Expanded(
                        child: _TimePickerField(
                          timeText: _endTime,
                          onTimeChanged: (t) {
                            setState(() => _endTime = t);
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // 课时和课包（扣课时状态才显示）
                  if (_shouldDeductCredits) ...[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        // 课时步进器（1/3 宽度）
                        SizedBox(
                          width: (MediaQuery.of(context).size.width - 44) / 3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const _Label(label: '课时'),
                              const SizedBox(height: 4),
                              _CreditsStepper(controller: _creditsController),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        // 课包选择（2/3 宽度）
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const _Label(label: '课包'),
                              const SizedBox(height: 4),
                              packagesAsync.when(
                                loading: () => const LinearProgressIndicator(),
                                error: (_, _) => const Text('加载课包失败'),
                                data: (result) => switch (result) {
                                  Ok(:final value) =>
                                    DropdownButtonFormField<int>(
                                      initialValue: _selectedPackageId,
                                      isExpanded: true,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Color(0xFF1A1A1A),
                                      ),
                                      decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                        hintText: '选择课包',
                                        contentPadding: EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 10,
                                        ),
                                      ),
                                      items: value
                                          .map(
                                            (p) => DropdownMenuItem(
                                              value: p.id,
                                              child: _PackageDropdownLabel(
                                                package: p,
                                              ),
                                            ),
                                          )
                                          .toList(),
                                      onChanged: (v) => setState(
                                        () => _selectedPackageId = v,
                                      ),
                                    ),
                                  Err() => const Text('加载课包失败'),
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                  ],

                  // 备注
                  const _Label(label: '备注'),
                  const SizedBox(height: 4),
                  TextFormField(
                    controller: _notesController,
                    maxLines: 2,
                    style: const TextStyle(fontSize: 14),
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: '可选',
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // 拍照
                  const _Label(label: '照片'),
                  const SizedBox(height: 8),
                  _PhotoPickerSection(
                    photos: _pendingPhotos,
                    onAdd: _isLoading ? null : _showImageSourceActionSheet,
                    onRemove: (index) {
                      setState(() => _pendingPhotos.removeAt(index));
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Label extends StatelessWidget {
  final String label;

  const _Label({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: TextStyle(
        fontSize: 12,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
    );
  }
}

class _PhotoPickerSection extends StatelessWidget {
  final List<String> photos;
  final VoidCallback? onAdd;
  final void Function(int index) onRemove;

  const _PhotoPickerSection({
    required this.photos,
    required this.onAdd,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        ...photos.indexed.map((entry) {
          final index = entry.$1;
          final path = entry.$2;
          return _PendingPhotoThumb(
            path: path,
            onRemove: () => onRemove(index),
          );
        }),
        _AddPhotoButton(onTap: onAdd),
      ],
    );
  }
}

class _AddPhotoButton extends StatelessWidget {
  final VoidCallback? onTap;

  const _AddPhotoButton({this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: Theme.of(context).colorScheme.outline),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_a_photo,
              size: 24,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 4),
            Text(
              '添加照片',
              style: TextStyle(
                fontSize: 10,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PendingPhotoThumb extends StatelessWidget {
  final String path;
  final VoidCallback onRemove;

  const _PendingPhotoThumb({required this.path, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            border: Border.all(
              color: Theme.of(context).colorScheme.outlineVariant,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Image.file(
              File(path),
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) =>
                  const Center(child: Icon(Icons.broken_image, size: 24)),
            ),
          ),
        ),
        Positioned(
          top: 0,
          right: 0,
          child: GestureDetector(
            onTap: onRemove,
            child: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.error,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.close, size: 12, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}

class _PackageDropdownLabel extends StatelessWidget {
  final Package package;
  const _PackageDropdownLabel({required this.package});

  @override
  Widget build(BuildContext context) {
    final bs = CreditBalanceService();
    final theme = Theme.of(context);
    final name =
        '${bs.formatDate(package.purchaseDate)} ${bs.packageTypeLabel(package.type)}';

    final hasValidity = package.validFrom != null || package.validUntil != null;
    if (!hasValidity) {
      return Text(name, style: const TextStyle(fontSize: 14));
    }

    final status = bs.periodPackageStatusLabel(
      now: DateTime.now(),
      validFrom: package.validFrom,
      validUntil: package.validUntil,
    );
    final (bg, fg) = switch (status) {
      '未开始' => (
        theme.colorScheme.tertiaryContainer,
        theme.colorScheme.onTertiaryContainer,
      ),
      '进行中' => (const Color(0xFFDCFCE7), const Color(0xFF166534)),
      '已结束' => (
        theme.colorScheme.surfaceContainerHighest,
        theme.colorScheme.onSurfaceVariant,
      ),
      _ => (
        theme.colorScheme.tertiaryContainer,
        theme.colorScheme.onTertiaryContainer,
      ),
    };

    return Row(
      children: [
        Flexible(child: Text(name, style: const TextStyle(fontSize: 14))),
        const SizedBox(width: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(3),
          ),
          child: Text(status, style: TextStyle(fontSize: 10, color: fg)),
        ),
      ],
    );
  }
}

class _DatePickerField extends StatelessWidget {
  final String dateText;
  final ValueChanged<String> onDateChanged;

  const _DatePickerField({required this.dateText, required this.onDateChanged});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final initial = DateTime.tryParse(dateText) ?? DateTime.now();
        final picked = await showDatePicker(
          context: context,
          initialDate: initial,
          firstDate: DateTime(2020),
          lastDate: DateTime(2100),
        );
        if (picked != null) {
          onDateChanged(
            '${picked.year.toString().padLeft(4, '0')}-'
            '${picked.month.toString().padLeft(2, '0')}-'
            '${picked.day.toString().padLeft(2, '0')}',
          );
        }
      },
      borderRadius: BorderRadius.circular(4),
      child: InputDecorator(
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          suffixIcon: Icon(Icons.calendar_today, size: 18),
        ),
        child: Text(
          _formatDate(dateText),
          style: TextStyle(
            fontSize: 14,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ),
    );
  }

  static String _formatDate(String dateStr) {
    final d = DateTime.tryParse(dateStr);
    if (d == null) return dateStr;
    final weekdays = ['周一', '周二', '周三', '周四', '周五', '周六', '周日'];
    return '${DateFormat('yyyy-MM-dd').format(d)} ${weekdays[d.weekday - 1]}';
  }
}

class _TimePickerField extends StatelessWidget {
  final String timeText;
  final ValueChanged<String> onTimeChanged;

  const _TimePickerField({required this.timeText, required this.onTimeChanged});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final parts = timeText.split(':');
        final initial = TimeOfDay(
          hour: int.tryParse(parts.elementAtOrNull(0) ?? '') ?? 0,
          minute: int.tryParse(parts.elementAtOrNull(1) ?? '') ?? 0,
        );
        final picked = await showTimePicker(
          context: context,
          initialTime: initial,
        );
        if (picked != null) {
          onTimeChanged(
            '${picked.hour.toString().padLeft(2, '0')}:'
            '${picked.minute.toString().padLeft(2, '0')}',
          );
        }
      },
      borderRadius: BorderRadius.circular(4),
      child: InputDecorator(
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          suffixIcon: Icon(Icons.access_time, size: 18),
        ),
        child: Text(
          timeText,
          style: TextStyle(
            fontSize: 14,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ),
    );
  }
}

class _CreditsStepper extends StatefulWidget {
  final TextEditingController controller;

  const _CreditsStepper({required this.controller});

  @override
  State<_CreditsStepper> createState() => _CreditsStepperState();
}

class _CreditsStepperState extends State<_CreditsStepper> {
  late final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    if (widget.controller.text.isEmpty) {
      widget.controller.text = '1';
    }
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void _step(double delta) {
    final current = double.tryParse(widget.controller.text) ?? 0;
    final next = (current + delta).clamp(0.5, 99);
    widget.controller.text = next == next.roundToDouble()
        ? '${next.toInt()}'
        : next.toStringAsFixed(1);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final outlineColor = theme.colorScheme.outline;
    const buttonSize = 36.0;

    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: outlineColor),
        borderRadius: BorderRadius.circular(4),
      ),
      child: SizedBox(
        height: 48,
        child: Row(
          children: [
            SizedBox(
              width: buttonSize,
              child: IconButton(
                onPressed: () => _step(-0.5),
                icon: const Icon(Icons.remove, size: 18),
                padding: EdgeInsets.zero,
                style: IconButton.styleFrom(
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  minimumSize: const Size(buttonSize, buttonSize),
                  padding: EdgeInsets.zero,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(4),
                      bottomLeft: Radius.circular(4),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: TextField(
                controller: widget.controller,
                focusNode: _focusNode,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 10),
                  isDense: true,
                ),
                onChanged: (_) => setState(() {}),
              ),
            ),
            SizedBox(
              width: buttonSize,
              child: IconButton(
                onPressed: () => _step(0.5),
                icon: const Icon(Icons.add, size: 18),
                padding: EdgeInsets.zero,
                style: IconButton.styleFrom(
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  minimumSize: const Size(buttonSize, buttonSize),
                  padding: EdgeInsets.zero,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(4),
                      bottomRight: Radius.circular(4),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
