import 'package:class2data/data/database/app_database.dart';
import 'package:class2data/shared/providers/database_provider.dart';
import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final _allTagsProvider = FutureProvider<Map<String, List<Tag>>>((ref) async {
  final db = ref.watch(databaseProvider);
  final allTags = await (db.select(db.tags)).get();
  final grouped = <String, List<Tag>>{};
  for (final tag in allTags) {
    if (tag.isHidden) continue;
    grouped.putIfAbsent(tag.category, () => []).add(tag);
  }
  return grouped;
});

const _categoryLabels = {
  'package_type': '课包类型',
  'schedule_type': '计划类型',
  'credit_tx_type': '课时流水类型',
  'class_status': '上课状态',
  'attachment_file_type': '附件类型',
  'attachment_owner_type': '附件归属',
  'payment_type': '费用类型',
  'contact_role': '联系人角色',
  'course_category': '课程分类',
  'achievement_type': '成长记录类型',
};

class TagManagePage extends ConsumerWidget {
  const TagManagePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tagsAsync = ref.watch(_allTagsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('标签管理')),
      body: tagsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('加载失败: $e')),
        data: (groupedTags) {
          if (groupedTags.isEmpty) {
            return const Center(child: Text('暂无标签'));
          }
          return ListView(
            children: groupedTags.entries.map((entry) {
              final category = entry.key;
              final tags = entry.value;
              final label = _categoryLabels[category] ?? category;
              return _TagCategorySection(
                category: category,
                label: label,
                tags: tags,
                onRefresh: () => ref.invalidate(_allTagsProvider),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}

class _TagCategorySection extends ConsumerWidget {
  final String category;
  final String label;
  final List<Tag> tags;
  final VoidCallback onRefresh;

  const _TagCategorySection({
    required this.category,
    required this.label,
    required this.tags,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ...tags.map(
                (tag) => Chip(
                  label: Text(
                    tag.displayName,
                    style: const TextStyle(fontSize: 12),
                  ),
                  deleteIcon: tag.isSystem
                      ? null
                      : const Icon(Icons.close, size: 14),
                  onDeleted: tag.isSystem
                      ? null
                      : () async {
                          final repo = ref.read(tagRepositoryProvider);
                          await repo.hideTag(tag.id);
                          onRefresh();
                        },
                ),
              ),
              ActionChip(
                label: const Text('+', style: TextStyle(fontSize: 12)),
                onPressed: () => _showAddDialog(context, ref),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _showAddDialog(BuildContext context, WidgetRef ref) async {
    final controller = TextEditingController();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('添加 $label 标签'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: '标签名称',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('添加'),
          ),
        ],
      ),
    );
    if (confirmed == true && controller.text.trim().isNotEmpty) {
      final now = DateTime.now();
      final repo = ref.read(tagRepositoryProvider);
      final value = controller.text.trim();
      await repo.insertCustomTag(
        TagsCompanion(
          category: Value(category),
          code: Value(value),
          displayName: Value(value),
          isSystem: const Value(false),
          isHidden: const Value(false),
          createdAt: Value(now),
        ),
      );
      onRefresh();
    }
  }
}
