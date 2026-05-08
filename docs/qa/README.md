# QA 与验收目录

本目录承载测试计划、手工验收脚本、验收报告和发布前问题清单。

## 推荐结构

```text
docs/qa/
  README.md
  test-plan.md
  manual-test-scripts.md
  acceptance-report.md
  issue-log.md
  release-checklist.md
```

## 产物职责

- `test-plan.md`：测试范围、测试类型、风险重点。
- `manual-test-scripts.md`：人工验收步骤，覆盖第一版主路径。
- `acceptance-report.md`：验收结果、通过项、失败项、剩余风险。
- `issue-log.md`：缺陷和体验问题记录。
- `release-checklist.md`：发布前检查清单。

## 验收通过标准

- 主路径完整通过：添加孩子、添加课程、添加计划、添加课包、首页记录上课、查看余额和统计、添加附件、导出备份、恢复备份。
- 高风险业务规则有自动化测试。
- UI 关键页面与设计规格一致。
- 发布前无阻塞缺陷。
- 已知问题写入发布说明。

## Agent 使用方式

- 做测试任务时，先读 [../engineering/quality-gates.md](../engineering/quality-gates.md)。
- 开发完成一个切片后，补充或更新相关验收脚本。
- 发布前必须形成 `acceptance-report.md` 和 `release-checklist.md`。
