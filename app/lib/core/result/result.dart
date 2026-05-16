/// 统一结果类型，避免到处 try-catch。
///
/// 用法：
/// ```dart
/// final result = await repository.getChild(id);
/// switch (result) {
///   case Ok(:final value):
///     // 使用 value
///   case Err(:final error):
///     // 处理 error
/// }
/// ```
sealed class Result<T> {
  const Result();
}

final class Ok<T> extends Result<T> {
  final T value;
  const Ok(this.value);
}

final class Err<T> extends Result<T> {
  final AppError error;
  const Err(this.error);
}

/// 应用层错误基类。
sealed class AppError {
  final String message;
  const AppError(this.message);
}

/// 数据库操作失败。
class DatabaseError extends AppError {
  final Object? cause;
  const DatabaseError(super.message, {this.cause});
}

/// 数据未找到。
class NotFoundError extends AppError {
  const NotFoundError(super.message);
}

/// 业务规则校验失败。
class ValidationError extends AppError {
  const ValidationError(super.message);
}

/// 文件操作失败。
class FileError extends AppError {
  final Object? cause;
  const FileError(super.message, {this.cause});
}

/// 网络请求失败。
class NetworkError extends AppError {
  final Object? cause;
  const NetworkError(super.message, {this.cause});
}
