import 'dart:io';

import 'package:path/path.dart' as p;

import '../../data/database/app_database.dart' show getDatabaseDir;
import 'cache_clean_service.dart';

class AvatarFileService {
  static const _avatarsDir = 'avatars';

  static final AvatarFileService instance = AvatarFileService._();

  AvatarFileService._();

  Future<Directory> getAvatarsDirectory() async {
    final appDir = await getDatabaseDir();
    final dir = Directory(p.join(appDir.path, _avatarsDir));
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    return dir;
  }

  Future<String> saveAvatar(int childId, String sourcePath) async {
    final dir = await getAvatarsDirectory();
    final extension = p.extension(sourcePath);
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final fileName = 'child_${childId}_$timestamp$extension';
    final destPath = p.join(dir.path, fileName);

    await File(sourcePath).copy(destPath);

    // 复制成功后删除源文件并清理 image_picker 残留缓存
    try {
      final sourceFile = File(sourcePath);
      if (await sourceFile.exists()) {
        await sourceFile.delete();
      }
      await CacheCleanService().clearImagePickerCache();
    } catch (_) {}

    return p.join(_avatarsDir, fileName);
  }

  Future<String> getAbsolutePath(String relativePath) async {
    final appDir = await getDatabaseDir();
    return p.join(appDir.path, relativePath);
  }

  Future<bool> deleteAvatar(String? relativePath) async {
    if (relativePath == null || relativePath.isEmpty) return true;
    try {
      final absolutePath = await getAbsolutePath(relativePath);
      final file = File(absolutePath);
      if (await file.exists()) {
        await file.delete();
      }
      return true;
    } catch (_) {
      return false;
    }
  }
}
