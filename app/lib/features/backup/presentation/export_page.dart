import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart' show Share, XFile;

import '../providers/backup_providers.dart';

class ExportPage extends ConsumerWidget {
  const ExportPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(backupNotifierProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('导出数据')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _ExportCard(
            title: 'JSON 导出',
            description: '导出所有数据为 JSON 格式，适合数据备份和迁移。',
            icon: Icons.data_object,
            isLoading: state.status == BackupStatus.exporting,
            isSuccess: state.status == BackupStatus.exported,
            onExport: () =>
                ref.read(backupNotifierProvider.notifier).exportJson(),
            onShare: state.filePath != null
                ? () => _shareFile(state.filePath!)
                : null,
            onReset: () => ref.read(backupNotifierProvider.notifier).reset(),
          ),
          const SizedBox(height: 16),
          _ExportCard(
            title: 'CSV 导出',
            description: '导出所有数据为 CSV 表格格式（每张表一个文件），适合用 Excel 查看。',
            icon: Icons.table_chart,
            isLoading: state.status == BackupStatus.exporting,
            isSuccess: state.status == BackupStatus.exported,
            onExport: () =>
                ref.read(backupNotifierProvider.notifier).exportCsv(),
            onShare: state.filePath != null
                ? () => _shareFile(state.filePath!)
                : null,
            onReset: () => ref.read(backupNotifierProvider.notifier).reset(),
          ),
        ],
      ),
    );
  }
}

class _ExportCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final bool isLoading;
  final bool isSuccess;
  final VoidCallback onExport;
  final VoidCallback? onShare;
  final VoidCallback? onReset;

  const _ExportCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.isLoading,
    required this.isSuccess,
    required this.onExport,
    this.onShare,
    this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 24, color: theme.colorScheme.primary),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(title, style: theme.textTheme.titleMedium),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),
            if (isSuccess && onShare != null) ...[
              SizedBox(
                width: double.infinity,
                child: Row(
                  children: [
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: onShare,
                        icon: const Icon(Icons.share),
                        label: const Text('分享文件'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    if (onReset != null)
                      OutlinedButton(
                        onPressed: onReset,
                        child: const Text('完成'),
                      ),
                  ],
                ),
              ),
            ] else ...[
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: isLoading ? null : onExport,
                  icon: isLoading
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.download),
                  label: Text(isLoading ? '正在导出...' : '导出'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

Future<void> _shareFile(String filePath) async {
  final file = File(filePath);
  if (await file.exists()) {
    await Share.shareXFiles([XFile(filePath)]);
  }
}
