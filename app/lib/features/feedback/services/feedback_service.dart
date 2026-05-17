import 'dart:convert';
import 'dart:io';

import 'package:class2data/core/result/result.dart';
import 'package:class2data/data/database/app_database.dart';
import 'package:class2data/domain/repositories/feedback_repository.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:drift/drift.dart' show Value;
import 'package:package_info_plus/package_info_plus.dart';

class FeedbackService {
  static const String _endpoint = String.fromEnvironment(
    'FEEDBACK_ENDPOINT',
    defaultValue: 'https://feishufeedback.riddles.top',
  );
  static final Uri _webhookUri = Uri.parse(_endpoint);

  final FeedbackRepository _repository;

  FeedbackService(this._repository);

  Future<Result<void>> submitFeedback({
    required String content,
    String? contact,
  }) async {
    final trimmedContent = content.trim();
    if (trimmedContent.isEmpty) {
      return const Err(ValidationError('请输入反馈内容'));
    }

    final metadata = await _loadMetadata();
    final now = DateTime.now();
    final insertResult = await _repository.insertEntry(
      FeedbackEntriesCompanion.insert(
        content: trimmedContent,
        contact: Value(_blankToNull(contact)),
        status: 'pending',
        appName: metadata.appName,
        appVersion: metadata.appVersion,
        platform: metadata.platform,
        deviceInfo: metadata.deviceInfo,
        submittedAt: now,
        createdAt: now,
        updatedAt: now,
      ),
    );

    int id;
    switch (insertResult) {
      case Ok(:final value):
        id = value;
      case Err(:final error):
        return Err(error);
    }

    final entryResult = await _repository.getById(id);
    FeedbackEntry? entry;
    switch (entryResult) {
      case Ok(:final value):
        entry = value;
      case Err(:final error):
        return Err(error);
    }
    if (entry == null) {
      return const Err(DatabaseError('反馈记录保存后无法读取'));
    }

    return _sendAndUpdate(entry);
  }

  Future<Result<void>> retryFeedback(FeedbackEntry entry) async {
    await _repository.updateStatus(
      id: entry.id,
      status: 'pending',
      errorMessage: null,
      sentAt: null,
    );
    return _sendAndUpdate(entry);
  }

  Future<Result<void>> deleteFeedback(int id) {
    return _repository.deleteById(id);
  }

  Future<Result<void>> _sendAndUpdate(FeedbackEntry entry) async {
    final sendResult = await _sendCard(entry);
    switch (sendResult) {
      case Ok():
        return _repository.updateStatus(
          id: entry.id,
          status: 'sent',
          errorMessage: null,
          sentAt: DateTime.now(),
        );
      case Err(:final error):
        await _repository.updateStatus(
          id: entry.id,
          status: 'failed',
          errorMessage: error.message,
          sentAt: null,
        );
        return Err(error);
    }
  }

  Future<Result<void>> _sendCard(FeedbackEntry entry) async {
    final client = HttpClient();
    try {
      final request = await client.postUrl(_webhookUri);
      request.headers.contentType = ContentType.json;
      const token = String.fromEnvironment('FEEDBACK_TOKEN');
      if (token.isNotEmpty) {
        request.headers.set('X-Feedback-Token', token);
      }
      request.write(jsonEncode(_buildCardPayload(entry)));
      final response = await request.close();
      final body = await response.transform(utf8.decoder).join();

      if (response.statusCode < 200 || response.statusCode >= 300) {
        return Err(
          NetworkError('飞书反馈发送失败(${response.statusCode}): ${_shorten(body)}'),
        );
      }

      final decoded = jsonDecode(body);
      if (decoded is Map<String, dynamic>) {
        final code = decoded['code'] ?? decoded['StatusCode'];
        if (code is num && code != 0) {
          return Err(
            NetworkError(
              '飞书反馈发送失败: ${decoded['msg'] ?? decoded['StatusMessage'] ?? body}',
            ),
          );
        }
      }

      return const Ok(null);
    } catch (e) {
      return Err(NetworkError('飞书反馈发送失败: $e', cause: e));
    } finally {
      client.close(force: true);
    }
  }

  Map<String, Object?> _buildCardPayload(FeedbackEntry entry) {
    return {
      'msg_type': 'interactive',
      'card': {
        'config': {'wide_screen_mode': true},
        'header': {
          'template': 'blue',
          'title': {'tag': 'plain_text', 'content': '课小记 App 用户反馈'},
        },
        'elements': [
          {
            'tag': 'div',
            'text': {'tag': 'lark_md', 'content': '**反馈内容**\n${entry.content}'},
          },
          if (entry.contact != null && entry.contact!.isNotEmpty)
            {
              'tag': 'div',
              'text': {
                'tag': 'lark_md',
                'content': '**联系方式**\n${entry.contact}',
              },
            },
          {'tag': 'hr'},
          {
            'tag': 'div',
            'fields': [
              _field('反馈 ID', '#${entry.id}'),
              _field('App', entry.appName),
              _field('版本', entry.appVersion),
              _field('平台', entry.platform),
              _field('设备', entry.deviceInfo),
              _field('时间', _formatDateTime(entry.submittedAt)),
            ],
          },
        ],
      },
    };
  }

  Map<String, Object> _field(String label, String value) {
    return {
      'is_short': true,
      'text': {'tag': 'lark_md', 'content': '**$label**\n$value'},
    };
  }

  Future<_FeedbackMetadata> _loadMetadata() async {
    final packageInfo = await PackageInfo.fromPlatform();
    final appName = packageInfo.appName.trim().isNotEmpty
        ? packageInfo.appName.trim()
        : '课小记';
    final appVersion = '${packageInfo.version}+${packageInfo.buildNumber}';

    return _FeedbackMetadata(
      appName: appName,
      appVersion: appVersion,
      platform: Platform.operatingSystem,
      deviceInfo: await _loadDeviceInfo(),
    );
  }

  Future<String> _loadDeviceInfo() async {
    try {
      final info = await DeviceInfoPlugin().deviceInfo;
      final data = info.data;
      final parts = <String>[];
      for (final key in [
        'manufacturer',
        'brand',
        'model',
        'name',
        'productName',
        'computerName',
        'osRelease',
        'systemName',
        'systemVersion',
        'release',
      ]) {
        final value = data[key];
        if (value != null && value.toString().trim().isNotEmpty) {
          parts.add(value.toString());
        }
      }
      return parts.isEmpty
          ? Platform.operatingSystemVersion
          : parts.join(' / ');
    } catch (_) {
      return Platform.operatingSystemVersion;
    }
  }

  String? _blankToNull(String? value) {
    final trimmed = value?.trim();
    if (trimmed == null || trimmed.isEmpty) return null;
    return trimmed;
  }

  String _shorten(String value) {
    if (value.length <= 200) return value;
    return '${value.substring(0, 200)}...';
  }

  String _formatDateTime(DateTime value) {
    return '${value.year.toString().padLeft(4, '0')}-'
        '${value.month.toString().padLeft(2, '0')}-'
        '${value.day.toString().padLeft(2, '0')} '
        '${value.hour.toString().padLeft(2, '0')}:'
        '${value.minute.toString().padLeft(2, '0')}:'
        '${value.second.toString().padLeft(2, '0')}';
  }
}

class _FeedbackMetadata {
  final String appName;
  final String appVersion;
  final String platform;
  final String deviceInfo;

  const _FeedbackMetadata({
    required this.appName,
    required this.appVersion,
    required this.platform,
    required this.deviceInfo,
  });
}
