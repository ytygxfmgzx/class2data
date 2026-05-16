import 'package:class2data/core/result/result.dart';
import 'package:class2data/data/database/app_database.dart';
import 'package:class2data/domain/models/schedule_slots.dart';
import 'package:class2data/features/children/providers/child_providers.dart';
import 'package:class2data/features/courses/providers/course_providers.dart';
import 'package:class2data/features/home/providers/home_providers.dart';
import 'package:class2data/shared/providers/database_provider.dart';
import 'package:class2data/shared/widgets/child_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final _allSchedulesProvider = FutureProvider<List<CourseSchedule>>((ref) async {
  ref.watch(homeDataVersionProvider);
  final db = ref.watch(databaseProvider);
  return (db.select(db.courseSchedules)).get();
});

class PlanManagePage extends ConsumerWidget {
  const PlanManagePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final schedulesAsync = ref.watch(_allSchedulesProvider);
    final coursesAsync = ref.watch(allActiveCoursesProvider);
    final childrenAsync = ref.watch(activeChildrenProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('课程计划维护'),
        actions: [
          TextButton(
            onPressed: () => _addPlan(context, ref),
            child: const Text('添加'),
          ),
        ],
      ),
      body: schedulesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('加载失败: $e')),
        data: (schedules) {
          final coursesResult = coursesAsync.whenOrNull(data: (r) => r);
          final childrenResult = childrenAsync.whenOrNull(data: (r) => r);

          final courses = switch (coursesResult) {
            Ok(:final value) => value,
            _ => <KidCourse>[],
          };
          final children = switch (childrenResult) {
            Ok(:final value) => value,
            _ => <ChildrenData>[],
          };

          if (schedules.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('还没有课程计划'),
                  const SizedBox(height: 12),
                  FilledButton(
                    onPressed: () => _addPlan(context, ref),
                    child: const Text('添加计划'),
                  ),
                ],
              ),
            );
          }

          return _PlanList(
            schedules: schedules,
            courses: courses,
            children: children,
          );
        },
      ),
    );
  }

  Future<void> _addPlan(BuildContext context, WidgetRef ref) async {
    final coursesAsync = ref.read(allActiveCoursesProvider);
    final childrenAsync = ref.read(activeChildrenProvider);
    final courses =
        coursesAsync.whenOrNull(
          data: (result) => switch (result) {
            Ok(:final value) => value,
            Err() => <KidCourse>[],
          },
        ) ??
        <KidCourse>[];
    final children =
        childrenAsync.whenOrNull(
          data: (result) => switch (result) {
            Ok(:final value) => value,
            Err() => <ChildrenData>[],
          },
        ) ??
        <ChildrenData>[];

    if (courses.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('请先添加课程')));
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
    if (selected != null && context.mounted) {
      await context.push('/courses/${selected.id}/schedules/add');
      ref.invalidate(_allSchedulesProvider);
    }
  }
}

class _PlanList extends ConsumerWidget {
  final List<CourseSchedule> schedules;
  final List<KidCourse> courses;
  final List<ChildrenData> children;

  static const _weekLabels = ['一', '二', '三', '四', '五', '六', '日'];

  const _PlanList({
    required this.schedules,
    required this.courses,
    required this.children,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return ListView.builder(
      itemCount: schedules.length,
      itemBuilder: (context, index) {
        final schedule = schedules[index];
        final course = courses
            .where((c) => c.id == schedule.kidCourseId)
            .firstOrNull;
        final child = course != null
            ? children.where((c) => c.id == course.childId).firstOrNull
            : null;

        final scheduleLabel = _buildScheduleLabel(schedule);

        return Dismissible(
          key: ValueKey(schedule.id),
          direction: DismissDirection.endToStart,
          confirmDismiss: (_) =>
              _confirmDelete(context, course?.name ?? '未知', scheduleLabel),
          onDismissed: (_) {
            final dao = ref.read(scheduleDaoProvider);
            dao.deleteSchedule(schedule.id);
            ref.read(homeDataVersionProvider.notifier).state++;
          },
          background: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 16),
            color: theme.colorScheme.error,
            child: Icon(Icons.delete, color: theme.colorScheme.onError),
          ),
          child: InkWell(
            onTap: () => context.push(
              '/courses/${schedule.kidCourseId}/schedules/${schedule.id}/edit',
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              constraints: const BoxConstraints(minHeight: 48),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: theme.colorScheme.outlineVariant,
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                children: [
                  if (child != null) ...[
                    ChildAvatar(
                      name: child.name,
                      avatarPath: child.avatarPath,
                      radius: 16,
                    ),
                    const SizedBox(width: 10),
                  ],
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${course?.name ?? "未知"} · $scheduleLabel',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          _buildDateRange(schedule),
                          style: TextStyle(
                            fontSize: 12,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        if (child != null)
                          Text(
                            child.name,
                            style: TextStyle(
                              fontSize: 12,
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 1,
                    ),
                    decoration: BoxDecoration(
                      color: schedule.isPaused
                          ? theme.colorScheme.surfaceContainerHighest
                          : theme.colorScheme.tertiaryContainer,
                      borderRadius: BorderRadius.circular(2),
                    ),
                    child: Text(
                      schedule.isPaused ? '停用' : '启用',
                      style: TextStyle(
                        fontSize: 10,
                        color: schedule.isPaused
                            ? theme.colorScheme.onSurfaceVariant
                            : theme.colorScheme.onTertiaryContainer,
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.chevron_right,
                    size: 14,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<bool?> _confirmDelete(
    BuildContext context,
    String courseName,
    String scheduleLabel,
  ) {
    return showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('确认删除'),
        content: Text('确定要删除「$courseName」的计划「$scheduleLabel」吗？删除后无法恢复。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('取消'),
          ),
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(ctx).colorScheme.error,
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('删除'),
          ),
        ],
      ),
    );
  }

  String _buildScheduleLabel(CourseSchedule schedule) {
    if (schedule.slotsJson != null && schedule.slotsJson!.isNotEmpty) {
      return switch (schedule.scheduleType) {
        'weekly_repeat' => _weeklyLabel(schedule.slotsJson!),
        'monthly_repeat' => _monthlyLabel(schedule.slotsJson!),
        'date_list' => _dateListLabel(schedule.slotsJson!),
        _ => '自定义',
      };
    }
    final weekdayLabel = schedule.weekday != null
        ? '周${_weekLabels[schedule.weekday! - 1]}'
        : '自定义';
    return weekdayLabel;
  }

  String _buildDateRange(CourseSchedule schedule) {
    final from = schedule.validFrom;
    final until = schedule.validUntil;
    if (until != null) {
      return '${_formatDate(from)} 至 ${_formatDate(until)}';
    }
    return '${_formatDate(from)} 起';
  }

  String _formatDate(DateTime d) {
    return '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
  }

  String _weeklyLabel(String json) {
    final slots = ScheduleSlotsJson.decodeWeeklySlots(json);
    if (slots.isEmpty) return '';
    final days = slots.map((s) => '周${_weekLabels[s.weekday - 1]}').join('、');
    return days;
  }

  String _monthlyLabel(String json) {
    final slots = ScheduleSlotsJson.decodeMonthlySlots(json);
    if (slots.isEmpty) return '';
    final days = slots.map((s) => '${s.dayOfMonth}号').join('、');
    return '每月$days';
  }

  String _dateListLabel(String json) {
    final slots = ScheduleSlotsJson.decodeDateSlots(json);
    if (slots.isEmpty) return '';
    return '${slots.length}个日期';
  }
}
