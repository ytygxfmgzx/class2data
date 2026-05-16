import 'package:class2data/core/result/result.dart';
import 'package:class2data/data/database/app_database.dart';
import 'package:class2data/features/feedback/providers/feedback_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FeedbackPage extends ConsumerStatefulWidget {
  const FeedbackPage({super.key});

  @override
  ConsumerState<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends ConsumerState<FeedbackPage> {
  final _contentController = TextEditingController();
  final _contactController = TextEditingController();
  bool _isSubmitting = false;
  final Set<int> _retryingIds = {};

  @override
  void dispose() {
    _contentController.dispose();
    _contactController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final content = _contentController.text.trim();
    if (content.isEmpty) {
      _showMessage('请输入反馈内容');
      return;
    }

    setState(() => _isSubmitting = true);
    final result = await ref
        .read(feedbackServiceProvider)
        .submitFeedback(
          content: content,
          contact: _contactController.text.trim(),
        );
    if (!mounted) return;

    setState(() => _isSubmitting = false);
    switch (result) {
      case Ok():
        _contentController.clear();
        _contactController.clear();
        _showMessage('反馈已发送，感谢你的建议');
      case Err(:final error):
        _showMessage(error.message);
    }
  }

  Future<void> _retry(FeedbackEntry entry) async {
    setState(() => _retryingIds.add(entry.id));
    final result = await ref.read(feedbackServiceProvider).retryFeedback(entry);
    if (!mounted) return;

    setState(() => _retryingIds.remove(entry.id));
    switch (result) {
      case Ok():
        _showMessage('反馈已重新发送');
      case Err(:final error):
        _showMessage(error.message);
    }
  }

  Future<void> _delete(FeedbackEntry entry) async {
    final result = await ref
        .read(feedbackServiceProvider)
        .deleteFeedback(entry.id);
    if (!mounted) return;

    switch (result) {
      case Ok():
        _showMessage('已删除');
      case Err(:final error):
        _showMessage(error.message);
    }
  }

  void _showMessage(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  @override
  Widget build(BuildContext context) {
    final entriesAsync = ref.watch(feedbackEntriesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('我要反馈')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _FeedbackForm(
            contentController: _contentController,
            contactController: _contactController,
            isSubmitting: _isSubmitting,
            onSubmit: _submit,
          ),
          const SizedBox(height: 24),
          Text(
            '反馈记录',
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          entriesAsync.when(
            loading: () => const Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (e, _) => Text('加载失败: $e'),
            data: (result) => switch (result) {
              Ok(:final value) =>
                value.isEmpty
                    ? Text(
                        '暂无反馈记录',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      )
                    : Column(
                        children: value
                            .map(
                              (entry) => _FeedbackRecordTile(
                                entry: entry,
                                isRetrying: _retryingIds.contains(entry.id),
                                onRetry: () => _retry(entry),
                                onDelete: () => _delete(entry),
                              ),
                            )
                            .toList(),
                      ),
              Err(:final error) => Text(error.message),
            },
          ),
        ],
      ),
    );
  }
}

class _FeedbackForm extends StatelessWidget {
  final TextEditingController contentController;
  final TextEditingController contactController;
  final bool isSubmitting;
  final VoidCallback onSubmit;

  const _FeedbackForm({
    required this.contentController,
    required this.contactController,
    required this.isSubmitting,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '反馈内容',
          style: TextStyle(
            fontSize: 12,
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 4),
        TextField(
          controller: contentController,
          minLines: 5,
          maxLines: 8,
          textInputAction: TextInputAction.newline,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: '写下你遇到的问题、想法或建议',
          ),
        ),
        const SizedBox(height: 16),
        Text(
          '联系方式（选填）',
          style: TextStyle(
            fontSize: 12,
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 4),
        TextField(
          controller: contactController,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: '微信、邮箱或其他联系方式',
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '提交时会自动附带 App 版本、平台、设备和时间信息。',
          style: TextStyle(
            fontSize: 12,
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: FilledButton(
            onPressed: isSubmitting ? null : onSubmit,
            child: isSubmitting
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('提交反馈'),
          ),
        ),
      ],
    );
  }
}

class _FeedbackRecordTile extends StatelessWidget {
  final FeedbackEntry entry;
  final bool isRetrying;
  final VoidCallback onRetry;
  final VoidCallback onDelete;

  const _FeedbackRecordTile({
    required this.entry,
    required this.isRetrying,
    required this.onRetry,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dismissible(
      key: ValueKey(entry.id),
      direction: DismissDirection.endToStart,
      confirmDismiss: (_) => _confirmDelete(context),
      onDismissed: (_) => onDelete(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16),
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: theme.colorScheme.error,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Icon(Icons.delete_outline, color: theme.colorScheme.onError),
      ),
      child: _buildContent(context),
    );
  }

  Future<bool> _confirmDelete(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('删除反馈'),
        content: const Text('确定要删除这条反馈记录吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('删除'),
          ),
        ],
      ),
    );
    return confirmed ?? false;
  }

  Widget _buildContent(BuildContext context) {
    final theme = Theme.of(context);
    final status = _statusLabel(entry.status);
    final color = _statusColor(theme, entry.status);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: theme.colorScheme.outlineVariant),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                _formatDateTime(entry.submittedAt),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(3),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    fontSize: 11,
                    color: color,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            entry.content,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodyMedium,
          ),
          if (entry.contact != null && entry.contact!.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              '联系方式：${entry.contact}',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
          if (entry.status == 'failed') ...[
            if (entry.errorMessage != null &&
                entry.errorMessage!.isNotEmpty) ...[
              const SizedBox(height: 6),
              Text(
                entry.errorMessage!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.error,
                ),
              ),
            ],
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: isRetrying ? null : onRetry,
                icon: isRetrying
                    ? const SizedBox(
                        width: 14,
                        height: 14,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.refresh, size: 16),
                label: const Text('重试'),
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _statusLabel(String status) {
    return switch (status) {
      'pending' => '发送中',
      'sent' => '发送成功',
      'failed' => '发送失败',
      _ => status,
    };
  }

  Color _statusColor(ThemeData theme, String status) {
    return switch (status) {
      'pending' => theme.colorScheme.primary,
      'sent' => Colors.green.shade700,
      'failed' => theme.colorScheme.error,
      _ => theme.colorScheme.onSurfaceVariant,
    };
  }

  String _formatDateTime(DateTime value) {
    return '${value.year.toString().padLeft(4, '0')}-'
        '${value.month.toString().padLeft(2, '0')}-'
        '${value.day.toString().padLeft(2, '0')} '
        '${value.hour.toString().padLeft(2, '0')}:'
        '${value.minute.toString().padLeft(2, '0')}';
  }
}
