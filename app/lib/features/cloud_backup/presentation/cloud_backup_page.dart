import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../domain/services/cloud_backup_service.dart';
import '../../../shared/providers/database_provider.dart';
import '../providers/cloud_backup_providers.dart';
import '../providers/webdav_config_providers.dart';

class CloudBackupPage extends ConsumerStatefulWidget {
  const CloudBackupPage({super.key});

  @override
  ConsumerState<CloudBackupPage> createState() => _CloudBackupPageState();
}

class _CloudBackupPageState extends ConsumerState<CloudBackupPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(cloudBackupNotifierProvider.notifier).checkRemote();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(cloudBackupNotifierProvider);
    final config = ref.watch(webDavConfigProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('云端备份与恢复')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _StatusCard(state: state, config: config),
          const SizedBox(height: 16),
          _ActionsCard(
            state: state,
            config: config,
            onBackup: _handleBackup,
            onRestore: _handleRestore,
            onTransfer: _handleTransfer,
          ),
          const SizedBox(height: 16),
          _ServerInfoCard(config: config),
        ],
      ),
    );
  }

  Future<void> _handleBackup() async {
    final notifier = ref.read(cloudBackupNotifierProvider.notifier);

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('备份到云端'),
        content: const Text('将当前设备的数据上传到云端。已有文件将增量更新。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('确认'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    await notifier.backupToCloud();

    if (!mounted) return;
    final state = ref.read(cloudBackupNotifierProvider);
    if (state.status == CloudBackupStatus.completed) {
      _showSnackBar('备份成功');
    } else if (state.status == CloudBackupStatus.error) {
      _showSnackBar(state.errorMessage ?? '备份失败', isError: true);
    }
  }

  Future<void> _handleRestore() async {
    final state = ref.read(cloudBackupNotifierProvider);
    if (state.remoteManifest == null) {
      _showSnackBar('云端暂无数据', isError: true);
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('从云端恢复'),
        content: const Text(
          '恢复将用云端数据替换本设备数据。\n\n'
          '恢复前会自动创建本地备份，以防万一。\n\n'
          '是否继续？',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('确认恢复'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    await ref.read(cloudBackupNotifierProvider.notifier).restoreFromCloud();

    if (!mounted) return;
    final newState = ref.read(cloudBackupNotifierProvider);
    if (newState.status == CloudBackupStatus.completed) {
      ref.invalidate(databaseProvider);
      _showSnackBar('恢复成功，请返回查看最新数据');
    } else if (newState.status == CloudBackupStatus.error) {
      _showSnackBar(newState.errorMessage ?? '恢复失败', isError: true);
    }
  }

  Future<void> _handleTransfer() async {
    final state = ref.read(cloudBackupNotifierProvider);
    if (state.deviceLock == null) return;

    final config = ref.read(webDavConfigProvider);
    final currentDeviceName = config.deviceName ?? '当前设备';

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('转移设备绑定'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('已绑定：${state.deviceLock!.deviceName}'),
            Text('绑定时间：${_formatDateTime(state.deviceLock!.lockedAt)}'),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Theme.of(
                  ctx,
                ).colorScheme.errorContainer.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '请注意：',
                    style: TextStyle(
                      color: Theme.of(ctx).colorScheme.error,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    '· 请先"从云端恢复"或"本地备份"当前设备的数据\n'
                    '· 转移后原设备将无法备份到此云端',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Text('是否将绑定转移至 $currentDeviceName？'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('确认转移'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    await ref.read(cloudBackupNotifierProvider.notifier).transferDeviceLock();

    if (!mounted) return;
    _showSnackBar('绑定已转移，可先恢复云端数据再备份');
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Theme.of(context).colorScheme.error : null,
      ),
    );
  }

  String _formatDateTime(DateTime dt) {
    return '${dt.year}-${dt.month.toString().padLeft(2, '0')}'
        '-${dt.day.toString().padLeft(2, '0')} '
        '${dt.hour.toString().padLeft(2, '0')}'
        ':${dt.minute.toString().padLeft(2, '0')}';
  }
}

class _StatusCard extends StatelessWidget {
  final CloudBackupState state;
  final WebDavConfig config;

  const _StatusCard({required this.state, required this.config});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('状态', style: theme.textTheme.titleMedium),
            const SizedBox(height: 12),

            // 绑定状态
            if (state.deviceLock != null)
              _StatusRow(
                icon: Icons.lock,
                label: '云端绑定',
                value: state.deviceLock!.deviceName,
              )
            else if (state.remoteManifest != null)
              const _StatusRow(
                icon: Icons.lock_open,
                label: '云端绑定',
                value: '未绑定（可备份）',
              ),

            // 上次同步时间（仅远端有数据时显示）
            if (state.remoteManifest != null && config.lastSyncTime != null)
              _StatusRow(
                icon: Icons.schedule,
                label: '上次同步',
                value: _formatDateTime(config.lastSyncTime!),
              ),

            // 远端状态
            if (state.status == CloudBackupStatus.checkingRemote)
              const Row(
                children: [
                  SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  SizedBox(width: 8),
                  Text('正在检查云端...'),
                ],
              )
            else if (state.remoteManifest != null) ...[
              if (state.filesToDownload > 0)
                _StatusRow(
                  icon: Icons.cloud_download_outlined,
                  label: '云端有新数据',
                  value: '${state.filesToDownload} 个文件',
                  valueColor: theme.colorScheme.primary,
                ),
              if (state.filesToUpload > 0)
                _StatusRow(
                  icon: Icons.cloud_upload_outlined,
                  label: '本地有新数据',
                  value: '${state.filesToUpload} 个文件',
                  valueColor: theme.colorScheme.tertiary,
                ),
              if (state.filesToDownload == 0 && state.filesToUpload == 0)
                const _StatusRow(
                  icon: Icons.cloud_done,
                  label: '同步状态',
                  value: '本地与云端文件已一致',
                ),
            ] else if (state.status == CloudBackupStatus.idle)
              const _StatusRow(
                icon: Icons.cloud_off,
                label: '云端状态',
                value: '云端还没有备份过数据',
              ),

            // 进度
            if (state.progress != null &&
                (state.status == CloudBackupStatus.uploading ||
                    state.status == CloudBackupStatus.downloading)) ...[
              const SizedBox(height: 12),
              _ProgressIndicator(progress: state.progress!),
            ],
          ],
        ),
      ),
    );
  }

  String _formatDateTime(DateTime dt) {
    return '${dt.year}-${dt.month.toString().padLeft(2, '0')}'
        '-${dt.day.toString().padLeft(2, '0')} '
        '${dt.hour.toString().padLeft(2, '0')}'
        ':${dt.minute.toString().padLeft(2, '0')}';
  }
}

class _StatusRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;

  const _StatusRow({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveColor = valueColor ?? theme.colorScheme.onSurface;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 18, color: effectiveColor),
          const SizedBox(width: 8),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(color: effectiveColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              value,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: effectiveColor,
                fontWeight: valueColor != null
                    ? FontWeight.bold
                    : FontWeight.normal,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProgressIndicator extends StatelessWidget {
  final CloudBackupProgress progress;

  const _ProgressIndicator({required this.progress});

  @override
  Widget build(BuildContext context) {
    final progressValue = progress.total > 0
        ? progress.current / progress.total
        : 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LinearProgressIndicator(value: progressValue),
        const SizedBox(height: 4),
        Text(
          '${progress.phase}'
          '${progress.total > 0 ? ' (${progress.current}/${progress.total})' : ''}'
          '${progress.currentFile != null ? '\n${progress.currentFile}' : ''}',
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}

class _ActionsCard extends StatelessWidget {
  final CloudBackupState state;
  final WebDavConfig config;
  final VoidCallback onBackup;
  final VoidCallback onRestore;
  final VoidCallback onTransfer;

  const _ActionsCard({
    required this.state,
    required this.config,
    required this.onBackup,
    required this.onRestore,
    required this.onTransfer,
  });

  bool get _isBusy =>
      state.status == CloudBackupStatus.uploading ||
      state.status == CloudBackupStatus.downloading ||
      state.status == CloudBackupStatus.checkingRemote;

  bool get _isDeviceLocked {
    if (state.deviceLock == null) return false;
    return state.deviceLock!.deviceId != config.deviceId;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('操作', style: theme.textTheme.titleMedium),
            const SizedBox(height: 12),

            // 备份到云端
            if (_isDeviceLocked) ...[
              // 设备绑定不匹配
              SizedBox(
                width: double.infinity,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.errorContainer.withValues(
                      alpha: 0.3,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '此云端已绑定：${state.deviceLock!.deviceName}',
                        style: theme.textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton.tonal(
                          onPressed: _isBusy ? null : onTransfer,
                          child: const Text('转移绑定到此设备'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ] else ...[
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _isBusy ? null : onBackup,
                  child: _isBusy && state.status == CloudBackupStatus.uploading
                      ? const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(width: 8),
                            Text('备份中...'),
                          ],
                        )
                      : const Text('备份到云端'),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '备份将上传当前设备的数据到云端',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],

            const SizedBox(height: 16),

            // 从云端恢复
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: _isBusy ? null : onRestore,
                child: _isBusy && state.status == CloudBackupStatus.downloading
                    ? const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                          SizedBox(width: 8),
                          Text('恢复中...'),
                        ],
                      )
                    : const Text('从云端恢复'),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '恢复将用云端数据替换本设备数据，恢复前自动创建本地备份',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ServerInfoCard extends StatelessWidget {
  final WebDavConfig config;

  const _ServerInfoCard({required this.config});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('服务器', style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Icons.cloud_outlined,
                  size: 18,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    config.serverUrl ?? '',
                    style: theme.textTheme.bodySmall,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => context.push('/cloud-backup/config'),
                child: const Text('修改配置'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
