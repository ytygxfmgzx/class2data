import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/tables.dart';

part 'class_record_dao.g.dart';

@DriftAccessor(tables: [ClassRecords, CreditTransactions])
class ClassRecordDao extends DatabaseAccessor<AppDatabase>
    with _$ClassRecordDaoMixin {
  ClassRecordDao(super.db);

  /// 查询指定日期范围内的上课记录。
  /// SQLite 对 YYYY-MM-DD 格式字符串可直接排序比较。
  Future<List<ClassRecord>> getByDateRange(String startDate, String endDate) {
    return (select(classRecords)..where(
          (t) =>
              t.classDate.isBiggerOrEqualValue(startDate) &
              t.classDate.isSmallerOrEqualValue(endDate),
        ))
        .get();
  }

  Stream<List<ClassRecord>> watchByCourseId(int kidCourseId) {
    return (select(classRecords)
          ..where((t) => t.kidCourseId.equals(kidCourseId))
          ..orderBy([
            (t) => OrderingTerm.desc(t.classDate),
            (t) => OrderingTerm.desc(t.startTime),
          ]))
        .watch();
  }

  Future<List<ClassRecord>> getByCourseId(int kidCourseId) {
    return (select(classRecords)
          ..where((t) => t.kidCourseId.equals(kidCourseId))
          ..orderBy([
            (t) => OrderingTerm.desc(t.classDate),
            (t) => OrderingTerm.desc(t.startTime),
          ]))
        .get();
  }

  Future<ClassRecord?> getById(int id) {
    return (select(
      classRecords,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  Future<int> countByCourseId(int kidCourseId) async {
    final countExpr = classRecords.id.count();
    final query = selectOnly(classRecords)
      ..where(classRecords.kidCourseId.equals(kidCourseId))
      ..addColumns([countExpr]);
    final row = await query.getSingle();
    return row.read(countExpr) ?? 0;
  }

  Future<int> insertRecord(ClassRecordsCompanion entry) {
    return into(classRecords).insert(entry);
  }

  /// 事务：创建上课记录 + 可选消耗流水
  Future<int> insertRecordWithTransaction(
    ClassRecordsCompanion record,
    CreditTransactionsCompanion? creditTx,
  ) {
    return transaction(() async {
      final recordId = await into(classRecords).insert(record);

      if (creditTx != null) {
        await into(
          creditTransactions,
        ).insert(creditTx.copyWith(classRecordId: Value(recordId)));
      }

      return recordId;
    });
  }

  Future<void> updateRecord(ClassRecordsCompanion entry) {
    return (update(
      classRecords,
    )..where((t) => t.id.equals(entry.id.value))).write(entry);
  }

  Future<void> deleteRecord(int id) {
    return (delete(classRecords)..where((t) => t.id.equals(id))).go();
  }

  Future<void> deleteTransactionsByRecordId(int recordId) {
    return (delete(
      creditTransactions,
    )..where((t) => t.classRecordId.equals(recordId))).go();
  }

  /// 事务：更新上课记录 + 可选替换消耗流水
  /// 先删除旧流水，再更新记录，最后插入新流水（如有）
  Future<void> updateRecordWithCreditTransaction(
    ClassRecordsCompanion record,
    CreditTransactionsCompanion? creditTx,
  ) {
    return transaction(() async {
      final recordId = record.id.value;
      await (delete(
        creditTransactions,
      )..where((t) => t.classRecordId.equals(recordId))).go();

      await (update(
        classRecords,
      )..where((t) => t.id.equals(recordId))).write(record);

      if (creditTx != null) {
        await into(
          creditTransactions,
        ).insert(creditTx.copyWith(classRecordId: Value(recordId)));
      }
    });
  }
}
