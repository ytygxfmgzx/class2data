import 'package:class2data/core/result/result.dart';
import 'package:class2data/data/database/app_database.dart';
import 'package:class2data/domain/services/credit_balance_service.dart';
import 'package:class2data/features/credit_ledger/providers/credit_ledger_providers.dart';
import 'package:class2data/features/packages/providers/package_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class PackageListSection extends ConsumerWidget {
  final int courseId;

  const PackageListSection({super.key, required this.courseId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final packagesAsync = ref.watch(activePackagesByCourseProvider(courseId));
    final balanceService = CreditBalanceService();

    return packagesAsync.when(
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
              : ListView.builder(
                  itemCount: value.length,
                  itemBuilder: (context, index) => _PackageRow(
                    package: value[index],
                    courseId: courseId,
                    balanceService: balanceService,
                  ),
                ),
        Err(:final error) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(error.message),
        ),
      },
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
      onTap: () =>
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
                          style: theme.textTheme.bodyMedium,
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
                color: theme.colorScheme.onSurface,
              ),
            ),
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
