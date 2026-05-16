import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 应用启动引导。
///
/// 初始化全局基础设施（日志、数据库、通知等），然后运行根 Widget。
void bootstrap(WidgetBuilder builder) {
  WidgetsFlutterBinding.ensureInitialized();

  // 数据库由 Riverpod Provider 懒初始化，无需手动 setup。

  runApp(ProviderScope(child: Builder(builder: builder)));
}
