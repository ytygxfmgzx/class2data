import 'package:class2data/core/result/result.dart';
import 'package:class2data/data/database/app_database.dart';
import 'package:class2data/domain/services/credit_balance_service.dart';
import 'package:class2data/features/attachments/presentation/attachment_list_section.dart';
import 'package:class2data/features/packages/providers/package_providers.dart';
import 'package:class2data/shared/providers/database_provider.dart';
import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ClassRecordEditPage extends ConsumerStatefulWidget {
  final int recordId;

  const ClassRecordEditPage({super.key, required this.recordId});

  @override
  ConsumerState<ClassRecordEditPage> createState() =>
      _ClassRecordEditPageState();
}

class _ClassRecordEditPageState extends ConsumerState<ClassRecordEditPage> {
  final _formKey = GlobalKey<FormState>();
  final _creditsController = TextEditingController();
  final _durationController = TextEditingController();
  final _notesController = TextEditingController();

  String _status = 'attended';
  int? _selectedPackageId;
  bool _isLoading = false;
  bool _isDataLoaded = false;

  ClassRecord? _record;
  String? _childName;
  String? _courseName;

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
    _loadRecord();
  }

  Future<void> _loadRecord() async {
    final repo = ref.read(classRecordRepositoryProvider);
    final result = await repo.getById(widget.recordId);

    final record = switch (result) {
      Ok(:final value) => value,
      Err() => null,
    };
    if (record == null || !mounted) return;

    // 加载课程和孩子名称
    String? courseName;
    String? childName;

    final courseRepo = ref.read(kidCourseRepositoryProvider);
    final courseResult = await courseRepo.getById(record.kidCourseId);
    final course = switch (courseResult) {
      Ok(:final value) => value,
      Err() => null,
    };

    if (course != null) {
      courseName = course.name;
      final childRepo = ref.read(childRepositoryProvider);
      final childResult = await childRepo.getById(course.childId);
      final child = switch (childResult) {
        Ok(:final value) => value,
        Err() => null,
      };
      if (child != null) childName = child.name;
    }

    if (!mounted) return;

    setState(() {
      _record = record;
      _childName = childName;
      _courseName = courseName;
      _status = record.status;
      _selectedPackageId = record.packageId;
      if (record.creditUnitsCost > 0) {
        _creditsController.text = CreditBalanceService().formatCredits(
          record.creditUnitsCost,
        );
      }
      if (record.durationMinutes != null) {
        _durationController.text = '${record.durationMinutes}';
      }
      if (record.notes != null) {
        _notesController.text = record.notes!;
      }
      _isDataLoaded = true;
    });
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

    final updatedRecord = ClassRecordsCompanion(
      id: Value(widget.recordId),
      kidCourseId: Value(_record!.kidCourseId),
      scheduleId: Value(_record!.scheduleId),
      status: Value(_status),
      classType: Value(_record!.classType),
      classNameSnapshot: Value(_record!.classNameSnapshot),
      classDate: Value(_record!.classDate),
      startTime: Value(_record!.startTime),
      endTime: Value(_record!.endTime),
      durationMinutes: Value(durationMinutes),
      creditUnitsCost: Value(creditUnitsCost ?? _record!.creditUnitsCost),
      packageId: Value(_shouldDeductCredits ? _selectedPackageId : null),
      scheduleOccurrenceKey: Value(_record!.scheduleOccurrenceKey),
      scheduleOccurrenceDate: Value(_record!.scheduleOccurrenceDate),
      scheduleOccurrenceStartTime: Value(_record!.scheduleOccurrenceStartTime),
      notes: Value(
        _notesController.text.trim().isEmpty
            ? null
            : _notesController.text.trim(),
      ),
      createdAt: Value(_record!.createdAt),
      updatedAt: Value(now),
    );

    final repo = ref.read(classRecordRepositoryProvider);
    await repo.updateRecord(updatedRecord);

    if (mounted) {
      setState(() => _isLoading = false);
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (!_isDataLoaded) {
      return Scaffold(
        appBar: AppBar(title: const Text('编辑上课记录')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('编辑上课记录'),
        actions: [
          TextButton(
            onPressed: _isLoading ? null : _save,
            child: const Text('保存'),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // 只读信息
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerLow,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_childName != null)
                    _ReadOnlyRow(label: '孩子', value: _childName!),
                  if (_courseName != null)
                    _ReadOnlyRow(label: '课程', value: _courseName!),
                  _ReadOnlyRow(
                    label: '日期',
                    value:
                        '${_record!.classDate}  ${_record!.startTime}'
                        '${_record!.endTime != null ? '-${_record!.endTime}' : ''}',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // 状态
            const _Label(label: '状态'),
            const SizedBox(height: 4),
            SegmentedButton<String>(
              segments: _statusOptions
                  .map(
                    (e) => ButtonSegment(
                      value: e.$1,
                      label: Text(e.$2, style: const TextStyle(fontSize: 12)),
                    ),
                  )
                  .toList(),
              selected: {_status},
              onSelectionChanged: (v) => setState(() => _status = v.first),
            ),
            const SizedBox(height: 16),

            // 课时和时长
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
                          keyboardType: const TextInputType.numberWithOptions(
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

              // 课包
              const _Label(label: '扣课包'),
              const SizedBox(height: 4),
              _PackageDropdown(
                kidCourseId: _record!.kidCourseId,
                selectedPackageId: _selectedPackageId,
                onChanged: (v) => setState(() => _selectedPackageId = v),
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
            const SizedBox(height: 20),

            // 照片
            AttachmentListSection(
              ownerType: 'class_record',
              ownerId: widget.recordId,
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class _ReadOnlyRow extends StatelessWidget {
  final String label;
  final String value;

  const _ReadOnlyRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          SizedBox(
            width: 40,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
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

class _PackageDropdown extends ConsumerWidget {
  final int kidCourseId;
  final int? selectedPackageId;
  final ValueChanged<int?> onChanged;

  const _PackageDropdown({
    required this.kidCourseId,
    required this.selectedPackageId,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final packagesAsync = ref.watch(
      activePackagesByCourseProvider(kidCourseId),
    );

    return packagesAsync.when(
      loading: () => const LinearProgressIndicator(),
      error: (_, _) => const Text('加载课包失败'),
      data: (result) => switch (result) {
        Ok(:final value) => DropdownButtonFormField<int>(
          initialValue: selectedPackageId,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: '选择课包',
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          ),
          items: value
              .map(
                (p) => DropdownMenuItem(
                  value: p.id,
                  child: Text(
                    '${CreditBalanceService().packageTypeLabel(p.type)}'
                    ' · ${p.purchaseDate.month}/${p.purchaseDate.day}',
                    style: const TextStyle(fontSize: 13),
                  ),
                ),
              )
              .toList(),
          onChanged: onChanged,
        ),
        Err() => const Text('加载课包失败'),
      },
    );
  }
}
