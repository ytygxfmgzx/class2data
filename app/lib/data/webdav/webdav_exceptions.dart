/// WebDAV 操作异常类型。
sealed class WebDavException implements Exception {
  final String message;
  final int? statusCode;

  const WebDavException(this.message, {this.statusCode});

  @override
  String toString() => message;
}

/// 连接失败（DNS、网络不可达、超时）。
class WebDavConnectionError extends WebDavException {
  final String url;

  const WebDavConnectionError(super.message, {required this.url});

  @override
  String toString() => '连接失败: $message';
}

/// 认证失败（401/403）。
class WebDavAuthError extends WebDavException {
  const WebDavAuthError(super.message, {super.statusCode});

  @override
  String toString() => '认证失败: $message';
}

/// 资源不存在（404）。
class WebDavNotFoundError extends WebDavException {
  const WebDavNotFoundError(super.message, {super.statusCode});

  @override
  String toString() => '资源不存在: $message';
}

/// 存储空间不足（507）。
class WebDavQuotaError extends WebDavException {
  const WebDavQuotaError(super.message, {super.statusCode});

  @override
  String toString() => '存储空间不足: $message';
}

/// 其他 HTTP 错误。
class WebDavHttpError extends WebDavException {
  const WebDavHttpError(super.message, {super.statusCode});

  @override
  String toString() =>
      'HTTP 错误${statusCode != null ? ' ($statusCode)' : ''}: $message';
}
