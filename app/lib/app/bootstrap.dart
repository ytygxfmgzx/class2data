import 'package:class2data/domain/services/cache_clean_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 应用启动引导。
///
/// 初始化全局基础设施（日志、数据库、通知等），然后运行根 Widget。
void bootstrap(WidgetBuilder builder) {
  WidgetsFlutterBinding.ensureInitialized();

  // 清理超过 1 天的残留缓存文件（即发即弃，不阻塞启动）
  CacheCleanService().clearExpiredCache().catchError((_) => 0);

  runApp(ProviderScope(child: Builder(builder: builder)));
}
