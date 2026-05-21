import 'dart:async';
import 'dart:io';

import 'package:class2data/core/result/result.dart';
import 'package:class2data/data/database/app_database.dart';
import 'package:class2data/data/database/daos/child_dao.dart';
import 'package:class2data/domain/repositories/child_repository.dart';
import 'package:class2data/domain/services/attachment_file_service.dart';
import 'package:class2data/domain/services/avatar_file_service.dart';
import 'package:path/path.dart' as p;

class ChildRepositoryImpl implements ChildRepository {
  final ChildDao _dao;

  ChildRepositoryImpl(this._dao);

  @override
  Future<Result<List<ChildrenData>>> getAllActive() async {
    try {
      return Ok(await _dao.getAllActive());
    } catch (e) {
      return Err(DatabaseError('查询孩子列表失败: $e'));
    }
  }

  @override
  Stream<Result<List<ChildrenData>>> watchAllActive() {
    return _dao
        .watchAllActive()
        .map((list) => Ok<List<ChildrenData>>(list))
        .handleError(
          (e) => Err<List<ChildrenData>>(DatabaseError('监听孩子列表失败: $e')),
        );
  }

  @override
  Future<Result<ChildrenData?>> getById(int id) async {
    try {
      return Ok(await _dao.getById(id));
    } catch (e) {
      return Err(DatabaseError('查询孩子失败: $e'));
    }
  }

  @override
  Future<Result<int>> insertChild(ChildrenCompanion entry) async {
    try {
      return Ok(await _dao.insertChild(entry));
    } catch (e) {
      return Err(DatabaseError('添加孩子失败: $e'));
    }
  }

  @override
  Future<Result<void>> updateChild(ChildrenCompanion entry) async {
    try {
      await _dao.updateChild(entry);
      return const Ok(null);
    } catch (e) {
      return Err(DatabaseError('更新孩子失败: $e'));
    }
  }

  @override
  Future<Result<void>> deleteChild(int id) async {
    try {
      final child = await _dao.getById(id);
      final attachmentPaths = await _dao.getAttachmentPathsForChild(id);
      await _dao.deleteChildCascade(id);
      // 清理头像
      if (child != null && child.avatarPath != null) {
        await AvatarFileService.instance.deleteAvatar(child.avatarPath);
      }
      // 清理附件物理文件
      final fileService = AttachmentFileService();
      for (final path in attachmentPaths) {
        try {
          final file = await fileService.getFile(path);
          if (await file.exists()) await file.delete();
        } catch (_) {}
      }
      // 清理残留的附件目录
      final ownerDirs = <String>{};
      for (final path in attachmentPaths) {
        final parts = p.split(path);
        if (parts.length >= 2) {
          ownerDirs.add(p.join(parts[0], parts[1]));
        }
      }
      for (final ownerDir in ownerDirs) {
        try {
          final dir = Directory(
            p.join(
              (await fileService.getAttachmentsDirectory()).path,
              ownerDir,
            ),
          );
          if (await dir.exists()) {
            await dir.delete(recursive: true);
          }
        } catch (_) {}
      }
      return const Ok(null);
    } catch (e) {
      return Err(DatabaseError('删除孩子失败: $e'));
    }
  }
}
