import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../data/webdav/webdav_client.dart';
import '../../../data/webdav/webdav_exceptions.dart';
import '../providers/webdav_config_providers.dart';

class WebDavConfigPage extends ConsumerStatefulWidget {
  const WebDavConfigPage({super.key});

  @override
  ConsumerState<WebDavConfigPage> createState() => _WebDavConfigPageState();
}

class _WebDavConfigPageState extends ConsumerState<WebDavConfigPage> {
  final _formKey = GlobalKey<FormState>();
  final _serverUrlController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isTesting = false;
  String? _testResult;
  bool _testSuccess = false;

  @override
  void initState() {
    super.initState();
    final config = ref.read(webDavConfigProvider);
    if (config.serverUrl != null) _serverUrlController.text = config.serverUrl!;
    if (config.username != null) _usernameController.text = config.username!;
    if (config.password != null) _passwordController.text = config.password!;
  }

  @override
  void dispose() {
    _serverUrlController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('WebDAV 配置')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              '配置 WebDAV 服务器以启用云端备份与恢复。',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _serverUrlController,
              decoration: const InputDecoration(
                labelText: '服务器地址',
                hintText: 'https://dav.example.com/dav/',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.cloud_outlined),
              ),
              validator: (v) {
                if (v == null || v.trim().isEmpty) return '请输入服务器地址';
                final uri = Uri.tryParse(v.trim());
                if (uri == null || (!uri.hasScheme)) return '请输入有效的 URL';
                return null;
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: '用户名',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person_outline),
              ),
              validator: (v) {
                if (v == null || v.trim().isEmpty) return '请输入用户名';
                return null;
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _passwordController,
              obscureText: _obscurePassword,
              decoration: InputDecoration(
                labelText: '密码',
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.lock_outline),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () =>
                      setState(() => _obscurePassword = !_obscurePassword),
                ),
              ),
              validator: (v) {
                if (v == null || v.trim().isEmpty) return '请输入密码';
                return null;
              },
            ),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: _isTesting ? null : _testConnection,
              child: _isTesting
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('测试连接'),
            ),
            if (_testResult != null) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _testSuccess
                      ? Theme.of(
                          context,
                        ).colorScheme.primaryContainer.withValues(alpha: 0.3)
                      : Theme.of(
                          context,
                        ).colorScheme.errorContainer.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      _testSuccess ? Icons.check_circle : Icons.error,
                      size: 18,
                      color: _testSuccess
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.error,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _testResult!,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 16),
            FilledButton(
              onPressed: _testSuccess ? _save : null,
              child: const Text('保存'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _testConnection() async {
    if (!_formKey.currentState!.validate()) return;

    final serverUrl = _serverUrlController.text.trim();
    // 检查 HTTP 安全警告
    if (serverUrl.startsWith('http://')) {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('安全警告'),
          content: const Text(
            '您输入的是 HTTP 地址，数据将通过未加密连接传输，'
            '可能被第三方截获。建议使用 HTTPS。是否继续？',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: const Text('取消'),
            ),
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(true),
              child: const Text('继续'),
            ),
          ],
        ),
      );
      if (confirmed != true) return;
    }

    setState(() {
      _isTesting = true;
      _testResult = null;
    });

    try {
      final client = WebDavClient(
        baseUrl: serverUrl,
        username: _usernameController.text.trim(),
        password: _passwordController.text.trim(),
        timeout: const Duration(seconds: 15),
      );

      final success = await client.testConnection();
      client.dispose();

      if (!mounted) return;
      setState(() {
        _testSuccess = success;
        _testResult = success ? '连接成功' : '连接失败：该地址不是有效的 WebDAV 目录';
      });
    } on WebDavAuthError {
      if (!mounted) return;
      setState(() {
        _testSuccess = false;
        _testResult = '认证失败：用户名或密码错误';
      });
    } on WebDavConnectionError catch (e) {
      if (!mounted) return;
      setState(() {
        _testSuccess = false;
        _testResult = '连接失败：${e.message}';
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _testSuccess = false;
        _testResult = '连接失败：$e';
      });
    } finally {
      if (mounted) setState(() => _isTesting = false);
    }
  }

  Future<void> _save() async {
    await ref
        .read(webDavConfigProvider.notifier)
        .saveConfig(
          serverUrl: _serverUrlController.text.trim(),
          username: _usernameController.text.trim(),
          password: _passwordController.text.trim(),
        );
    if (mounted) context.pushReplacement('/cloud-backup');
  }
}
