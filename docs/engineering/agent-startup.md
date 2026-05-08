# Agent 开工定位流程

本文解决“每次新对话开始，AI agent 如何快速知道从哪里开始工作”的问题。

## 固定启动顺序

每次新对话或上下文恢复后，agent 必须按以下顺序定位：

1. 读取根目录 [../../AGENTS.md](../../AGENTS.md)。
2. 读取 [project-status.md](project-status.md)，确认当前阶段、最近完成、下一步和阻塞项。
3. 如果用户消息提到具体文件，读取该文件。
4. 根据任务类型读取一份最相关的流程文档：
   - 需求、UI、发布相关：读 [delivery-lifecycle.md](delivery-lifecycle.md)。
   - 开发实现相关：读 [ai-agent-workflow.md](ai-agent-workflow.md)。
   - 架构相关：读 [architecture.md](architecture.md)。
   - 领域规则相关：读 [domain-model.md](domain-model.md)。
   - 测试验收相关：读 [quality-gates.md](quality-gates.md)。
5. 明确本次任务属于哪个阶段和哪个切片。
6. 从 `project-status.md` 的“下一步”继续，除非用户本轮消息明确改变方向。

## 开工判断矩阵

| 用户请求 | 当前阶段判断 | 先读文档 | 产物 |
| --- | --- | --- | --- |
| “帮我完善需求” | P1/P2 | `delivery-lifecycle.md`、产品源文档 | PRD、验收标准、问题清单 |
| “设计页面/UI” | P3/P4 | `delivery-lifecycle.md`、`feature-slices.md` | IA、流程、高保真 HTML 原型、页面规格 |
| “开始开发” | P5/P6 | `project-status.md`、`architecture.md`、相关切片 | 代码、测试、更新状态 |
| “修 bug” | P6/P7 | `project-status.md`、相关代码和测试 | 修复、回归验证 |
| “验收/测试” | P7 | `quality-gates.md`、验收标准 | 测试报告、问题清单 |
| “准备发布” | P8 | `delivery-lifecycle.md`、`quality-gates.md` | 发布说明、构建说明 |

## 任务启动输出

非平凡任务开工前，agent 应用短句说明：

```text
当前定位：
- 阶段：
- 切片：
- 我将读取：
- 本次产物：
- 验证方式：
```

如果用户只问一个简单问题，可以直接回答，不需要展开完整启动输出。

## 项目状态文件维护

[project-status.md](project-status.md) 是跨对话交接文件，必须保持短、准、新。

每次完成以下工作后都要更新：

- 阶段变化。
- 里程碑完成。
- 新增或关闭阻塞项。
- 新增关键决策。
- 完成一个功能切片。
- 发现影响后续 agent 的风险。

不要把详细实现过程写进状态文件。状态文件只回答：

- 当前在哪里。
- 上次完成了什么。
- 下一步做什么。
- 有什么阻塞。
- 重要文档在哪里。

## 状态文件更新模板

```text
当前阶段：
当前切片：
最近完成：
下一步：
阻塞项：
关键决策：
最近验证：
最后更新：
```

## 用户消息优先级

如果 `project-status.md` 和用户当前消息冲突，以用户当前消息为准。任务完成后，更新 `project-status.md` 反映新的方向。

如果用户当前消息很模糊，则以 `project-status.md` 的“下一步”为默认工作方向。

## 快速恢复原则

agent 不应依赖上一轮聊天记忆来判断项目状态。聊天上下文可能压缩或丢失，`project-status.md` 才是跨会话事实来源。

如果状态文件缺失或明显过期，agent 应先重建状态：

1. 扫描仓库结构。
2. 读取最近相关文档。
3. 检查是否有实际代码和测试。
4. 输出“事实 / 推测 / 待确认”。
5. 更新 `project-status.md`。
