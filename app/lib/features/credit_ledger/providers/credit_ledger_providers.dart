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

/// 计算课包余额
final packageBalanceProvider = FutureProvider.family<int, int>((
  ref,
  packageId,
) async {
  final repo = ref.watch(creditTransactionRepositoryProvider);
  final result = await repo.getByPackageId(packageId);
  return switch (result) {
    Ok(:final value) => CreditBalanceService().packageBalance(value),
    Err() => 0,
  };
});

/// 计算课程总余额
final courseBalanceProvider = FutureProvider.family<int, int>((
  ref,
  courseId,
) async {
  final repo = ref.watch(creditTransactionRepositoryProvider);
  final result = await repo.getByCourseId(courseId);
  return switch (result) {
    Ok(:final value) => CreditBalanceService().courseBalance(value),
    Err() => 0,
  };
});
