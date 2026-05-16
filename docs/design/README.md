# 设计产物目录

本目录承载”信息架构 -> 交互流程 -> UI 设计”的产物。它是产品规格和开发实现之间的桥梁。

注意：Markdown 文件只负责说明设计规则、页面行为和验收标准；本项目的 UI 确认主产物是高保真、可交互的 HTML 原型。用户确认 HTML 原型的样式和流程后，才能进入 Flutter 开发。

设计方向：**实用工具型** — 高信息密度、功能优先、零装饰。详见 `visual-system.md` 和 `ui-guidelines.md`。

## 推荐结构

```text
docs/design/
  README.md
  information-architecture.md
  user-flows.md
  screen-inventory.md
  ui-guidelines.md
  visual-system.md
  wireframes/
    home.svg
    record-class.svg
  mockups/
    home.png
    record-class.png
  prototypes/
    README.md
    html/
      index.html
      styles.css
      app.js
      assets/
  screenshots/
    home-android.png
  screen-specs/
    home.md
    course-detail.md
    record-class.md
    package-form.md
    backup-restore.md
```

## 产物职责

- `information-architecture.md`：导航、页面层级、信息分组。
- `user-flows.md`：关键操作路径和异常路径。
- `screen-inventory.md`：页面清单、入口、出口、依赖数据。
- `ui-guidelines.md`：移动端体验原则、文案、布局、表单和状态规范。
- `visual-system.md`：色彩、字体、间距、圆角、图标和组件基础规则。
- `wireframes/`：可选的低保真页面线框图，用于复杂流程的早期沟通。
- `mockups/`：可选的静态视觉稿；如果已有高保真 HTML 原型，可以不单独输出。
- `prototypes/html/`：本项目 UI 设计的主产物，高保真、可交互、本地可打开的 HTML 原型。
- `screenshots/`：开发实现后的页面截图，用于 UI 还原验收。
- `screen-specs/`：每个关键页面的布局、状态、交互、HTML 原型入口和验收说明。

## UI 产物层级

本项目 UI 设计的必交付物：

1. 高保真可交互 HTML 原型：用于确认视觉风格、真实文案、页面跳转、弹层、表单和主路径效率。
2. 页面规格说明：记录每个页面的状态、字段、交互和验收标准。
3. 开发截图：用于确认 Flutter 实现是否还原 HTML 原型。

可选产物：

- 低保真 wireframe：当页面流程复杂、需要先确认结构时使用。
- 静态 mockup：当需要单独展示某个视觉方向时使用。

推荐流程：

```text
产品规格 -> 用户流程 -> 高保真 HTML 原型 -> 用户确认 -> Flutter 开发实现 -> 截图验收
```

不能只交付 Markdown 页面说明就进入开发。除非用户明确豁免，关键页面必须先有可打开、可点击、能体现真实样式的 HTML 原型。

## UI 设计通过标准

- 首页、记录上课、课程详情、课包续费、备份恢复必须出现在高保真 HTML 原型中。
- HTML 原型必须能在本地浏览器打开，支持移动端视口预览。
- HTML 原型必须包含页面跳转、底部导航、关键弹层、表单状态和主要异常状态。
- 每个 `screen-specs/*.md` 必须链接对应 HTML 原型页面或交互入口。
- 每个页面必须覆盖正常、空、加载、错误和边界状态。
- 日常记录路径必须支持不超过 10 秒的操作目标。
- UI 文案必须短、清晰、符合家长日常语言。
- 设计必须能被 Flutter 实现，不依赖不可得资源。

## Agent 使用方式

- 做 UI 前先确认产品规格，不要先画页面再倒推需求。
- 做开发前先确认对应页面规格和 HTML 原型是否存在。
- 如果页面规格或 HTML 原型缺失，先补 `screen-specs/` 和 `prototypes/html/`，再写 Flutter 代码。
