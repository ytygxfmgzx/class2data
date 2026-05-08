# 产品规格目录

本目录承载“需求设计 -> 可开发规格”的产物。开发前，如果某个功能缺少这里的规格或验收标准，应先补齐。

## 推荐文件

```text
docs/product/
  README.md
  prd.md
  user-journeys.md
  acceptance-criteria.md
  glossary.md
  open-questions.md
```

## 产物职责

- `prd.md`：第一版产品需求说明，包含目标、范围、非范围、功能说明和约束。
- `user-journeys.md`：用户完成关键任务的路径，例如记录上课、续费、查看余额、备份恢复。
- `acceptance-criteria.md`：每个功能的验收标准，测试和开发都以它为依据。
- `glossary.md`：统一术语，例如孩子课程、课包、课时流水、待处理课程。
- `open-questions.md`：尚未确认的问题，不能混入已定规格。

## 产品规格通过标准

- 每个第一版功能都能追溯到用户问题。
- 每个功能都有可验证的验收标准。
- 范围外内容明确标注，不能进入第一版开发任务。
- 术语和 [../interest-class-app-design.md](../interest-class-app-design.md) 一致。

## Agent 使用方式

- 做需求整理时，先读产品源文档，再在本目录补规格。
- 做开发任务前，确认对应功能在 `acceptance-criteria.md` 中有验收标准。
- 发现需求冲突时，写入 `open-questions.md`，不要直接猜。
