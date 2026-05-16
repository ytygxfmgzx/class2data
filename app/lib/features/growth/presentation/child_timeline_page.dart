import 'package:class2data/domain/services/course_statistics_service.dart';
import 'package:class2data/features/children/providers/child_providers.dart';
import 'package:class2data/features/growth/providers/growth_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ChildTimelinePage extends ConsumerWidget {
  final int childId;

  const ChildTimelinePage({super.key, required this.childId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final childAsync = ref.watch(childByIdProvider(childId));
    final timelineAsync = ref.watch(childTimelineProvider(childId));

    return childAsync.when(
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, _) => Scaffold(body: Center(child: Text('加载失败: $e'))),
      data: (child) {
        if (child == null) {
          return const Scaffold(body: Center(child: Text('孩子不存在')));
        }
        return Scaffold(
          appBar: AppBar(
            title: Text(child.name),
            actions: [
              IconButton(
                icon: const Icon(Icons.photo_library),
                tooltip: '照片墙',
                onPressed: () => context.push('/children/$childId/photos'),
              ),
            ],
          ),
          body: timelineAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('加载失败: $e')),
            data: (events) {
              if (events.isEmpty) {
                return const Center(child: Text('还没有记录'));
              }
              return _TimelineList(events: events);
            },
          ),
        );
      },
    );
  }
}

class _TimelineList extends ConsumerWidget {
  final List<TimelineEvent> events;

  const _TimelineList({required this.events});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 按日期分组
    final grouped = <String, List<TimelineEvent>>{};
    for (final e in events) {
      grouped.putIfAbsent(e.date, () => []).add(e);
    }
    final dates = grouped.keys.toList();

    return ListView.builder(
      itemCount: dates.length,
      itemBuilder: (context, index) {
        final date = dates[index];
        final dayEvents = grouped[date]!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _DateHeader(date: date),
            for (int i = 0; i < dayEvents.length; i++)
              _TimelineItem(
                event: dayEvents[i],
                isLast: i == dayEvents.length - 1,
              ),
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
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
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
    final weekdays = ['一', '二', '三', '四', '五', '六', '日'];
    final weekday = weekdays[d.weekday - 1];
    return '${d.month}月${d.day}日 周$weekday';
  }
}

class _TimelineItem extends ConsumerWidget {
  final TimelineEvent event;
  final bool isLast;

  const _TimelineItem({required this.event, required this.isLast});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final icon = _icon;
    final color = _color(theme);

    return InkWell(
      onTap: () => _navigate(context, ref),
      child: IntrinsicHeight(
        child: Row(
          children: [
            // 时间线轴
            SizedBox(
              width: 56,
              child: Column(
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    margin: const EdgeInsets.only(top: 12),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon, size: 14, color: color),
                  ),
                  if (!isLast)
                    Expanded(
                      child: Container(
                        width: 2,
                        color: theme.colorScheme.outlineVariant,
                      ),
                    ),
                ],
              ),
            ),
            // 内容
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(top: 12, bottom: 12, right: 16),
                decoration: isLast
                    ? null
                    : BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: theme.colorScheme.outlineVariant,
                            width: 1,
                          ),
                        ),
                      ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event.title,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (event.subtitle != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        event.subtitle!,
                        style: TextStyle(
                          fontSize: 13,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData get _icon => switch (event.type) {
    'class_record' => Icons.school,
    'achievement' => Icons.emoji_events,
    'package' => Icons.inventory_2,
    'payment' => Icons.payment,
    _ => Icons.circle,
  };

  Color _color(ThemeData theme) => switch (event.type) {
    'class_record' => theme.colorScheme.primary,
    'achievement' => theme.colorScheme.tertiary,
    'package' => theme.colorScheme.secondary,
    'payment' => theme.colorScheme.error,
    _ => theme.colorScheme.onSurfaceVariant,
  };

  void _navigate(BuildContext context, WidgetRef ref) {
    switch (event.type) {
      case 'class_record':
        if (event.recordId != null) {
          context.push('/class-records/${event.recordId}');
        }
      case 'achievement':
        if (event.achievementId != null) {
          context.push('/achievements/${event.achievementId}/edit');
        }
    }
  }
}
