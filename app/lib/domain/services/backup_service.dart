import 'dart:convert';
import 'dart:io';

import 'package:archive/archive.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../data/database/app_database.dart';
import '../../data/database/daos/export_dao.dart';
import '../../data/files/backup_file_store.dart';
import 'attachment_file_service.dart';

/// 备份/恢复/导出业务服务。
class BackupService {
  final AppDatabase _database;
  final BackupFileStore _fileStore;
  final AttachmentFileService _attachmentFileService;

  BackupService({
    required AppDatabase database,
    required BackupFileStore fileStore,
    required AttachmentFileService attachmentFileService,
  }) : _database = database,
       _fileStore = fileStore,
       _attachmentFileService = attachmentFileService;

  /// 创建完整备份，返回 zip 文件路径。
  Future<String> createBackup() async {
    await _database.checkpoint();

    final dbPath = await AppDatabase.getDatabasePath();
    final dbFile = File(dbPath);
    if (!await dbFile.exists()) {
      throw Exception('数据库文件不存在');
    }

    final attachmentsDir = await _attachmentFileService
        .getAttachmentsDirectory();

    final attachmentFiles = <String>[];
    if (await attachmentsDir.exists()) {
      await for (final entity in attachmentsDir.list(recursive: true)) {
        if (entity is File) {
          final relative = p.relative(entity.path, from: attachmentsDir.path);
          attachmentFiles.add(relative.replaceAll('\\', '/'));
        }
      }
    }

    final manifest = BackupManifest(
      format: 'class2data-backup',
      formatVersion: 1,
      appVersion: '0.1.0+1',
      schemaVersion: _database.schemaVersion,
      exportTime: DateTime.now(),
      databaseFile: 'database/class2data.db',
      attachmentCount: attachmentFiles.length,
      attachmentFiles: attachmentFiles,
    );

    final outputPath = await _fileStore.getBackupOutputPath();
    await _fileStore.createBackupZip(
      dbFile: dbFile,
      attachmentsDir: attachmentsDir,
      manifest: manifest,
      outputPath: outputPath,
    );

    return outputPath;
  }

  /// 校验备份包。
  Future<BackupValidation> validateBackup(String zipPath) async {
    final extractDir = await _fileStore.getTempExtractDir();

    try {
      await _fileStore.extractBackupZip(zipPath, extractDir);
      return _fileStore.validateBackup(
        extractDir,
        currentSchemaVersion: _database.schemaVersion,
      );
    } catch (e) {
      return BackupValidation(isValid: false, errorMessage: '解压失败: $e');
    }
  }

  /// 执行恢复。
  ///
  /// [onDatabaseClosed] 关闭数据库后的回调，用于让 provider 层 invalidate。
  Future<void> restoreBackup(
    String zipPath, {
    required Future<void> Function() onDatabaseClosed,
  }) async {
    final extractDir = await _fileStore.getTempExtractDir();

    try {
      await _fileStore.extractBackupZip(zipPath, extractDir);

      final validation = await _fileStore.validateBackup(
        extractDir,
        currentSchemaVersion: _database.schemaVersion,
      );
      if (!validation.isValid) {
        throw Exception(validation.errorMessage);
      }

      final newDbFile = File(
        p.join(extractDir.path, validation.manifest!.databaseFile),
      );
      final newAttachmentsDir = Directory(
        p.join(extractDir.path, 'attachments'),
      );

      final currentDbPath = await AppDatabase.getDatabasePath();
      final currentDbFile = File(currentDbPath);
      final currentAttachmentsDir = await _attachmentFileService
          .getAttachmentsDirectory();

      await _database.close();
      await onDatabaseClosed();

      await _fileStore.replaceDatabase(currentDbFile, newDbFile);
      await _fileStore.replaceAttachments(
        currentAttachmentsDir,
        newAttachmentsDir,
      );
    } catch (e) {
      await onDatabaseClosed();
      rethrow;
    } finally {
      try {
        if (await extractDir.exists()) {
          await extractDir.delete(recursive: true);
        }
      } catch (_) {}
    }
  }

  /// 全量 JSON 导出，返回文件路径。
  Future<String> exportAllJson(ExportDao exportDao) async {
    final allData = await exportDao.exportAll();
    final jsonStr = const JsonEncoder.withIndent('  ').convert(allData);

    final now = DateTime.now();
    final timestamp =
        '${now.year}${now.month.toString().padLeft(2, '0')}'
        '${now.day.toString().padLeft(2, '0')}';
    final filename = 'class2data_export_$timestamp.json';

    final outputPath = await _fileStore.getExportPath(filename);
    await File(outputPath).writeAsString(jsonStr);
    return outputPath;
  }

  /// 全量 CSV 导出（每张表一个 CSV，打包为 zip），返回 zip 文件路径。
  Future<String> exportAllCsv(ExportDao exportDao) async {
    final allData = await exportDao.exportAll();

    final now = DateTime.now();
    final timestamp =
        '${now.year}${now.month.toString().padLeft(2, '0')}'
        '${now.day.toString().padLeft(2, '0')}';
    final baseName = 'class2data_export_$timestamp';

    final tempDir = await getTemporaryDirectory();
    final csvDir = Directory(p.join(tempDir.path, '${baseName}_csv'));
    if (await csvDir.exists()) {
      await csvDir.delete(recursive: true);
    }
    await csvDir.create(recursive: true);

    for (final entry in allData.entries) {
      if (entry.value.isEmpty) continue;
      final csvContent = _mapListToCsv(entry.value);
      final csvFile = File(p.join(csvDir.path, '${entry.key}.csv'));
      await csvFile.writeAsString(csvContent);
    }

    final zipPath = await _fileStore.getExportPath('$baseName.zip');
    final zipBytes = await _dirToZipBytes(csvDir);
    await File(zipPath).writeAsBytes(zipBytes);

    try {
      await csvDir.delete(recursive: true);
    } catch (_) {}

    return zipPath;
  }

  Future<List<int>> _dirToZipBytes(Directory dir) async {
    final archive = Archive();
    await _addDirToArchive(archive, dir, '');
    return ZipEncoder().encodeBytes(archive);
  }

  Future<void> _addDirToArchive(
    Archive archive,
    Directory dir,
    String prefix,
  ) async {
    await for (final entity in dir.list(recursive: false)) {
      final name = prefix.isEmpty
          ? p.basename(entity.path)
          : p.join(prefix, p.basename(entity.path));
      if (entity is File) {
        final bytes = await entity.readAsBytes();
        archive.addFile(ArchiveFile.bytes(name, bytes));
      } else if (entity is Directory) {
        await _addDirToArchive(archive, entity, name);
      }
    }
  }

  String _mapListToCsv(List<Map<String, dynamic>> data) {
    if (data.isEmpty) return '';

    final headers = data.first.keys.toList();
    final sb = StringBuffer();

    sb.writeln(headers.map(_csvEscape).join(','));

    for (final row in data) {
      sb.writeln(
        headers.map((h) => _csvEscape(row[h]?.toString() ?? '')).join(','),
      );
    }

    return sb.toString();
  }

  String _csvEscape(String value) {
    if (value.contains(',') || value.contains('"') || value.contains('\n')) {
      return '"${value.replaceAll('"', '""')}"';
    }
    return value;
  }
}
