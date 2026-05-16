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
  final _durationController = TextEditingController();
  final _notesController = TextEditingController();

  String _status = 'attended';
  int? _selectedPackageId;
  bool _isLoading = false;
  final List<String> _pendingPhotos = [];

  static const _statusOptions = [
    ('attended', '已上课'),
    ('leave', '请假'),
    ('cancelled', '取消'),
    ('absent', '缺课'),
    ('makeup', '补课'),
  ];

  bool get _shouldDeductCredits =>
      _status == 'attended' || _status == 'makeup' || _status == 'absent';

  @override
  void initState() {
    super.initState();
    _loadDefaults();
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
    );

    if (mounted) {
      setState(() {
        if (defaults.creditUnitsCost != null) {
          _creditsController.text = CreditBalanceService().formatCredits(
            defaults.creditUnitsCost!,
          );
        }
        if (defaults.durationMinutes != null) {
          _durationController.text = '${defaults.durationMinutes}';
        }
        _selectedPackageId = recommendedPkg ?? defaults.packageId;
      });
    }
  }

  @override
  void dispose() {
    _creditsController.dispose();
    _durationController.dispose();
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
    if (_durationController.text.trim().isNotEmpty) {
      durationMinutes = int.tryParse(_durationController.text.trim());
    }

    final record = ClassRecordsCompanion(
      kidCourseId: Value(widget.occurrence.kidCourseId),
      scheduleId: isManual
          ? const Value.absent()
          : Value(widget.occurrence.scheduleId),
      status: Value(_status),
      classType: Value(widget.occurrence.classType),
      classNameSnapshot: Value(widget.occurrence.classNameSnapshot),
      classDate: Value(widget.occurrence.date),
      startTime: Value(widget.occurrence.startTime),
      endTime: Value(widget.occurrence.endTime),
      durationMinutes: Value(durationMinutes),
      creditUnitsCost: Value(creditUnitsCost ?? 0),
      packageId: Value(_shouldDeductCredits ? _selectedPackageId : null),
      scheduleOccurrenceKey: isManual
          ? const Value.absent()
          : Value(widget.occurrence.occurrenceKey),
      scheduleOccurrenceDate: isManual
          ? const Value.absent()
          : Value(widget.occurrence.date),
      scheduleOccurrenceStartTime: isManual
          ? const Value.absent()
          : Value(widget.occurrence.startTime),
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
  }

  Future<void> _saveAttachments(int recordId) async {
    final fileService = ref.read(attachmentFileServiceProvider);
    final attachRepo = ref.read(attachmentRepositoryProvider);

    for (final photoPath in _pendingPhotos) {
      try {
        final relativePath = await fileService.copyToPrivateDirectory(
          sourcePath: photoPath,
          ownerType: 'class_record',
          ownerId: recordId,
        );
        final file = File(photoPath);
        final fileName = photoPath.split('/').last.split('\\').last;
        final fileSize = await file.length();

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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.occurrence.classNameSnapshot ?? '记录上课',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '${widget.occurrence.date}  ${widget.occurrence.startTime}-${widget.occurrence.endTime}',
                        style: TextStyle(
                          fontSize: 12,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
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
          Expanded(
            child: Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // 状态选择
                  const _Label(label: '状态'),
                  const SizedBox(height: 4),
                  SegmentedButton<String>(
                    segments: _statusOptions
                        .map(
                          (e) => ButtonSegment(
                            value: e.$1,
                            label: Text(
                              e.$2,
                              style: const TextStyle(fontSize: 12),
                            ),
                          ),
                        )
                        .toList(),
                    selected: {_status},
                    onSelectionChanged: (v) =>
                        setState(() => _status = v.first),
                  ),
                  const SizedBox(height: 16),

                  // 课时和时长（扣课时状态才显示）
                  if (_shouldDeductCredits) ...[
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const _Label(label: '课时'),
                              const SizedBox(height: 4),
                              TextFormField(
                                controller: _creditsController,
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                      decimal: true,
                                    ),
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: '1',
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 10,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const _Label(label: '时长（分钟）'),
                              const SizedBox(height: 4),
                              TextFormField(
                                controller: _durationController,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: '60',
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 10,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // 课包选择
                    const _Label(label: '扣课包'),
                    const SizedBox(height: 4),
                    packagesAsync.when(
                      loading: () => const LinearProgressIndicator(),
                      error: (_, _) => const Text('加载课包失败'),
                      data: (result) => switch (result) {
                        Ok(:final value) => DropdownButtonFormField<int>(
                          initialValue: _selectedPackageId,
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
                                  child: Text(
                                    '${CreditBalanceService().packageTypeLabel(p.type)} · ${p.purchaseDate.month}/${p.purchaseDate.day}',
                                    style: const TextStyle(fontSize: 13),
                                  ),
                                ),
                              )
                              .toList(),
                          onChanged: (v) =>
                              setState(() => _selectedPackageId = v),
                        ),
                        Err() => const Text('加载课包失败'),
                      },
                    ),
                    const SizedBox(height: 16),
                  ],

                  // 备注
                  const _Label(label: '备注'),
                  const SizedBox(height: 4),
                  TextFormField(
                    controller: _notesController,
                    maxLines: 2,
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
