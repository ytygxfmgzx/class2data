import 'dart:io';
import 'dart:math';

import 'package:class2data/core/result/result.dart';
import 'package:class2data/data/database/app_database.dart';
import 'package:class2data/domain/services/schedule_occurrence_service.dart';
import 'package:class2data/features/children/providers/child_providers.dart';
import 'package:class2data/features/class_records/presentation/class_record_bottom_sheet.dart';
import 'package:class2data/features/courses/providers/course_providers.dart';
import 'package:class2data/features/growth/models/growth_feed_event.dart';
import 'package:class2data/features/growth/providers/growth_providers.dart';
import 'package:class2data/shared/widgets/child_avatar.dart';
import 'package:class2data/shared/widgets/photo_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class GrowthPage extends ConsumerWidget {
  const GrowthPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final childrenAsync = ref.watch(activeChildrenProvider);
    final feedAsync = ref.watch(growthFeedProvider);
    final filter = ref.watch(growthFilterProvider);

    return childrenAsync.when(
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, _) => Scaffold(body: Center(child: Text('加载失败: $e'))),
      data: (result) => switch (result) {
        Ok(:final value) => _buildContent(
          context,
          ref,
          value,
          feedAsync,
          filter,
        ),
        Err(:final error) => Scaffold(
          body: Center(child: Text('加载失败: ${error.message}')),
        ),
      },
    );
  }

  Widget _buildContent(
    BuildContext context,
    WidgetRef ref,
    List<ChildrenData> children,
    AsyncValue<List<GrowthFeedEvent>> feedAsync,
    GrowthFilter filter,
  ) {
    if (children.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('成长')),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('还没有孩子', style: Theme.of(context).textTheme.bodyLarge),
              const SizedBox(height: 12),
              FilledButton(
                onPressed: () => context.push('/children/add'),
                child: const Text('录入孩子'),
              ),
            ],
          ),
        ),
      );
    }

    final coursesAsync = ref.watch(allActiveCoursesProvider);
    final courses =
        coursesAsync.whenOrNull(
          data: (result) => switch (result) {
            Ok(:final value) => value,
            Err() => <KidCourse>[],
          },
        ) ??
        <KidCourse>[];

    return Scaffold(
      appBar: AppBar(
        title: const Text('成长'),
        actions: [
          IconButton(
            icon: const Icon(Icons.bar_chart),
            tooltip: '统计',
            onPressed: () => context.push('/statistics'),
          ),
        ],
      ),
      body: feedAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('加载失败: $e')),
        data: (events) {
          if (events.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('还没有记录', style: Theme.of(context).textTheme.bodyLarge),
                  const SizedBox(height: 12),
                  FilledButton(
                    onPressed: () =>
                        _addRecord(context, ref, courses, children),
                    child: const Text('添加记录'),
                  ),
                ],
              ),
            );
          }
          return _FeedList(events: events);
        },
      ),
      floatingActionButton: _FilterFab(
        children: children,
        filter: filter,
        onFilterChanged: (f) =>
            ref.read(growthFilterProvider.notifier).state = f,
      ),
    );
  }

  Future<void> _addRecord(
    BuildContext context,
    WidgetRef ref,
    List<KidCourse> courses,
    List<ChildrenData> children,
  ) async {
    if (courses.isEmpty) {
      await context.push('/courses/add');
      return;
    }

    final selected = await showDialog<KidCourse>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('选择课程'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: courses.map((c) {
              final child = children
                  .where((ch) => ch.id == c.childId)
                  .firstOrNull;
              return ListTile(
                leading: child != null
                    ? ChildAvatar(
                        name: child.name,
                        avatarPath: child.avatarPath,
                        radius: 16,
                      )
                    : null,
                title: Text(c.name),
                subtitle: child != null ? Text(child.name) : null,
                onTap: () => Navigator.pop(ctx, c),
              );
            }).toList(),
          ),
        ),
      ),
    );
    if (selected == null || !context.mounted) return;

    final now = DateTime.now();
    final occurrence = ScheduleOccurrence(
      scheduleId: -1,
      kidCourseId: selected.id,
      date:
          '${now.year.toString().padLeft(4, '0')}-'
          '${now.month.toString().padLeft(2, '0')}-'
          '${now.day.toString().padLeft(2, '0')}',
      startTime: DateFormat('HH:mm').format(now),
      endTime: DateFormat('HH:mm').format(now.add(const Duration(hours: 1))),
      occurrenceKey: 'manual_${selected.id}_${now.millisecondsSinceEpoch}',
      classType: null,
      classNameSnapshot: selected.name,
    );

    await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      builder: (_) => ClassRecordBottomSheet(occurrence: occurrence),
    );
  }
}

class _FeedList extends StatelessWidget {
  final List<GrowthFeedEvent> events;

  const _FeedList({required this.events});

  @override
  Widget build(BuildContext context) {
    final grouped = <String, List<GrowthFeedEvent>>{};
    for (final e in events) {
      grouped.putIfAbsent(e.dateKey, () => []).add(e);
    }
    final dates = grouped.keys.toList();

    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 80),
      itemCount: dates.length,
      itemBuilder: (context, index) {
        final date = dates[index];
        final dayEvents = grouped[date]!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _DateHeader(date: date),
            for (final event in dayEvents) _FeedCard(event: event),
          ],
        );
      },
    );
  }
}

class _DateHeader extends StatelessWidget {
  final String date;

  const _DateHeader({required this.date});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 4),
      child: Text(
        _formatDate(date),
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: theme.colorScheme.primary,
        ),
      ),
    );
  }

  String _formatDate(String dateStr) {
    final d = DateTime.tryParse(dateStr);
    if (d == null) return dateStr;
    const weekdays = ['一', '二', '三', '四', '五', '六', '日'];
    return '${d.year}年${d.month}月${d.day}日 周${weekdays[d.weekday - 1]}';
  }
}

class _FeedCard extends StatelessWidget {
  final GrowthFeedEvent event;

  const _FeedCard({required this.event});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final typeIcon = _typeIcon;
    final typeColor = _typeColor(theme);

    return InkWell(
      onTap: () => _navigate(context),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ChildAvatar(
              name: event.childName,
              avatarPath: event.childAvatarPath,
              radius: 20,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        event.childName,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      if (event.timeRange != null)
                        Text(
                          event.timeRange!,
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(typeIcon, size: 14, color: typeColor),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          event.title,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      if (event.recordStatus != null)
                        _StatusBadge(status: event.recordStatus!),
                    ],
                  ),
                  if (event.subtitle != null && event.subtitle!.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      event.subtitle!,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                  if (event.notes != null && event.notes!.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceContainerLow,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        event.notes!,
                        style: theme.textTheme.bodyMedium,
                      ),
                    ),
                  ],
                  if (event.imagePaths.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    _PhotoGrid(
                      imagePaths: event.imagePaths,
                      onTap: (index) => PhotoViewerDialog.show(
                        context,
                        imagePaths: event.imagePaths,
                        initialIndex: index,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData get _typeIcon => switch (event.type) {
    'class_record' => Icons.school,
    'achievement' => Icons.emoji_events,
    'package' => Icons.inventory_2,
    _ => Icons.circle,
  };

  Color _typeColor(ThemeData theme) => switch (event.type) {
    'class_record' => theme.colorScheme.primary,
    'achievement' => theme.colorScheme.tertiary,
    'package' => theme.colorScheme.secondary,
    _ => theme.colorScheme.onSurfaceVariant,
  };

  void _navigate(BuildContext context) {
    switch (event.type) {
      case 'class_record':
        if (event.recordId != null) {
          context.push('/class-records/${event.recordId}');
        }
      case 'achievement':
        if (event.achievementId != null) {
          context.push('/achievements/${event.achievementId}/edit');
        }
      case 'package':
        if (event.courseId != null) {
          context.push('/courses/${event.courseId}?tab=1');
        }
    }
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final (label, bgColor, textColor) = _style;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(label, style: TextStyle(fontSize: 10, color: textColor)),
    );
  }

  (String, Color, Color) get _style => switch (status) {
    'attended' => ('已上课', const Color(0xFFDCFCE7), const Color(0xFF166534)),
    'leave' => ('请假', const Color(0xFFF3F4F6), const Color(0xFF6B7280)),
    'cancelled' => ('取消', const Color(0xFFF3F4F6), const Color(0xFF6B7280)),
    'absent' => ('缺课', const Color(0xFFFEE2E2), const Color(0xFF991B1B)),
    'makeup' => ('补课', const Color(0xFFDBEAFE), const Color(0xFF1E40AF)),
    _ => (status, const Color(0xFFF3F4F6), const Color(0xFF6B7280)),
  };
}

class _PhotoGrid extends StatelessWidget {
  final List<String> imagePaths;
  final void Function(int index) onTap;

  const _PhotoGrid({required this.imagePaths, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final count = min(imagePaths.length, 9);
    if (count == 0) return const SizedBox.shrink();

    // 按3列计算每张缩略图尺寸，保证无论几张照片大小一致
    final screenWidth = MediaQuery.of(context).size.width;
    // 右侧内容区宽度 = 屏幕宽度 - 头像(40) - 间距(10) - 左右边距(16*2)
    final contentWidth = screenWidth - 40 - 10 - 32;
    const spacing = 4.0;
    final thumbSize = ((contentWidth - spacing * 2) / 3).floorToDouble();

    return Wrap(
      spacing: spacing,
      runSpacing: spacing,
      children: List.generate(count, (index) {
        return GestureDetector(
          onTap: () => onTap(index),
          child: SizedBox(
            width: thumbSize,
            height: thumbSize,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: _PhotoThumbnail(path: imagePaths[index]),
            ),
          ),
        );
      }),
    );
  }
}

class _PhotoThumbnail extends StatelessWidget {
  final String path;

  const _PhotoThumbnail({required this.path});

  @override
  Widget build(BuildContext context) {
    return Image.file(
      File(path),
      fit: BoxFit.cover,
      errorBuilder: (_, _, _) => Container(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        child: const Center(
          child: Icon(Icons.broken_image, size: 24, color: Colors.white38),
        ),
      ),
    );
  }
}

class _FilterFab extends StatelessWidget {
  final List<ChildrenData> children;
  final GrowthFilter filter;
  final ValueChanged<GrowthFilter> onFilterChanged;

  const _FilterFab({
    required this.children,
    required this.filter,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isFiltered =
        !filter.showAllChildren || !filter.showAllTypes || !filter.showAllDates;

    return FloatingActionButton.small(
      onPressed: () => _showFilterSheet(context),
      tooltip: '筛选',
      backgroundColor: isFiltered
          ? theme.colorScheme.primaryContainer
          : theme.colorScheme.surfaceContainerHigh,
      foregroundColor: isFiltered
          ? theme.colorScheme.onPrimaryContainer
          : theme.colorScheme.onSurfaceVariant,
      child: Icon(
        isFiltered ? Icons.filter_list : Icons.filter_list_outlined,
        size: 20,
      ),
    );
  }

  Future<void> _showFilterSheet(BuildContext context) async {
    final result = await showModalBottomSheet<GrowthFilter>(
      context: context,
      builder: (_) => _FilterSheet(children: children, initialFilter: filter),
    );
    if (result != null) {
      onFilterChanged(result);
    }
  }
}

class _FilterSheet extends StatefulWidget {
  final List<ChildrenData> children;
  final GrowthFilter initialFilter;

  const _FilterSheet({required this.children, required this.initialFilter});

  @override
  State<_FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<_FilterSheet> {
  late int? _selectedChildId;
  late Set<String> _selectedTypes;
  String? _dateFrom;
  String? _dateTo;

  @override
  void initState() {
    super.initState();
    _selectedChildId = widget.initialFilter.childId;
    _selectedTypes = Set.from(widget.initialFilter.types);
    _dateFrom = widget.initialFilter.dateFrom;
    _dateTo = widget.initialFilter.dateTo;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  '筛选',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () {
                    _selectedChildId = null;
                    _selectedTypes.clear();
                    _dateFrom = null;
                    _dateTo = null;
                    Navigator.pop(context, const GrowthFilter());
                  },
                  child: const Text('重置'),
                ),
              ],
            ),
            if (widget.children.length > 1) ...[
              const SizedBox(height: 8),
              Text(
                '孩子',
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 4),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: [
                  FilterChip(
                    label: const Text('全部'),
                    selected: _selectedChildId == null,
                    onSelected: (_) => setState(() => _selectedChildId = null),
                  ),
                  for (final child in widget.children)
                    FilterChip(
                      label: Text(child.name),
                      selected: _selectedChildId == child.id,
                      onSelected: (_) =>
                          setState(() => _selectedChildId = child.id),
                    ),
                ],
              ),
            ],
            const SizedBox(height: 12),
            Text(
              '记录类型',
              style: theme.textTheme.labelMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 4),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: [
                FilterChip(
                  label: const Text('全部'),
                  selected: _selectedTypes.isEmpty,
                  onSelected: (_) => setState(() => _selectedTypes.clear()),
                ),
                FilterChip(
                  avatar: const Icon(Icons.school, size: 14),
                  label: const Text('上课记录'),
                  selected: _selectedTypes.contains('class_record'),
                  onSelected: (v) => setState(() {
                    v
                        ? _selectedTypes.add('class_record')
                        : _selectedTypes.remove('class_record');
                  }),
                ),
                FilterChip(
                  avatar: const Icon(Icons.emoji_events, size: 14),
                  label: const Text('成长记录'),
                  selected: _selectedTypes.contains('achievement'),
                  onSelected: (v) => setState(() {
                    v
                        ? _selectedTypes.add('achievement')
                        : _selectedTypes.remove('achievement');
                  }),
                ),
                FilterChip(
                  avatar: const Icon(Icons.inventory_2, size: 14),
                  label: const Text('课包记录'),
                  selected: _selectedTypes.contains('package'),
                  onSelected: (v) => setState(() {
                    v
                        ? _selectedTypes.add('package')
                        : _selectedTypes.remove('package');
                  }),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              '时间区间',
              style: theme.textTheme.labelMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Expanded(
                  child: _MonthPickerField(
                    label: '开始月份',
                    value: _dateFrom,
                    onChanged: (v) => setState(() => _dateFrom = v),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    '至',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
                Expanded(
                  child: _MonthPickerField(
                    label: '结束月份',
                    value: _dateTo,
                    onChanged: (v) => setState(() => _dateTo = v),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () => Navigator.pop(
                  context,
                  GrowthFilter(
                    childId: _selectedChildId,
                    types: Set.from(_selectedTypes),
                    dateFrom: _dateFrom,
                    dateTo: _dateTo,
                  ),
                ),
                child: const Text('确定'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MonthPickerField extends StatelessWidget {
  final String label;
  final String? value;
  final ValueChanged<String?> onChanged;

  const _MonthPickerField({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final display = value ?? '全部';

    return GestureDetector(
      onTap: () => _showMonthPicker(context),
      child: InputDecorator(
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          isDense: true,
        ),
        child: Text(
          display,
          style: value != null
              ? theme.textTheme.bodyMedium
              : theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
        ),
      ),
    );
  }

  Future<void> _showMonthPicker(BuildContext context) async {
    final result = await showModalBottomSheet<String>(
      context: context,
      builder: (ctx) => _MonthPickerDialog(initialValue: value),
    );
    if (result != null) {
      onChanged(result.isEmpty ? null : result);
    }
  }
}

class _MonthPickerDialog extends StatefulWidget {
  final String? initialValue;

  const _MonthPickerDialog({required this.initialValue});

  @override
  State<_MonthPickerDialog> createState() => _MonthPickerDialogState();
}

class _MonthPickerDialogState extends State<_MonthPickerDialog> {
  late int _year;

  @override
  void initState() {
    super.initState();
    if (widget.initialValue != null) {
      _year =
          int.tryParse(widget.initialValue!.substring(0, 4)) ??
          DateTime.now().year;
    } else {
      _year = DateTime.now().year;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left, size: 20),
                  onPressed: () => setState(() => _year--),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
                const SizedBox(width: 16),
                Text(
                  '$_year年',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 16),
                IconButton(
                  icon: const Icon(Icons.chevron_right, size: 20),
                  onPressed: () => setState(() => _year++),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
            const SizedBox(height: 12),
            GridView.count(
              crossAxisCount: 4,
              shrinkWrap: true,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: 2,
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context, ''),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: theme.colorScheme.outlineVariant,
                      ),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Center(
                      child: Text(
                        '全部',
                        style: TextStyle(
                          fontSize: 13,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                    ),
                  ),
                ),
                for (int m = 1; m <= 12; m++)
                  GestureDetector(
                    onTap: () => Navigator.pop(
                      context,
                      '$_year-${m.toString().padLeft(2, '0')}',
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color:
                              widget.initialValue ==
                                  '$_year-${m.toString().padLeft(2, '0')}'
                              ? theme.colorScheme.primary
                              : theme.colorScheme.outlineVariant,
                        ),
                        borderRadius: BorderRadius.circular(4),
                        color:
                            widget.initialValue ==
                                '$_year-${m.toString().padLeft(2, '0')}'
                            ? theme.colorScheme.primaryContainer
                            : null,
                      ),
                      child: Center(
                        child: Text(
                          '$m月',
                          style: TextStyle(
                            fontSize: 13,
                            color:
                                widget.initialValue ==
                                    '$_year-${m.toString().padLeft(2, '0')}'
                                ? theme.colorScheme.primary
                                : theme.colorScheme.onSurface,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
