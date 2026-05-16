# 高保真 HTML 原型

## 当前版本

`prototype-v2.html` — 单文件 inline React 原型，双击即可在浏览器中运行。

### 覆盖页面

| 页面 | 路由 |
|------|------|
| 首页（周视图、课程列表） | home |
| 成长时间线 | growth |
| 设置 | settings |
| 课程详情 | course-detail |
| 照片墙 | photo-wall |
| 孩子管理 / 录入 | child-manage / child-form |
| 课程管理 / 录入 | course-manage / course-form |
| 课程计划维护 / 添加 | plan-manage / plan-form |
| 标签管理 | tag-manage |
| 备份与恢复 | backup |
| 通知设置 | notification |
| 录入课时包 | package-form |
| 录入成就 | achievement-form |
| 记录上课（底部弹窗） | modal: record |
| 照片查看器（全屏弹窗） | modal: photo-viewer |

### 运行方式

直接用浏览器打开 `prototype-v2.html` 即可。需要网络加载 React/Babel CDN。

### 设计规格

- 设备框：iPhone 15 Pro（393×852）
- 配色/字体/间距遵循 `docs/design/visual-system.md`
- 交互说明参考 `docs/design/ui-guidelines.md`

## 开发约束

- 不依赖真实后端，使用内嵌 mock 数据。
- 不写入真实数据。
- 页面宽度、字体、间距按移动端优先设计。
- 交互状态通过本地 React state 模拟。
