import 'package:class2data/core/result/result.dart';
import 'package:class2data/data/database/app_database.dart';

abstract class ClassRecordRepository {
  Future<Result<List<ClassRecord>>> getByDateRange(
    String startDate,
    String endDate,
  );
  Stream<Result<List<ClassRecord>>> watchByCourseId(int kidCourseId);
  Future<Result<List<ClassRecord>>> getByCourseId(int kidCourseId);
  Future<Result<ClassRecord?>> getById(int id);
  Future<Result<int>> countByCourseId(int kidCourseId);
  Future<Result<int>> insertRecord(ClassRecordsCompanion entry);
  Future<Result<int>> insertRecordWithTransaction(
    ClassRecordsCompanion record,
    CreditTransactionsCompanion? creditTx,
  );
  Future<Result<void>> updateRecord(ClassRecordsCompanion entry);
  Future<Result<void>> deleteRecord(int id);
  Future<Result<void>> deleteTransactionsByRecordId(int recordId);
}
