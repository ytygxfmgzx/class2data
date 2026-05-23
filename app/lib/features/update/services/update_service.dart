import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';

class UpdateInfo {
  final String version;
  final String downloadUrl;
  final String releaseNotes;

  const UpdateInfo({
    required this.version,
    required this.downloadUrl,
    required this.releaseNotes,
  });
}

class UpdateService {
  static const String _endpoint = String.fromEnvironment(
    'UPDATE_ENDPOINT',
    defaultValue: 'https://update.riddles.top',
  );

  Future<UpdateInfo?> checkForUpdate() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      final currentVersion = packageInfo.version;

      final client = HttpClient();
      client.connectionTimeout = const Duration(seconds: 10);
      try {
        final uri = Uri.parse('$_endpoint/api/latest-release');
        final request = await client.getUrl(uri);
        final response = await request.close();

        if (response.statusCode != 200) return null;

        final body = await response.transform(utf8.decoder).join();
        final data = jsonDecode(body) as Map<String, dynamic>;

        if (data['ok'] != true) return null;
        final remoteVersion = data['version'] as String? ?? '';
        if (remoteVersion.isEmpty) return null;

        if (!_isNewerVersion(currentVersion, remoteVersion)) return null;

        final apk = data['apk'] as Map<String, dynamic>?;
        if (apk == null) return null;

        final downloadUrl = apk['download_url'] as String? ?? '';
        if (downloadUrl.isEmpty) return null;

        return UpdateInfo(
          version: remoteVersion,
          downloadUrl:
              '$_endpoint/download?url=${Uri.encodeComponent(downloadUrl)}',
          releaseNotes: data['body'] as String? ?? '',
        );
      } finally {
        client.close(force: true);
      }
    } catch (e) {
      debugPrint('[UpdateService] 检查更新失败: $e');
      return null;
    }
  }

  bool _isNewerVersion(String current, String remote) {
    final currentParts = _parseVersion(current);
    final remoteParts = _parseVersion(remote);
    if (currentParts == null || remoteParts == null) return false;

    for (var i = 0; i < remoteParts.length; i++) {
      if (i >= currentParts.length) return remoteParts[i] > 0;
      if (remoteParts[i] > currentParts[i]) return true;
      if (remoteParts[i] < currentParts[i]) return false;
    }
    return false;
  }

  List<int>? _parseVersion(String version) {
    final parts = version.split('.');
    if (parts.isEmpty) return null;
    final result = <int>[];
    for (final p in parts) {
      final n = int.tryParse(p);
      if (n == null) return null;
      result.add(n);
    }
    return result;
  }
}
