import 'package:class2data/core/result/result.dart';
import 'package:class2data/data/database/app_database.dart';

abstract class PaymentRepository {
  Stream<Result<List<Payment>>> watchByCourseId(int kidCourseId);
  Stream<Result<List<Payment>>> watchByPackageId(int packageId);
  Future<Result<Payment?>> getById(int id);
  Future<Result<int>> insertPayment(PaymentsCompanion entry);
  Future<Result<void>> updatePayment(PaymentsCompanion entry);
  Future<Result<void>> deletePayment(int id);
}
