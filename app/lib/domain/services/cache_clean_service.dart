import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// 缓存清理服务。
///
/// 负责 image_picker 残留缓存的大小计算和清理。
class CacheCleanService {
  /// 计算临时目录下所有文件的总大小（字节）。
  Future<int> calculateCacheSize() async {
    final tempDir = await getTemporaryDirectory();
    if (!await tempDir.exists()) return 0;

    int totalSize = 0;
    await for (final entity in tempDir.list(recursive: true)) {
      if (entity is File) {
        try {
          totalSize += await entity.length();
        } catch (_) {}
      }
    }
    return totalSize;
  }

  /// 清理临时目录下的所有文件和子目录，返回释放的字节数。
  Future<int> clearAllCache() async {
    final tempDir = await getTemporaryDirectory();
    if (!await tempDir.exists()) return 0;

    int freedBytes = 0;
    await for (final entity in tempDir.list()) {
      try {
        if (entity is File) {
          freedBytes += await entity.length();
          await entity.delete();
        } else if (entity is Directory) {
          freedBytes += await _directorySize(entity);
          await entity.delete(recursive: true);
        }
      } catch (_) {}
    }
    return freedBytes;
  }

  /// 清理超过 [maxAge] 的过期缓存文件，返回释放的字节数。
  Future<int> clearExpiredCache({
    Duration maxAge = const Duration(days: 1),
  }) async {
    final tempDir = await getTemporaryDirectory();
    if (!await tempDir.exists()) return 0;

    final cutoff = DateTime.now().subtract(maxAge);
    int freedBytes = 0;

    await for (final entity in tempDir.list()) {
      try {
        final stat = await entity.stat();
        if (stat.modified.isBefore(cutoff)) {
          if (entity is File) {
            freedBytes += await entity.length();
            await entity.delete();
          } else if (entity is Directory) {
            freedBytes += await _directorySize(entity);
            await entity.delete(recursive: true);
          }
        }
      } catch (_) {}
    }
    return freedBytes;
  }

  /// 清理 image_picker 产生的临时文件（UUID 目录 + scaled 文件）。
  Future<void> clearImagePickerCache() async {
    final tempDir = await getTemporaryDirectory();
    if (!await tempDir.exists()) return;

    final uuidPattern = RegExp(
      r'^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$',
      caseSensitive: false,
    );

    await for (final entity in tempDir.list()) {
      try {
        if (entity is Directory) {
          final name = p.basename(entity.path);
          if (uuidPattern.hasMatch(name)) {
            await entity.delete(recursive: true);
          }
        } else if (entity is File) {
          final name = p.basename(entity.path);
          if (name.startsWith('scaled_')) {
            await entity.delete();
          }
        }
      } catch (_) {}
    }
  }

  Future<int> _directorySize(Directory dir) async {
    int size = 0;
    await for (final entity in dir.list(recursive: true)) {
      if (entity is File) {
        try {
          size += await entity.length();
        } catch (_) {}
      }
    }
    return size;
  }
}
