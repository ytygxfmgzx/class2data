import 'package:class2data/core/result/result.dart';
import 'package:class2data/data/database/app_database.dart';
import 'package:class2data/domain/services/credit_balance_service.dart';
import 'package:class2data/shared/providers/database_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 监听某课程的课时流水
final creditTransactionsByCourseProvider =
    StreamNotifierProvider.family<
      CreditTransactionsByCourseNotifier,
      Result<List<CreditTransaction>>,
      int
    >(CreditTransactionsByCourseNotifier.new);

class CreditTransactionsByCourseNotifier
    extends FamilyStreamNotifier<Result<List<CreditTransaction>>, int> {
  @override
  Stream<Result<List<CreditTransaction>>> build(int arg) {
    final repo = ref.watch(creditTransactionRepositoryProvider);
    return repo.watchByCourseId(arg);
  }
}

/// 监听某课包的课时流水
final creditTransactionsByPackageProvider =
    StreamNotifierProvider.family<
      CreditTransactionsByPackageNotifier,
      Result<List<CreditTransaction>>,
      int
    >(CreditTransactionsByPackageNotifier.new);

class CreditTransactionsByPackageNotifier
    extends FamilyStreamNotifier<Result<List<CreditTransaction>>, int> {
  @override
  Stream<Result<List<CreditTransaction>>> build(int arg) {
    final repo = ref.watch(creditTransactionRepositoryProvider);
    return repo.watchByPackageId(arg);
  }
}

/// 计算课包余额（响应式：依赖 stream 版流水 provider）
final packageBalanceProvider = FutureProvider.family<int, int>((
  ref,
  packageId,
) async {
  final txAsync = await ref.watch(
    creditTransactionsByPackageProvider(packageId).future,
  );
  final transactions = switch (txAsync) {
    Ok(:final value) => value,
    Err() => <CreditTransaction>[],
  };
  return CreditBalanceService().packageBalance(transactions);
});

/// 计算课程总余额（响应式：依赖 stream 版流水 provider）
final courseBalanceProvider = FutureProvider.family<int, int>((
  ref,
  courseId,
) async {
  final txAsync = await ref.watch(
    creditTransactionsByCourseProvider(courseId).future,
  );
  final transactions = switch (txAsync) {
    Ok(:final value) => value,
    Err() => <CreditTransaction>[],
  };
  return CreditBalanceService().courseBalance(transactions);
});
