import 'dart:async';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../data/webdav/webdav_client.dart';

const _kServerUrl = 'webdav_server_url';
const _kUsername = 'webdav_username';
const _kPassword = 'webdav_password';
const _kDeviceId = 'webdav_device_id';
const _kDeviceName = 'webdav_device_name';
const _kLastSeenVersion = 'webdav_last_seen_version';
const _kLastSyncTime = 'webdav_last_sync_time';

const _secureStorage = FlutterSecureStorage(
  aOptions: AndroidOptions(encryptedSharedPreferences: true),
);

class WebDavConfig {
  final String? serverUrl;
  final String? username;
  final String? password;
  final String? deviceId;
  final String? deviceName;
  final int lastSeenVersion;
  final DateTime? lastSyncTime;

  const WebDavConfig({
    this.serverUrl,
    this.username,
    this.password,
    this.deviceId,
    this.deviceName,
    this.lastSeenVersion = 0,
    this.lastSyncTime,
  });

  bool get isConfigured =>
      serverUrl != null &&
      serverUrl!.isNotEmpty &&
      username != null &&
      password != null;

  WebDavConfig copyWith({
    String? serverUrl,
    String? username,
    String? password,
    String? deviceId,
    String? deviceName,
    int? lastSeenVersion,
    DateTime? lastSyncTime,
    bool clearLastSyncTime = false,
  }) => WebDavConfig(
    serverUrl: serverUrl ?? this.serverUrl,
    username: username ?? this.username,
    password: password ?? this.password,
    deviceId: deviceId ?? this.deviceId,
    deviceName: deviceName ?? this.deviceName,
    lastSeenVersion: lastSeenVersion ?? this.lastSeenVersion,
    lastSyncTime: clearLastSyncTime
        ? null
        : (lastSyncTime ?? this.lastSyncTime),
  );
}

class WebDavConfigNotifier extends StateNotifier<WebDavConfig> {
  final _loadCompleter = Completer<void>();

  WebDavConfigNotifier() : super(const WebDavConfig()) {
    _loadConfig();
  }

  /// 等待配置加载完成。
  Future<void> get loaded => _loadCompleter.future;

  Future<void> _loadConfig() async {
    final serverUrl = await _secureStorage.read(key: _kServerUrl);
    final username = await _secureStorage.read(key: _kUsername);
    final password = await _secureStorage.read(key: _kPassword);
    final deviceId = await _secureStorage.read(key: _kDeviceId);
    final deviceName = await _secureStorage.read(key: _kDeviceName);
    final versionStr = await _secureStorage.read(key: _kLastSeenVersion);
    final syncTimeStr = await _secureStorage.read(key: _kLastSyncTime);

    state = WebDavConfig(
      serverUrl: serverUrl,
      username: username,
      password: password,
      deviceId: deviceId,
      deviceName: deviceName,
      lastSeenVersion: int.tryParse(versionStr ?? '') ?? 0,
      lastSyncTime: syncTimeStr != null ? DateTime.tryParse(syncTimeStr) : null,
    );
    _loadCompleter.complete();
  }

  Future<void> saveConfig({
    required String serverUrl,
    required String username,
    required String password,
  }) async {
    await _secureStorage.write(key: _kServerUrl, value: serverUrl);
    await _secureStorage.write(key: _kUsername, value: username);
    await _secureStorage.write(key: _kPassword, value: password);

    // 首次配置时生成设备 ID
    String? deviceId = state.deviceId;
    if (deviceId == null) {
      deviceId = _generateDeviceId();
      await _secureStorage.write(key: _kDeviceId, value: deviceId);
    }

    // 获取设备名称
    String? deviceName = state.deviceName;
    if (deviceName == null || _isGenericDeviceName(deviceName)) {
      deviceName = await _getDeviceName();
      await _secureStorage.write(key: _kDeviceName, value: deviceName);
    }

    state = state.copyWith(
      serverUrl: serverUrl,
      username: username,
      password: password,
      deviceId: deviceId,
      deviceName: deviceName,
    );
  }

  Future<void> saveLastSeenVersion(int version) async {
    await _secureStorage.write(
      key: _kLastSeenVersion,
      value: version.toString(),
    );
    state = state.copyWith(lastSeenVersion: version);
  }

  Future<void> saveLastSyncTime(DateTime time) async {
    await _secureStorage.write(
      key: _kLastSyncTime,
      value: time.toIso8601String(),
    );
    state = state.copyWith(lastSyncTime: time);
  }

  Future<void> clearLastSyncTime() async {
    await _secureStorage.delete(key: _kLastSyncTime);
    state = state.copyWith(clearLastSyncTime: true);
  }

  Future<void> updateDeviceName(String name) async {
    await _secureStorage.write(key: _kDeviceName, value: name);
    state = state.copyWith(deviceName: name);
  }

  Future<void> clearConfig() async {
    await _secureStorage.delete(key: _kServerUrl);
    await _secureStorage.delete(key: _kUsername);
    await _secureStorage.delete(key: _kPassword);
    // 保留设备 ID 和名称（设备不变）
    state = WebDavConfig(
      deviceId: state.deviceId,
      deviceName: state.deviceName,
    );
  }

  String _generateDeviceId() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final random = StringBuffer();
    for (int i = 0; i < 8; i++) {
      random.write(timestamp.toRadixString(36));
    }
    return '${timestamp.toRadixString(36)}-${random.toString().substring(0, 8)}';
  }

  static const _genericDeviceNames = {
    'iOS 设备',
    'Android 设备',
    'Windows 设备',
    'Mac 设备',
    '未知设备',
  };

  bool _isGenericDeviceName(String name) => _genericDeviceNames.contains(name);

  Future<String> _getDeviceName() async {
    try {
      final info = await DeviceInfoPlugin().deviceInfo;
      if (info is AndroidDeviceInfo) {
        return '${info.brand} ${info.model}';
      } else if (info is IosDeviceInfo) {
        return info.utsname.machine;
      } else if (info is WindowsDeviceInfo) {
        return info.computerName;
      } else if (info is MacOsDeviceInfo) {
        return info.computerName;
      }
    } catch (_) {}
    if (Platform.isAndroid) return 'Android 设备';
    if (Platform.isIOS) return 'iOS 设备';
    if (Platform.isWindows) return 'Windows 设备';
    if (Platform.isMacOS) return 'Mac 设备';
    return '未知设备';
  }
}

/// WebDAV 配置 Provider。
final webDavConfigProvider =
    StateNotifierProvider<WebDavConfigNotifier, WebDavConfig>((ref) {
      return WebDavConfigNotifier();
    });

/// WebDAV 客户端 Provider（依赖配置）。
final webDavClientProvider = Provider<WebDavClient?>((ref) {
  final config = ref.watch(webDavConfigProvider);
  if (!config.isConfigured) return null;
  return WebDavClient(
    baseUrl: config.serverUrl!,
    username: config.username!,
    password: config.password!,
  );
});
