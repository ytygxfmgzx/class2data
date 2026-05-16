import 'package:flutter/material.dart';

/// 实用工具型主题 — 信息密度高，功能优先，零装饰。
///
/// 色彩 token：中性底 + 语义色。
/// 语义色：蓝=操作，绿=正常，橙=警告，红=危险。
/// 圆角 4px，列表行高 48px，系统字体栈。
class AppTheme {
  AppTheme._();

  static ThemeData get light {
    final base = ThemeData(
      useMaterial3: true,
      colorSchemeSeed: const Color(0xFF2563EB),
      brightness: Brightness.light,
    );

    return base.copyWith(
      cardTheme: base.cardTheme.copyWith(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        ),
      ),
    );
  }
}
