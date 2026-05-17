# 课小记 (class2data)

家庭课外班账本和成长档案，手机优先，本地数据优先。

## 技术栈

- Flutter 3.41+ / Dart 3.11+
- Riverpod — 状态管理
- go_router — 路由
- Drift + SQLite — 本地数据库
- App 私有目录 — 附件存储
- flutter_local_notifications — 本地提醒

## 运行

```bash
flutter pub get
flutter run
```

## 验证命令

```bash
dart format lib/ test/
flutter analyze
flutter test
dart run build_runner build --delete-conflicting-outputs  # 涉及 Drift/Riverpod 代码生成时
```

## 目录结构

```text
lib/
  main.dart           — 入口
  app/                — 启动引导、路由、主题
  core/               — 跨功能基础设施（错误、日志、时间、ID、通用控件）
  data/               — 数据库、文件存储、Repository 实现
  domain/             — 领域实体、值对象、业务服务、仓储接口
  features/           — 按用户能力切分的功能模块
  shared/             — 跨功能共享的展示组件和 Provider
```
