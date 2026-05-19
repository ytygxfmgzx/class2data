/// cloud-manifest.json 数据模型。
class CloudManifest {
  final String format;
  final int formatVersion;
  final int version;
  final String deviceId;
  final String deviceName;
  final DateTime lastModifiedTime;
  final int schemaVersion;
  final String appVersion;
  final int databaseSize;
  final String databaseSha256;
  final Map<String, CloudFileInfo> files;

  const CloudManifest({
    required this.format,
    required this.formatVersion,
    required this.version,
    required this.deviceId,
    required this.deviceName,
    required this.lastModifiedTime,
    required this.schemaVersion,
    required this.appVersion,
    required this.databaseSize,
    required this.databaseSha256,
    required this.files,
  });

  factory CloudManifest.fromJson(Map<String, dynamic> json) {
    final filesMap = <String, CloudFileInfo>{};
    final rawFiles = json['files'] as Map<String, dynamic>?;
    if (rawFiles != null) {
      for (final entry in rawFiles.entries) {
        filesMap[entry.key] = CloudFileInfo.fromJson(
          entry.value as Map<String, dynamic>,
        );
      }
    }

    return CloudManifest(
      format: json['format'] as String,
      formatVersion: json['formatVersion'] as int,
      version: json['version'] as int,
      deviceId: json['deviceId'] as String,
      deviceName: json['deviceName'] as String,
      lastModifiedTime: DateTime.parse(json['lastModifiedTime'] as String),
      schemaVersion: json['schemaVersion'] as int,
      appVersion: json['appVersion'] as String,
      databaseSize: json['databaseSize'] as int,
      databaseSha256: json['databaseSha256'] as String,
      files: filesMap,
    );
  }

  Map<String, dynamic> toJson() => {
    'format': format,
    'formatVersion': formatVersion,
    'version': version,
    'deviceId': deviceId,
    'deviceName': deviceName,
    'lastModifiedTime': lastModifiedTime.toUtc().toIso8601String(),
    'schemaVersion': schemaVersion,
    'appVersion': appVersion,
    'databaseSize': databaseSize,
    'databaseSha256': databaseSha256,
    'files': files.map((k, v) => MapEntry(k, v.toJson())),
  };
}

/// manifest 中的单个文件信息。
class CloudFileInfo {
  final int size;
  final String? sha256;

  const CloudFileInfo({required this.size, this.sha256});

  factory CloudFileInfo.fromJson(Map<String, dynamic> json) {
    return CloudFileInfo(
      size: json['size'] as int,
      sha256: json['sha256'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{'size': size};
    if (sha256 != null) map['sha256'] = sha256;
    return map;
  }
}

/// device-lock.json 数据模型。
class DeviceLock {
  final String deviceId;
  final String deviceName;
  final DateTime lockedAt;

  const DeviceLock({
    required this.deviceId,
    required this.deviceName,
    required this.lockedAt,
  });

  factory DeviceLock.fromJson(Map<String, dynamic> json) {
    return DeviceLock(
      deviceId: json['deviceId'] as String,
      deviceName: json['deviceName'] as String,
      lockedAt: DateTime.parse(json['lockedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
    'deviceId': deviceId,
    'deviceName': deviceName,
    'lockedAt': lockedAt.toUtc().toIso8601String(),
  };
}
