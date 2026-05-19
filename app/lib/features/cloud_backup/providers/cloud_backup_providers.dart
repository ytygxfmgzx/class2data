import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/services/avatar_file_service.dart';
import '../../../domain/services/cloud_backup_service.dart';
import '../../../domain/services/cloud_manifest.dart';
import '../../../shared/providers/database_provider.dart';
import '../../attachments/providers/attachment_providers.dart';
import '../../backup/providers/backup_providers.dart';
import 'webdav_config_providers.dart';

final cloudBackupServiceProvider = Provider<CloudBackupService>((ref) {
  return CloudBackupService(
    database: ref.watch(databaseProvider),
    fileStore: ref.watch(backupFileStoreProvider),
    attachmentFileService: ref.watch(attachmentFileServiceProvider),
    avatarFileService: AvatarFileService.instance,
  );
});

enum CloudBackupStatus {
  idle,
  checkingRemote,
  uploading,
  downloading,
  restoring,
  completed,
  error,
  deviceLocked,
  schemaMismatch,
}

class CloudBackupState {
  final CloudBackupStatus status;
  final CloudBackupProgress? progress;
  final String? errorMessage;
  final CloudManifest? remoteManifest;
  final DeviceLock? deviceLock;
  final DateTime? lastSyncTime;
  final int filesToDownload;
  final int filesToUpload;

  const CloudBackupState({
    this.status = CloudBackupStatus.idle,
    this.progress,
    this.errorMessage,
    this.remoteManifest,
    this.deviceLock,
    this.lastSyncTime,
    this.filesToDownload = 0,
    this.filesToUpload = 0,
  });

  CloudBackupState copyWith({
    CloudBackupStatus? status,
    CloudBackupProgress? progress,
    bool clearProgress = false,
    String? errorMessage,
    bool clearErrorMessage = false,
    CloudManifest? remoteManifest,
    DeviceLock? deviceLock,
    DateTime? lastSyncTime,
    int? filesToDownload,
    int? filesToUpload,
  }) => CloudBackupState(
    status: status ?? this.status,
    progress: clearProgress ? null : (progress ?? this.progress),
    errorMessage: clearErrorMessage
        ? null
        : (errorMessage ?? this.errorMessage),
    remoteManifest: remoteManifest ?? this.remoteManifest,
    deviceLock: deviceLock ?? this.deviceLock,
    lastSyncTime: lastSyncTime ?? this.lastSyncTime,
    filesToDownload: filesToDownload ?? this.filesToDownload,
    filesToUpload: filesToUpload ?? this.filesToUpload,
  );
}

class CloudBackupNotifier extends StateNotifier<CloudBackupState> {
  final CloudBackupService _service;
  final Ref _ref;

  CloudBackupNotifier(this._service, this._ref)
    : super(const CloudBackupState());

  /// 检查远端状态。
  Future<void> checkRemote() async {
    state = const CloudBackupState(status: CloudBackupStatus.checkingRemote);
    try {
      final client = _ref.read(webDavClientProvider);
      if (client == null) {
        state = const CloudBackupState(
          status: CloudBackupStatus.error,
          errorMessage: 'WebDAV 未配置',
        );
        return;
      }

      final manifest = await _service.checkRemote(client);
      final lock = await _service.getDeviceLock(client);

      // 远端无数据时，清掉本地残留的同步时间
      if (manifest == null) {
        await _ref.read(webDavConfigProvider.notifier).clearLastSyncTime();
      }

      // 计算本地与云端的文件差异
      int filesToDownload = 0;
      int filesToUpload = 0;
      if (manifest != null) {
        final diff = await _service.computeSyncDiff(manifest);
        filesToDownload = diff.toDownload;
        filesToUpload = diff.toUpload;
      }

      state = CloudBackupState(
        status: CloudBackupStatus.idle,
        remoteManifest: manifest,
        deviceLock: lock,
        lastSyncTime: manifest != null
            ? _ref.read(webDavConfigProvider).lastSyncTime
            : null,
        filesToDownload: filesToDownload,
        filesToUpload: filesToUpload,
      );
    } catch (e) {
      state = CloudBackupState(
        status: CloudBackupStatus.error,
        errorMessage: '检查远端失败: $e',
      );
    }
  }

  /// 备份到云端。
  Future<void> backupToCloud() async {
    final config = _ref.read(webDavConfigProvider);
    final client = _ref.read(webDavClientProvider);
    if (client == null || config.deviceId == null) {
      state = const CloudBackupState(
        status: CloudBackupStatus.error,
        errorMessage: 'WebDAV 未配置',
      );
      return;
    }

    state = const CloudBackupState(status: CloudBackupStatus.uploading);
    try {
      final result = await _service.backupToCloud(
        client,
        config.deviceId!,
        config.deviceName ?? '未知设备',
        onProgress: (p) => state = state.copyWith(progress: p),
      );

      switch (result) {
        case CloudBackupSuccess(:final manifest):
          await _ref
              .read(webDavConfigProvider.notifier)
              .saveLastSyncTime(DateTime.now());
          await _ref
              .read(webDavConfigProvider.notifier)
              .saveLastSeenVersion(manifest.version);
          state = CloudBackupState(
            status: CloudBackupStatus.completed,
            remoteManifest: manifest,
            deviceLock: DeviceLock(
              deviceId: manifest.deviceId,
              deviceName: manifest.deviceName,
              lockedAt: manifest.lastModifiedTime,
            ),
          );
        case CloudBackupDeviceLocked(:final existingLock):
          state = CloudBackupState(
            status: CloudBackupStatus.deviceLocked,
            deviceLock: existingLock,
          );
        case CloudBackupSchemaMismatch(:final requiredVersion):
          state = CloudBackupState(
            status: CloudBackupStatus.schemaMismatch,
            errorMessage: '需要数据库版本 $requiredVersion，请更新 App',
          );
        case CloudBackupError(:final message):
          state = CloudBackupState(
            status: CloudBackupStatus.error,
            errorMessage: message,
          );
        case CloudBackupChecksumError(:final message):
          state = CloudBackupState(
            status: CloudBackupStatus.error,
            errorMessage: message,
          );
      }
    } catch (e) {
      state = CloudBackupState(
        status: CloudBackupStatus.error,
        errorMessage: '备份失败: $e',
      );
    }
  }

  /// 转移设备绑定。
  Future<void> transferDeviceLock() async {
    final config = _ref.read(webDavConfigProvider);
    final client = _ref.read(webDavClientProvider);
    if (client == null || config.deviceId == null) return;

    try {
      await _service.transferDeviceLock(
        client,
        config.deviceId!,
        config.deviceName ?? '未知设备',
      );
      // 转移后重新检查远端状态
      await checkRemote();
    } catch (e) {
      state = CloudBackupState(
        status: CloudBackupStatus.error,
        errorMessage: '转移绑定失败: $e',
      );
    }
  }

  /// 从云端恢复。
  Future<void> restoreFromCloud() async {
    final client = _ref.read(webDavClientProvider);
    if (client == null) {
      state = const CloudBackupState(
        status: CloudBackupStatus.error,
        errorMessage: 'WebDAV 未配置',
      );
      return;
    }

    state = state.copyWith(status: CloudBackupStatus.downloading);
    try {
      final result = await _service.restoreFromCloud(
        client,
        onProgress: (p) => state = state.copyWith(progress: p),
        beforeReplace: () async {
          // 自动创建本地备份
          await _ref.read(backupNotifierProvider.notifier).createBackup();
        },
      );

      switch (result) {
        case CloudBackupSuccess(:final manifest):
          await _ref
              .read(webDavConfigProvider.notifier)
              .saveLastSeenVersion(manifest.version);
          await _ref
              .read(webDavConfigProvider.notifier)
              .saveLastSyncTime(DateTime.now());
          state = CloudBackupState(
            status: CloudBackupStatus.completed,
            remoteManifest: manifest,
            deviceLock: DeviceLock(
              deviceId: manifest.deviceId,
              deviceName: manifest.deviceName,
              lockedAt: manifest.lastModifiedTime,
            ),
          );
        case CloudBackupSchemaMismatch(:final requiredVersion):
          state = state.copyWith(
            status: CloudBackupStatus.schemaMismatch,
            errorMessage: '需要数据库版本 $requiredVersion，请更新 App',
          );
        case CloudBackupChecksumError(:final message):
          state = state.copyWith(
            status: CloudBackupStatus.error,
            errorMessage: message,
          );
        case CloudBackupError(:final message):
          state = state.copyWith(
            status: CloudBackupStatus.error,
            errorMessage: message,
          );
        case CloudBackupDeviceLocked():
          // 恢复不需要设备绑定
          break;
      }
    } catch (e) {
      state = state.copyWith(
        status: CloudBackupStatus.error,
        errorMessage: '恢复失败: $e',
      );
    }
  }

  /// 重置状态。
  void reset() {
    state = const CloudBackupState();
  }
}

final cloudBackupNotifierProvider =
    StateNotifierProvider<CloudBackupNotifier, CloudBackupState>((ref) {
      return CloudBackupNotifier(ref.watch(cloudBackupServiceProvider), ref);
    });
