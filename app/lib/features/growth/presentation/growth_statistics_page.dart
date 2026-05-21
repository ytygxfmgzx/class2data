import 'package:class2data/core/result/result.dart';
import 'package:class2data/data/database/app_database.dart';
import 'package:class2data/domain/services/course_statistics_service.dart';
import 'package:class2data/features/children/providers/child_providers.dart';
import 'package:class2data/features/courses/providers/course_providers.dart';
import 'package:class2data/features/growth/providers/growth_providers.dart';
import 'package:class2data/shared/widgets/child_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GrowthStatisticsPage extends ConsumerStatefulWidget {
  const GrowthStatisticsPage({super.key});

  @override
  ConsumerState<GrowthStatisticsPage> createState() =>
      _GrowthStatisticsPageState();
}

class _GrowthStatisticsPageState extends ConsumerState<GrowthStatisticsPage>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  List<ChildrenData> _children = [];

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  void _initTabs(List<ChildrenData> children) {
    if (_children.length == children.length &&
        _children.every((c) => children.any((cc) => cc.id == c.id))) {
      return;
    }
    _tabController?.dispose();
    _children = children;
    _tabController = TabController(length: children.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final childrenAsync = ref.watch(activeChildrenProvider);

    return childrenAsync.when(
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, _) => Scaffold(body: Center(child: Text('加载失败: $e'))),
      data: (result) => switch (result) {
        Ok(:final value) => _buildContent(value),
        Err(:final error) => Scaffold(
          body: Center(child: Text('加载失败: ${error.message}')),
        ),
      },
    );
  }

  Widget _buildContent(List<ChildrenData> children) {
    if (children.isEmpty) {
      return const Scaffold(body: Center(child: Text('还没有孩子')));
    }

    _initTabs(children);

    final needsTabs = children.length > 1;
    final filter = ref.watch(statisticsFilterProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('统计'),
        bottom: needsTabs
            ? TabBar(
                controller: _tabController,
                tabs: children
                    .map(
                      (c) => Tab(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ChildAvatar(
                              name: c.name,
                              avatarPath: c.avatarPath,
                              radius: 10,
                            ),
                            const SizedBox(width: 6),
                            Text(c.name),
                          ],
                        ),
                      ),
                    )
                    .toList(),
              )
            : null,
      ),
      body: needsTabs
          ? TabBarView(
              controller: _tabController,
              children: children
                  .map((c) => _ChildStatsView(childId: c.id))
                  .toList(),
            )
          : _ChildStatsView(childId: children.first.id),
      floatingActionButton: _StatisticsFilterFab(
        filter: filter,
        onFilterChanged: (f) =>
            ref.read(statisticsFilterProvider.notifier).state = f,
      ),
    );
  }
}

class _ChildStatsView extends ConsumerWidget {
  final int childId;

  const _ChildStatsView({required this.childId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final coursesAsync = ref.watch(coursesByChildProvider(childId));
    final statsAsync = ref.watch(childCourseStatisticsProvider(childId));
    final totalAsync = ref.watch(childTotalStatisticsProvider(childId));

    final courses = switch (coursesAsync) {
      AsyncData(:final value) => switch (value) {
        Ok(:final value) => value,
        Err() => <KidCourse>[],
      },
      _ => <KidCourse>[],
    };

    final child = ref
        .watch(activeChildrenProvider)
        .whenOrNull(
          data: (result) => switch (result) {
            Ok(:final value) => value.where((c) => c.id == childId).firstOrNull,
            Err() => null,
          },
        );

    return statsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('加载失败: $e')),
      data: (statsMap) {
        if (courses.isEmpty) {
          return const Center(child: Text('还没有课程'));
        }

        final totalStats = totalAsync.whenOrNull(data: (s) => s);
        final totalDuration = totalStats?.totalDurationMinutes ?? 0;
        final totalSpent = totalStats?.totalSpentCents ?? 0;

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // 顶部汇总统计
            _SummaryBar(totalDuration: totalDuration, totalSpent: totalSpent),
            const SizedBox(height: 16),
            // 各课程统计卡片
            for (final course in courses)
              _CourseStatsCard(
                course: course,
                stats: statsMap[course.id],
                childName: child?.name,
                childAvatarPath: child?.avatarPath,
                totalDuration: totalDuration,
                totalSpent: totalSpent,
              ),
          ],
        );
      },
    );
  }
}

class _SummaryBar extends StatelessWidget {
  final int totalDuration;
  final int totalSpent;

  const _SummaryBar({required this.totalDuration, required this.totalSpent});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final formatter = CreditBalanceFormatter();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                Icon(
                  Icons.timer,
                  size: 20,
                  color: theme.colorScheme.onPrimaryContainer,
                ),
                const SizedBox(height: 4),
                Text(
                  '总时长',
                  style: TextStyle(
                    fontSize: 12,
                    color: theme.colorScheme.onPrimaryContainer,
                  ),
                ),
                Text(
                  _formatDuration(totalDuration),
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: theme.colorScheme.onPrimaryContainer,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 1,
            height: 40,
            color: theme.colorScheme.onPrimaryContainer.withValues(alpha: 0.2),
          ),
          Expanded(
            child: Column(
              children: [
                Icon(
                  Icons.payments,
                  size: 20,
                  color: theme.colorScheme.onPrimaryContainer,
                ),
                const SizedBox(height: 4),
                Text(
                  '总花费',
                  style: TextStyle(
                    fontSize: 12,
                    color: theme.colorScheme.onPrimaryContainer,
                  ),
                ),
                Text(
                  formatter.formatAmount(totalSpent),
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: theme.colorScheme.onPrimaryContainer,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
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

class _CourseStatsCard extends StatefulWidget {
  final KidCourse course;
  final CourseStatistics? stats;
  final String? childName;
  final String? childAvatarPath;
  final int totalDuration;
  final int totalSpent;

  const _CourseStatsCard({
    required this.course,
    required this.stats,
    this.childName,
    this.childAvatarPath,
    required this.totalDuration,
    required this.totalSpent,
  });

  @override
  State<_CourseStatsCard> createState() => _CourseStatsCardState();
}

class _CourseStatsCardState extends State<_CourseStatsCard> {
  bool _feeExpanded = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final formatter = CreditBalanceFormatter();
    final stats = widget.stats;

    final durationMinutes = stats?.totalDurationMinutes ?? 0;
    final spentCents = stats?.totalSpentCents ?? 0;
    final timePercent = widget.totalDuration > 0
        ? (durationMinutes / widget.totalDuration * 100).toStringAsFixed(2)
        : '--';
    final spentPercent = widget.totalSpent > 0
        ? (spentCents / widget.totalSpent * 100).toStringAsFixed(2)
        : '--';

    final hasBreakdown =
        stats != null && stats.feeBreakdown.isNotEmpty && spentCents > 0;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 头部：孩子头像 + 课程信息
            Row(
              children: [
                if (widget.childName != null)
                  ChildAvatar(
                    name: widget.childName!,
                    avatarPath: widget.childAvatarPath,
                    radius: 14,
                  ),
                if (widget.childName != null) const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.course.name,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (widget.course.institutionName != null &&
                          widget.course.institutionName!.isNotEmpty)
                        Text(
                          widget.course.institutionName!,
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
            const SizedBox(height: 12),
            // 统计数据网格
            Row(
              children: [
                Expanded(
                  child: _StatCell(
                    icon: Icons.calendar_today,
                    label: '已学',
                    value: _formatPeriod(stats?.firstClassDate),
                  ),
                ),
                Expanded(
                  child: _StatCell(
                    icon: Icons.school,
                    label: '上课',
                    value: '${stats?.classCount ?? 0}节',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _StatCell(
                    icon: Icons.timer,
                    label: '总时长',
                    value: _formatDuration(durationMinutes),
                  ),
                ),
                Expanded(
                  child: _StatCell(
                    icon: Icons.playlist_add_check,
                    label: '剩余',
                    value:
                        '${formatter.formatCredits(stats?.remainingCredits ?? 0)}节',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // 花费行（可点击展开）
            GestureDetector(
              onTap: hasBreakdown
                  ? () => setState(() => _feeExpanded = !_feeExpanded)
                  : null,
              child: Row(
                children: [
                  Expanded(
                    child: _StatCell(
                      icon: Icons.payments,
                      label: '花费',
                      value: formatter.formatAmount(spentCents),
                      trailing: hasBreakdown
                          ? AnimatedRotation(
                              turns: _feeExpanded ? 0.25 : 0,
                              duration: const Duration(milliseconds: 200),
                              child: Icon(
                                Icons.chevron_right,
                                size: 18,
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            )
                          : null,
                    ),
                  ),
                  const Expanded(child: SizedBox()),
                ],
              ),
            ),
            // 费用明细展开区
            if (_feeExpanded && hasBreakdown) ...[
              const SizedBox(height: 8),
              _FeeBreakdownList(
                breakdown: stats.feeBreakdown,
                totalCents: spentCents,
              ),
            ],
            const SizedBox(height: 8),
            // 占比行
            Row(
              children: [
                Expanded(
                  child: _StatCell(
                    icon: Icons.pie_chart_outline,
                    label: '时间占比',
                    value: widget.totalDuration > 0 ? '$timePercent%' : '--',
                  ),
                ),
                Expanded(
                  child: _StatCell(
                    icon: Icons.pie_chart_outline,
                    label: '花费占比',
                    value: widget.totalSpent > 0 ? '$spentPercent%' : '--',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatPeriod(DateTime? firstDate) {
    if (firstDate == null) return '--';
    final now = DateTime.now();
    if (firstDate.isAfter(now)) return '--';
    int years = now.year - firstDate.year;
    int months = now.month - firstDate.month;
    if (now.day < firstDate.day) months--;
    if (months < 0) {
      years--;
      months += 12;
    }
    if (years > 0 && months > 0) return '$years年$months个月';
    if (years > 0) return '$years年';
    if (months > 0) return '$months个月';
    final days = now.difference(firstDate).inDays;
    return '$days天';
  }

  String _formatDuration(int totalMinutes) {
    if (totalMinutes == 0) return '0分钟';
    if (totalMinutes >= 600) {
      return '${(totalMinutes / 60).toStringAsFixed(1)}小时';
    }
    return '$totalMinutes分钟';
  }
}

class _StatCell extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Widget? trailing;

  const _StatCell({
    required this.icon,
    required this.label,
    required this.value,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: theme.colorScheme.onSurfaceVariant),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                Text(
                  value,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}

class _FeeBreakdownList extends StatelessWidget {
  final List<FeeTypeEntry> breakdown;
  final int totalCents;

  const _FeeBreakdownList({required this.breakdown, required this.totalCents});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final formatter = CreditBalanceFormatter();

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (int i = 0; i < breakdown.length; i++) ...[
            if (i > 0)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Divider(
                  height: 1,
                  color: theme.colorScheme.outlineVariant.withValues(
                    alpha: 0.5,
                  ),
                ),
              ),
            _FeeBreakdownRow(
              entry: breakdown[i],
              totalCents: totalCents,
              formatter: formatter,
              color: _breakdownColor(theme, i),
            ),
          ],
        ],
      ),
    );
  }

  Color _breakdownColor(ThemeData theme, int index) {
    final colors = [
      theme.colorScheme.primary,
      theme.colorScheme.tertiary,
      theme.colorScheme.secondary,
      theme.colorScheme.error,
      theme.colorScheme.primaryContainer,
      theme.colorScheme.tertiaryContainer,
    ];
    return colors[index % colors.length];
  }
}

class _FeeBreakdownRow extends StatelessWidget {
  final FeeTypeEntry entry;
  final int totalCents;
  final CreditBalanceFormatter formatter;
  final Color color;

  const _FeeBreakdownRow({
    required this.entry,
    required this.totalCents,
    required this.formatter,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final percent = totalCents > 0
        ? (entry.amountCents / totalCents * 100)
        : 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              entry.typeName,
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              '${formatter.formatAmount(entry.amountCents)}  ${percent.toStringAsFixed(1)}%',
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(2),
          child: LinearProgressIndicator(
            value: totalCents > 0 ? entry.amountCents / totalCents : 0,
            backgroundColor: theme.colorScheme.outlineVariant.withValues(
              alpha: 0.3,
            ),
            valueColor: AlwaysStoppedAnimation(color),
            minHeight: 4,
          ),
        ),
      ],
    );
  }
}

class _StatisticsFilterFab extends StatelessWidget {
  final StatisticsFilter filter;
  final ValueChanged<StatisticsFilter> onFilterChanged;

  const _StatisticsFilterFab({
    required this.filter,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isFiltered = !filter.showAllDates;

    return FloatingActionButton(
      onPressed: () => _showFilterSheet(context),
      tooltip: '筛选',
      backgroundColor: isFiltered
          ? theme.colorScheme.primaryContainer
          : theme.colorScheme.surfaceContainerHigh,
      foregroundColor: isFiltered
          ? theme.colorScheme.onPrimaryContainer
          : theme.colorScheme.onSurfaceVariant,
      child: Icon(isFiltered ? Icons.filter_list : Icons.filter_list_outlined),
    );
  }

  Future<void> _showFilterSheet(BuildContext context) async {
    final result = await showModalBottomSheet<StatisticsFilter>(
      context: context,
      builder: (_) => _StatisticsFilterSheet(initialFilter: filter),
    );
    if (result != null) {
      onFilterChanged(result);
    }
  }
}

class _StatisticsFilterSheet extends StatefulWidget {
  final StatisticsFilter initialFilter;

  const _StatisticsFilterSheet({required this.initialFilter});

  @override
  State<_StatisticsFilterSheet> createState() => _StatisticsFilterSheetState();
}

class _StatisticsFilterSheetState extends State<_StatisticsFilterSheet> {
  String? _dateFrom;
  String? _dateTo;

  @override
  void initState() {
    super.initState();
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
                  '时间筛选',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, const StatisticsFilter());
                  },
                  child: const Text('重置'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              '统计区间',
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
                  StatisticsFilter(dateFrom: _dateFrom, dateTo: _dateTo),
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
