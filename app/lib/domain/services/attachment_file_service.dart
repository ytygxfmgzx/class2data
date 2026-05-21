import 'dart:io';

import 'package:path/path.dart' as p;

import '../../data/database/app_database.dart' show getDatabaseDir;
import 'cache_clean_service.dart';

/// 附件文件管理服务。
///
/// 负责将文件复制到 App 私有目录、删除文件、获取文件路径。
class AttachmentFileService {
  static const _attachmentsDir = 'attachments';

  /// 获取附件存储根目录。
  Future<Directory> getAttachmentsDirectory() async {
    final appDir = await getDatabaseDir();
    final dir = Directory(p.join(appDir.path, _attachmentsDir));
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    return dir;
  }

  /// 将源文件复制到私有目录，返回相对路径。
  ///
  /// [sourcePath] — 源文件的绝对路径
  /// [ownerType] — 业务对象类型（用于子目录组织）
  /// [ownerId] — 业务对象 ID
  Future<String> copyToPrivateDirectory({
    required String sourcePath,
    required String ownerType,
    required int ownerId,
  }) async {
    final dir = await getAttachmentsDirectory();
    final subDir = Directory(p.join(dir.path, ownerType, '$ownerId'));
    if (!await subDir.exists()) {
      await subDir.create(recursive: true);
    }

    final sourceFile = File(sourcePath);
    final extension = p.extension(sourcePath);
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final fileName = '${ownerType}_${ownerId}_$timestamp$extension';
    final destPath = p.join(subDir.path, fileName);

    await sourceFile.copy(destPath);

    // 复制成功后删除源文件并清理 image_picker 残留缓存
    try {
      if (await sourceFile.exists()) {
        await sourceFile.delete();
      }
      await CacheCleanService().clearImagePickerCache();
    } catch (_) {}

    // 返回相对路径（相对于 attachments 目录）
    return p.join(ownerType, '$ownerId', fileName);
  }

  /// 根据相对路径获取绝对路径。
  Future<String> getAbsolutePath(String relativePath) async {
    final dir = await getAttachmentsDirectory();
    return p.join(dir.path, relativePath);
  }

  /// 根据相对路径获取文件。
  Future<File> getFile(String relativePath) async {
    final absolutePath = await getAbsolutePath(relativePath);
    return File(absolutePath);
  }

  /// 检查文件是否存在。
  Future<bool> fileExists(String relativePath) async {
    final file = await getFile(relativePath);
    return file.exists();
  }

  /// 删除文件。返回是否成功。
  Future<bool> deleteFile(String relativePath) async {
    try {
      final file = await getFile(relativePath);
      if (await file.exists()) {
        await file.delete();
      }
      return true;
    } catch (_) {
      return false;
    }
  }

  /// 删除指定业务对象的附件目录（含所有文件）。
  Future<bool> deleteOwnerDirectory(String ownerType, int ownerId) async {
    try {
      final dir = await getAttachmentsDirectory();
      final subDir = Directory(p.join(dir.path, ownerType, '$ownerId'));
      if (await subDir.exists()) {
        await subDir.delete(recursive: true);
      }
      return true;
    } catch (_) {
      return false;
    }
  }

  /// 获取文件大小（字节）。
  Future<int?> getFileSize(String relativePath) async {
    try {
      final file = await getFile(relativePath);
      if (await file.exists()) {
        return await file.length();
      }
      return null;
    } catch (_) {
      return null;
    }
  }
}
