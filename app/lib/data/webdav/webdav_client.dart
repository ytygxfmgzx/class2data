import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:xml/xml.dart';

import 'webdav_exceptions.dart';

/// WebDAV HTTP 客户端。
///
/// 使用 dart:io HttpClient 实现，注册 Basic Auth 凭据，
/// 确保重定向时认证头不被丢弃。
class WebDavClient {
  final String baseUrl;
  final String username;
  final String password;
  final HttpClient _httpClient;
  final Duration _timeout;

  WebDavClient({
    required this.baseUrl,
    required this.username,
    required this.password,
    Duration? timeout,
  }) : _timeout = timeout ?? const Duration(seconds: 30),
       _httpClient = _createHttpClient(baseUrl, username, password);

  static HttpClient _createHttpClient(
    String baseUrl,
    String username,
    String password,
  ) {
    final client = HttpClient();
    final uri = Uri.parse(baseUrl);
    client.addCredentials(
      uri,
      '',
      HttpClientBasicCredentials(username, password),
    );
    return client;
  }

  /// 测试连接：PROPFIND depth=0 验证 URL 可达且为 WebDAV 目录。
  Future<bool> testConnection() async {
    final request = await _openRequest('PROPFIND', '').timeout(_timeout);
    request.headers.set('Content-Type', 'application/xml; charset=utf-8');
    request.headers.set('Depth', '0');
    request.write(
      '<?xml version="1.0" encoding="utf-8"?>'
      '<d:propfind xmlns:d="DAV:">'
      '<d:prop><d:resourcetype/></d:prop>'
      '</d:propfind>',
    );
    final response = await request.close().timeout(_timeout);
    await response.drain<void>();
    return response.statusCode == 207;
  }

  /// 检查路径是否存在。
  Future<bool> exists(String path) async {
    try {
      final request = await _openRequest('HEAD', path).timeout(_timeout);
      final response = await request.close().timeout(_timeout);
      await response.drain<void>();
      return response.statusCode == 200;
    } on WebDavNotFoundError {
      return false;
    } on WebDavHttpError {
      return false;
    }
  }

  /// 下载文件，返回字节内容。
  Future<Uint8List> download(String path) async {
    final request = await _openRequest('GET', path).timeout(_timeout);
    final response = await request.close().timeout(_timeout);
    _checkStatus(response, path);
    final builder = BytesBuilder();
    await for (final chunk in response) {
      builder.add(chunk);
    }
    return builder.toBytes();
  }

  /// 下载文件并写入本地文件，支持进度回调。
  Future<void> downloadToFile(
    String remotePath,
    String localPath, {
    void Function(int received, int total)? onProgress,
  }) async {
    final request = await _openRequest('GET', remotePath).timeout(_timeout);
    final response = await request.close().timeout(_timeout);
    _checkStatus(response, remotePath);

    final total = response.contentLength > 0 ? response.contentLength : 0;
    final file = File(localPath);
    await file.parent.create(recursive: true);

    final sink = file.openWrite();
    try {
      int received = 0;
      await for (final chunk in response) {
        sink.add(chunk);
        received += chunk.length;
        onProgress?.call(received, total > 0 ? total : received);
      }
    } finally {
      await sink.close();
    }
  }

  /// 上传字节内容。
  Future<void> upload(
    String path,
    Uint8List data, {
    void Function(int sent, int total)? onProgress,
  }) async {
    final request = await _openRequest('PUT', path).timeout(_timeout);
    request.headers.set('Content-Type', 'application/octet-stream');
    request.headers.set('Content-Length', data.length.toString());
    request.add(data);
    final response = await request.close().timeout(_timeout);
    _checkStatus(response, path);
    await response.drain<void>();
    onProgress?.call(data.length, data.length);
  }

  /// 上传本地文件到远端，支持进度回调。
  Future<void> uploadFile(
    String localPath,
    String remotePath, {
    void Function(int sent, int total)? onProgress,
  }) async {
    final file = File(localPath);
    if (!await file.exists()) {
      throw FileSystemException('文件不存在', localPath);
    }

    final fileSize = await file.length();
    final request = await _openRequest('PUT', remotePath).timeout(_timeout);
    request.headers.set('Content-Type', 'application/octet-stream');
    request.headers.set('Content-Length', fileSize.toString());

    final stream = file.openRead();
    int sent = 0;

    final reportingStream = stream.transform(
      StreamTransformer<List<int>, List<int>>.fromHandlers(
        handleData: (data, sink) {
          sent += data.length;
          onProgress?.call(sent, fileSize);
          sink.add(data);
        },
      ),
    );

    await pipeStream(reportingStream, request);
    final response = await request.close().timeout(_timeout);
    _checkStatus(response, remotePath);
    await response.drain<void>();
  }

  /// 删除远端文件或目录。
  Future<void> delete(String path) async {
    final request = await _openRequest('DELETE', path).timeout(_timeout);
    final response = await request.close().timeout(_timeout);
    _checkStatus(response, path);
    await response.drain<void>();
  }

  /// 创建目录（如果已存在不报错）。
  Future<void> ensureDirectory(String path) async {
    final normalized = _normalizePath(path);
    final segments = normalized.split('/').where((s) => s.isNotEmpty).toList();

    String current = '';
    for (final segment in segments) {
      current += '/$segment';
      if (!await exists(current)) {
        await _mkcol(current);
      }
    }
  }

  /// 下载并解析 JSON 文件。
  Future<Map<String, dynamic>> downloadJson(String path) async {
    final bytes = await download(path);
    return jsonDecode(utf8.decode(bytes)) as Map<String, dynamic>;
  }

  /// 上传 JSON 对象。
  Future<void> uploadJson(String path, Map<String, dynamic> data) async {
    final bytes = utf8.encode(jsonEncode(data));
    await upload(path, Uint8List.fromList(bytes));
  }

  void dispose() {
    _httpClient.close();
  }

  // === 私有方法 ===

  Future<HttpClientRequest> _openRequest(String method, String path) async {
    final uri = _buildUri(path);
    final request = await _httpClient.openUrl(method, uri);
    // 手动添加 Authorization 头作为补充（某些服务器可能不触发 HttpClient 的凭据回调）
    final credentials = base64Encode(utf8.encode('$username:$password'));
    request.headers.set('Authorization', 'Basic $credentials');
    return request;
  }

  Future<void> _mkcol(String path) async {
    final request = await _openRequest('MKCOL', path).timeout(_timeout);
    final response = await request.close().timeout(_timeout);
    // 405/409 通常表示目录已存在，不报错
    if (response.statusCode == 405 || response.statusCode == 409) {
      await response.drain<void>();
      return;
    }
    _checkStatus(response, path);
    await response.drain<void>();
  }

  Uri _buildUri(String path) {
    final base = baseUrl.endsWith('/') ? baseUrl : '$baseUrl/';
    final cleanPath = _stripLeadingSlash(_normalizePath(path));
    return Uri.parse('$base$cleanPath');
  }

  String _normalizePath(String path) {
    if (path.isEmpty) return '';
    if (!path.startsWith('/')) return '/$path';
    return path;
  }

  String _stripLeadingSlash(String path) {
    if (path.startsWith('/')) return path.substring(1);
    return path;
  }

  void _checkStatus(HttpClientResponse response, String path) {
    switch (response.statusCode) {
      case 200:
      case 201:
      case 204:
      case 207:
      case 206:
        return;
      case 401:
      case 403:
        throw WebDavAuthError('用户名或密码错误', statusCode: response.statusCode);
      case 404:
        throw WebDavNotFoundError(
          '路径不存在: $path',
          statusCode: response.statusCode,
        );
      case 507:
        throw WebDavQuotaError(
          'WebDAV 存储空间不足',
          statusCode: response.statusCode,
        );
      default:
        throw WebDavHttpError(
          '请求失败 (${response.statusCode}): ${response.reasonPhrase}',
          statusCode: response.statusCode,
        );
    }
  }

  /// 安全地将 Stream 管道写入 HttpClientRequest。
  Future<void> pipeStream(
    Stream<List<int>> stream,
    HttpClientRequest request,
  ) async {
    await for (final chunk in stream) {
      request.add(chunk);
    }
  }
}

/// WebDAV PROPFIND 响应中提取的文件信息。
class WebDavResourceInfo {
  final String href;
  final bool isDirectory;
  final int? contentLength;
  final DateTime? lastModified;

  const WebDavResourceInfo({
    required this.href,
    required this.isDirectory,
    this.contentLength,
    this.lastModified,
  });

  static List<WebDavResourceInfo> parseFromXml(String xmlStr) {
    final document = XmlDocument.parse(xmlStr);
    final results = <WebDavResourceInfo>[];

    for (final response in document.findAllElements('d:response')) {
      final hrefEl = response.findElements('d:href').firstOrNull;
      if (hrefEl == null) continue;

      final propstat = response.findElements('d:propstat').firstOrNull;
      if (propstat == null) continue;

      final prop = propstat.findElements('d:prop').firstOrNull;
      if (prop == null) continue;

      final resourcetype = prop.findElements('d:resourcetype').firstOrNull;
      final isDir =
          resourcetype?.findElements('d:collection').isNotEmpty ?? false;

      final contentLengthEl = prop
          .findElements('d:getcontentlength')
          .firstOrNull;
      final lastModifiedEl = prop.findElements('d:getlastmodified').firstOrNull;

      results.add(
        WebDavResourceInfo(
          href: hrefEl.innerText,
          isDirectory: isDir,
          contentLength: contentLengthEl != null
              ? int.tryParse(contentLengthEl.innerText)
              : null,
          lastModified: lastModifiedEl != null
              ? HttpDate.parse(lastModifiedEl.innerText)
              : null,
        ),
      );
    }

    return results;
  }
}
