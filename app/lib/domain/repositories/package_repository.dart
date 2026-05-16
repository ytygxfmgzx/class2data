import 'package:class2data/core/result/result.dart';
import 'package:class2data/data/database/app_database.dart';

abstract class PackageRepository {
  Stream<Result<List<Package>>> watchByCourseId(int kidCourseId);
  Stream<Result<List<Package>>> watchActiveByCourseId(int kidCourseId);
  Future<Result<Package?>> getById(int id);
  Future<Result<int>> insertPackage(PackagesCompanion entry);
  Future<Result<void>> updatePackage(PackagesCompanion entry);
  Future<Result<void>> voidPackage(int id, String voidReason);

  /// 事务：一次购课 → 创建课包 + 费用 + 正向流水
  Future<Result<int>> createPurchaseTransaction({
    required PackagesCompanion package,
    PaymentsCompanion? payment,
    CreditTransactionsCompanion? creditTx,
  });

  /// 事务：作废课包
  Future<Result<void>> voidPackageTransaction({
    required int packageId,
    required String voidReason,
    required CreditTransactionsCompanion voidTx,
  });

  /// 彻底删除课包及其关联流水
  Future<Result<void>> deletePackage(int packageId);
}
