import 'dart:async';

import 'package:class2data/core/result/result.dart';
import 'package:class2data/data/database/app_database.dart';
import 'package:class2data/data/database/daos/contact_dao.dart';
import 'package:class2data/domain/repositories/contact_repository.dart';

class ContactRepositoryImpl implements ContactRepository {
  final ContactDao _dao;

  ContactRepositoryImpl(this._dao);

  @override
  Stream<Result<List<Contact>>> watchByCourseId(int courseId) {
    return _dao
        .watchByCourseId(courseId)
        .map((list) => Ok<List<Contact>>(list))
        .handleError((e) => Err<List<Contact>>(DatabaseError('监听联系人失败: $e')));
  }

  @override
  Future<Result<Contact?>> getById(int id) async {
    try {
      return Ok(await _dao.getById(id));
    } catch (e) {
      return Err(DatabaseError('查询联系人失败: $e'));
    }
  }

  @override
  Future<Result<int>> insertContact(ContactsCompanion entry) async {
    try {
      return Ok(await _dao.insertContact(entry));
    } catch (e) {
      return Err(DatabaseError('添加联系人失败: $e'));
    }
  }

  @override
  Future<Result<void>> updateContact(ContactsCompanion entry) async {
    try {
      await _dao.updateContact(entry);
      return const Ok(null);
    } catch (e) {
      return Err(DatabaseError('更新联系人失败: $e'));
    }
  }

  @override
  Future<Result<void>> deleteContact(int id) async {
    try {
      await _dao.deleteContact(id);
      return const Ok(null);
    } catch (e) {
      return Err(DatabaseError('删除联系人失败: $e'));
    }
  }
}
