import 'package:class2data/core/result/result.dart';
import 'package:class2data/data/database/app_database.dart';
import 'package:class2data/shared/providers/database_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 监听某课程下所有费用记录
final paymentsByCourseProvider =
    StreamNotifierProvider.family<
      PaymentsByCourseNotifier,
      Result<List<Payment>>,
      int
    >(PaymentsByCourseNotifier.new);

class PaymentsByCourseNotifier
    extends FamilyStreamNotifier<Result<List<Payment>>, int> {
  @override
  Stream<Result<List<Payment>>> build(int arg) {
    final repo = ref.watch(paymentRepositoryProvider);
    return repo.watchByCourseId(arg);
  }
}

/// 监听某课包下的费用记录
final paymentsByPackageProvider =
    StreamNotifierProvider.family<
      PaymentsByPackageNotifier,
      Result<List<Payment>>,
      int
    >(PaymentsByPackageNotifier.new);

class PaymentsByPackageNotifier
    extends FamilyStreamNotifier<Result<List<Payment>>, int> {
  @override
  Stream<Result<List<Payment>>> build(int arg) {
    final repo = ref.watch(paymentRepositoryProvider);
    return repo.watchByPackageId(arg);
  }
}
