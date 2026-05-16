import 'package:class2data/core/result/result.dart';
import 'package:class2data/data/database/app_database.dart';

abstract class CreditTransactionRepository {
  Stream<Result<List<CreditTransaction>>> watchByCourseId(int kidCourseId);
  Stream<Result<List<CreditTransaction>>> watchByPackageId(int packageId);
  Future<Result<List<CreditTransaction>>> getByCourseId(int kidCourseId);
  Future<Result<List<CreditTransaction>>> getByPackageId(int packageId);
  Future<Result<List<CreditTransaction>>> getByClassRecordId(int classRecordId);
  Future<Result<int>> insertTransaction(CreditTransactionsCompanion entry);
  Future<Result<void>> insertTransactions(
    List<CreditTransactionsCompanion> entries,
  );
  Future<Result<void>> deleteByClassRecordId(int classRecordId);
}
