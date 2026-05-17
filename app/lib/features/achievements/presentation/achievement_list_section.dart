import 'package:class2data/features/achievements/models/achievement_list_item.dart';
import 'package:class2data/features/achievements/providers/achievement_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class AchievementListSection extends ConsumerWidget {
  final int courseId;

  const AchievementListSection({super.key, required this.courseId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemsAsync = ref.watch(
      achievementListItemsByCourseProvider(courseId),
    );

    return itemsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Text('加载失败: $e'),
      ),
      data: (items) => items.isEmpty
          ? const Padding(
              padding: EdgeInsets.all(16),
              child: Center(child: Text('暂无成长记录')),
            )
          : ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) =>
                  _AchievementRow(item: items[index]),
            ),
    );
  }
}

class _AchievementRow extends StatelessWidget {
  final AchievementListItem item;

  const _AchievementRow({required this.item});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final achievement = item.achievement;

    return InkWell(
      onTap: () => context.push('/achievements/${achievement.id}/edit'),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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
                  // 第一行: 日期 + 类型标签
                  Row(
                    children: [
                      Text(
                        achievement.achievementDate,
                        style: theme.textTheme.bodyMedium,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Wrap(
                          spacing: 4,
                          runSpacing: 2,
                          children: item.typeLinks.map((link) {
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 1,
                              ),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.secondaryContainer,
                                borderRadius: BorderRadius.circular(2),
                              ),
                              child: Text(
                                link.typeNameSnapshot,
                                style: TextStyle(
                                  fontSize: 11,
                                  color: theme.colorScheme.onSecondaryContainer,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                  // 第二行: 费用标签在前，备注跟后
                  if (achievement.notes != null &&
                          achievement.notes!.isNotEmpty ||
                      item.payment != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Row(
                        children: [
                          if (item.payment != null) ...[
                            if (item.payment!.typeNameSnapshot != null)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 1,
                                ),
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.tertiaryContainer,
                                  borderRadius: BorderRadius.circular(2),
                                ),
                                child: Text(
                                  item.payment!.typeNameSnapshot!,
                                  style: TextStyle(
                                    fontSize: 11,
                                    color:
                                        theme.colorScheme.onTertiaryContainer,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 1,
                              ),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.tertiaryContainer,
                                borderRadius: BorderRadius.circular(2),
                              ),
                              child: Text(
                                '¥${(item.payment!.amountCents / 100).toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: theme.colorScheme.onTertiaryContainer,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                          ],
                          if (achievement.notes != null &&
                              achievement.notes!.isNotEmpty)
                            Expanded(
                              child: Text(
                                achievement.notes!,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                        ],
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
  }
}
