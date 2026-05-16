import 'package:class2data/core/result/result.dart';
import 'package:class2data/data/database/app_database.dart';
import 'package:class2data/domain/services/credit_balance_service.dart';
import 'package:class2data/features/credit_ledger/providers/credit_ledger_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class CreditLedgerPage extends ConsumerWidget {
  final int courseId;

  const CreditLedgerPage({super.key, required this.courseId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final txAsync = ref.watch(creditTransactionsByCourseProvider(courseId));
    final balanceAsync = ref.watch(courseBalanceProvider(courseId));
    final balanceService = CreditBalanceService();
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('课时明细'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: '手动调整',
            onPressed: () => context.push('/courses/$courseId/credit-adjust'),
          ),
        ],
      ),
      body: Column(
        children: [
          // 余额摘要
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: theme.colorScheme.surfaceContainerLow,
            child: Row(
              children: [
                Text(
                  '当前余额',
                  style: TextStyle(
                    fontSize: 13,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  balanceAsync.when(
                    loading: () => '...',
                    error: (_, _) => '--',
                    data: (b) => '${balanceService.formatCredits(b)} 课时',
                  ),
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          // 流水列表
          Expanded(
            child: txAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('加载失败: $e')),
              data: (result) => switch (result) {
                Ok(:final value) =>
                  value.isEmpty
                      ? const Center(child: Text('暂无课时记录'))
                      : _LedgerList(
                          transactions: value,
                          balanceService: balanceService,
                        ),
                Err(:final error) => Center(child: Text(error.message)),
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _LedgerList extends StatelessWidget {
  final List<CreditTransaction> transactions;
  final CreditBalanceService balanceService;

  const _LedgerList({required this.transactions, required this.balanceService});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // 计算累计余额
    int runningBalance = 0;

    return ListView.builder(
      itemCount: transactions.length,
      itemBuilder: (context, index) {
        final tx = transactions[index];
        runningBalance += tx.creditUnitsDelta;

        final isPositive = tx.creditUnitsDelta > 0;
        final deltaText = isPositive
            ? '+${balanceService.formatCredits(tx.creditUnitsDelta)}'
            : balanceService.formatCredits(tx.creditUnitsDelta);
        final typeLabel = balanceService.transactionTypeLabel(tx.type);

        return Container(
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
                    Text(typeLabel, style: theme.textTheme.bodyMedium),
                    const SizedBox(height: 2),
                    Text(
                      _formatDate(tx.transactionDate),
                      style: TextStyle(
                        fontSize: 12,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    if (tx.reason != null)
                      Text(
                        tx.reason!,
                        style: TextStyle(
                          fontSize: 12,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    deltaText,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: isPositive
                          ? Colors.green.shade700
                          : theme.colorScheme.error,
                    ),
                  ),
                  Text(
                    balanceService.formatCredits(runningBalance),
                    style: TextStyle(
                      fontSize: 12,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  String _formatDate(DateTime d) {
    return '${d.year}-'
        '${d.month.toString().padLeft(2, '0')}-'
        '${d.day.toString().padLeft(2, '0')}';
  }
}
