import 'package:flutter/services.dart';

/// Android 平台公共目录存储和文件管理器交互。
class BackupStorageChannel {
  static const _channel = MethodChannel(
    'com.class2data.class2data/backup_storage',
  );

  /// 将文件保存到 Downloads/kexiaoji/backup/ 目录，返回公共路径。
  Future<String> saveToDownloads(String fileName, String sourcePath) async {
    return await _channel.invokeMethod<String>('saveToDownloads', {
          'fileName': fileName,
          'sourceFilePath': sourcePath,
        })
        as String;
  }

  /// 获取备份目录路径（Download/kexiaoji/backup）。
  Future<String> getBackupDirPath() async {
    return await _channel.invokeMethod<String>('getBackupDirPath') as String;
  }

  /// 打开文件管理器定位到指定目录。
  Future<bool> openInFileManager(String dirPath) async {
    return await _channel.invokeMethod<bool>('openInFileManager', {
          'dirPath': dirPath,
        }) ??
        false;
  }
}
