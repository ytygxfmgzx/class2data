import 'dart:async';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:share_plus/share_plus.dart' show Share, XFile;

import '../../../data/files/backup_file_store.dart' show BackupFileInfo;
import '../../../shared/utils/file_utils.dart';
import '../providers/backup_providers.dart';

class BackupPage extends ConsumerStatefulWidget {
  const BackupPage({super.key});

  @override
  ConsumerState<BackupPage> createState() => _BackupPageState();
}

class _BackupPageState extends ConsumerState<BackupPage>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(backupNotifierProvider.notifier).loadLatestBackup();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      ref.read(backupNotifierProvider.notifier).loadLatestBackup();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(backupNotifierProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('本地备份与恢复')),
      body: ListView(
        children: [
          // 备份区域
          Container(
            color: Theme.of(context).colorScheme.surface,
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.only(top: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('备份', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                Text(
                  '将所有数据导出为文件，建议每月备份一次。',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: state.status == BackupStatus.creating
                        ? null
                        : () => ref
                              .read(backupNotifierProvider.notifier)
                              .createBackup(),
                    child: state.status == BackupStatus.creating
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text('立即备份'),
                  ),
                ),
                // 刚备份完：显示成功卡片
                if (state.status == BackupStatus.created &&
                    state.filePath != null) ...[
                  const SizedBox(height: 12),
                  _BackupSuccessCard(state: state),
                ],
                // 非备份中/成功状态 + 有历史备份：显示最近备份
                if (state.status != BackupStatus.created &&
                    state.status != BackupStatus.creating &&
                    state.latestBackup != null) ...[
                  const SizedBox(height: 12),
                  _LatestBackupCard(info: state.latestBackup!),
                ],
              ],
            ),
          ),
          // 恢复区域
          Container(
            color: Theme.of(context).colorScheme.surface,
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.only(top: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('恢复', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                Text(
                  '从备份文件恢复数据，将覆盖当前数据。',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: _RestoreButton(state: state),
                ),
                if (state.status == BackupStatus.validated &&
                    state.validationInfo != null) ...[
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Theme.of(
                        context,
                      ).colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '备份信息',
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          state.validationInfo!,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: _ConfirmRestoreButton(onConfirm: _startRestore),
                  ),
                ],
              ],
            ),
          ),
          // 注意事项
          Container(
            color: const Color(0xFFFFF7E6),
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.only(top: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '注意事项',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: const Color(0xFFFA8C16),
                  ),
                ),
                const SizedBox(height: 8),
                const _WarningItem('恢复会覆盖当前所有数据'),
                const _WarningItem('建议先备份当前数据再恢复'),
                const _WarningItem('备份文件包含所有孩子、课程和记录'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _startRestore() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('确认恢复'),
        content: const Text('恢复将覆盖当前所有数据（孩子、课程、课包、记录、附件等）。此操作不可撤销。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(ctx).colorScheme.error,
              foregroundColor: Theme.of(ctx).colorScheme.onError,
            ),
            child: const Text('确认恢复'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;

    // 显示恢复中 dialog（不 await，后面手动关闭）
    unawaited(
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => PopScope(
          canPop: false,
          child: Center(
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CircularProgressIndicator(),
                    const SizedBox(height: 16),
                    Text(
                      '正在恢复数据...',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );

    try {
      await ref.read(backupNotifierProvider.notifier).restoreBackup();
    } catch (_) {}

    if (!mounted) return;

    // 关闭恢复中 dialog
    Navigator.of(context, rootNavigator: true).pop();

    final state = ref.read(backupNotifierProvider);
    if (state.status == BackupStatus.restored) {
      // 恢复成功 dialog
      await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('恢复成功'),
          content: const Text('数据已恢复，请返回查看。'),
          actions: [
            FilledButton(
              onPressed: () {
                // 重建数据库连接，然后返回上一页
                ref.read(backupNotifierProvider.notifier).rebuildDatabase();
                Navigator.of(ctx).pop();
                Navigator.of(context).pop();
              },
              child: const Text('确定'),
            ),
          ],
        ),
      );
    } else if (state.status == BackupStatus.error) {
      // 恢复失败 dialog
      await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('恢复失败'),
          content: Text(state.errorMessage ?? '未知错误'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('确定'),
            ),
          ],
        ),
      );
    }
  }
}

class _WarningItem extends StatelessWidget {
  final String text;
  const _WarningItem(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(fontSize: 12)),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RestoreButton extends ConsumerStatefulWidget {
  final BackupState state;
  const _RestoreButton({required this.state});

  @override
  ConsumerState<_RestoreButton> createState() => _RestoreButtonState();
}

class _RestoreButtonState extends ConsumerState<_RestoreButton> {
  @override
  Widget build(BuildContext context) {
    final state = widget.state;
    return OutlinedButton(
      onPressed: state.status == BackupStatus.validating
          ? null
          : _pickBackupFile,
      child: state.status == BackupStatus.validating
          ? const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : const Text('选择备份文件'),
    );
  }

  Future<void> _pickBackupFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['zip'],
      dialogTitle: '选择备份文件',
    );
    if (result != null && result.files.single.path != null) {
      await ref
          .read(backupNotifierProvider.notifier)
          .validateBackup(result.files.single.path!);
    }
  }
}

class _ConfirmRestoreButton extends StatelessWidget {
  final VoidCallback onConfirm;
  const _ConfirmRestoreButton({required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: onConfirm,
      style: FilledButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.error,
        foregroundColor: Theme.of(context).colorScheme.onError,
      ),
      child: const Text('确认恢复'),
    );
  }
}

class _BackupSuccessCard extends ConsumerWidget {
  final BackupState state;
  const _BackupSuccessCard({required this.state});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fileName = p.basename(state.filePath!);
    final isAndroid = Platform.isAndroid;
    final isIOS = Platform.isIOS;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '备份成功',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(height: 8),
          Text(fileName, style: Theme.of(context).textTheme.bodySmall),
          if (state.fileSize != null) ...[
            const SizedBox(height: 2),
            Text(
              state.fileSize!,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
          if (isAndroid) ...[
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => _openBackupDir(context, ref),
                icon: const Icon(Icons.folder_open, size: 16),
                label: const Text('打开备份目录'),
              ),
            ),
          ],
          if (isIOS) ...[
            const SizedBox(height: 8),
            Text(
              '请在系统"文件"App 中查找：课小记 > kexiaoji > backup',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: () => _shareFile(context, state.filePath!),
            icon: const Icon(Icons.share, size: 16),
            label: const Text('分享备份文件'),
          ),
        ],
      ),
    );
  }
}

Future<void> _shareFile(BuildContext context, String filePath) async {
  final file = File(filePath);
  if (await file.exists()) {
    await Share.shareXFiles([XFile(filePath)]);
  }
}

Future<void> _openBackupDir(BuildContext context, WidgetRef ref) async {
  final success = await ref
      .read(backupNotifierProvider.notifier)
      .openBackupDirectory();
  if (!success && context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('备份目录: Download/kexiaoji/backup'),
        duration: Duration(seconds: 4),
      ),
    );
  }
}

class _LatestBackupCard extends ConsumerWidget {
  final BackupFileInfo info;
  const _LatestBackupCard({required this.info});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isAndroid = Platform.isAndroid;
    final isIOS = Platform.isIOS;
    final dateStr =
        '${info.modifiedTime.year}-'
        '${info.modifiedTime.month.toString().padLeft(2, '0')}-'
        '${info.modifiedTime.day.toString().padLeft(2, '0')} '
        '${info.modifiedTime.hour.toString().padLeft(2, '0')}:'
        '${info.modifiedTime.minute.toString().padLeft(2, '0')}';

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('最近一次备份文件', style: Theme.of(context).textTheme.labelLarge),
          const SizedBox(height: 8),
          Text(info.name, style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: 2),
          Text(
            '${formatFileSize(info.size)} · $dateStr',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          if (isAndroid) ...[
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => _openBackupDir(context, ref),
                icon: const Icon(Icons.folder_open, size: 16),
                label: const Text('打开备份目录'),
              ),
            ),
          ],
          if (isIOS) ...[
            const SizedBox(height: 8),
            Text(
              '请在系统"文件"App 中查找：课小记 > kexiaoji > backup',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
