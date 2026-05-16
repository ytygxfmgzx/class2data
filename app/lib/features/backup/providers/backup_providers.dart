import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/database/daos/export_dao.dart';
import '../../../data/files/backup_file_store.dart';
import '../../../domain/services/backup_service.dart';
import '../../../shared/providers/database_provider.dart';
import '../../attachments/providers/attachment_providers.dart';

final backupFileStoreProvider = Provider<BackupFileStore>((ref) {
  return BackupFileStore();
});

final backupServiceProvider = Provider<BackupService>((ref) {
  return BackupService(
    database: ref.watch(databaseProvider),
    fileStore: ref.watch(backupFileStoreProvider),
    attachmentFileService: ref.watch(attachmentFileServiceProvider),
  );
});

final exportDaoProvider = Provider<ExportDao>((ref) {
  final db = ref.watch(databaseProvider);
  return ExportDao(db);
});

/// 备份/恢复状态。
enum BackupStatus {
  idle,
  creating,
  created,
  selectingFile,
  validating,
  validated,
  restoring,
  restored,
  exporting,
  exported,
  error,
}

class BackupState {
  final BackupStatus status;
  final String? filePath;
  final String? errorMessage;
  final String? validationInfo;

  const BackupState({
    this.status = BackupStatus.idle,
    this.filePath,
    this.errorMessage,
    this.validationInfo,
  });

  BackupState copyWith({
    BackupStatus? status,
    String? filePath,
    String? errorMessage,
    String? validationInfo,
  }) => BackupState(
    status: status ?? this.status,
    filePath: filePath ?? this.filePath,
    errorMessage: errorMessage ?? this.errorMessage,
    validationInfo: validationInfo ?? this.validationInfo,
  );
}

class BackupNotifier extends StateNotifier<BackupState> {
  final BackupService _backupService;
  final ExportDao _exportDao;
  final Ref _ref;

  BackupNotifier(this._backupService, this._exportDao, this._ref)
    : super(const BackupState());

  /// 创建备份。
  Future<void> createBackup() async {
    state = const BackupState(status: BackupStatus.creating);
    try {
      final zipPath = await _backupService.createBackup();
      state = BackupState(status: BackupStatus.created, filePath: zipPath);
    } catch (e) {
      state = BackupState(status: BackupStatus.error, errorMessage: '备份失败: $e');
    }
  }

  /// 校验备份文件。
  Future<void> validateBackup(String zipPath) async {
    state = const BackupState(status: BackupStatus.validating);
    try {
      final result = await _backupService.validateBackup(zipPath);
      if (result.isValid && result.manifest != null) {
        final m = result.manifest!;
        final info = StringBuffer();
        info.writeln('导出时间: ${_formatDateTime(m.exportTime)}');
        info.writeln('App 版本: ${m.appVersion}');
        info.writeln('数据库版本: ${m.schemaVersion}');
        info.writeln('附件数量: ${m.attachmentCount}');
        state = BackupState(
          status: BackupStatus.validated,
          filePath: zipPath,
          validationInfo: info.toString().trimRight(),
        );
      } else {
        state = BackupState(
          status: BackupStatus.error,
          errorMessage: result.errorMessage ?? '校验失败',
        );
      }
    } catch (e) {
      state = BackupState(status: BackupStatus.error, errorMessage: '校验失败: $e');
    }
  }

  /// 执行恢复。
  Future<void> restoreBackup() async {
    if (state.filePath == null) return;

    state = BackupState(
      status: BackupStatus.restoring,
      filePath: state.filePath,
    );
    try {
      await _backupService.restoreBackup(
        state.filePath!,
        onDatabaseClosed: () async {
          // invalidate 数据库 provider，下次访问时自动重建
          _ref.invalidate(databaseProvider);
        },
      );
      state = const BackupState(status: BackupStatus.restored);
    } catch (e) {
      state = BackupState(status: BackupStatus.error, errorMessage: '恢复失败: $e');
    }
  }

  /// 导出 JSON。
  Future<void> exportJson() async {
    state = const BackupState(status: BackupStatus.exporting);
    try {
      final path = await _backupService.exportAllJson(_exportDao);
      state = BackupState(status: BackupStatus.exported, filePath: path);
    } catch (e) {
      state = BackupState(status: BackupStatus.error, errorMessage: '导出失败: $e');
    }
  }

  /// 导出 CSV。
  Future<void> exportCsv() async {
    state = const BackupState(status: BackupStatus.exporting);
    try {
      final path = await _backupService.exportAllCsv(_exportDao);
      state = BackupState(status: BackupStatus.exported, filePath: path);
    } catch (e) {
      state = BackupState(status: BackupStatus.error, errorMessage: '导出失败: $e');
    }
  }

  /// 重置状态。
  void reset() {
    state = const BackupState();
  }

  String _formatDateTime(DateTime dt) {
    return '${dt.year}-${dt.month.toString().padLeft(2, '0')}'
        '-${dt.day.toString().padLeft(2, '0')} '
        '${dt.hour.toString().padLeft(2, '0')}'
        ':${dt.minute.toString().padLeft(2, '0')}';
  }
}

final backupNotifierProvider =
    StateNotifierProvider<BackupNotifier, BackupState>((ref) {
      return BackupNotifier(
        ref.watch(backupServiceProvider),
        ref.watch(exportDaoProvider),
        ref,
      );
    });
