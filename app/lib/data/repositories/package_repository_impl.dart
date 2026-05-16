import 'dart:async';

import 'package:class2data/core/result/result.dart';
import 'package:class2data/data/database/app_database.dart';
import 'package:class2data/data/database/daos/package_dao.dart';
import 'package:class2data/domain/repositories/package_repository.dart';

class PackageRepositoryImpl implements PackageRepository {
  final PackageDao _dao;

  PackageRepositoryImpl(this._dao);

  @override
  Stream<Result<List<Package>>> watchByCourseId(int kidCourseId) {
    return _dao
        .watchByCourseId(kidCourseId)
        .map((list) => Ok<List<Package>>(list))
        .handleError((e) => Err<List<Package>>(DatabaseError('监听课包列表失败: $e')));
  }

  @override
  Stream<Result<List<Package>>> watchActiveByCourseId(int kidCourseId) {
    return _dao
        .watchActiveByCourseId(kidCourseId)
        .map((list) => Ok<List<Package>>(list))
        .handleError(
          (e) => Err<List<Package>>(DatabaseError('监听可用课包列表失败: $e')),
        );
  }

  @override
  Future<Result<Package?>> getById(int id) async {
    try {
      return Ok(await _dao.getById(id));
    } catch (e) {
      return Err(DatabaseError('查询课包失败: $e'));
    }
  }

  @override
  Future<Result<int>> insertPackage(PackagesCompanion entry) async {
    try {
      return Ok(await _dao.insertPackage(entry));
    } catch (e) {
      return Err(DatabaseError('添加课包失败: $e'));
    }
  }

  @override
  Future<Result<void>> updatePackage(PackagesCompanion entry) async {
    try {
      await _dao.updatePackage(entry);
      return const Ok(null);
    } catch (e) {
      return Err(DatabaseError('更新课包失败: $e'));
    }
  }

  @override
  Future<Result<void>> voidPackage(int id, String voidReason) async {
    try {
      await _dao.voidPackage(id, voidReason);
      return const Ok(null);
    } catch (e) {
      return Err(DatabaseError('作废课包失败: $e'));
    }
  }

  @override
  Future<Result<int>> createPurchaseTransaction({
    required PackagesCompanion package,
    PaymentsCompanion? payment,
    CreditTransactionsCompanion? creditTx,
  }) async {
    try {
      return Ok(
        await _dao.createPurchaseTransaction(
          package: package,
          payment: payment,
          creditTx: creditTx,
        ),
      );
    } catch (e) {
      return Err(DatabaseError('创建购课记录失败: $e'));
    }
  }

  @override
  Future<Result<void>> voidPackageTransaction({
    required int packageId,
    required String voidReason,
    required CreditTransactionsCompanion voidTx,
  }) async {
    try {
      await _dao.voidPackageTransaction(
        packageId: packageId,
        voidReason: voidReason,
        voidTx: voidTx,
      );
      return const Ok(null);
    } catch (e) {
      return Err(DatabaseError('作废课包事务失败: $e'));
    }
  }

  @override
  Future<Result<void>> deletePackage(int packageId) async {
    try {
      await _dao.deletePackage(packageId);
      return const Ok(null);
    } catch (e) {
      return Err(DatabaseError('删除课包失败: $e'));
    }
  }
}
