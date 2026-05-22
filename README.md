# 课小记 (class2data)

家庭课外班账本和成长档案。

手机优先、本地数据优先 —— 数据在用户手上，不依赖云服务。

## 功能概览

- **孩子管理** — 多孩子、多课程，各自独立记账
- **课程与课包** — 课时包、周期卡、寒暑假班等多种类型；每次续费形成新的课包
- **上课记录** — 快速记录上课、缺课、请假、补课，目标路径不超过 10 秒
- **课时流水** — 余额由课包和流水计算，不靠手工维护
- **费用记录** — 金额以整数分存储，支持课包、上课、成长等多种费用来源
- **成长档案** — 记录成就、里程碑，支持类型多选和照片附件
- **统计与照片墙** — 课程统计聚合、时间线、照片瀑布流
- **备份与恢复** — zip 打包（数据库 + 附件），支持 JSON/CSV 导出
- **联系人** — 老师、机构等联系人管理

## 技术栈

| 层次 | 技术 |
|------|------|
| 框架 | Flutter 3.41+ / Dart 3.11+ |
| 状态管理 | Riverpod |
| 路由 | go_router |
| 数据库 | Drift + SQLite |
| 附件存储 | App 私有目录 |
| 通知 | flutter_local_notifications |

## 项目结构

```text
class2data/
├── app/                — Flutter 应用
│   ├── lib/
│   │   ├── main.dart       入口
│   │   ├── app/            启动引导、路由、主题
│   │   ├── core/           跨功能基础设施（错误、日志、时间、ID、通用控件）
│   │   ├── data/           数据库、文件存储、Repository 实现
│   │   ├── domain/         领域实体、值对象、业务服务、仓储接口
│   │   ├── features/       按用户能力切分的功能模块
│   │   └── shared/         跨功能共享的展示组件和 Provider
│   └── pubspec.yaml
├── docs/               — 产品需求、设计稿、工程文档
├── infra/              — 基础设施（Cloudflare Workers 等）
└── CLAUDE.md           — AI 代理工作指引
```

## 快速开始

```bash
cd app
flutter pub get
flutter run
```

### 构建 APK（含反馈代理）

```bash
cd app
flutter build apk --dart-define=FEEDBACK_TOKEN=your_token_here
```

## 验证命令

```bash
cd app
dart format .
flutter analyze
flutter test
dart run build_runner build --delete-conflicting-outputs  # 涉及 Drift/Riverpod 代码生成时
```

## 文档

| 文档 | 说明 |
|------|------|
| [产品需求](docs/interest-class-app-design.md) | 第一版功能范围和业务规则 |
| [工程导航](docs/engineering/README.md) | 架构、数据模型、API 设计等 |
| [项目状态](docs/engineering/project-status.md) | 当前里程碑和进展 |
| [交付流程](docs/engineering/delivery-lifecycle.md) | 端到端实施规范 |

## 许可

[MIT License](LICENSE)

## Star History

[![Star History Chart](https://api.star-history.com/svg?repos=ytygxfmgzx/class2data&type=Date)](https://star-history.com/#ytygxfmgzx/class2data&Date)
