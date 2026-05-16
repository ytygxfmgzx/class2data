import 'dart:async';

import 'package:class2data/core/result/result.dart';
import 'package:class2data/data/database/app_database.dart';
import 'package:class2data/data/database/daos/payment_dao.dart';
import 'package:class2data/domain/repositories/payment_repository.dart';

class PaymentRepositoryImpl implements PaymentRepository {
  final PaymentDao _dao;

  PaymentRepositoryImpl(this._dao);

  @override
  Stream<Result<List<Payment>>> watchByCourseId(int kidCourseId) {
    return _dao
        .watchByCourseId(kidCourseId)
        .map((list) => Ok<List<Payment>>(list))
        .handleError((e) => Err<List<Payment>>(DatabaseError('监听费用列表失败: $e')));
  }

  @override
  Stream<Result<List<Payment>>> watchByPackageId(int packageId) {
    return _dao
        .watchByPackageId(packageId)
        .map((list) => Ok<List<Payment>>(list))
        .handleError((e) => Err<List<Payment>>(DatabaseError('监听课包费用失败: $e')));
  }

  @override
  Future<Result<Payment?>> getById(int id) async {
    try {
      return Ok(await _dao.getById(id));
    } catch (e) {
      return Err(DatabaseError('查询费用失败: $e'));
    }
  }

  @override
  Future<Result<int>> insertPayment(PaymentsCompanion entry) async {
    try {
      return Ok(await _dao.insertPayment(entry));
    } catch (e) {
      return Err(DatabaseError('添加费用失败: $e'));
    }
  }

  @override
  Future<Result<void>> updatePayment(PaymentsCompanion entry) async {
    try {
      await _dao.updatePayment(entry);
      return const Ok(null);
    } catch (e) {
      return Err(DatabaseError('更新费用失败: $e'));
    }
  }

  @override
  Future<Result<void>> deletePayment(int id) async {
    try {
      await _dao.deletePayment(id);
      return const Ok(null);
    } catch (e) {
      return Err(DatabaseError('删除费用失败: $e'));
    }
  }
}
