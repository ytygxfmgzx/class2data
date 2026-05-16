import 'dart:async';

import 'package:class2data/core/result/result.dart';
import 'package:class2data/data/database/app_database.dart';
import 'package:class2data/data/database/daos/class_record_dao.dart';
import 'package:class2data/domain/repositories/class_record_repository.dart';

class ClassRecordRepositoryImpl implements ClassRecordRepository {
  final ClassRecordDao _dao;

  ClassRecordRepositoryImpl(this._dao);

  @override
  Future<Result<List<ClassRecord>>> getByDateRange(
    String startDate,
    String endDate,
  ) async {
    try {
      return Ok(await _dao.getByDateRange(startDate, endDate));
    } catch (e) {
      return Err(DatabaseError('查询上课记录失败: $e'));
    }
  }

  @override
  Stream<Result<List<ClassRecord>>> watchByCourseId(int kidCourseId) {
    return _dao
        .watchByCourseId(kidCourseId)
        .map((list) => Ok<List<ClassRecord>>(list))
        .handleError(
          (e) => Err<List<ClassRecord>>(DatabaseError('监听上课记录失败: $e')),
        );
  }

  @override
  Future<Result<List<ClassRecord>>> getByCourseId(int kidCourseId) async {
    try {
      return Ok(await _dao.getByCourseId(kidCourseId));
    } catch (e) {
      return Err(DatabaseError('查询上课记录失败: $e'));
    }
  }

  @override
  Future<Result<ClassRecord?>> getById(int id) async {
    try {
      return Ok(await _dao.getById(id));
    } catch (e) {
      return Err(DatabaseError('查询上课记录失败: $e'));
    }
  }

  @override
  Future<Result<int>> countByCourseId(int kidCourseId) async {
    try {
      return Ok(await _dao.countByCourseId(kidCourseId));
    } catch (e) {
      return Err(DatabaseError('统计上课次数失败: $e'));
    }
  }

  @override
  Future<Result<int>> insertRecord(ClassRecordsCompanion entry) async {
    try {
      return Ok(await _dao.insertRecord(entry));
    } catch (e) {
      return Err(DatabaseError('添加上课记录失败: $e'));
    }
  }

  @override
  Future<Result<int>> insertRecordWithTransaction(
    ClassRecordsCompanion record,
    CreditTransactionsCompanion? creditTx,
  ) async {
    try {
      return Ok(await _dao.insertRecordWithTransaction(record, creditTx));
    } catch (e) {
      return Err(DatabaseError('创建上课记录失败: $e'));
    }
  }

  @override
  Future<Result<void>> updateRecord(ClassRecordsCompanion entry) async {
    try {
      await _dao.updateRecord(entry);
      return const Ok(null);
    } catch (e) {
      return Err(DatabaseError('更新上课记录失败: $e'));
    }
  }

  @override
  Future<Result<void>> deleteRecord(int id) async {
    try {
      await _dao.deleteRecord(id);
      return const Ok(null);
    } catch (e) {
      return Err(DatabaseError('删除上课记录失败: $e'));
    }
  }

  @override
  Future<Result<void>> deleteTransactionsByRecordId(int recordId) async {
    try {
      await _dao.deleteTransactionsByRecordId(recordId);
      return const Ok(null);
    } catch (e) {
      return Err(DatabaseError('删除关联流水失败: $e'));
    }
  }
}
