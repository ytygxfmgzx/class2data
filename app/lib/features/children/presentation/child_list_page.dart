import 'package:class2data/core/result/result.dart';
import 'package:class2data/data/database/app_database.dart';
import 'package:class2data/features/children/providers/child_providers.dart';
import 'package:class2data/features/home/providers/home_providers.dart';
import 'package:class2data/shared/providers/database_provider.dart';
import 'package:class2data/shared/widgets/child_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ChildListPage extends ConsumerWidget {
  const ChildListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final childrenAsync = ref.watch(activeChildrenProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('孩子管理'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => context.push('/children/add'),
          ),
        ],
      ),
      body: childrenAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('加载失败: $e')),
        data: (result) => switch (result) {
          Ok(:final value) =>
            value.isEmpty
                ? _EmptyState(onAdd: () => context.push('/children/add'))
                : _ChildList(children: value),
          Err(:final error) => Center(child: Text(error.message)),
        },
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final VoidCallback onAdd;

  const _EmptyState({required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.child_care,
            size: 48,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: 12),
          Text('还没有孩子', style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 12),
          FilledButton(onPressed: onAdd, child: const Text('录入孩子')),
        ],
      ),
    );
  }
}

class _ChildList extends ConsumerWidget {
  final List<ChildrenData> children;

  const _ChildList({required this.children});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return ListView.builder(
      itemCount: children.length,
      itemBuilder: (context, index) {
        final child = children[index];
        return Dismissible(
          key: ValueKey(child.id),
          direction: DismissDirection.endToStart,
          confirmDismiss: (_) => _confirmDelete(context, child.name),
          onDismissed: (_) async {
            final result = await ref
                .read(childRepositoryProvider)
                .deleteChild(child.id);
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
            onTap: () => context.push('/children/${child.id}/edit'),
            child: Container(
              height: 48,
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
                  ChildAvatar(
                    name: child.name,
                    avatarPath: child.avatarPath,
                    radius: 14,
                  ),
                  const SizedBox(width: 12),
                  Expanded(child: Text(child.name)),
                  Icon(
                    Icons.chevron_right,
                    size: 20,
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

  Future<bool?> _confirmDelete(BuildContext context, String name) {
    return showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('确认删除'),
        content: Text('确定要删除 $name 吗？删除后无法恢复。'),
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
