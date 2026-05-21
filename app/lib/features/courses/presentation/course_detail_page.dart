import 'package:class2data/core/result/result.dart';
import 'package:class2data/data/database/app_database.dart';
import 'package:class2data/domain/models/schedule_slots.dart';
import 'package:class2data/domain/services/course_statistics_service.dart';
import 'package:class2data/domain/services/schedule_occurrence_service.dart';
import 'package:class2data/features/achievements/presentation/achievement_list_section.dart';
import 'package:class2data/features/children/providers/child_providers.dart';
import 'package:class2data/features/class_records/presentation/class_record_bottom_sheet.dart';
import 'package:class2data/features/class_records/presentation/class_record_list_section.dart';
import 'package:class2data/features/contacts/presentation/contact_form_page.dart';
import 'package:class2data/features/contacts/presentation/contact_list_section.dart';
import 'package:class2data/features/courses/presentation/schedule_form_page.dart';
import 'package:class2data/features/courses/providers/course_providers.dart';
import 'package:class2data/features/home/providers/home_providers.dart';
import 'package:class2data/features/packages/presentation/package_form_page.dart';
import 'package:class2data/features/packages/presentation/package_list_section.dart';
import 'package:class2data/shared/widgets/child_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class CourseDetailPage extends ConsumerWidget {
  final int courseId;
  final int initialTab;

  const CourseDetailPage({
    super.key,
    required this.courseId,
    this.initialTab = 0,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final courseAsync = ref.watch(courseByIdProvider(courseId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('课程详情'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => context.push('/courses/$courseId/edit'),
          ),
        ],
      ),
      body: courseAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('加载失败: $e')),
        data: (course) {
          if (course == null) {
            return const Center(child: Text('课程不存在'));
          }

          return DefaultTabController(
            initialIndex: initialTab.clamp(0, 4),
            length: 5,
            child: Column(
              children: [
                // 头部信息
                _CourseHeader(courseName: course.name, childId: course.childId),
                // 指标网格
                _MetricsGrid(courseId: courseId),
                const SizedBox(height: 8),
                // 操作按钮
                _ActionButtons(courseId: courseId, courseName: course.name),
                const SizedBox(height: 12),
                // Tab 栏
                const TabBar(
                  isScrollable: true,
                  tabAlignment: TabAlignment.start,
                  tabs: [
                    Tab(text: '上课记录'),
                    Tab(text: '成长记录'),
                    Tab(text: '课包'),
                    Tab(text: '计划'),
                    Tab(text: '联系人'),
                  ],
                ),
                // Tab 内容
                Expanded(
                  child: TabBarView(
                    children: [
                      // 上课记录
                      ClassRecordListSection(courseId: courseId),
                      // 成长记录
                      AchievementListSection(courseId: courseId),
                      // 课包
                      PackageListSection(courseId: courseId),
                      // 计划
                      _ScheduleListTab(courseId: courseId),
                      // 联系人
                      ContactListSection(courseId: courseId),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _ScheduleListTab extends ConsumerWidget {
  final int courseId;

  const _ScheduleListTab({required this.courseId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final schedulesAsync = ref.watch(schedulesByCourseProvider(courseId));
    final theme = Theme.of(context);

    return schedulesAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('加载失败: $e')),
      data: (result) => switch (result) {
        Ok(:final value) =>
          value.isEmpty
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('暂无计划'),
                      const SizedBox(height: 8),
                      FilledButton(
                        onPressed: () =>
                            context.push('/courses/$courseId/schedules/add'),
                        child: const Text('添加计划'),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: value.length,
                  itemBuilder: (context, index) {
                    final s = value[index];
                    final typeLabel = switch (s.scheduleType) {
                      'weekly_repeat' => '周循环',
                      'monthly_repeat' => '月循环',
                      'daily_repeat' => '每天',
                      'single' => '单次',
                      'date_list' => '指定日期',
                      _ => s.scheduleType,
                    };
                    final detailText = _buildScheduleDetail(s);
                    return InkWell(
                      onTap: () => context.push(
                        '/courses/$courseId/schedules/${s.id}/edit',
                      ),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
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
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '$typeLabel $detailText',
                                    style: theme.textTheme.bodyMedium,
                                  ),
                                  Text(
                                    _buildDateRange(s),
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: theme.colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                  if (s.location != null &&
                                      s.location!.isNotEmpty)
                                    Text(
                                      s.location!,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color:
                                            theme.colorScheme.onSurfaceVariant,
                                      ),
                                    ),
                                  if (s.isPaused)
                                    Text(
                                      '已暂停',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: theme.colorScheme.error,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            Icon(
                              Icons.chevron_right,
                              size: 20,
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        Err(:final error) => Center(child: Text(error.message)),
      },
    );
  }

  static const _weekLabels = ['一', '二', '三', '四', '五', '六', '日'];

  String _buildScheduleDetail(CourseSchedule s) {
    if (s.slotsJson != null && s.slotsJson!.isNotEmpty) {
      return switch (s.scheduleType) {
        'weekly_repeat' => _weeklySlotsDetail(s.slotsJson!),
        'monthly_repeat' => _monthlySlotsDetail(s.slotsJson!),
        'date_list' => _dateSlotsDetail(s.slotsJson!),
        _ => '',
      };
    }
    return '';
  }

  String _weeklySlotsDetail(String json) {
    final slots = ScheduleSlotsJson.decodeWeeklySlots(json);
    if (slots.isEmpty) return '';
    final days = slots.map((s) => '周${_weekLabels[s.weekday - 1]}').join('、');
    return days;
  }

  String _monthlySlotsDetail(String json) {
    final slots = ScheduleSlotsJson.decodeMonthlySlots(json);
    if (slots.isEmpty) return '';
    final days = slots.map((s) => '${s.dayOfMonth}号').join('、');
    return '每月$days';
  }

  String _dateSlotsDetail(String json) {
    final slots = ScheduleSlotsJson.decodeDateSlots(json);
    if (slots.isEmpty) return '';
    return '${slots.length}个日期';
  }

  String _buildDateRange(CourseSchedule s) {
    final from = s.validFrom;
    final until = s.validUntil;
    if (until != null) {
      return '${_formatDate(from)} 至 ${_formatDate(until)}';
    }
    return '${_formatDate(from)} 起';
  }

  String _formatDate(DateTime d) {
    return '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
  }
}

class _CourseHeader extends ConsumerWidget {
  final String courseName;
  final int childId;

  const _CourseHeader({required this.courseName, required this.childId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final childrenAsync = ref.watch(activeChildrenProvider);

    final child = childrenAsync.whenOrNull(
      data: (result) => switch (result) {
        Ok(:final value) => value.where((c) => c.id == childId).firstOrNull,
        Err() => null,
      },
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          if (child != null) ...[
            ChildAvatar(
              name: child.name,
              avatarPath: child.avatarPath,
              radius: 18,
            ),
            const SizedBox(width: 10),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  courseName,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (child != null)
                  Text(
                    child.name,
                    style: TextStyle(
                      fontSize: 13,
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

class _MetricsGrid extends ConsumerWidget {
  final int courseId;

  const _MetricsGrid({required this.courseId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final formatter = CreditBalanceFormatter();
    final statsAsync = ref.watch(singleCourseStatisticsProvider(courseId));

    return statsAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
      data: (stats) {
        final balanceText = formatter.formatCredits(stats.remainingCredits);
        final spentText = formatter.formatAmount(stats.totalSpentCents);
        final countText = '${stats.classCount}';
        final durationText = _formatDuration(stats.totalDurationMinutes);
        final purchasedText = formatter.formatCredits(stats.purchasedCredits);

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisExtent: 56,
              mainAxisSpacing: 4,
              crossAxisSpacing: 4,
            ),
            itemCount: 6,
            itemBuilder: (context, index) {
              return switch (index) {
                0 => _MetricCard(
                  label: '剩余课时',
                  value: balanceText,
                  theme: theme,
                ),
                1 => _MetricCard(label: '已花费', value: spentText, theme: theme),
                2 => _MetricCard(label: '上课次数', value: countText, theme: theme),
                3 => _MetricCard(
                  label: '消耗课时',
                  value: formatter.formatCredits(stats.consumedCredits),
                  theme: theme,
                ),
                4 => _MetricCard(
                  label: '累计时长',
                  value: durationText,
                  theme: theme,
                ),
                _ => _MetricCard(
                  label: '已购课时',
                  value: purchasedText,
                  theme: theme,
                ),
              };
            },
          ),
        );
      },
    );
  }

  String _formatDuration(int totalMinutes) {
    if (totalMinutes == 0) return '0分钟';
    if (totalMinutes >= 600) {
      return '${(totalMinutes / 60).toStringAsFixed(1)}小时';
    }
    return '$totalMinutes分钟';
  }
}

class _ActionButtons extends ConsumerWidget {
  final int courseId;
  final String courseName;

  const _ActionButtons({required this.courseId, required this.courseName});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () async {
                final now = DateTime.now();
                final occ = ScheduleOccurrence(
                  scheduleId: -1,
                  kidCourseId: courseId,
                  date:
                      '${now.year.toString().padLeft(4, '0')}-'
                      '${now.month.toString().padLeft(2, '0')}-'
                      '${now.day.toString().padLeft(2, '0')}',
                  startTime: DateFormat('HH:mm').format(now),
                  endTime: DateFormat(
                    'HH:mm',
                  ).format(now.add(const Duration(hours: 1))),
                  occurrenceKey:
                      'manual_${courseId}_${now.millisecondsSinceEpoch}',
                  classType: null,
                  classNameSnapshot: courseName,
                );
                await showModalBottomSheet<bool>(
                  context: context,
                  isScrollControlled: true,
                  builder: (_) => ClassRecordBottomSheet(occurrence: occ),
                );
              },
              child: const Text('记录上课'),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () async {
                    await showModalBottomSheet<bool>(
                      context: context,
                      isScrollControlled: true,
                      builder: (_) =>
                          PackageFormBottomSheet(courseId: courseId),
                    );
                  },
                  child: const Text('+课包'),
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: OutlinedButton(
                  onPressed: () async {
                    await showModalBottomSheet<bool>(
                      context: context,
                      isScrollControlled: true,
                      builder: (_) =>
                          ScheduleFormBottomSheet(courseId: courseId),
                    );
                  },
                  child: const Text('+上课计划'),
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: OutlinedButton(
                  onPressed: () async {
                    await showModalBottomSheet<bool>(
                      context: context,
                      isScrollControlled: true,
                      builder: (_) =>
                          ContactFormBottomSheet(courseId: courseId),
                    );
                  },
                  child: const Text('+联系人'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  final String label;
  final String value;
  final ThemeData? theme;

  const _MetricCard({required this.label, required this.value, this.theme});

  @override
  Widget build(BuildContext context) {
    final t = theme ?? Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: t.colorScheme.surfaceContainerLow,
        border: Border.all(color: t.colorScheme.outlineVariant, width: 1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: t.colorScheme.onSurfaceVariant,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: t.colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
