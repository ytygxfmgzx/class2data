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
    final theme = Theme.of(context);
    final balanceService = CreditBalanceService();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Text(
                '课包',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () =>
                    context.push('/courses/$courseId/packages/add'),
                child: const Text('录入'),
              ),
            ],
          ),
        ),
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
                  Text(
                    '${_formatDate(package.purchaseDate)} $typeLabel',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      decoration: isVoided ? TextDecoration.lineThrough : null,
                      color: isVoided
                          ? theme.colorScheme.onSurfaceVariant
                          : null,
                    ),
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
    final typeLabel = balanceService.packageTypeLabel(package.type);
    if (package.type == 'period_pack') {
      final status = balanceService.periodPackageStatusLabel(
        now: DateTime.now(),
        validFrom: package.validFrom,
        validUntil: package.validUntil,
      );
      final validity = balanceService.periodPackageValidityLabel(
        package.validFrom,
        package.validUntil,
      );
      return '$typeLabel · $status · $validity';
    }

    var subtitle = typeLabel;
    if (package.totalCredits != null) {
      subtitle += ' · ${balanceService.formatCredits(package.totalCredits!)}课时';
    }
    return '$subtitle · $balanceText剩余';
  }

  String _formatDate(DateTime d) => '${d.month}/${d.day}';
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
