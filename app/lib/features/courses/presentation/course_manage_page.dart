import 'package:class2data/core/result/result.dart';
import 'package:class2data/data/database/app_database.dart';
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

    final theme = Theme.of(context);
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
            color: theme.colorScheme.error,
            child: Icon(Icons.delete, color: theme.colorScheme.onError),
          ),
          child: InkWell(
            onTap: () => context.push('/courses/${course.id}'),
            child: Container(
              height: 52,
              padding: const EdgeInsets.symmetric(horizontal: 16),
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
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 1,
                    ),
                    decoration: BoxDecoration(
                      color: course.isArchived
                          ? theme.colorScheme.surfaceContainerHighest
                          : theme.colorScheme.tertiaryContainer,
                      borderRadius: BorderRadius.circular(2),
                    ),
                    child: Text(
                      course.isArchived ? '已归档' : '启用',
                      style: TextStyle(
                        fontSize: 10,
                        color: course.isArchived
                            ? theme.colorScheme.onSurfaceVariant
                            : theme.colorScheme.onTertiaryContainer,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
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
