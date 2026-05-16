import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart' show Share, XFile;

import '../providers/backup_providers.dart';

class BackupPage extends ConsumerWidget {
  const BackupPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(backupNotifierProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('备份与恢复')),
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
                if (state.status == BackupStatus.created &&
                    state.filePath != null) ...[
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    onPressed: () => _shareFile(context, state.filePath!),
                    icon: const Icon(Icons.share, size: 16),
                    label: const Text('分享备份文件'),
                  ),
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
                    child: _ConfirmRestoreButton(state: state),
                  ),
                ],
                if (state.status == BackupStatus.restored) ...[
                  const SizedBox(height: 12),
                  Text(
                    '恢复成功，数据已更新。',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                    ),
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

class _ConfirmRestoreButton extends ConsumerStatefulWidget {
  final BackupState state;
  const _ConfirmRestoreButton({required this.state});

  @override
  ConsumerState<_ConfirmRestoreButton> createState() =>
      _ConfirmRestoreButtonState();
}

class _ConfirmRestoreButtonState extends ConsumerState<_ConfirmRestoreButton> {
  @override
  Widget build(BuildContext context) {
    final state = widget.state;
    return FilledButton(
      onPressed: state.status == BackupStatus.restoring
          ? null
          : _confirmRestore,
      style: FilledButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.error,
        foregroundColor: Theme.of(context).colorScheme.onError,
      ),
      child: state.status == BackupStatus.restoring
          ? const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            )
          : const Text('确认恢复'),
    );
  }

  Future<void> _confirmRestore() async {
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
    if (confirmed == true) {
      await ref.read(backupNotifierProvider.notifier).restoreBackup();
    }
  }
}

Future<void> _shareFile(BuildContext context, String filePath) async {
  final file = File(filePath);
  if (await file.exists()) {
    await Share.shareXFiles([XFile(filePath)]);
  }
}
