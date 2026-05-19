import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../data/database/app_database.dart';
import '../../data/files/backup_file_store.dart';
import '../../data/webdav/webdav_client.dart';
import '../../data/webdav/webdav_exceptions.dart';
import 'attachment_file_service.dart';
import 'avatar_file_service.dart';
import 'cloud_manifest.dart';

const _kexiaojiDir = 'kexiaoji';
const _filesDir = 'files';

/// 云端备份/恢复进度。
class CloudBackupProgress {
  final String phase;
  final int current;
  final int total;
  final String? currentFile;

  const CloudBackupProgress({
    required this.phase,
    this.current = 0,
    this.total = 0,
    this.currentFile,
  });
}

/// 本地文件信息（相对路径 → 绝对路径 + 大小）。
class _LocalFileEntry {
  final String absolutePath;
  final int fileSize;

  const _LocalFileEntry({
    required this.absolutePath,
    required this.fileSize,
  });
}

/// 云端备份/恢复业务服务。
class CloudBackupService {
  final AppDatabase _database;
  final BackupFileStore _fileStore;
  final AttachmentFileService _attachmentFileService;
  final AvatarFileService _avatarFileService;

  CloudBackupService({
    required AppDatabase database,
    required BackupFileStore fileStore,
    required AttachmentFileService attachmentFileService,
    required AvatarFileService avatarFileService,
  }) : _database = database,
       _fileStore = fileStore,
       _attachmentFileService = attachmentFileService,
       _avatarFileService = avatarFileService;

  /// 检查远端状态，返回远端 meta 或 null（无远端数据时）。
  Future<CloudManifest?> checkRemote(WebDavClient client) async {
    try {
      final json = await client.downloadJson(
        '/$_kexiaojiDir/cloud-manifest.json',
      );
      return CloudManifest.fromJson(json);
    } on WebDavNotFoundError {
      return null;
    } catch (_) {
      return null;
    }
  }

  /// 检查远端设备绑定。
  Future<DeviceLock?> getDeviceLock(WebDavClient client) async {
    try {
      final json = await client.downloadJson('/$_kexiaojiDir/device-lock.json');
      return DeviceLock.fromJson(json);
    } on WebDavNotFoundError {
      return null;
    } catch (_) {
      return null;
    }
  }

  /// 计算本地与云端的文件差异（轻量扫描，按路径对比）。
  Future<({int toDownload, int toUpload})> computeSyncDiff(
    CloudManifest remoteManifest,
  ) async {
    final localFiles = await _scanLocalFiles();
    final remoteFiles = remoteManifest.files;

    int toDownload = 0;
    int toUpload = 0;

    for (final entry in remoteFiles.entries) {
      if (!localFiles.containsKey(entry.key)) {
        toDownload++;
      }
    }

    for (final key in localFiles.keys) {
      if (!remoteFiles.containsKey(key)) {
        toUpload++;
      }
    }

    return (toDownload: toDownload, toUpload: toUpload);
  }

  /// 备份到云端（增量）。
  Future<CloudBackupResult> backupToCloud(
    WebDavClient client,
    String deviceId,
    String deviceName, {
    void Function(CloudBackupProgress)? onProgress,
  }) async {
    // 1. 确保目录存在
    await client.ensureDirectory('/$_kexiaojiDir');
    await client.ensureDirectory('/$_kexiaojiDir/$_filesDir');
    await client.ensureDirectory('/$_kexiaojiDir/$_filesDir/attachments');
    await client.ensureDirectory('/$_kexiaojiDir/$_filesDir/avatars');

    // 2. 检查设备绑定
    final existingLock = await getDeviceLock(client);
    if (existingLock != null && existingLock.deviceId != deviceId) {
      return CloudBackupDeviceLocked(existingLock);
    }

    // 3. checkpoint
    await _database.checkpoint();

    // 4. 读取远端 manifest
    CloudManifest? remoteManifest;
    try {
      final json = await client.downloadJson(
        '/$_kexiaojiDir/cloud-manifest.json',
      );
      remoteManifest = CloudManifest.fromJson(json);
    } on WebDavNotFoundError {
      remoteManifest = null;
    }

    // 5. 扫描本地文件
    final localFiles = await _scanLocalFiles();

    // 6. 计算差异（按路径对比）
    final remoteFiles = remoteManifest?.files ?? {};
    final toUpload = <String, _LocalFileEntry>{};
    final toDelete = <String>[];

    for (final entry in localFiles.entries) {
      if (!remoteFiles.containsKey(entry.key)) {
        toUpload[entry.key] = entry.value;
      }
    }

    for (final remotePath in remoteFiles.keys) {
      if (!localFiles.containsKey(remotePath)) {
        toDelete.add(remotePath);
      }
    }

    // 7. 上传差异文件
    if (toUpload.isNotEmpty) {
      final createdDirs = <String>{};
      onProgress?.call(
        CloudBackupProgress(phase: '上传文件', total: toUpload.length),
      );

      var uploaded = 0;
      for (final entry in toUpload.entries) {
        onProgress?.call(
          CloudBackupProgress(
            phase: '上传文件',
            current: uploaded,
            total: toUpload.length,
            currentFile: entry.key,
          ),
        );

        final remoteFilePath = '/$_kexiaojiDir/$_filesDir/${entry.key}';
        final parentDir = p.url.dirname(remoteFilePath);
        if (!createdDirs.contains(parentDir)) {
          await client.ensureDirectory(parentDir);
          createdDirs.add(parentDir);
        }

        final localPath = entry.value.absolutePath;
        if (await File(localPath).exists()) {
          await client.uploadFile(localPath, remoteFilePath);
        }
        uploaded++;
      }
    }

    // 8. 删除远端多余文件
    for (final remotePath in toDelete) {
      try {
        await client.delete('/$_kexiaojiDir/$_filesDir/$remotePath');
      } on WebDavNotFoundError {
        // 已经不存在，跳过
      }
    }

    // 9. 上传数据库
    onProgress?.call(const CloudBackupProgress(phase: '上传数据库...'));
    final dbPath = await AppDatabase.getDatabasePath();
    final dbFile = File(dbPath);
    final dbBytes = await dbFile.readAsBytes();
    final dbHash = sha256.convert(dbBytes).toString();

    await client.uploadFile(dbPath, '/$_kexiaojiDir/database.db');

    // 10. 构建 manifest
    final newVersion = (remoteManifest?.version ?? 0) + 1;
    final manifestFiles = <String, CloudFileInfo>{};
    for (final entry in localFiles.entries) {
      manifestFiles[entry.key] = CloudFileInfo(
        size: entry.value.fileSize,
      );
    }

    final manifest = CloudManifest(
      format: 'class2data-cloud',
      formatVersion: 1,
      version: newVersion,
      deviceId: deviceId,
      deviceName: deviceName,
      lastModifiedTime: DateTime.now(),
      schemaVersion: _database.schemaVersion,
      appVersion: '0.1.0+1',
      databaseSize: dbBytes.length,
      databaseSha256: dbHash,
      files: manifestFiles,
    );

    // 11. 上传 manifest（最后上传，作为完成标志）
    await client.uploadJson(
      '/$_kexiaojiDir/cloud-manifest.json',
      manifest.toJson(),
    );

    // 12. 上传 device-lock（首次）
    if (existingLock == null) {
      final lock = DeviceLock(
        deviceId: deviceId,
        deviceName: deviceName,
        lockedAt: DateTime.now(),
      );
      await client.uploadJson('/$_kexiaojiDir/device-lock.json', lock.toJson());
    }

    return CloudBackupSuccess(manifest);
  }

  /// 从云端恢复（增量）。
  Future<CloudBackupResult> restoreFromCloud(
    WebDavClient client, {
    void Function(CloudBackupProgress)? onProgress,
    Future<void> Function()? beforeReplace,
  }) async {
    // 1. 下载 manifest
    onProgress?.call(const CloudBackupProgress(phase: '检查云端数据...'));
    final json = await client.downloadJson(
      '/$_kexiaojiDir/cloud-manifest.json',
    );
    final manifest = CloudManifest.fromJson(json);

    // 2. 校验 schema 版本
    if (manifest.schemaVersion > _database.schemaVersion) {
      return CloudBackupSchemaMismatch(manifest.schemaVersion);
    }

    // 3. 计算差异（按路径对比）
    final localFiles = await _scanLocalFiles();
    final remoteFiles = manifest.files;
    final toDownload = <String>[];
    final toDelete = <String>[];

    for (final entry in remoteFiles.entries) {
      if (!localFiles.containsKey(entry.key)) {
        toDownload.add(entry.key);
      }
    }

    // 本地多余文件
    final attachmentsDir = await _attachmentFileService
        .getAttachmentsDirectory();
    final avatarsDir = await _avatarFileService.getAvatarsDirectory();
    final localFileSet = await _scanLocalFileRelativePaths();

    for (final localPath in localFileSet) {
      if (!remoteFiles.containsKey(localPath)) {
        toDelete.add(localPath);
      }
    }

    // 4. 下载到临时目录
    final tempDir = await _getTempDir();
    try {
      if (toDownload.isNotEmpty) {
        onProgress?.call(
          CloudBackupProgress(phase: '下载文件', total: toDownload.length),
        );

        for (var i = 0; i < toDownload.length; i++) {
          final remotePath = toDownload[i];
          onProgress?.call(
            CloudBackupProgress(
              phase: '下载文件',
              current: i,
              total: toDownload.length,
              currentFile: remotePath,
            ),
          );

          final localPath = p.join(tempDir.path, remotePath);
          await client.downloadToFile(
            '/$_kexiaojiDir/$_filesDir/$remotePath',
            localPath,
          );
        }
      }

      // 5. 下载数据库
      onProgress?.call(const CloudBackupProgress(phase: '下载数据库...'));
      final tempDbPath = p.join(tempDir.path, 'database.db');
      await client.downloadToFile('/$_kexiaojiDir/database.db', tempDbPath);

      // 校验数据库 SHA256
      final dbBytes = await File(tempDbPath).readAsBytes();
      final dbHash = sha256.convert(dbBytes).toString();
      if (dbHash != manifest.databaseSha256) {
        return const CloudBackupChecksumError('数据库校验失败');
      }

      // 6. 回调：让调用方做恢复前操作（自动本地备份）
      await beforeReplace?.call();

      // 7. 替换文件
      onProgress?.call(const CloudBackupProgress(phase: '恢复数据...'));

      // 替换附件/头像
      for (final remotePath in toDownload) {
        final srcPath = p.join(tempDir.path, remotePath);
        String targetDir;
        String relativePath;
        if (remotePath.startsWith('attachments/')) {
          targetDir = attachmentsDir.path;
          relativePath = remotePath.substring('attachments/'.length);
        } else {
          targetDir = avatarsDir.path;
          relativePath = remotePath.substring('avatars/'.length);
        }
        final destPath = p.join(targetDir, relativePath);
        await File(destPath).parent.create(recursive: true);
        await File(srcPath).copy(destPath);
      }

      // 删除本地多余文件
      for (final localPath in toDelete) {
        String basePath;
        String relativePath;
        if (localPath.startsWith('attachments/')) {
          basePath = attachmentsDir.path;
          relativePath = localPath.substring('attachments/'.length);
        } else {
          basePath = avatarsDir.path;
          relativePath = localPath.substring('avatars/'.length);
        }
        final file = File(p.join(basePath, relativePath));
        if (await file.exists()) {
          await file.delete();
        }
      }

      // 替换数据库
      await _database.close();
      await _fileStore.replaceDatabase(
        File(await AppDatabase.getDatabasePath()),
        File(tempDbPath),
      );

      return CloudBackupSuccess(manifest);
    } finally {
      if (await tempDir.exists()) {
        try {
          await tempDir.delete(recursive: true);
        } catch (_) {}
      }
    }
  }

  /// 转移设备绑定。
  Future<void> transferDeviceLock(
    WebDavClient client,
    String deviceId,
    String deviceName,
  ) async {
    final lock = DeviceLock(
      deviceId: deviceId,
      deviceName: deviceName,
      lockedAt: DateTime.now(),
    );
    await client.uploadJson('/$_kexiaojiDir/device-lock.json', lock.toJson());
  }

  // === 私有方法 ===

  Future<Directory> _getTempDir() async {
    final temp = await getTemporaryDirectory();
    final dir = Directory(
      p.join(
        temp.path,
        'cloud_restore_${DateTime.now().millisecondsSinceEpoch}',
      ),
    );
    await dir.create(recursive: true);
    return dir;
  }

  Future<Map<String, _LocalFileEntry>> _scanLocalFiles() async {
    final result = <String, _LocalFileEntry>{};

    final attachmentsDir = await _attachmentFileService
        .getAttachmentsDirectory();
    await _scanDirectory(
      directory: attachmentsDir,
      prefix: 'attachments',
      result: result,
    );

    final avatarsDir = await _avatarFileService.getAvatarsDirectory();
    await _scanDirectory(
      directory: avatarsDir,
      prefix: 'avatars',
      result: result,
    );

    return result;
  }

  Future<void> _scanDirectory({
    required Directory directory,
    required String prefix,
    required Map<String, _LocalFileEntry> result,
  }) async {
    if (!await directory.exists()) return;

    await for (final entity in directory.list(recursive: true)) {
      if (entity is File) {
        final relative = p.relative(entity.path, from: directory.path);
        final key = '$prefix/${relative.replaceAll('\\', '/')}';
        final stat = await entity.stat();
        result[key] = _LocalFileEntry(
          absolutePath: entity.path,
          fileSize: stat.size,
        );
      }
    }
  }

  Future<Set<String>> _scanLocalFileRelativePaths() async {
    final result = <String>{};

    final attachmentsDir = await _attachmentFileService
        .getAttachmentsDirectory();
    if (await attachmentsDir.exists()) {
      await for (final entity in attachmentsDir.list(recursive: true)) {
        if (entity is File) {
          final relative = p.relative(entity.path, from: attachmentsDir.path);
          result.add('attachments/${relative.replaceAll('\\', '/')}');
        }
      }
    }

    final avatarsDir = await _avatarFileService.getAvatarsDirectory();
    if (await avatarsDir.exists()) {
      await for (final entity in avatarsDir.list(recursive: true)) {
        if (entity is File) {
          final relative = p.relative(entity.path, from: avatarsDir.path);
          result.add('avatars/${relative.replaceAll('\\', '/')}');
        }
      }
    }

    return result;
  }
}

/// 云端备份/恢复操作结果。
sealed class CloudBackupResult {
  const CloudBackupResult();
}

class CloudBackupSuccess extends CloudBackupResult {
  final CloudManifest manifest;
  const CloudBackupSuccess(this.manifest);
}

class CloudBackupDeviceLocked extends CloudBackupResult {
  final DeviceLock existingLock;
  const CloudBackupDeviceLocked(this.existingLock);
}

class CloudBackupSchemaMismatch extends CloudBackupResult {
  final int requiredVersion;
  const CloudBackupSchemaMismatch(this.requiredVersion);
}

class CloudBackupChecksumError extends CloudBackupResult {
  final String message;
  const CloudBackupChecksumError(this.message);
}

class CloudBackupError extends CloudBackupResult {
  final String message;
  const CloudBackupError(this.message);
}
