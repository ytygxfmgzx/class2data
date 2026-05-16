import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/tables.dart';

part 'payment_dao.g.dart';

@DriftAccessor(tables: [Payments])
class PaymentDao extends DatabaseAccessor<AppDatabase> with _$PaymentDaoMixin {
  PaymentDao(super.db);

  Stream<List<Payment>> watchByCourseId(int kidCourseId) {
    return (select(payments)
          ..where((t) => t.kidCourseId.equals(kidCourseId))
          ..orderBy([(t) => OrderingTerm.desc(t.paymentDate)]))
        .watch();
  }

  Stream<List<Payment>> watchByPackageId(int packageId) {
    return (select(
      payments,
    )..where((t) => t.packageId.equals(packageId))).watch();
  }

  Future<Payment?> getById(int id) {
    return (select(payments)..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  Future<int> insertPayment(PaymentsCompanion entry) {
    return into(payments).insert(entry);
  }

  Future<void> updatePayment(PaymentsCompanion entry) {
    return (update(
      payments,
    )..where((t) => t.id.equals(entry.id.value))).write(entry);
  }

  Future<void> deletePayment(int id) {
    return (delete(payments)..where((t) => t.id.equals(id))).go();
  }
}
