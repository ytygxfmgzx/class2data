import 'package:class2data/core/result/result.dart';
import 'package:class2data/data/database/app_database.dart';
import 'package:class2data/domain/services/course_statistics_service.dart';
import 'package:class2data/features/children/providers/child_providers.dart';
import 'package:class2data/features/courses/providers/course_providers.dart';
import 'package:class2data/features/growth/providers/growth_providers.dart';
import 'package:class2data/shared/widgets/child_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// 课程色板，卡片头部色块和占比进度条共用
const _kCourseColors = [
  Color(0xFF2563EB), // 蓝
  Color(0xFF10B981), // 绿
  Color(0xFFF59E0B), // 橙
  Color(0xFFEF4444), // 红
  Color(0xFF8B5CF6), // 紫
  Color(0xFFEC4899), // 粉
];

Color _courseColor(int index) => _kCourseColors[index % _kCourseColors.length];

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
      backgroundColor: const Color(0xFFF2F2F7),
      appBar: AppBar(
        title: const Text('成长统计'),
        backgroundColor: const Color(0xFFF2F2F7),
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

// === 孩子统计视图 ===

class _ChildStatsView extends ConsumerWidget {
  final int childId;

  const _ChildStatsView({required this.childId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final coursesAsync = ref.watch(coursesByChildProvider(childId));
    final statsAsync = ref.watch(childCourseStatisticsProvider(childId));
    final overviewAsync = ref.watch(childOverviewStatsProvider(childId));

    final courses = switch (coursesAsync) {
      AsyncData(:final value) => switch (value) {
        Ok(:final value) => value,
        Err() => <KidCourse>[],
      },
      _ => <KidCourse>[],
    };

    return statsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('加载失败: $e')),
      data: (statsMap) {
        if (courses.isEmpty) {
          return const Center(
            child: Text('还没有课程', style: TextStyle(color: Color(0xFF8E8E93))),
          );
        }

        final overview = overviewAsync.whenOrNull(data: (s) => s);
        final totalDuration = overview?.totalDurationMinutes ?? 0;
        final totalSpent = overview?.totalSpentCents ?? 0;

        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 80),
          children: [
            _OverviewSection(overview: overview),
            const SizedBox(height: 12),
            for (int i = 0; i < courses.length; i++)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _CourseStatsCard(
                  course: courses[i],
                  colorIndex: i,
                  stats: statsMap[courses[i].id],
                  totalDuration: totalDuration,
                  totalSpent: totalSpent,
                ),
              ),
          ],
        );
      },
    );
  }
}

// === 顶部总览区域 ===

class _OverviewSection extends StatelessWidget {
  final ChildOverviewStats? overview;

  const _OverviewSection({this.overview});

  @override
  Widget build(BuildContext context) {
    final formatter = CreditBalanceFormatter();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _OverviewCell(
                  label: '总上课时长',
                  value: _formatDuration(overview?.totalDurationMinutes ?? 0),
                ),
              ),
              _verticalDivider(),
              Expanded(
                child: _OverviewCell(
                  label: '总花费',
                  value: formatter.formatAmount(overview?.totalSpentCents ?? 0),
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Divider(height: 1, thickness: 0.5, color: Color(0xFFE5E5EA)),
          ),
          Row(
            children: [
              Expanded(
                child: _OverviewCell(
                  label: '第一次上课',
                  value: _formatDate(overview?.firstClassDate),
                ),
              ),
              _verticalDivider(),
              Expanded(
                child: _OverviewCell(
                  label: '第一次花费',
                  value: _formatDate(overview?.firstSpentDate),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _verticalDivider() {
    return Container(
      width: 1,
      height: 36,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      color: const Color(0xFFC6C6C8),
    );
  }

  String _formatDuration(int totalMinutes) {
    if (totalMinutes == 0) return '--';
    if (totalMinutes >= 600) {
      return '${(totalMinutes / 60).toStringAsFixed(1)}小时';
    }
    return '$totalMinutes分钟';
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '--';
    return '${date.year}.${date.month.toString().padLeft(2, '0')}.${date.day.toString().padLeft(2, '0')}';
  }
}

class _OverviewCell extends StatelessWidget {
  final String label;
  final String value;

  const _OverviewCell({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Color(0xFF8E8E93)),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}

// === 课程统计卡片 ===

class _CourseStatsCard extends StatefulWidget {
  final KidCourse course;
  final int colorIndex;
  final CourseStatistics? stats;
  final int totalDuration;
  final int totalSpent;

  const _CourseStatsCard({
    required this.course,
    required this.colorIndex,
    required this.stats,
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
    final stats = widget.stats;
    final formatter = CreditBalanceFormatter();
    final color = _courseColor(widget.colorIndex);
    final durationMinutes = stats?.totalDurationMinutes ?? 0;
    final spentCents = stats?.totalSpentCents ?? 0;

    final timeFraction = widget.totalDuration > 0
        ? durationMinutes / widget.totalDuration
        : 0.0;
    final spentFraction = widget.totalSpent > 0
        ? spentCents / widget.totalSpent
        : 0.0;

    final hasBreakdown =
        stats != null && stats.feeBreakdown.isNotEmpty && spentCents > 0;

    return InkWell(
      onTap: () => context.push('/courses/${widget.course.id}'),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── 标题行：色块+课程名+机构 | 剩余课程 badge ──
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 左侧：色块 + 课程信息
                  Container(
                    margin: const EdgeInsets.only(top: 5),
                    child: Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.course.name,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (widget.course.institutionName != null &&
                            widget.course.institutionName!.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 2),
                            child: Text(
                              widget.course.institutionName!,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFF8E8E93),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  // 右侧：剩余课程 badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF2F2F7),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      '剩余${formatter.formatCredits(stats?.remainingCredits ?? 0)}课时',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF8E8E93),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ── 分组1：日期（2×2）──
            const Divider(
              height: 1,
              thickness: 0.5,
              indent: 16,
              endIndent: 16,
              color: Color(0xFFE5E5EA),
            ),
            _StatGrid(
              children: [
                _StatItem(
                  label: '第一次上课',
                  value: _formatDate(stats?.firstClassDate),
                ),
                _StatItem(
                  label: '上一次上课',
                  value: _formatDate(stats?.lastClassDate),
                ),
                _StatItem(
                  label: '第一次花费',
                  value: _formatDate(stats?.firstSpentDate),
                ),
                _StatItem(
                  label: '上一次花费',
                  value: _formatDate(stats?.lastSpentDate),
                ),
              ],
            ),

            // ── 分组2：时间（2×2）──
            const Divider(
              height: 1,
              thickness: 0.5,
              indent: 16,
              endIndent: 16,
              color: Color(0xFFE5E5EA),
            ),
            _StatGrid(
              children: [
                _StatItem(
                  label: '已学总时长',
                  value: _formatPeriod(stats?.firstClassDate),
                ),
                _StatItem(
                  label: '上课总时长',
                  value: _formatDuration(durationMinutes),
                ),
                _StatItem(
                  label: '已消耗课时',
                  value:
                      '${formatter.formatCredits(stats?.consumedCredits ?? 0)}课时',
                ),
                _StatItem(
                  label: '总购买课时',
                  value:
                      '${formatter.formatCredits(stats?.purchasedCredits ?? 0)}课时',
                ),
              ],
            ),

            // ── 分组3：占比（进度条）──
            const Divider(
              height: 1,
              thickness: 0.5,
              indent: 16,
              endIndent: 16,
              color: Color(0xFFE5E5EA),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
              child: Column(
                children: [
                  _RatioBar(
                    label: '时间占比',
                    fraction: timeFraction,
                    color: color,
                  ),
                  const SizedBox(height: 10),
                  _RatioBar(
                    label: '花费占比',
                    fraction: spentFraction,
                    color: color,
                  ),
                ],
              ),
            ),

            // ── 分组4：花费 ──
            const Divider(
              height: 1,
              thickness: 0.5,
              indent: 16,
              endIndent: 16,
              color: Color(0xFFE5E5EA),
            ),
            GestureDetector(
              onTap: hasBreakdown
                  ? () => setState(() => _feeExpanded = !_feeExpanded)
                  : null,
              behavior: HitTestBehavior.opaque,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 14),
                child: Row(
                  children: [
                    const Text(
                      '总花费',
                      style: TextStyle(fontSize: 11, color: Color(0xFF8E8E93)),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        formatter.formatAmount(spentCents),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    if (hasBreakdown)
                      AnimatedRotation(
                        turns: _feeExpanded ? 0.25 : 0,
                        duration: const Duration(milliseconds: 200),
                        child: const Icon(
                          Icons.chevron_right,
                          size: 16,
                          color: Color(0xFF8E8E93),
                        ),
                      ),
                  ],
                ),
              ),
            ),

            // 费用明细展开区
            if (_feeExpanded && hasBreakdown) ...[
              const Divider(
                height: 1,
                thickness: 0.5,
                indent: 16,
                endIndent: 16,
                color: Color(0xFFE5E5EA),
              ),
              _FeeBreakdownSection(
                breakdown: stats.feeBreakdown,
                totalCents: spentCents,
              ),
            ],
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
    if (totalMinutes == 0) return '--';
    if (totalMinutes >= 600) {
      return '${(totalMinutes / 60).toStringAsFixed(1)}小时';
    }
    return '$totalMinutes分钟';
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '--';
    return '${date.year}.${date.month.toString().padLeft(2, '0')}.${date.day.toString().padLeft(2, '0')}';
  }
}

// === 2×2 网格布局 ===

class _StatGrid extends StatelessWidget {
  final List<Widget> children;

  const _StatGrid({required this.children});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
      child: Column(
        children: [
          for (int i = 0; i < children.length; i += 2)
            Padding(
              padding: EdgeInsets.only(top: i > 0 ? 8 : 0),
              child: Row(
                children: [
                  Expanded(child: children[i]),
                  const SizedBox(width: 16),
                  if (i + 1 < children.length)
                    Expanded(child: children[i + 1])
                  else
                    const Expanded(child: SizedBox()),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

// === 指标单元格 ===

class _StatItem extends StatelessWidget {
  final String label;
  final String value;

  const _StatItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: Color(0xFF8E8E93)),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

// === 占比进度条 ===

class _RatioBar extends StatelessWidget {
  final String label;
  final double fraction;
  final Color color;

  const _RatioBar({
    required this.label,
    required this.fraction,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final percent = fraction > 0
        ? '${(fraction * 100).toStringAsFixed(2)}%'
        : '--';

    return Row(
      children: [
        SizedBox(
          width: 56,
          child: Text(
            label,
            style: const TextStyle(fontSize: 11, color: Color(0xFF8E8E93)),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: SizedBox(
            height: 8,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: Stack(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      color: Color(0xFFE5E5EA),
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                    ),
                  ),
                  if (fraction > 0)
                    FractionallySizedBox(
                      widthFactor: fraction.clamp(0.0, 1.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          percent,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}

// === 费用明细展开区域（进度条样式） ===

class _FeeBreakdownSection extends StatelessWidget {
  final List<FeeTypeEntry> breakdown;
  final int totalCents;

  const _FeeBreakdownSection({
    required this.breakdown,
    required this.totalCents,
  });

  @override
  Widget build(BuildContext context) {
    final formatter = CreditBalanceFormatter();

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (int i = 0; i < breakdown.length; i++) ...[
            if (i > 0) const SizedBox(height: 10),
            _FeeBarRow(
              entry: breakdown[i],
              totalCents: totalCents,
              formatter: formatter,
              color: _breakdownColor(i),
            ),
          ],
        ],
      ),
    );
  }

  Color _breakdownColor(int index) {
    const colors = [
      Color(0xFF2563EB),
      Color(0xFF10B981),
      Color(0xFFF59E0B),
      Color(0xFFEF4444),
      Color(0xFF8B5CF6),
      Color(0xFFEC4899),
    ];
    return colors[index % colors.length];
  }
}

class _FeeBarRow extends StatelessWidget {
  final FeeTypeEntry entry;
  final int totalCents;
  final CreditBalanceFormatter formatter;
  final Color color;

  const _FeeBarRow({
    required this.entry,
    required this.totalCents,
    required this.formatter,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final fraction = totalCents > 0 ? entry.amountCents / totalCents : 0.0;
    final percent = (fraction * 100).toStringAsFixed(1);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(entry.typeName, style: const TextStyle(fontSize: 13)),
            Text(
              '${formatter.formatAmount(entry.amountCents)}  $percent%',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Color(0xFF8E8E93),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        SizedBox(
          height: 6,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFE5E5EA),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
                if (fraction > 0)
                  FractionallySizedBox(
                    widthFactor: fraction.clamp(0.0, 1.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// === 筛选浮动按钮 ===

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
