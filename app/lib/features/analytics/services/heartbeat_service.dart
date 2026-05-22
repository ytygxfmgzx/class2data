import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class HeartbeatService {
  static const String _endpoint = String.fromEnvironment(
    'HEARTBEAT_ENDPOINT',
    defaultValue: 'https://heartbeat.riddles.top',
  );
  static const String _token = String.fromEnvironment('HEARTBEAT_TOKEN');
  static const String _deviceIdKey = 'analytics_device_id';
  static final Uri _uri = Uri.parse('$_endpoint/api/heartbeat');

  Future<void> send() async {
    try {
      debugPrint('[Heartbeat] 开始发送...');
      final deviceId = await _getDeviceId();
      debugPrint('[Heartbeat] deviceId=$deviceId');
      final packageInfo = await PackageInfo.fromPlatform();
      final deviceInfo = await _loadDeviceInfo();

      final payload = {
        'device_id': deviceId,
        'platform': Platform.operatingSystem,
        'app_version': '${packageInfo.version}+${packageInfo.buildNumber}',
        'build_mode': _buildMode(),
        'device_brand': deviceInfo.brand,
        'device_model': deviceInfo.model,
      };
      debugPrint('[Heartbeat] payload=$payload');

      final client = HttpClient();
      try {
        final request = await client.postUrl(_uri);
        request.headers.contentType = ContentType.json;
        if (_token.isNotEmpty) {
          request.headers.set('X-Heartbeat-Token', _token);
        }
        request.write(jsonEncode(payload));
        final response = await request.close();
        final body = await response.transform(utf8.decoder).join();
        debugPrint('[Heartbeat] response=${response.statusCode} body=$body');
      } finally {
        client.close(force: true);
      }
    } catch (e, st) {
      debugPrint('[Heartbeat] 失败: $e\n$st');
    }
  }

  Future<String> _getDeviceId() async {
    final prefs = await SharedPreferences.getInstance();
    final cached = prefs.getString(_deviceIdKey);
    if (cached != null) return cached;

    // 优先使用平台标识符
    final platformId = await _getPlatformDeviceId();
    if (platformId != null && platformId.isNotEmpty) {
      await prefs.setString(_deviceIdKey, platformId);
      return platformId;
    }

    // Fallback: 生成 UUID v4
    final uuid = const Uuid().v4();
    await prefs.setString(_deviceIdKey, uuid);
    return uuid;
  }

  static const _platformChannel = MethodChannel(
    'com.class2data.class2data/backup_storage',
  );

  Future<String?> _getPlatformDeviceId() async {
    try {
      if (Platform.isAndroid) {
        return await _platformChannel.invokeMethod<String>('getAndroidId');
      }
      if (Platform.isIOS) {
        final info = await DeviceInfoPlugin().deviceInfo;
        return (info as IosDeviceInfo).identifierForVendor;
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  String _buildMode() {
    if (kReleaseMode) return 'release';
    if (kProfileMode) return 'profile';
    return 'debug';
  }

  Future<({String brand, String model})> _loadDeviceInfo() async {
    try {
      final info = await DeviceInfoPlugin().deviceInfo;
      return switch (info) {
        AndroidDeviceInfo(:final brand, :final model) => (
          brand: brand,
          model: model,
        ),
        IosDeviceInfo(:final name) => (brand: 'Apple', model: name),
        WindowsDeviceInfo(:final computerName) => (
          brand: 'Windows',
          model: computerName,
        ),
        _ => (brand: '', model: ''),
      };
    } catch (_) {
      return (brand: '', model: '');
    }
  }
}
