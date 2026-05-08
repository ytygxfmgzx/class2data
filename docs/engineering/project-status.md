# 项目状态

本文件是每次新对话的快速定位入口。保持短、准、新；不要写成长篇日志。

## 当前阶段

- 生命周期阶段：P2 产品规格补齐，随后进入 P3 信息架构与交互流程、P4 UI 设计。
- 工程里程碑：M0 尚未开始。
- 当前切片：无代码切片；尚未进入开发。

## 最近完成

- 已补齐第一版 PRD 草案：[../product/prd.md](../product/prd.md)。
- 已整理第一版产品方案：[../interest-class-app-design.md](../interest-class-app-design.md)。
- 已建立 agent 根入口：[../../AGENTS.md](../../AGENTS.md)。
- 已建立工程文档导航：[README.md](README.md)。
- 已建立架构、领域模型、功能切片、路线图、agent 工作流和质量门禁。
- 已补充端到端实施流程：[delivery-lifecycle.md](delivery-lifecycle.md)。
- 已补充每次对话开工定位流程：[agent-startup.md](agent-startup.md)。
- 已建立产品、设计、QA、发布产物目录说明：
  - [../product/README.md](../product/README.md)
  - [../design/README.md](../design/README.md)
  - [../qa/README.md](../qa/README.md)
  - [../release/README.md](../release/README.md)

## 下一步

推荐顺序：

1. 补齐产品规格文档：
   - `user-journeys.md`
   - `acceptance-criteria.md`
   - `glossary.md`
   - `open-questions.md`
2. 补齐 UI/交互设计产物：
   - `information-architecture.md`
   - `user-flows.md`
   - `screen-inventory.md`
   - `ui-guidelines.md`
   - `visual-system.md`
   - `screen-specs/`
   - `prototypes/html/index.html`
   - `prototypes/html/styles.css`
   - `prototypes/html/app.js`
3. 用户确认产品规格和关键 UI 后，进入 M0：初始化 Flutter 工程到 `app/`。

## 阻塞项

- Flutter 工程尚未初始化。
- 产品规格尚未全部补齐；PRD 草案已完成，仍缺少用户旅程、验收标准、术语表和待确认问题清单。
- UI 设计尚未形成高保真可交互 HTML 原型和可验收页面规格。
- 关键页面尚无 HTML 原型页面或页面规格。

## 关键决策

- 第一版技术路线：Flutter + Riverpod + go_router + Drift + SQLite + App 私有目录 + 本地通知 + 手动备份。
- 第一版不做云同步、多用户协作、Web 后台、复杂 AI 自动识别、完整自动排课算法。
- 一次购课或续费等于一个新课包。
- 课时余额由课包和课时流水计算。
- 附件默认保存到 App 私有目录。
- 备份与恢复是第一版核心功能。

## 最近验证

- 已确认 `docs/product/prd.md` 写入正常，PRD 引用的上游文档路径存在。
- Markdown 本地链接检查通过。
- 已修正 UI 设计产物定义：Markdown 是规格说明，可视化页面才是 UI 交付物。
- 已确定本项目不依赖 Figma，UI 设计主产物为高保真可交互 HTML 原型。
- 未运行 Flutter/Dart 命令，因为 `app/` 工程尚未创建。

## 最后更新

2026-05-08
