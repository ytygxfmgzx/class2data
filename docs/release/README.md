# 发布目录

本目录承载发布说明、构建说明、已知问题和版本记录。

## 推荐结构

```text
docs/release/
  README.md
  build-instructions.md
  known-issues.md
  v0.1.0-release-notes.md
```

## 产物职责

- `build-instructions.md`：如何构建 Android 安装包、需要的环境和命令。
- `known-issues.md`：已知问题、影响范围、规避方式。
- `v0.1.0-release-notes.md`：版本能力、修复、限制和备份提醒。

## 发布通过标准

- 构建命令可复现。
- 安装包可在 Android 设备或模拟器运行。
- 新安装环境主路径验收通过。
- 备份恢复通过验证。
- 发布说明清楚说明能做什么、不能做什么。

## Agent 使用方式

- 只有测试验收通过后才进入发布产物准备。
- 任何已知缺陷必须同步到 `known-issues.md`。
- 发布说明不能夸大未完成能力。
