import 'package:class2data/core/result/result.dart';
import 'package:class2data/data/database/app_database.dart';
import 'package:class2data/domain/services/credit_balance_service.dart';
import 'package:class2data/features/credit_ledger/providers/credit_ledger_providers.dart';
import 'package:class2data/features/packages/providers/package_providers.dart';
import 'package:class2data/shared/providers/database_provider.dart';
import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class PackageListSection extends ConsumerWidget {
  final int courseId;

  const PackageListSection({super.key, required this.courseId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final packagesAsync = ref.watch(packagesByCourseProvider(courseId));
    final balanceService = CreditBalanceService();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        packagesAsync.when(
          loading: () => const SizedBox.shrink(),
          error: (e, _) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text('加载失败: $e'),
          ),
          data: (result) => switch (result) {
            Ok(:final value) =>
              value.isEmpty
                  ? const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text('暂无课包'),
                    )
                  : Column(
                      children: value
                          .map(
                            (p) => _PackageRow(
                              package: p,
                              courseId: courseId,
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

class _PackageRow extends ConsumerWidget {
  final Package package;
  final int courseId;
  final CreditBalanceService balanceService;

  const _PackageRow({
    required this.package,
    required this.courseId,
    required this.balanceService,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final balanceAsync = ref.watch(packageBalanceProvider(package.id));

    final balanceText = balanceAsync.when(
      loading: () => '...',
      error: (_, _) => '--',
      data: (balance) => balanceService.formatCredits(balance),
    );

    final isVoided = package.isVoided;
    final typeLabel = balanceService.packageTypeLabel(package.type);
    final amountText = balanceService.formatAmount(package.amountCents);
    final nameText =
        '${balanceService.formatDate(package.purchaseDate)} $typeLabel';

    // 有效期状态标签（仅有 validFrom/validUntil 的课包才显示）
    final hasValidity = package.validFrom != null || package.validUntil != null;
    final statusLabel = hasValidity
        ? balanceService.periodPackageStatusLabel(
            now: DateTime.now(),
            validFrom: package.validFrom,
            validUntil: package.validUntil,
          )
        : null;

    final (statusBg, statusFg) = switch (statusLabel) {
      '未开始' => (
        theme.colorScheme.tertiaryContainer,
        theme.colorScheme.onTertiaryContainer,
      ),
      '进行中' => (const Color(0xFFDCFCE7), const Color(0xFF166534)),
      '已结束' => (
        theme.colorScheme.surfaceContainerHighest,
        theme.colorScheme.onSurfaceVariant,
      ),
      _ => (
        theme.colorScheme.tertiaryContainer,
        theme.colorScheme.onTertiaryContainer,
      ),
    };

    final subtitle = _buildSubtitle(balanceText);

    return InkWell(
      onTap: isVoided
          ? null
          : () =>
                context.push('/courses/$courseId/packages/${package.id}/edit'),
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
                      Flexible(
                        child: Text(
                          nameText,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            decoration: isVoided
                                ? TextDecoration.lineThrough
                                : null,
                            color: isVoided
                                ? theme.colorScheme.onSurfaceVariant
                                : null,
                          ),
                        ),
                      ),
                      if (statusLabel != null) ...[
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 1,
                          ),
                          decoration: BoxDecoration(
                            color: statusBg,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            statusLabel,
                            style: TextStyle(fontSize: 11, color: statusFg),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              amountText,
              style: TextStyle(
                fontSize: 13,
                color: isVoided
                    ? theme.colorScheme.onSurfaceVariant
                    : theme.colorScheme.onSurface,
              ),
            ),
            if (!isVoided) ...[
              const SizedBox(width: 8),
              _DeleteButton(packageId: package.id, courseId: courseId),
            ],
          ],
        ),
      ),
    );
  }

  String _buildSubtitle(String balanceText) {
    if (package.type == 'period_pack') {
      return balanceService.periodPackageValidityLabel(
        package.validFrom,
        package.validUntil,
      );
    }

    final typeLabel = balanceService.packageTypeLabel(package.type);
    var subtitle = typeLabel;
    if (package.totalCredits != null) {
      subtitle += ' · ${balanceService.formatCredits(package.totalCredits!)}课时';
    }
    return '$subtitle · $balanceText剩余';
  }
}

class _DeleteButton extends ConsumerWidget {
  final int packageId;
  final int courseId;

  const _DeleteButton({required this.packageId, required this.courseId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton(
      icon: Icon(
        Icons.delete_outline,
        size: 20,
        color: Theme.of(context).colorScheme.error,
      ),
      tooltip: '删除',
      onPressed: () => _showDeleteDialog(context, ref),
    );
  }

  void _showDeleteDialog(BuildContext context, WidgetRef ref) async {
    final creditRepo = ref.read(creditTransactionRepositoryProvider);
    final txResult = await creditRepo.getByPackageId(packageId);
    final transactions = switch (txResult) {
      Ok(:final value) => value,
      Err() => <CreditTransaction>[],
    };

    final hasConsumed = transactions.any((t) => t.creditUnitsDelta < 0);

    if (!context.mounted) return;

    if (hasConsumed) {
      _showVoidDialog(context, ref);
    } else {
      _showDirectDeleteDialog(context, ref);
    }
  }

  void _showDirectDeleteDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('删除课包'),
        content: const Text('确定要删除这个课包吗？删除后无法恢复。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('取消'),
          ),
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(ctx).colorScheme.error,
            ),
            onPressed: () async {
              final repo = ref.read(packageRepositoryProvider);
              await repo.deletePackage(packageId);
              if (ctx.mounted) Navigator.pop(ctx);
            },
            child: const Text('删除'),
          ),
        ],
      ),
    );
  }

  void _showVoidDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('删除课包'),
        content: const Text(
          '该课包已有上课消耗记录，删除后剩余课时将被清零，已上课的记录和消耗仍会保留。\n\n此操作不可恢复。',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('取消'),
          ),
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(ctx).colorScheme.error,
            ),
            onPressed: () async {
              final repo = ref.read(packageRepositoryProvider);
              final creditRepo = ref.read(creditTransactionRepositoryProvider);
              final balanceService = CreditBalanceService();
              final now = DateTime.now();

              final txResult = await creditRepo.getByPackageId(packageId);
              final balance = switch (txResult) {
                Ok(:final value) => balanceService.packageBalance(value),
                Err() => 0,
              };

              if (balance != 0) {
                await repo.voidPackageTransaction(
                  packageId: packageId,
                  voidReason: '删除课包',
                  voidTx: CreditTransactionsCompanion(
                    kidCourseId: Value(courseId),
                    packageId: Value(packageId),
                    type: const Value('void'),
                    creditUnitsDelta: Value(-balance),
                    reason: const Value('删除课包'),
                    transactionDate: Value(now),
                    createdAt: Value(now),
                  ),
                );
              } else {
                await repo.voidPackage(packageId, '删除课包');
              }

              if (ctx.mounted) Navigator.pop(ctx);
            },
            child: const Text('确认删除'),
          ),
        ],
      ),
    );
  }
}
