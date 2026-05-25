import 'package:class2data/core/result/result.dart';
import 'package:class2data/data/database/app_database.dart';
import 'package:class2data/domain/services/credit_balance_service.dart';
import 'package:class2data/features/children/providers/child_providers.dart';
import 'package:class2data/features/courses/providers/course_providers.dart';
import 'package:class2data/features/home/providers/home_providers.dart';
import 'package:class2data/shared/providers/database_provider.dart';
import 'package:class2data/shared/widgets/child_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class CourseManagePage extends ConsumerWidget {
  const CourseManagePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final coursesAsync = ref.watch(allActiveCoursesProvider);
    final childrenAsync = ref.watch(activeChildrenProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('课程管理'),
        actions: [
          TextButton(
            onPressed: () => context.push('/courses/add'),
            child: const Text('添加'),
          ),
        ],
      ),
      body: coursesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('加载失败: $e')),
        data: (result) => switch (result) {
          Ok(:final value) => childrenAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('加载失败: $e')),
            data: (childResult) {
              final children = switch (childResult) {
                Ok(:final value) => value,
                Err() => <ChildrenData>[],
              };
              return _buildList(context, ref, value, children);
            },
          ),
          Err(:final error) => Center(child: Text('加载失败: $error')),
        },
      ),
    );
  }

  Widget _buildList(
    BuildContext context,
    WidgetRef ref,
    List<KidCourse> courses,
    List<ChildrenData> children,
  ) {
    if (courses.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('还没有课程'),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: () => context.push('/courses/add'),
              child: const Text('录入课程'),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: courses.length,
      itemBuilder: (context, index) {
        final course = courses[index];
        final child = children.where((c) => c.id == course.childId).firstOrNull;

        return Dismissible(
          key: ValueKey(course.id),
          direction: DismissDirection.endToStart,
          confirmDismiss: (_) => _confirmDelete(context, course.name),
          onDismissed: (_) async {
            final result = await ref
                .read(kidCourseRepositoryProvider)
                .deleteCourse(course.id);
            if (result case Ok()) {
              ref.read(homeDataVersionProvider.notifier).state++;
            }
          },
          background: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 16),
            color: Theme.of(context).colorScheme.error,
            child: Icon(
              Icons.delete,
              color: Theme.of(context).colorScheme.onError,
            ),
          ),
          child: _CourseListItem(course: course, child: child),
        );
      },
    );
  }

  Future<bool?> _confirmDelete(BuildContext context, String name) {
    return showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('确认删除'),
        content: Text('确定要删除课程「$name」吗？删除后无法恢复。'),
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
}

class _CourseListItem extends ConsumerWidget {
  final KidCourse course;
  final ChildrenData? child;

  const _CourseListItem({required this.course, this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summaryAsync = ref.watch(courseListSummaryProvider(course.id));
    final theme = Theme.of(context);

    return InkWell(
      onTap: () => context.push('/courses/${course.id}'),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        constraints: const BoxConstraints(minHeight: 52),
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
                name: child!.name,
                avatarPath: child!.avatarPath,
                radius: 14,
              ),
              const SizedBox(width: 8),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    course.name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    '${child?.name ?? ""} · ${course.institutionName}',
                    style: TextStyle(
                      fontSize: 12,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            summaryAsync.when(
              data: (summary) => _buildSummaryRight(theme, summary),
              loading: () => const SizedBox.shrink(),
              error: (_, _) => const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRight(ThemeData theme, CourseListSummary summary) {
    if (!summary.hasAnyInfo) return const SizedBox.shrink();

    final showCredits = summary.hasCreditPackages;
    final showPeriod = summary.hasPeriodPackages;

    if (showCredits && showPeriod) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildCreditsLabel(theme, summary.totalCredits, showPrefix: true),
          const SizedBox(height: 2),
          _buildPeriodLabel(theme, summary.latestExpiry, showPrefix: true),
        ],
      );
    }

    if (showCredits) {
      return _buildCreditsLabel(theme, summary.totalCredits);
    }

    if (showPeriod) {
      return _buildPeriodLabel(theme, summary.latestExpiry);
    }

    return const SizedBox.shrink();
  }

  Widget _buildCreditsLabel(
    ThemeData theme,
    int credits, {
    bool showPrefix = false,
  }) {
    final service = CreditBalanceService();
    final prefix = showPrefix ? '课时包' : '';
    return Text(
      '$prefix余${service.formatCredits(credits)}课时',
      style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurfaceVariant),
    );
  }

  Widget _buildPeriodLabel(
    ThemeData theme,
    DateTime? expiry, {
    bool showPrefix = false,
  }) {
    final prefix = showPrefix ? '周期卡' : '';
    final suffix = expiry != null ? '${expiry.month}月${expiry.day}日到期' : '长期有效';
    return Text(
      '$prefix$suffix',
      style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurfaceVariant),
    );
  }
}
