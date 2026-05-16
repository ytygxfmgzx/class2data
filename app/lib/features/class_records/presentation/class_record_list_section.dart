import 'package:class2data/core/result/result.dart';
import 'package:class2data/data/database/app_database.dart';
import 'package:class2data/domain/services/credit_balance_service.dart';
import 'package:class2data/features/class_records/providers/class_record_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ClassRecordListSection extends ConsumerWidget {
  final int courseId;

  const ClassRecordListSection({super.key, required this.courseId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recordsAsync = ref.watch(classRecordsByCourseProvider(courseId));
    final balanceService = CreditBalanceService();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        recordsAsync.when(
          loading: () => const SizedBox.shrink(),
          error: (e, _) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text('加载失败: $e'),
          ),
          data: (result) => switch (result) {
            Ok(:final value) =>
              value.isEmpty
                  ? const Padding(
                      padding: EdgeInsets.all(16),
                      child: Center(child: Text('暂无上课记录')),
                    )
                  : Column(
                      children: value
                          .map(
                            (r) => _RecordRow(
                              record: r,
                              balanceService: balanceService,
                            ),
                          )
                          .toList(),
                    ),
            Err(:final error) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(error.message),
            ),
          },
        ),
      ],
    );
  }
}

class _RecordRow extends StatelessWidget {
  final ClassRecord record;
  final CreditBalanceService balanceService;

  const _RecordRow({required this.record, required this.balanceService});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final statusLabel = _statusLabel(record.status);
    final statusColor = _statusColor(record.status);

    return InkWell(
      onTap: () => context.push('/class-records/${record.id}'),
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
                  Row(
                    children: [
                      Text(record.classDate, style: theme.textTheme.bodyMedium),
                      const SizedBox(width: 8),
                      Text(
                        record.startTime,
                        style: TextStyle(
                          fontSize: 13,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 1,
                        ),
                        decoration: BoxDecoration(
                          color: statusColor.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(2),
                        ),
                        child: Text(
                          statusLabel,
                          style: TextStyle(
                            fontSize: 11,
                            color: statusColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      if (record.creditUnitsCost > 0) ...[
                        const SizedBox(width: 6),
                        Text(
                          '-${balanceService.formatCredits(record.creditUnitsCost)}课时',
                          style: TextStyle(
                            fontSize: 11,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ],
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

  String _statusLabel(String status) {
    return switch (status) {
      'attended' => '已上课',
      'leave' => '请假',
      'cancelled' => '取消',
      'absent' => '缺课',
      'makeup' => '补课',
      _ => status,
    };
  }

  Color _statusColor(String status) {
    return switch (status) {
      'attended' => Colors.green.shade700,
      'leave' => Colors.orange.shade700,
      'cancelled' => Colors.grey,
      'absent' => Colors.red.shade700,
      'makeup' => Colors.blue.shade700,
      _ => Colors.grey,
    };
  }
}
