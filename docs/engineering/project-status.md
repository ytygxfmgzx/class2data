# 项目状态

本文件是每次新对话的快速定位入口。保持短、准、新；不要写成长篇日志。

## 当前阶段

- 生命周期阶段：M8 备份、恢复和导出已完成，准备进入 M9。
- 工程里程碑：M8 已完成。
- 当前切片：M9 通知、体验打磨和发布准备。

## 最近完成

- 成长记录增强：
  - “录入成就”升级为“记录成长”，支持记录类型标签多选，第一个类型作为主类型。
  - 成长记录可勾选“产生费用”，自动创建或更新关联 `Payment`；费用统计仍统一只看费用记录。
  - 产生费用时必须关联课程，金额必填，费用类型支持自动推断和手动修改。
- M9 体验打磨：
  - “请开发者喝茶”详情页已重设计为说明区、赞赏码区和支持说明区，保留原有二维码分享能力。
  - 联系人表单底部弹层的角色选择已适配 Flutter 3.33 `initialValue` API。
- M8 备份、恢复和导出已完成：
  - BackupFileStore（zip 打包/解包、manifest 校验、文件系统操作）。
  - BackupService（createBackup、validateBackup、restoreBackup、exportAllJson、exportAllCsv）。
  - ExportDao（全表数据导出为 Map 列表）。
  - BackupNotifier（Riverpod 状态管理：备份/恢复/导出状态机）。
  - BackupPage（备份、恢复、注意事项三个区域，按原型匹配）。
  - ExportPage（JSON/CSV 导出，已实现但原型中未展示入口）。
  - AppDatabase 新增 checkpoint() 和 getDatabasePath() 静态方法。
  - 设置页按原型调整为"数据管理/数据安全/关于"分组。
  - 路由：/backup、/export 已注册，设置页已连接。
  - 依赖：archive、share_plus、file_picker 已添加。
  - `flutter analyze` 通过（0 issue from M8 code）。
  - `dart format` 通过。
  - `dart run build_runner build` 代码生成通过。
- M7 统计、时间线和照片墙已完成。
- M6 附件和成就已完成。
- M5 记录上课和销课已完成。
- M4 课包、费用和课时流水已完成。
- M3 上课计划和首页已完成。
- M2 孩子、课程和联系人已完成。
- M1 基础设施与数据库已完成。
- M0 工程初始化已完成。
- P4~P2 设计阶段已完成。

## 下一步

1. M9 通知、体验打磨和发布准备。

## 阻塞项

- 无。

## 关键决策

- 第一版技术路线：Flutter + Riverpod + go_router + Drift + SQLite + App 私有目录 + 本地通知 + 手动备份。
- 数据精度：金额用 amountCents 整数分，课时用 creditUnits 定点整数（100=1课时），日期存 YYYY-MM-DD 字符串，时间存 HH:mm 字符串。
- 附件存储：文件复制到 App 私有目录（Documents/attachments/），数据库存相对路径。删除文件失败时保留记录并提示重试。
- 成长记录：可关联孩子和课程，日期存 YYYY-MM-DD 字符串；类型支持多选，`Achievement.type` 保存主类型，`AchievementTypeLink` 保存全部类型快照。
- 成长记录费用：不在 `Achievement` 保存金额；勾选产生费用时创建关联 `Payment.achievementId`，产生费用必须关联课程，统计仍只汇总 `Payment`。
- 图片选择：使用 image_picker 库，支持相册选择，最大 1920px，质量 85%。
- M5 已上课/缺课/补课才扣课时，请假/取消不创建消耗流水。
- M4 余额计算：由 CreditTransaction 流水求和得到，不维护单字段。
- M7 统计聚合：CourseStatisticsService 纯领域服务，从已有 DAO 数据聚合计算。时间线聚合上课记录、成就和购课事件。
- M7 照片墙：通过 AttachmentDao.getByOwnerIds 批量查询，支持成就和上课记录附件。
- M8 备份：zip 包含 manifest.json + 数据库文件 + 附件目录。manifest 记录格式版本、App 版本、schema 版本、导出时间和附件清单。
- M8 恢复：先校验 manifest 和文件完整性，覆盖式恢复前有确认弹窗，失败时回滚到 .bak 文件。
- M8 导出：JSON 全量导出为单文件，CSV 每张表一个文件打包为 zip。导出代码已实现但原型未展示入口。
- 反馈代理：通过 Cloudflare Worker 转发飞书 webhook，隐藏真实 webhook 地址。自定义域名 `feishufeedback.riddles.top` 已作为默认值写入代码，FEEDBACK_TOKEN 通过 `--dart-define` 编译时注入。Worker 源码在 `infra/cloudflare-workers/feedback-proxy.js`。

## 最近验证

- `dart run build_runner build --delete-conflicting-outputs` 通过（使用 Flutter SDK 内置 `dart.exe`）。
- `dart format .` 通过。
- `flutter analyze` 通过。
- `flutter test` 通过。
- `dart format lib\features\feedback\presentation\appreciation_page.dart` 通过。
- `dart format lib\features\contacts\presentation\contact_form_page.dart` 通过。
- `flutter analyze` 通过。
- `flutter test` 通过。
- `flutter analyze` 通过（0 issue from M8 code）。
- `dart format` 通过。
- `dart run build_runner build` 代码生成通过。

## 最后更新

2026-05-17（成长记录增强：类型多选与费用联动）
