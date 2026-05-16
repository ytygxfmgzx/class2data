import 'dart:async';

import 'package:class2data/core/result/result.dart';
import 'package:class2data/data/database/app_database.dart';
import 'package:class2data/data/database/daos/credit_transaction_dao.dart';
import 'package:class2data/domain/repositories/credit_transaction_repository.dart';

class CreditTransactionRepositoryImpl implements CreditTransactionRepository {
  final CreditTransactionDao _dao;

  CreditTransactionRepositoryImpl(this._dao);

  @override
  Stream<Result<List<CreditTransaction>>> watchByCourseId(int kidCourseId) {
    return _dao
        .watchByCourseId(kidCourseId)
        .map((list) => Ok<List<CreditTransaction>>(list))
        .handleError(
          (e) => Err<List<CreditTransaction>>(DatabaseError('监听课时流水失败: $e')),
        );
  }

  @override
  Stream<Result<List<CreditTransaction>>> watchByPackageId(int packageId) {
    return _dao
        .watchByPackageId(packageId)
        .map((list) => Ok<List<CreditTransaction>>(list))
        .handleError(
          (e) => Err<List<CreditTransaction>>(DatabaseError('监听课包流水失败: $e')),
        );
  }

  @override
  Future<Result<List<CreditTransaction>>> getByCourseId(int kidCourseId) async {
    try {
      return Ok(await _dao.getByCourseId(kidCourseId));
    } catch (e) {
      return Err(DatabaseError('查询课时流水失败: $e'));
    }
  }

  @override
  Future<Result<List<CreditTransaction>>> getByPackageId(int packageId) async {
    try {
      return Ok(await _dao.getByPackageId(packageId));
    } catch (e) {
      return Err(DatabaseError('查询课包流水失败: $e'));
    }
  }

  @override
  Future<Result<List<CreditTransaction>>> getByClassRecordId(
    int classRecordId,
  ) async {
    try {
      return Ok(await _dao.getByClassRecordId(classRecordId));
    } catch (e) {
      return Err(DatabaseError('查询上课记录流水失败: $e'));
    }
  }

  @override
  Future<Result<int>> insertTransaction(
    CreditTransactionsCompanion entry,
  ) async {
    try {
      return Ok(await _dao.insertTransaction(entry));
    } catch (e) {
      return Err(DatabaseError('添加课时流水失败: $e'));
    }
  }

  @override
  Future<Result<void>> insertTransactions(
    List<CreditTransactionsCompanion> entries,
  ) async {
    try {
      await _dao.insertTransactions(entries);
      return const Ok(null);
    } catch (e) {
      return Err(DatabaseError('批量添加课时流水失败: $e'));
    }
  }

  @override
  Future<Result<void>> deleteByClassRecordId(int classRecordId) async {
    try {
      await _dao.deleteByClassRecordId(classRecordId);
      return const Ok(null);
    } catch (e) {
      return Err(DatabaseError('删除上课记录流水失败: $e'));
    }
  }
}
