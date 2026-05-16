import 'dart:async';

import 'package:class2data/core/result/result.dart';
import 'package:class2data/data/database/app_database.dart';
import 'package:class2data/data/database/daos/attachment_dao.dart';
import 'package:class2data/domain/repositories/attachment_repository.dart';

class AttachmentRepositoryImpl implements AttachmentRepository {
  final AttachmentDao _dao;

  AttachmentRepositoryImpl(this._dao);

  @override
  Stream<Result<List<Attachment>>> watchByOwner(String ownerType, int ownerId) {
    return _dao
        .watchByOwner(ownerType, ownerId)
        .map((list) => Ok<List<Attachment>>(list))
        .handleError((e) => Err<List<Attachment>>(DatabaseError('监听附件失败: $e')));
  }

  @override
  Future<Result<List<Attachment>>> getByOwner(
    String ownerType,
    int ownerId,
  ) async {
    try {
      return Ok(await _dao.getByOwner(ownerType, ownerId));
    } catch (e) {
      return Err(DatabaseError('查询附件失败: $e'));
    }
  }

  @override
  Future<Result<Attachment?>> getById(int id) async {
    try {
      return Ok(await _dao.getById(id));
    } catch (e) {
      return Err(DatabaseError('查询附件失败: $e'));
    }
  }

  @override
  Future<Result<int>> insertAttachment(AttachmentsCompanion entry) async {
    try {
      return Ok(await _dao.insertAttachment(entry));
    } catch (e) {
      return Err(DatabaseError('添加附件失败: $e'));
    }
  }

  @override
  Future<Result<void>> deleteAttachment(int id) async {
    try {
      await _dao.deleteAttachment(id);
      return const Ok(null);
    } catch (e) {
      return Err(DatabaseError('删除附件失败: $e'));
    }
  }

  @override
  Future<Result<List<Attachment>>> getByOwnerIds(
    String ownerType,
    List<int> ownerIds,
  ) async {
    try {
      return Ok(await _dao.getByOwnerIds(ownerType, ownerIds));
    } catch (e) {
      return Err(DatabaseError('查询附件失败: $e'));
    }
  }

  @override
  Future<Result<void>> deleteByOwner(String ownerType, int ownerId) async {
    try {
      await _dao.deleteByOwner(ownerType, ownerId);
      return const Ok(null);
    } catch (e) {
      return Err(DatabaseError('删除附件失败: $e'));
    }
  }
}
