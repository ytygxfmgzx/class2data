import 'package:class2data/core/result/result.dart';
import 'package:class2data/data/database/app_database.dart';
import 'package:class2data/domain/models/schedule_slots.dart';
import 'package:class2data/features/children/providers/child_providers.dart';
import 'package:class2data/features/courses/providers/course_providers.dart';
import 'package:class2data/features/home/providers/home_providers.dart';
import 'package:class2data/shared/providers/database_provider.dart';
import 'package:class2data/shared/widgets/child_avatar.dart';
import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ScheduleFormPage extends ConsumerStatefulWidget {
  final int courseId;
  final int? scheduleId;

  const ScheduleFormPage({super.key, required this.courseId, this.scheduleId});

  @override
  ConsumerState<ScheduleFormPage> createState() => _ScheduleFormPageState();
}

class _ScheduleFormPageState extends ConsumerState<ScheduleFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _notesController = TextEditingController();
  final _locationController = TextEditingController();

  String _scheduleType = 'weekly_repeat';
  List<WeekdaySlot> _weekdaySlots = [];
  List<MonthDaySlot> _monthDaySlots = [];
  List<DateSlot> _dateSlots = [];
  DateTime? _validFrom;
  DateTime? _validUntil;
  bool _isLoading = false;
  bool _isLegacyType = false;

  bool get _isEditing => widget.scheduleId != null;

  static const _weekdayLabels = ['周一', '周二', '周三', '周四', '周五', '周六', '周日'];

  @override
  void initState() {
    super.initState();
    _validFrom = DateTime.now();
    if (_isEditing) _loadSchedule();
  }

  Future<void> _loadSchedule() async {
    final repo = ref.read(scheduleRepositoryProvider);
    final result = await repo.getById(widget.scheduleId!);
    switch (result) {
      case Ok(:final value):
        if (value != null && mounted) {
          setState(() {
            _scheduleType = value.scheduleType;
            _validFrom = value.validFrom;
            _validUntil = value.validUntil;
            _notesController.text = value.notes ?? '';
            _locationController.text = value.location ?? '';

            if (value.slotsJson != null && value.slotsJson!.isNotEmpty) {
              _loadFromSlotsJson(value);
            } else {
              _loadFromLegacyFields(value);
            }
          });
        }
      case Err():
        break;
    }
  }

  void _loadFromSlotsJson(CourseSchedule schedule) {
    switch (schedule.scheduleType) {
      case 'weekly_repeat':
        _weekdaySlots = ScheduleSlotsJson.decodeWeeklySlots(
          schedule.slotsJson!,
        );
      case 'monthly_repeat':
        _monthDaySlots = ScheduleSlotsJson.decodeMonthlySlots(
          schedule.slotsJson!,
        );
      case 'date_list':
        _dateSlots = ScheduleSlotsJson.decodeDateSlots(schedule.slotsJson!);
    }
  }

  void _loadFromLegacyFields(CourseSchedule schedule) {
    switch (schedule.scheduleType) {
      case 'weekly_repeat':
        if (schedule.weekday != null) {
          _weekdaySlots = [
            WeekdaySlot(
              weekday: schedule.weekday!,
              startTime: schedule.startTime,
              endTime: schedule.endTime,
            ),
          ];
        }
      case 'daily_repeat':
        _isLegacyType = true;
      case 'single':
        _isLegacyType = true;
        if (schedule.date != null) {
          _dateSlots = [
            DateSlot(
              date: schedule.date!,
              startTime: schedule.startTime,
              endTime: schedule.endTime,
            ),
          ];
        }
      case 'date_list':
        if (schedule.dateList != null && schedule.dateList!.isNotEmpty) {
          _dateSlots = schedule.dateList!
              .split(',')
              .map((d) => d.trim())
              .where((d) => d.isNotEmpty)
              .map(
                (d) => DateSlot(
                  date: d,
                  startTime: schedule.startTime,
                  endTime: schedule.endTime,
                ),
              )
              .toList();
        }
    }
  }

  @override
  void dispose() {
    _notesController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  bool _validate() {
    if (_scheduleType == 'weekly_repeat' && _weekdaySlots.isEmpty) {
      _showError('请至少选择一天');
      return false;
    }
    if (_scheduleType == 'monthly_repeat' && _monthDaySlots.isEmpty) {
      _showError('请至少选择一天');
      return false;
    }
    if (_scheduleType == 'date_list' && _dateSlots.isEmpty) {
      _showError('请至少选择一个日期');
      return false;
    }
    if (_validFrom == null) {
      _showError('请选择开始日期');
      return false;
    }
    return true;
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
  }

  Future<void> _delete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('确认删除'),
        content: const Text('确定要删除此计划吗？删除后无法恢复。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('取消'),
          ),
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('删除'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      final repo = ref.read(scheduleRepositoryProvider);
      await repo.deleteSchedule(widget.scheduleId!);
      if (mounted) {
        ref.read(homeDataVersionProvider.notifier).state++;
        context.pop();
      }
    }
  }

  Future<void> _save() async {
    if (!_validate()) return;

    setState(() => _isLoading = true);

    final repo = ref.read(scheduleRepositoryProvider);
    final now = DateTime.now();

    String? slotsJson;
    int? weekday;
    String? dateListStr;
    String? startTime;
    String? endTime;

    switch (_scheduleType) {
      case 'weekly_repeat':
        slotsJson = ScheduleSlotsJson.encodeWeeklySlots(_weekdaySlots);
        weekday = _weekdaySlots.first.weekday;
        startTime = _weekdaySlots.first.startTime;
        endTime = _weekdaySlots.first.endTime;
      case 'monthly_repeat':
        slotsJson = ScheduleSlotsJson.encodeMonthlySlots(_monthDaySlots);
        startTime = _monthDaySlots.first.startTime;
        endTime = _monthDaySlots.first.endTime;
      case 'date_list':
        slotsJson = ScheduleSlotsJson.encodeDateSlots(_dateSlots);
        dateListStr = _dateSlots.map((s) => s.date).join(',');
        startTime = _dateSlots.first.startTime;
        endTime = _dateSlots.first.endTime;
      default:
        break;
    }

    final entry = CourseSchedulesCompanion(
      id: _isEditing ? Value(widget.scheduleId!) : const Value.absent(),
      kidCourseId: Value(widget.courseId),
      scheduleType: Value(_scheduleType),
      weekday: Value(weekday),
      startTime: Value(startTime ?? ''),
      endTime: Value(endTime ?? ''),
      dateList: Value(dateListStr),
      slotsJson: Value(slotsJson),
      location: Value(
        _locationController.text.trim().isEmpty
            ? null
            : _locationController.text.trim(),
      ),
      validFrom: Value(_validFrom ?? now),
      validUntil: Value(_validUntil),
      notes: Value(
        _notesController.text.trim().isEmpty
            ? null
            : _notesController.text.trim(),
      ),
      createdAt: Value(now),
      updatedAt: Value(now),
    );

    final result = _isEditing
        ? await repo.updateSchedule(entry)
        : await repo.insertSchedule(entry);

    if (!mounted) return;

    switch (result) {
      case Ok():
        ref.read(homeDataVersionProvider.notifier).state++;
        setState(() => _isLoading = false);
        context.pop();
      case Err(:final error):
        setState(() => _isLoading = false);
        _showError(error.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    final courseAsync = ref.watch(courseByIdProvider(widget.courseId));

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? '编辑计划' : '添加计划'),
        actions: [
          if (_isEditing)
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.error,
              ),
              onPressed: _isLoading ? null : _delete,
              child: const Text('删除'),
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
          children: [
            const SizedBox(height: 8),
            _buildCourseHeader(courseAsync),
            const SizedBox(height: 16),
            _buildScheduleTypeSelector(),
            const SizedBox(height: 16),
            _buildConditionalFields(),
            const Divider(height: 32),
            _buildValidityFields(),
            const SizedBox(height: 12),
            _buildLocationField(),
            const SizedBox(height: 12),
            _buildNotesField(),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomButton(),
    );
  }

  Widget _buildCourseHeader(AsyncValue<KidCourse?> courseAsync) {
    return courseAsync.when(
      data: (course) {
        if (course == null) return const SizedBox.shrink();
        final childAsync = ref.watch(childByIdProvider(course.childId));
        return childAsync.when(
          data: (child) => _CourseInfoCard(course: course, child: child),
          loading: () => const SizedBox.shrink(),
          error: (_, _) => _CourseInfoCard(course: course, child: null),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
    );
  }

  Widget _buildScheduleTypeSelector() {
    if (_isLegacyType) {
      return SegmentedButton<String>(
        segments: const [
          ButtonSegment(value: 'weekly_repeat', label: Text('周循环')),
          ButtonSegment(value: 'monthly_repeat', label: Text('月循环')),
          ButtonSegment(value: 'date_list', label: Text('指定日期')),
          ButtonSegment(value: 'daily_repeat', label: Text('每天')),
          ButtonSegment(value: 'single', label: Text('单次')),
        ],
        selected: {_scheduleType},
        onSelectionChanged: _onTypeChanged,
      );
    }

    return SegmentedButton<String>(
      segments: const [
        ButtonSegment(value: 'weekly_repeat', label: Text('周循环')),
        ButtonSegment(value: 'monthly_repeat', label: Text('月循环')),
        ButtonSegment(value: 'date_list', label: Text('指定日期')),
      ],
      selected: {_scheduleType},
      onSelectionChanged: _onTypeChanged,
    );
  }

  void _onTypeChanged(Set<String> selection) {
    final newType = selection.first;
    if (newType == _scheduleType) return;

    setState(() {
      _scheduleType = newType;
      _isLegacyType = false;
    });
  }

  Widget _buildConditionalFields() {
    switch (_scheduleType) {
      case 'weekly_repeat':
        return _buildWeeklyFields();
      case 'monthly_repeat':
        return _buildMonthlyFields();
      case 'date_list':
        return _buildDateListFields();
      case 'daily_repeat':
        return _buildLegacyDailyFields();
      case 'single':
        return _buildLegacySingleFields();
      default:
        return const SizedBox.shrink();
    }
  }

  // === 周循环 ===

  Widget _buildWeeklyFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const _Label(label: '每周上课日'),
            const Spacer(),
            TextButton.icon(
              onPressed: _showWeeklyPicker,
              icon: const Icon(Icons.date_range, size: 18),
              label: Text(_weekdaySlots.isEmpty ? '选择星期' : '修改'),
            ),
          ],
        ),
        if (_weekdaySlots.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Text(
              '点击「选择星期」选取每周上课日',
              style: TextStyle(
                fontSize: 13,
                color: Theme.of(context).hintColor,
              ),
            ),
          )
        else ...[
          const SizedBox(height: 4),
          Wrap(
            spacing: 6,
            runSpacing: 4,
            children: _weekdaySlots.map((slot) {
              return Chip(
                label: Text(_weekdayLabels[slot.weekday - 1]),
                visualDensity: VisualDensity.compact,
                onDeleted: () => setState(() {
                  _weekdaySlots.removeWhere((s) => s.weekday == slot.weekday);
                }),
              );
            }).toList(),
          ),
          const SizedBox(height: 12),
          ..._weekdaySlots.map((slot) => _buildWeekdayTimeRow(slot)),
        ],
      ],
    );
  }

  Future<void> _showWeeklyPicker() async {
    final selectedWeekdays = _weekdaySlots.map((s) => s.weekday).toSet();
    final result = await showModalBottomSheet<Set<int>>(
      context: context,
      builder: (ctx) => _WeekdayPickerSheet(selectedDays: selectedWeekdays),
    );
    if (result == null || !mounted) return;

    setState(() {
      final removed = _weekdaySlots
          .where((s) => !result.contains(s.weekday))
          .map((s) => s.weekday)
          .toSet();
      _weekdaySlots.removeWhere((s) => removed.contains(s.weekday));

      final existing = _weekdaySlots.map((s) => s.weekday).toSet();
      final defaultStart = _weekdaySlots.isNotEmpty
          ? _weekdaySlots.last.startTime
          : '09:00';
      final defaultEnd = _weekdaySlots.isNotEmpty
          ? _weekdaySlots.last.endTime
          : '10:00';
      for (final day in result) {
        if (!existing.contains(day)) {
          _weekdaySlots.add(
            WeekdaySlot(
              weekday: day,
              startTime: defaultStart,
              endTime: defaultEnd,
            ),
          );
        }
      }
    });
  }

  Widget _buildWeekdayTimeRow(WeekdaySlot slot) {
    final idx = _weekdaySlots.indexOf(slot);
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: theme.colorScheme.outlineVariant),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 40,
              child: Text(
                _weekdayLabels[slot.weekday - 1],
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _TimeField(
                time: slot.startTime,
                onPicked: (t) => setState(
                  () => _weekdaySlots[idx] = WeekdaySlot(
                    weekday: slot.weekday,
                    startTime: t,
                    endTime: slot.endTime,
                  ),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 6),
              child: Text('-'),
            ),
            Expanded(
              child: _TimeField(
                time: slot.endTime,
                onPicked: (t) => setState(
                  () => _weekdaySlots[idx] = WeekdaySlot(
                    weekday: slot.weekday,
                    startTime: slot.startTime,
                    endTime: t,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // === 月循环 ===

  Widget _buildMonthlyFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const _Label(label: '每月上课日'),
            const Spacer(),
            TextButton.icon(
              onPressed: _showMonthlyPicker,
              icon: const Icon(Icons.calendar_month, size: 18),
              label: Text(_monthDaySlots.isEmpty ? '选择日期' : '修改日期'),
            ),
          ],
        ),
        if (_monthDaySlots.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Text(
              '点击「选择日期」选取每月上课日',
              style: TextStyle(
                fontSize: 13,
                color: Theme.of(context).hintColor,
              ),
            ),
          )
        else ...[
          const SizedBox(height: 4),
          Wrap(
            spacing: 6,
            runSpacing: 4,
            children: _monthDaySlots.map((slot) {
              return Chip(
                label: Text('每月${slot.dayOfMonth}号'),
                visualDensity: VisualDensity.compact,
                onDeleted: () => _removeMonthDay(slot.dayOfMonth),
              );
            }).toList(),
          ),
          const SizedBox(height: 12),
          ..._monthDaySlots.map((slot) => _buildMonthDayTimeRow(slot)),
        ],
      ],
    );
  }

  Future<void> _showMonthlyPicker() async {
    final selectedDays = _monthDaySlots.map((s) => s.dayOfMonth).toSet();
    final result = await showModalBottomSheet<Set<int>>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => _MonthDayPickerSheet(selectedDays: selectedDays),
    );
    if (result == null || !mounted) return;

    setState(() {
      final removed = _monthDaySlots
          .where((s) => !result.contains(s.dayOfMonth))
          .map((s) => s.dayOfMonth)
          .toSet();
      _monthDaySlots.removeWhere((s) => removed.contains(s.dayOfMonth));

      final existing = _monthDaySlots.map((s) => s.dayOfMonth).toSet();
      final defaultStart = _monthDaySlots.isNotEmpty
          ? _monthDaySlots.last.startTime
          : '09:00';
      final defaultEnd = _monthDaySlots.isNotEmpty
          ? _monthDaySlots.last.endTime
          : '10:00';
      for (final day in result) {
        if (!existing.contains(day)) {
          _monthDaySlots.add(
            MonthDaySlot(
              dayOfMonth: day,
              startTime: defaultStart,
              endTime: defaultEnd,
            ),
          );
        }
      }
    });
  }

  void _removeMonthDay(int day) {
    setState(() {
      _monthDaySlots.removeWhere((s) => s.dayOfMonth == day);
    });
  }

  Widget _buildMonthDayTimeRow(MonthDaySlot slot) {
    final idx = _monthDaySlots.indexOf(slot);
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: theme.colorScheme.outlineVariant),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 56,
              child: Text(
                '每月${slot.dayOfMonth}号',
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _TimeField(
                time: slot.startTime,
                onPicked: (t) => setState(
                  () => _monthDaySlots[idx] = MonthDaySlot(
                    dayOfMonth: slot.dayOfMonth,
                    startTime: t,
                    endTime: slot.endTime,
                  ),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 6),
              child: Text('-'),
            ),
            Expanded(
              child: _TimeField(
                time: slot.endTime,
                onPicked: (t) => setState(
                  () => _monthDaySlots[idx] = MonthDaySlot(
                    dayOfMonth: slot.dayOfMonth,
                    startTime: slot.startTime,
                    endTime: t,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // === 指定日期 ===

  Widget _buildDateListFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const _Label(label: '选择上课日期'),
            const Spacer(),
            TextButton.icon(
              onPressed: _showDateListPicker,
              icon: const Icon(Icons.calendar_month, size: 18),
              label: Text(_dateSlots.isEmpty ? '选择日期' : '修改日期'),
            ),
          ],
        ),
        if (_dateSlots.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Text(
              '点击「选择日期」选取上课日期',
              style: TextStyle(
                fontSize: 13,
                color: Theme.of(context).hintColor,
              ),
            ),
          )
        else ...[
          const SizedBox(height: 4),
          Wrap(
            spacing: 6,
            runSpacing: 4,
            children: _dateSlots.map((slot) {
              return Chip(
                label: Text(slot.date),
                visualDensity: VisualDensity.compact,
                onDeleted: () => setState(() => _dateSlots.remove(slot)),
              );
            }).toList(),
          ),
          const SizedBox(height: 12),
          ..._dateSlots.map((slot) => _buildDateSlotRow(slot)),
        ],
      ],
    );
  }

  Future<void> _showDateListPicker() async {
    final existingDates = _dateSlots.map((s) => s.date).toSet();
    final result = await showModalBottomSheet<Set<String>>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => _DateListPickerSheet(selectedDates: existingDates),
    );
    if (result == null || !mounted) return;

    setState(() {
      final removed = _dateSlots
          .where((s) => !result.contains(s.date))
          .map((s) => s.date)
          .toSet();
      _dateSlots.removeWhere((s) => removed.contains(s.date));

      final existing = _dateSlots.map((s) => s.date).toSet();
      final defaultStart = _dateSlots.isNotEmpty
          ? _dateSlots.last.startTime
          : '09:00';
      final defaultEnd = _dateSlots.isNotEmpty
          ? _dateSlots.last.endTime
          : '10:00';
      final sortedDates = result.toList()..sort();
      for (final date in sortedDates) {
        if (!existing.contains(date)) {
          _dateSlots.add(
            DateSlot(date: date, startTime: defaultStart, endTime: defaultEnd),
          );
        }
      }
      _dateSlots.sort((a, b) => a.date.compareTo(b.date));
    });
  }

  Widget _buildDateSlotRow(DateSlot slot) {
    final idx = _dateSlots.indexOf(slot);
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: theme.colorScheme.outlineVariant),
        ),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Text(
                slot.date,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
            Expanded(
              child: _TimeField(
                time: slot.startTime,
                onPicked: (t) => setState(
                  () => _dateSlots[idx] = DateSlot(
                    date: slot.date,
                    startTime: t,
                    endTime: slot.endTime,
                  ),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 6),
              child: Text('-'),
            ),
            Expanded(
              child: _TimeField(
                time: slot.endTime,
                onPicked: (t) => setState(
                  () => _dateSlots[idx] = DateSlot(
                    date: slot.date,
                    startTime: slot.startTime,
                    endTime: t,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // === 旧类型兼容（daily_repeat / single）===

  Widget _buildLegacyDailyFields() {
    return const Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Text('每天重复（旧类型，建议改用周循环）', style: TextStyle(color: Colors.grey)),
    );
  }

  Widget _buildLegacySingleFields() {
    return const Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Text('单次上课（旧类型，建议改用指定日期）', style: TextStyle(color: Colors.grey)),
    );
  }

  // === 公共字段 ===

  Widget _buildValidityFields() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _Label(label: '开始日期'),
              const SizedBox(height: 4),
              _DateField(
                date: _validFrom,
                onPicked: (d) => setState(() => _validFrom = d),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _Label(label: '结束日期（可选）'),
              const SizedBox(height: 4),
              _DateField(
                date: _validUntil,
                onPicked: (d) => setState(() => _validUntil = d),
                clearable: true,
                onClear: () => setState(() => _validUntil = null),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLocationField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _Label(label: '上课地点'),
        const SizedBox(height: 4),
        TextFormField(
          controller: _locationController,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: '如：少年宫 3 楼舞蹈室',
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          ),
        ),
      ],
    );
  }

  Widget _buildNotesField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _Label(label: '备注'),
        const SizedBox(height: 4),
        TextFormField(controller: _notesController, maxLines: 2),
      ],
    );
  }

  Widget _buildBottomButton() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
        child: FilledButton(
          onPressed: _isLoading ? null : _save,
          style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(44)),
          child: _isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : const Text('保存'),
        ),
      ),
    );
  }
}

// === 课程信息卡片 ===

class _CourseInfoCard extends StatelessWidget {
  final KidCourse course;
  final ChildrenData? child;

  const _CourseInfoCard({required this.course, required this.child});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Row(
        children: [
          if (child != null)
            ChildAvatar(
              name: child!.name,
              avatarPath: child!.avatarPath,
              radius: 16,
            )
          else
            const CircleAvatar(radius: 16, child: Icon(Icons.person, size: 20)),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  course.name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (child != null)
                  Text(
                    child!.name,
                    style: TextStyle(
                      fontSize: 12,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// === 通用小组件 ===

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

class _DateField extends StatelessWidget {
  final DateTime? date;
  final ValueChanged<DateTime> onPicked;
  final bool clearable;
  final VoidCallback? onClear;

  const _DateField({
    required this.date,
    required this.onPicked,
    this.clearable = false,
    this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final text = date != null
        ? '${date!.year}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}'
        : '选择日期';

    return GestureDetector(
      onTap: () async {
        final d = await showDatePicker(
          context: context,
          initialDate: date ?? DateTime.now(),
          firstDate: DateTime(2024),
          lastDate: DateTime(2030),
          locale: const Locale('zh', 'CN'),
        );
        if (d != null) onPicked(d);
      },
      child: InputDecorator(
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 10,
          ),
          suffixIcon: clearable && date != null && onClear != null
              ? IconButton(
                  icon: const Icon(Icons.clear, size: 18),
                  onPressed: onClear,
                )
              : null,
        ),
        child: Text(
          text,
          style: TextStyle(
            color: date != null ? null : Theme.of(context).hintColor,
          ),
        ),
      ),
    );
  }
}

class _TimeField extends StatelessWidget {
  final String time;
  final ValueChanged<String> onPicked;

  const _TimeField({required this.time, required this.onPicked});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final parts = time.split(':');
        final initial = TimeOfDay(
          hour: parts.length >= 2 ? int.tryParse(parts[0]) ?? 9 : 9,
          minute: parts.length >= 2 ? int.tryParse(parts[1]) ?? 0 : 0,
        );
        final t = await showTimePicker(
          context: context,
          initialTime: initial,
          builder: (context, child) {
            return MediaQuery(
              data: MediaQuery.of(
                context,
              ).copyWith(alwaysUse24HourFormat: true),
              child: child!,
            );
          },
        );
        if (t != null) {
          onPicked(
            '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}',
          );
        }
      },
      child: InputDecorator(
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          isDense: true,
        ),
        child: Text(
          time.isEmpty ? '--:--' : time,
          style: TextStyle(
            fontSize: 13,
            color: time.isEmpty ? Theme.of(context).hintColor : null,
          ),
        ),
      ),
    );
  }
}

// === 月循环日期选择浮层 ===

class _MonthDayPickerSheet extends StatefulWidget {
  final Set<int> selectedDays;

  const _MonthDayPickerSheet({required this.selectedDays});

  @override
  State<_MonthDayPickerSheet> createState() => _MonthDayPickerSheetState();
}

class _MonthDayPickerSheetState extends State<_MonthDayPickerSheet> {
  late Set<int> _selected;

  @override
  void initState() {
    super.initState();
    _selected = Set.from(widget.selectedDays);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 8, 0),
            child: Row(
              children: [
                Text(
                  '选择每月上课日',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () => Navigator.pop(context, _selected),
                  child: const Text('确定'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _buildCalendarGrid(theme),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildCalendarGrid(ThemeData theme) {
    return Column(
      children: [
        _buildWeekHeader(theme),
        const SizedBox(height: 6),
        _buildDaysGrid(theme),
      ],
    );
  }

  Widget _buildWeekHeader(ThemeData theme) {
    const labels = ['一', '二', '三', '四', '五', '六', '日'];
    return Row(
      children: labels.map((l) {
        return Expanded(
          child: Center(
            child: Text(
              l,
              style: TextStyle(
                fontSize: 12,
                color: theme.colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildDaysGrid(ThemeData theme) {
    final rows = <List<int?>>[];
    var row = <int?>[];

    for (var day = 1; day <= 31; day++) {
      row.add(day);
      if (row.length == 7) {
        rows.add(row);
        row = [];
      }
    }
    if (row.isNotEmpty) {
      while (row.length < 7) {
        row.add(null);
      }
      rows.add(row);
    }

    return Column(
      children: rows.map((r) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Row(
            children: r.map((day) {
              return Expanded(
                child: AspectRatio(
                  aspectRatio: 1,
                  child: day == null
                      ? const SizedBox.shrink()
                      : _DayCell(
                          day: day,
                          selected: _selected.contains(day),
                          onTap: () {
                            setState(() {
                              if (_selected.contains(day)) {
                                _selected.remove(day);
                              } else {
                                _selected.add(day);
                              }
                            });
                          },
                        ),
                ),
              );
            }).toList(),
          ),
        );
      }).toList(),
    );
  }
}

class _DayCell extends StatelessWidget {
  final int day;
  final bool selected;
  final VoidCallback onTap;

  const _DayCell({
    required this.day,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
          color: selected ? theme.colorScheme.primary : null,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Text(
            '$day',
            style: TextStyle(
              fontSize: 14,
              fontWeight: selected ? FontWeight.w600 : null,
              color: selected
                  ? theme.colorScheme.onPrimary
                  : theme.colorScheme.onSurface,
            ),
          ),
        ),
      ),
    );
  }
}

// === 指定日期选择浮层（带月份/年份切换） ===

class _DateListPickerSheet extends StatefulWidget {
  final Set<String> selectedDates;

  const _DateListPickerSheet({required this.selectedDates});

  @override
  State<_DateListPickerSheet> createState() => _DateListPickerSheetState();
}

class _DateListPickerSheetState extends State<_DateListPickerSheet> {
  late Set<String> _selected;
  late DateTime _displayMonth;
  bool _showMonthPicker = false;
  int _pickerYear = DateTime.now().year;

  @override
  void initState() {
    super.initState();
    _selected = Set.from(widget.selectedDates);
    _displayMonth = DateTime.now();
    _pickerYear = _displayMonth.year;
  }

  void _previousMonth() {
    setState(() {
      _displayMonth = DateTime(_displayMonth.year, _displayMonth.month - 1);
    });
  }

  void _nextMonth() {
    setState(() {
      _displayMonth = DateTime(_displayMonth.year, _displayMonth.month + 1);
    });
  }

  void _toggleMonthPicker() {
    setState(() {
      _showMonthPicker = !_showMonthPicker;
      _pickerYear = _displayMonth.year;
    });
  }

  void _selectMonth(int year, int month) {
    setState(() {
      _displayMonth = DateTime(year, month, 1);
      _showMonthPicker = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 8, 0),
            child: Row(
              children: [
                Text(
                  '选择上课日期',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () => Navigator.pop(context, _selected),
                  child: const Text('确定'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _buildMonthNavigator(theme),
          ),
          const SizedBox(height: 6),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _showMonthPicker
                ? _buildMonthGrid(theme)
                : _buildCalendarGrid(theme),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildMonthNavigator(ThemeData theme) {
    final monthLabel =
        '${_displayMonth.year}年${_displayMonth.month.toString().padLeft(2, '0')}月';
    return Row(
      children: [
        SizedBox(
          width: 28,
          height: 28,
          child: IconButton(
            icon: const Icon(Icons.chevron_left, size: 18),
            onPressed: _showMonthPicker
                ? () => setState(() => _pickerYear--)
                : _previousMonth,
            padding: EdgeInsets.zero,
          ),
        ),
        Expanded(
          child: GestureDetector(
            onTap: _toggleMonthPicker,
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _showMonthPicker ? '$_pickerYear年' : monthLabel,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.arrow_drop_down,
                    size: 16,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(
          width: 28,
          height: 28,
          child: IconButton(
            icon: const Icon(Icons.chevron_right, size: 18),
            onPressed: _showMonthPicker
                ? () => setState(() => _pickerYear++)
                : _nextMonth,
            padding: EdgeInsets.zero,
          ),
        ),
      ],
    );
  }

  Widget _buildMonthGrid(ThemeData theme) {
    return GridView.count(
      crossAxisCount: 4,
      shrinkWrap: true,
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      childAspectRatio: 2,
      physics: const NeverScrollableScrollPhysics(),
      children: List.generate(12, (i) {
        final isActive =
            _pickerYear == _displayMonth.year && i + 1 == _displayMonth.month;
        return GestureDetector(
          onTap: () => _selectMonth(_pickerYear, i + 1),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: isActive
                    ? theme.colorScheme.primary
                    : theme.colorScheme.outlineVariant,
              ),
              borderRadius: BorderRadius.circular(4),
              color: isActive ? theme.colorScheme.primaryContainer : null,
            ),
            child: Center(
              child: Text(
                '${i + 1}月',
                style: TextStyle(
                  fontSize: 13,
                  color: isActive
                      ? theme.colorScheme.primary
                      : theme.colorScheme.onSurface,
                  fontWeight: isActive ? FontWeight.w500 : null,
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildCalendarGrid(ThemeData theme) {
    return Column(
      children: [
        _buildWeekHeader(theme),
        const SizedBox(height: 4),
        _buildDaysGrid(theme),
      ],
    );
  }

  Widget _buildWeekHeader(ThemeData theme) {
    const labels = ['一', '二', '三', '四', '五', '六', '日'];
    return Row(
      children: labels.map((l) {
        return Expanded(
          child: Center(
            child: Text(
              l,
              style: TextStyle(
                fontSize: 12,
                color: theme.colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildDaysGrid(ThemeData theme) {
    final firstDay = DateTime(_displayMonth.year, _displayMonth.month, 1);
    final daysInMonth = DateTime(
      _displayMonth.year,
      _displayMonth.month + 1,
      0,
    ).day;
    final startWeekday = firstDay.weekday;

    final cells = <int?>[];
    for (var i = 1; i < startWeekday; i++) {
      cells.add(null);
    }
    for (var day = 1; day <= daysInMonth; day++) {
      cells.add(day);
    }
    while (cells.length % 7 != 0) {
      cells.add(null);
    }

    final rows = <List<int?>>[];
    for (var i = 0; i < cells.length; i += 7) {
      rows.add(cells.sublist(i, i + 7));
    }

    return Column(
      children: rows.map((r) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 2),
          child: Row(
            children: r.map((day) {
              return Expanded(
                child: AspectRatio(
                  aspectRatio: 1,
                  child: day == null
                      ? const SizedBox.shrink()
                      : _CalendarDayCell(
                          date: _formatDate(day),
                          label: '$day',
                          selected: _selected.contains(_formatDate(day)),
                          onTap: () {
                            setState(() {
                              final dateStr = _formatDate(day);
                              if (_selected.contains(dateStr)) {
                                _selected.remove(dateStr);
                              } else {
                                _selected.add(dateStr);
                              }
                            });
                          },
                        ),
                ),
              );
            }).toList(),
          ),
        );
      }).toList(),
    );
  }

  String _formatDate(int day) {
    return '${_displayMonth.year.toString().padLeft(4, '0')}-'
        '${_displayMonth.month.toString().padLeft(2, '0')}-'
        '${day.toString().padLeft(2, '0')}';
  }
}

class _CalendarDayCell extends StatelessWidget {
  final String date;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _CalendarDayCell({
    required this.date,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
          color: selected ? theme.colorScheme.primary : null,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: selected ? FontWeight.w600 : null,
              color: selected
                  ? theme.colorScheme.onPrimary
                  : theme.colorScheme.onSurface,
            ),
          ),
        ),
      ),
    );
  }
}

// === 周循环星期选择浮层 ===

class _WeekdayPickerSheet extends StatefulWidget {
  final Set<int> selectedDays;

  const _WeekdayPickerSheet({required this.selectedDays});

  @override
  State<_WeekdayPickerSheet> createState() => _WeekdayPickerSheetState();
}

class _WeekdayPickerSheetState extends State<_WeekdayPickerSheet> {
  late Set<int> _selected;

  static const _labels = ['周一', '周二', '周三', '周四', '周五', '周六', '周日'];

  @override
  void initState() {
    super.initState();
    _selected = Set.from(widget.selectedDays);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 8, 12),
              child: Row(
                children: [
                  Text(
                    '选择每周上课日',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () => Navigator.pop(context, _selected),
                    child: const Text('确定'),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: List.generate(7, (i) {
                  final day = i + 1;
                  final isSelected = _selected.contains(day);
                  return Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          if (_selected.contains(day)) {
                            _selected.remove(day);
                          } else {
                            _selected.add(day);
                          }
                        });
                      },
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: Container(
                          decoration: BoxDecoration(
                            color: isSelected
                                ? theme.colorScheme.primary
                                : null,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isSelected
                                  ? theme.colorScheme.primary
                                  : theme.colorScheme.outlineVariant,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              _labels[i],
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: isSelected ? FontWeight.w600 : null,
                                color: isSelected
                                    ? theme.colorScheme.onPrimary
                                    : theme.colorScheme.onSurface,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 添加上课计划浮层
class ScheduleFormBottomSheet extends ConsumerStatefulWidget {
  final int courseId;

  const ScheduleFormBottomSheet({super.key, required this.courseId});

  @override
  ConsumerState<ScheduleFormBottomSheet> createState() =>
      _ScheduleFormBottomSheetState();
}

class _ScheduleFormBottomSheetState
    extends ConsumerState<ScheduleFormBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _notesController = TextEditingController();
  final _locationController = TextEditingController();

  String _scheduleType = 'weekly_repeat';
  final List<WeekdaySlot> _weekdaySlots = [];
  final List<MonthDaySlot> _monthDaySlots = [];
  final List<DateSlot> _dateSlots = [];
  DateTime? _validFrom;
  DateTime? _validUntil;
  bool _isLoading = false;

  static const _weekdayLabels = ['周一', '周二', '周三', '周四', '周五', '周六', '周日'];

  @override
  void initState() {
    super.initState();
    _validFrom = DateTime.now();
  }

  @override
  void dispose() {
    _notesController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  bool _validate() {
    if (_scheduleType == 'weekly_repeat' && _weekdaySlots.isEmpty) {
      _showError('请至少选择一天');
      return false;
    }
    if (_scheduleType == 'monthly_repeat' && _monthDaySlots.isEmpty) {
      _showError('请至少选择一天');
      return false;
    }
    if (_scheduleType == 'date_list' && _dateSlots.isEmpty) {
      _showError('请至少选择一个日期');
      return false;
    }
    if (_validFrom == null) {
      _showError('请选择开始日期');
      return false;
    }
    return true;
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
  }

  Future<void> _save() async {
    if (!_validate()) return;

    setState(() => _isLoading = true);

    final repo = ref.read(scheduleRepositoryProvider);
    final now = DateTime.now();

    String? slotsJson;
    int? weekday;
    String? dateListStr;
    String? startTime;
    String? endTime;

    switch (_scheduleType) {
      case 'weekly_repeat':
        slotsJson = ScheduleSlotsJson.encodeWeeklySlots(_weekdaySlots);
        weekday = _weekdaySlots.first.weekday;
        startTime = _weekdaySlots.first.startTime;
        endTime = _weekdaySlots.first.endTime;
      case 'monthly_repeat':
        slotsJson = ScheduleSlotsJson.encodeMonthlySlots(_monthDaySlots);
        startTime = _monthDaySlots.first.startTime;
        endTime = _monthDaySlots.first.endTime;
      case 'date_list':
        slotsJson = ScheduleSlotsJson.encodeDateSlots(_dateSlots);
        dateListStr = _dateSlots.map((s) => s.date).join(',');
        startTime = _dateSlots.first.startTime;
        endTime = _dateSlots.first.endTime;
      default:
        break;
    }

    final entry = CourseSchedulesCompanion(
      kidCourseId: Value(widget.courseId),
      scheduleType: Value(_scheduleType),
      weekday: Value(weekday),
      startTime: Value(startTime ?? ''),
      endTime: Value(endTime ?? ''),
      dateList: Value(dateListStr),
      slotsJson: Value(slotsJson),
      location: Value(
        _locationController.text.trim().isEmpty
            ? null
            : _locationController.text.trim(),
      ),
      validFrom: Value(_validFrom ?? now),
      validUntil: Value(_validUntil),
      notes: Value(
        _notesController.text.trim().isEmpty
            ? null
            : _notesController.text.trim(),
      ),
      createdAt: Value(now),
      updatedAt: Value(now),
    );

    final result = await repo.insertSchedule(entry);

    if (!mounted) return;

    switch (result) {
      case Ok():
        ref.read(homeDataVersionProvider.notifier).state++;
        setState(() => _isLoading = false);
        Navigator.pop(context, true);
      case Err(:final error):
        setState(() => _isLoading = false);
        _showError(error.message);
    }
  }

  @override
  Widget build(BuildContext context) {
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    '添加上课计划',
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
          Expanded(
            child: Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  SegmentedButton<String>(
                    segments: const [
                      ButtonSegment(value: 'weekly_repeat', label: Text('周循环')),
                      ButtonSegment(
                        value: 'monthly_repeat',
                        label: Text('月循环'),
                      ),
                      ButtonSegment(value: 'date_list', label: Text('指定日期')),
                    ],
                    selected: {_scheduleType},
                    onSelectionChanged: (v) =>
                        setState(() => _scheduleType = v.first),
                  ),
                  const SizedBox(height: 16),
                  _buildConditionalFields(),
                  const Divider(height: 32),
                  _buildValidityFields(),
                  const SizedBox(height: 12),
                  _buildLocationField(),
                  const SizedBox(height: 12),
                  _buildNotesField(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConditionalFields() {
    switch (_scheduleType) {
      case 'weekly_repeat':
        return _buildWeeklyFields();
      case 'monthly_repeat':
        return _buildMonthlyFields();
      case 'date_list':
        return _buildDateListFields();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildWeeklyFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const _Label(label: '每周上课日'),
            const Spacer(),
            TextButton.icon(
              onPressed: _showWeeklyPicker,
              icon: const Icon(Icons.date_range, size: 18),
              label: Text(_weekdaySlots.isEmpty ? '选择星期' : '修改'),
            ),
          ],
        ),
        if (_weekdaySlots.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Text(
              '点击「选择星期」选取每周上课日',
              style: TextStyle(
                fontSize: 13,
                color: Theme.of(context).hintColor,
              ),
            ),
          )
        else ...[
          const SizedBox(height: 4),
          Wrap(
            spacing: 6,
            runSpacing: 4,
            children: _weekdaySlots.map((slot) {
              return Chip(
                label: Text(_weekdayLabels[slot.weekday - 1]),
                visualDensity: VisualDensity.compact,
                onDeleted: () => setState(() {
                  _weekdaySlots.removeWhere((s) => s.weekday == slot.weekday);
                }),
              );
            }).toList(),
          ),
          const SizedBox(height: 12),
          ..._weekdaySlots.map((slot) => _buildWeekdayTimeRow(slot)),
        ],
      ],
    );
  }

  Future<void> _showWeeklyPicker() async {
    final selectedWeekdays = _weekdaySlots.map((s) => s.weekday).toSet();
    final result = await showModalBottomSheet<Set<int>>(
      context: context,
      builder: (ctx) => _WeekdayPickerSheet(selectedDays: selectedWeekdays),
    );
    if (result == null || !mounted) return;

    setState(() {
      final removed = _weekdaySlots
          .where((s) => !result.contains(s.weekday))
          .map((s) => s.weekday)
          .toSet();
      _weekdaySlots.removeWhere((s) => removed.contains(s.weekday));

      final existing = _weekdaySlots.map((s) => s.weekday).toSet();
      final defaultStart = _weekdaySlots.isNotEmpty
          ? _weekdaySlots.last.startTime
          : '09:00';
      final defaultEnd = _weekdaySlots.isNotEmpty
          ? _weekdaySlots.last.endTime
          : '10:00';
      for (final day in result) {
        if (!existing.contains(day)) {
          _weekdaySlots.add(
            WeekdaySlot(
              weekday: day,
              startTime: defaultStart,
              endTime: defaultEnd,
            ),
          );
        }
      }
    });
  }

  Widget _buildWeekdayTimeRow(WeekdaySlot slot) {
    final idx = _weekdaySlots.indexOf(slot);
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: theme.colorScheme.outlineVariant),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 40,
              child: Text(
                _weekdayLabels[slot.weekday - 1],
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _TimeField(
                time: slot.startTime,
                onPicked: (t) => setState(
                  () => _weekdaySlots[idx] = WeekdaySlot(
                    weekday: slot.weekday,
                    startTime: t,
                    endTime: slot.endTime,
                  ),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 6),
              child: Text('-'),
            ),
            Expanded(
              child: _TimeField(
                time: slot.endTime,
                onPicked: (t) => setState(
                  () => _weekdaySlots[idx] = WeekdaySlot(
                    weekday: slot.weekday,
                    startTime: slot.startTime,
                    endTime: t,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMonthlyFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const _Label(label: '每月上课日'),
            const Spacer(),
            TextButton.icon(
              onPressed: _showMonthlyPicker,
              icon: const Icon(Icons.calendar_month, size: 18),
              label: Text(_monthDaySlots.isEmpty ? '选择日期' : '修改日期'),
            ),
          ],
        ),
        if (_monthDaySlots.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Text(
              '点击「选择日期」选取每月上课日',
              style: TextStyle(
                fontSize: 13,
                color: Theme.of(context).hintColor,
              ),
            ),
          )
        else ...[
          const SizedBox(height: 4),
          Wrap(
            spacing: 6,
            runSpacing: 4,
            children: _monthDaySlots.map((slot) {
              return Chip(
                label: Text('每月${slot.dayOfMonth}号'),
                visualDensity: VisualDensity.compact,
                onDeleted: () => setState(
                  () => _monthDaySlots.removeWhere(
                    (s) => s.dayOfMonth == slot.dayOfMonth,
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 12),
          ..._monthDaySlots.map((slot) => _buildMonthDayTimeRow(slot)),
        ],
      ],
    );
  }

  Future<void> _showMonthlyPicker() async {
    final selectedDays = _monthDaySlots.map((s) => s.dayOfMonth).toSet();
    final result = await showModalBottomSheet<Set<int>>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => _MonthDayPickerSheet(selectedDays: selectedDays),
    );
    if (result == null || !mounted) return;

    setState(() {
      final removed = _monthDaySlots
          .where((s) => !result.contains(s.dayOfMonth))
          .map((s) => s.dayOfMonth)
          .toSet();
      _monthDaySlots.removeWhere((s) => removed.contains(s.dayOfMonth));

      final existing = _monthDaySlots.map((s) => s.dayOfMonth).toSet();
      final defaultStart = _monthDaySlots.isNotEmpty
          ? _monthDaySlots.last.startTime
          : '09:00';
      final defaultEnd = _monthDaySlots.isNotEmpty
          ? _monthDaySlots.last.endTime
          : '10:00';
      for (final day in result) {
        if (!existing.contains(day)) {
          _monthDaySlots.add(
            MonthDaySlot(
              dayOfMonth: day,
              startTime: defaultStart,
              endTime: defaultEnd,
            ),
          );
        }
      }
    });
  }

  Widget _buildMonthDayTimeRow(MonthDaySlot slot) {
    final idx = _monthDaySlots.indexOf(slot);
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: theme.colorScheme.outlineVariant),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 56,
              child: Text(
                '每月${slot.dayOfMonth}号',
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _TimeField(
                time: slot.startTime,
                onPicked: (t) => setState(
                  () => _monthDaySlots[idx] = MonthDaySlot(
                    dayOfMonth: slot.dayOfMonth,
                    startTime: t,
                    endTime: slot.endTime,
                  ),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 6),
              child: Text('-'),
            ),
            Expanded(
              child: _TimeField(
                time: slot.endTime,
                onPicked: (t) => setState(
                  () => _monthDaySlots[idx] = MonthDaySlot(
                    dayOfMonth: slot.dayOfMonth,
                    startTime: slot.startTime,
                    endTime: t,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateListFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const _Label(label: '选择上课日期'),
            const Spacer(),
            TextButton.icon(
              onPressed: _showDateListPicker,
              icon: const Icon(Icons.calendar_month, size: 18),
              label: Text(_dateSlots.isEmpty ? '选择日期' : '修改日期'),
            ),
          ],
        ),
        if (_dateSlots.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Text(
              '点击「选择日期」选取上课日期',
              style: TextStyle(
                fontSize: 13,
                color: Theme.of(context).hintColor,
              ),
            ),
          )
        else ...[
          const SizedBox(height: 4),
          Wrap(
            spacing: 6,
            runSpacing: 4,
            children: _dateSlots.map((slot) {
              return Chip(
                label: Text(slot.date),
                visualDensity: VisualDensity.compact,
                onDeleted: () => setState(() => _dateSlots.remove(slot)),
              );
            }).toList(),
          ),
          const SizedBox(height: 12),
          ..._dateSlots.map((slot) => _buildDateSlotRow(slot)),
        ],
      ],
    );
  }

  Future<void> _showDateListPicker() async {
    final existingDates = _dateSlots.map((s) => s.date).toSet();
    final result = await showModalBottomSheet<Set<String>>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => _DateListPickerSheet(selectedDates: existingDates),
    );
    if (result == null || !mounted) return;

    setState(() {
      final removed = _dateSlots
          .where((s) => !result.contains(s.date))
          .map((s) => s.date)
          .toSet();
      _dateSlots.removeWhere((s) => removed.contains(s.date));

      final existing = _dateSlots.map((s) => s.date).toSet();
      final defaultStart = _dateSlots.isNotEmpty
          ? _dateSlots.last.startTime
          : '09:00';
      final defaultEnd = _dateSlots.isNotEmpty
          ? _dateSlots.last.endTime
          : '10:00';
      final sortedDates = result.toList()..sort();
      for (final date in sortedDates) {
        if (!existing.contains(date)) {
          _dateSlots.add(
            DateSlot(date: date, startTime: defaultStart, endTime: defaultEnd),
          );
        }
      }
      _dateSlots.sort((a, b) => a.date.compareTo(b.date));
    });
  }

  Widget _buildDateSlotRow(DateSlot slot) {
    final idx = _dateSlots.indexOf(slot);
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: theme.colorScheme.outlineVariant),
        ),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Text(
                slot.date,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
            Expanded(
              child: _TimeField(
                time: slot.startTime,
                onPicked: (t) => setState(
                  () => _dateSlots[idx] = DateSlot(
                    date: slot.date,
                    startTime: t,
                    endTime: slot.endTime,
                  ),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 6),
              child: Text('-'),
            ),
            Expanded(
              child: _TimeField(
                time: slot.endTime,
                onPicked: (t) => setState(
                  () => _dateSlots[idx] = DateSlot(
                    date: slot.date,
                    startTime: slot.startTime,
                    endTime: t,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildValidityFields() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _Label(label: '开始日期'),
              const SizedBox(height: 4),
              _DateField(
                date: _validFrom,
                onPicked: (d) => setState(() => _validFrom = d),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _Label(label: '结束日期（可选）'),
              const SizedBox(height: 4),
              _DateField(
                date: _validUntil,
                onPicked: (d) => setState(() => _validUntil = d),
                clearable: true,
                onClear: () => setState(() => _validUntil = null),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLocationField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _Label(label: '上课地点'),
        const SizedBox(height: 4),
        TextFormField(
          controller: _locationController,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: '如：少年宫 3 楼舞蹈室',
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          ),
        ),
      ],
    );
  }

  Widget _buildNotesField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _Label(label: '备注'),
        const SizedBox(height: 4),
        TextFormField(controller: _notesController, maxLines: 2),
      ],
    );
  }
}
