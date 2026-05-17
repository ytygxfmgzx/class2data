import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// 备份 manifest 数据结构。
class BackupManifest {
  final String format;
  final int formatVersion;
  final String appVersion;
  final int schemaVersion;
  final DateTime exportTime;
  final String databaseFile;
  final int attachmentCount;
  final List<String> attachmentFiles;

  const BackupManifest({
    required this.format,
    required this.formatVersion,
    required this.appVersion,
    required this.schemaVersion,
    required this.exportTime,
    required this.databaseFile,
    required this.attachmentCount,
    required this.attachmentFiles,
  });

  factory BackupManifest.fromJson(Map<String, dynamic> json) {
    return BackupManifest(
      format: json['format'] as String,
      formatVersion: json['formatVersion'] as int,
      appVersion: json['appVersion'] as String,
      schemaVersion: json['schemaVersion'] as int,
      exportTime: DateTime.parse(json['exportTime'] as String),
      databaseFile: json['databaseFile'] as String,
      attachmentCount: json['attachmentCount'] as int,
      attachmentFiles: List<String>.from(json['attachmentFiles'] as List),
    );
  }

  Map<String, dynamic> toJson() => {
    'format': format,
    'formatVersion': formatVersion,
    'appVersion': appVersion,
    'schemaVersion': schemaVersion,
    'exportTime': exportTime.toUtc().toIso8601String(),
    'databaseFile': databaseFile,
    'attachmentCount': attachmentCount,
    'attachmentFiles': attachmentFiles,
  };
}

/// 备份校验结果。
class BackupValidation {
  final bool isValid;
  final BackupManifest? manifest;
  final String? errorMessage;

  const BackupValidation({
    required this.isValid,
    this.manifest,
    this.errorMessage,
  });
}

/// 备份文件操作层。
///
/// 负责 zip 打包/解包、manifest 读写和文件系统操作。
class BackupFileStore {
  static const _backupDirName = 'backup_temp';

  /// 获取临时解压目录。
  Future<Directory> getTempExtractDir() async {
    final tempDir = await getTemporaryDirectory();
    final dir = Directory(p.join(tempDir.path, _backupDirName));
    if (await dir.exists()) {
      await dir.delete(recursive: true);
    }
    await dir.create(recursive: true);
    return dir;
  }

  /// 创建备份 zip。
  Future<void> createBackupZip({
    required File dbFile,
    required Directory attachmentsDir,
    required BackupManifest manifest,
    required String outputPath,
  }) async {
    final archive = Archive();

    // 添加 manifest
    final manifestBytes = utf8.encode(
      const JsonEncoder.withIndent('  ').convert(manifest.toJson()),
    );
    archive.addFile(
      ArchiveFile.bytes('manifest.json', Uint8List.fromList(manifestBytes)),
    );

    // 添加数据库文件
    final dbBytes = await dbFile.readAsBytes();
    archive.addFile(ArchiveFile.bytes(manifest.databaseFile, dbBytes));

    // 添加附件文件
    if (await attachmentsDir.exists()) {
      await _addDirectoryToArchive(archive, attachmentsDir, 'attachments');
    }

    // 编码为 zip 并写入文件
    final zipData = ZipEncoder().encodeBytes(archive);
    await File(outputPath).writeAsBytes(zipData);
  }

  /// 递归添加目录下所有文件到 archive。
  Future<void> _addDirectoryToArchive(
    Archive archive,
    Directory dir,
    String prefix,
  ) async {
    await for (final entity in dir.list(recursive: false)) {
      if (entity is File) {
        final relativeName = p.join(prefix, p.basename(entity.path));
        final bytes = await entity.readAsBytes();
        archive.addFile(ArchiveFile.bytes(relativeName, bytes));
      } else if (entity is Directory) {
        await _addDirectoryToArchive(
          archive,
          entity,
          p.join(prefix, p.basename(entity.path)),
        );
      }
    }
  }

  /// 解压备份 zip 到指定目录。
  Future<void> extractBackupZip(String zipPath, Directory targetDir) async {
    final bytes = await File(zipPath).readAsBytes();
    final archive = ZipDecoder().decodeBytes(bytes);

    for (final file in archive) {
      final filePath = p.join(targetDir.path, file.name);
      if (file.isFile) {
        final outFile = File(filePath);
        await outFile.parent.create(recursive: true);
        await outFile.writeAsBytes(file.content as List<int>);
      } else {
        await Directory(filePath).create(recursive: true);
      }
    }
  }

  /// 从解压目录读取 manifest。
  Future<BackupManifest> readManifest(Directory extractedDir) async {
    final manifestFile = File(p.join(extractedDir.path, 'manifest.json'));
    if (!await manifestFile.exists()) {
      throw const FileSystemException('manifest.json 不存在');
    }
    final content = await manifestFile.readAsString();
    final json = jsonDecode(content) as Map<String, dynamic>;
    return BackupManifest.fromJson(json);
  }

  /// 校验备份包完整性。
  Future<BackupValidation> validateBackup(
    Directory extractedDir, {
    required int currentSchemaVersion,
  }) async {
    try {
      final manifest = await readManifest(extractedDir);

      if (manifest.format != 'class2data-backup') {
        return const BackupValidation(
          isValid: false,
          errorMessage: '不是有效的课小记录备份文件',
        );
      }

      if (manifest.formatVersion > 1) {
        return BackupValidation(
          isValid: false,
          errorMessage: '备份格式版本 ${manifest.formatVersion} 不受支持',
        );
      }

      if (manifest.schemaVersion > currentSchemaVersion) {
        return BackupValidation(
          isValid: false,
          errorMessage:
              '备份的数据库版本 (${manifest.schemaVersion}) 高于当前版本 ($currentSchemaVersion)，请先更新 App',
        );
      }

      final dbFile = File(p.join(extractedDir.path, manifest.databaseFile));
      if (!await dbFile.exists()) {
        return const BackupValidation(
          isValid: false,
          errorMessage: '备份包中缺少数据库文件',
        );
      }

      for (final attachmentPath in manifest.attachmentFiles) {
        final file = File(
          p.join(extractedDir.path, 'attachments', attachmentPath),
        );
        if (!await file.exists()) {
          return BackupValidation(
            isValid: false,
            errorMessage: '备份包中缺少附件文件: $attachmentPath',
          );
        }
      }

      return BackupValidation(isValid: true, manifest: manifest);
    } on FileSystemException catch (e) {
      return BackupValidation(isValid: false, errorMessage: e.message);
    } on FormatException catch (e) {
      return BackupValidation(
        isValid: false,
        errorMessage: 'manifest 格式错误: ${e.message}',
      );
    } catch (e) {
      return BackupValidation(isValid: false, errorMessage: '校验失败: $e');
    }
  }

  /// 替换数据库文件。
  Future<void> replaceDatabase(File currentDbFile, File newDbFile) async {
    final backupPath = '${currentDbFile.path}.bak';
    final backupFile = File(backupPath);

    if (await currentDbFile.exists()) {
      await currentDbFile.copy(backupPath);
    }

    try {
      if (await currentDbFile.exists()) {
        await currentDbFile.delete();
      }
      await newDbFile.copy(currentDbFile.path);

      if (await backupFile.exists()) {
        await backupFile.delete();
      }
    } catch (e) {
      if (await backupFile.exists()) {
        await backupFile.copy(currentDbFile.path);
        await backupFile.delete();
      }
      rethrow;
    }
  }

  /// 替换附件目录。
  Future<void> replaceAttachments(
    Directory currentDir,
    Directory newDir,
  ) async {
    if (await currentDir.exists()) {
      await currentDir.delete(recursive: true);
    }

    await currentDir.parent.create(recursive: true);

    if (await newDir.exists()) {
      await _copyDirectory(newDir, currentDir);
    } else {
      await currentDir.create(recursive: true);
    }
  }

  Future<void> _copyDirectory(Directory source, Directory target) async {
    await target.create(recursive: true);
    await for (final entity in source.list(recursive: false)) {
      final newPath = p.join(target.path, p.basename(entity.path));
      if (entity is File) {
        await entity.copy(newPath);
      } else if (entity is Directory) {
        await _copyDirectory(entity, Directory(newPath));
      }
    }
  }

  /// 获取备份输出文件路径。
  Future<String> getBackupOutputPath() async {
    final tempDir = await getTemporaryDirectory();
    final now = DateTime.now();
    final timestamp =
        '${now.year}${now.month.toString().padLeft(2, '0')}'
        '${now.day.toString().padLeft(2, '0')}_'
        '${now.hour.toString().padLeft(2, '0')}'
        '${now.minute.toString().padLeft(2, '0')}'
        '${now.second.toString().padLeft(2, '0')}';
    return p.join(tempDir.path, 'class2data_backup_$timestamp.zip');
  }

  /// 获取导出文件路径。
  Future<String> getExportPath(String filename) async {
    final tempDir = await getTemporaryDirectory();
    return p.join(tempDir.path, filename);
  }
}
