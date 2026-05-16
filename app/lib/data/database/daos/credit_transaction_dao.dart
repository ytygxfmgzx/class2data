import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/tables.dart';

part 'credit_transaction_dao.g.dart';

@DriftAccessor(tables: [CreditTransactions])
class CreditTransactionDao extends DatabaseAccessor<AppDatabase>
    with _$CreditTransactionDaoMixin {
  CreditTransactionDao(super.db);

  Stream<List<CreditTransaction>> watchByCourseId(int kidCourseId) {
    return (select(creditTransactions)
          ..where((t) => t.kidCourseId.equals(kidCourseId))
          ..orderBy([(t) => OrderingTerm.desc(t.transactionDate)]))
        .watch();
  }

  Stream<List<CreditTransaction>> watchByPackageId(int packageId) {
    return (select(
      creditTransactions,
    )..where((t) => t.packageId.equals(packageId))).watch();
  }

  Future<List<CreditTransaction>> getByCourseId(int kidCourseId) {
    return (select(
      creditTransactions,
    )..where((t) => t.kidCourseId.equals(kidCourseId))).get();
  }

  Future<List<CreditTransaction>> getByPackageId(int packageId) {
    return (select(
      creditTransactions,
    )..where((t) => t.packageId.equals(packageId))).get();
  }

  Future<List<CreditTransaction>> getByClassRecordId(int classRecordId) {
    return (select(
      creditTransactions,
    )..where((t) => t.classRecordId.equals(classRecordId))).get();
  }

  Future<int> insertTransaction(CreditTransactionsCompanion entry) {
    return into(creditTransactions).insert(entry);
  }

  Future<void> insertTransactions(List<CreditTransactionsCompanion> entries) {
    return batch((b) {
      b.insertAll(creditTransactions, entries);
    });
  }

  Future<void> deleteByClassRecordId(int classRecordId) {
    return (delete(
      creditTransactions,
    )..where((t) => t.classRecordId.equals(classRecordId))).go();
  }
}
