import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/tables.dart';

part 'package_dao.g.dart';

@DriftAccessor(tables: [Packages, CreditTransactions, Payments])
class PackageDao extends DatabaseAccessor<AppDatabase> with _$PackageDaoMixin {
  PackageDao(super.db);

  Stream<List<Package>> watchByCourseId(int kidCourseId) {
    return (select(packages)
          ..where((t) => t.kidCourseId.equals(kidCourseId))
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .watch();
  }

  Stream<List<Package>> watchActiveByCourseId(int kidCourseId) {
    return (select(packages)
          ..where((t) => t.kidCourseId.equals(kidCourseId))
          ..where((t) => t.isVoided.equals(false))
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .watch();
  }

  Future<Package?> getById(int id) {
    return (select(packages)..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  Future<int> insertPackage(PackagesCompanion entry) {
    return into(packages).insert(entry);
  }

  Future<void> updatePackage(PackagesCompanion entry) {
    return (update(
      packages,
    )..where((t) => t.id.equals(entry.id.value))).write(entry);
  }

  Future<void> voidPackage(int id, String voidReason) {
    return (update(packages)..where((t) => t.id.equals(id))).write(
      PackagesCompanion(
        isVoided: const Value(true),
        voidedAt: Value(DateTime.now()),
        voidReason: Value(voidReason),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  /// 事务：一次购课 → 创建课包 + 费用 + 正向流水
  Future<int> createPurchaseTransaction({
    required PackagesCompanion package,
    PaymentsCompanion? payment,
    CreditTransactionsCompanion? creditTx,
  }) {
    return transaction(() async {
      final packageId = await into(packages).insert(package);

      if (payment != null) {
        await into(
          payments,
        ).insert(payment.copyWith(packageId: Value(packageId)));
      }

      if (creditTx != null) {
        await into(
          creditTransactions,
        ).insert(creditTx.copyWith(packageId: Value(packageId)));
      }

      return packageId;
    });
  }

  /// 事务：作废课包 → 标记作废 + 创建反向流水
  Future<void> voidPackageTransaction({
    required int packageId,
    required String voidReason,
    required CreditTransactionsCompanion voidTx,
  }) {
    return transaction(() async {
      await voidPackage(packageId, voidReason);
      await into(creditTransactions).insert(voidTx);
    });
  }

  /// 事务：彻底删除课包及其关联流水
  Future<void> deletePackage(int packageId) {
    return transaction(() async {
      await (delete(
        creditTransactions,
      )..where((t) => t.packageId.equals(packageId))).go();
      await (delete(packages)..where((t) => t.id.equals(packageId))).go();
    });
  }
}
