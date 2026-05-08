# 工程文档导航

这一组文档把产品方案转成 AI agent 可执行的工程契约。未来任何 agent 接手时，应先从本文件判断需要读取哪些资料。

## 文档地图

- [project-status.md](project-status.md)：跨对话项目状态，记录当前阶段、下一步、阻塞项和最近验证。
- [agent-startup.md](agent-startup.md)：每次新对话或上下文恢复时的开工定位流程。
- [delivery-lifecycle.md](delivery-lifecycle.md)：从需求设计、UI 设计、开发、测试到发布的端到端实施流程。
- [architecture.md](architecture.md)：工程分层、目录结构、模块边界、数据流。
- [domain-model.md](domain-model.md)：领域对象、数据精度、业务不变量、课包与课时流水规则。
- [feature-slices.md](feature-slices.md)：功能切片、页面地图、垂直交付范围。
- [implementation-roadmap.md](implementation-roadmap.md)：从空仓库到第一版可发布 App 的阶段计划。
- [ai-agent-workflow.md](ai-agent-workflow.md)：AI agent 每次接任务时的工作流程和交接模板。
- [quality-gates.md](quality-gates.md)：测试策略、验收标准、发布检查清单。

## Agent 阅读策略

不要机械地全量读取所有文档。

- 每次新对话：先读 `project-status.md`，再读 `agent-startup.md`。
- 做需求、UI、验收、发布流程判断：读 `delivery-lifecycle.md`。
- 做产品范围判断：读 `interest-class-app-design.md` 和 `feature-slices.md`。
- 做架构或目录调整：读 `architecture.md`。
- 做数据库、服务、统计、销课、备份：读 `domain-model.md`。
- 做具体开发任务：读 `ai-agent-workflow.md`、相关功能切片和质量门禁。
- 做里程碑规划：读 `implementation-roadmap.md`。
- 做收尾验收：读 `quality-gates.md`。

## 工程原则

- 先确认当前生命周期阶段，再决定产物；不要跳过需求、交互、UI 和验收标准直接开发。
- 用垂直切片交付用户可感知的能力，不长期停留在孤立底层建设。
- 业务规则放在领域服务和应用服务中，不散落在页面组件里。
- 数据库是事实来源，附件文件由 App 私有目录管理，二者通过元数据关联。
- 所有会影响余额、费用、附件和备份的数据写入都要考虑事务、回滚和可恢复性。
- 文档是工程契约的一部分。代码改变规则时，文档必须同步。

## 第一版完成定义

第一版不是“所有想法都做完”，而是完成一个家长日常能用的闭环：

1. 添加孩子和课程。
2. 添加上课计划。
3. 添加课包和费用记录。
4. 从首页待处理课程记录已上课、请假、取消、缺课或补课。
5. 自动生成课时流水并计算余额。
6. 记录成就、联系人、照片和附件。
7. 查看课程统计、孩子时间线和照片墙。
8. 手动导出完整备份包并可恢复。

## 决策记录规则

当出现会长期影响工程的决定时，新增或更新工程文档，而不是只写在聊天记录里。典型场景：

- 改变技术栈或状态管理方式。
- 改变数据库字段含义、精度或迁移策略。
- 改变课包、销课、附件、备份等核心业务规则。
- 改变目录结构或测试门禁。
- 改变当前阶段、下一步或阻塞项时，必须更新 `project-status.md`。
