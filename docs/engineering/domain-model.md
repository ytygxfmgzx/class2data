# 领域模型与业务不变量

本文把产品设计中的概念转成实现约束。写代码前，如果任务涉及数据库、销课、课包、统计、附件或备份，应先读本文。

## 核心实体

| 实体 | 含义 | 关键关系 |
| --- | --- | --- |
| `Child` | 家里的孩子 | 拥有多个 `KidCourse` |
| `KidCourse` | 某个孩子的一门课 | 归属 `Child`，聚合课程相关数据 |
| `CourseSchedule` | 上课计划 | 归属 `KidCourse`，运行时生成待处理课程 |
| `Package` | 一次购课、续费或赠课形成的权益 | 归属 `KidCourse` |
| `ClassRecord` | 某次上课事件 | 归属 `KidCourse`，可关联 `CourseSchedule` |
| `CreditTransaction` | 课时变化流水 | 归属 `KidCourse`，可关联 `Package` 和 `ClassRecord` |
| `Payment` | 费用记录 | 归属 `KidCourse`，可关联 `Package` |
| `Achievement` | 成就记录 | 归属 `Child`，可关联 `KidCourse` |
| `Attachment` | 照片、截图、合同、奖状等文件元数据 | 归属具体业务对象 |
| `Contact` | 老师、教练、顾问等联系人 | 归属 `KidCourse` |

## ID、时间和精度

- ID 使用稳定字符串或 Drift 支持的整数主键都可以，但同一工程内必须统一。
- 日期字段优先存储本地日期，例如 `YYYY-MM-DD`，适合课程日历和家庭记录。
- 时间字段优先存储本地时间，例如 `HH:mm`。
- `created_at`、`updated_at` 存储完整时间戳。
- 金额不要用浮点数，使用 `amount_cents` 这类整数分单位。
- 课时不要用浮点数，使用定点整数，例如 `credit_units`，约定 `100 = 1 课时`。
- 展示层负责把 `credit_units` 格式化成 `0.5`、`1`、`1.5` 等用户可读文本。

## 类型策略

### 系统语义类型

这些类型影响业务计算，必须使用稳定代码：

- `Package.type`
- `CourseSchedule.schedule_type`
- `CreditTransaction.type`
- `Attachment.owner_type`
- `Attachment.file_type`

实现要求：

- 数据库存储英文稳定 code，例如 `lesson_pack`、`weekly_repeat`、`consume`。
- 中文显示名由代码映射或系统字典提供。
- 不允许用户改名预置 code。
- 不允许用户新增会参与系统计算的新 code。
- 特殊情况使用 `other` 加备注。

### 普通分类标签

这些类型主要用于展示、筛选、统计：

- `KidCourse.category`
- `CourseSchedule.class_type`
- `ClassRecord.class_type`
- `Payment.type`
- `Achievement.type`
- `Contact.role`

实现要求：

- 可以有预置标签和用户自定义标签。
- 历史记录必须保存当时的显示名称快照，例如 `class_type_name_snapshot`。
- 标签改名或隐藏不能改变历史记录含义。

## 课包规则

- 一次购课、续费或赠课必须创建一个新的 `Package`。
- 第一版不支持把续费追加到旧课包。
- `Package.total_credits` 可为空，用于周期卡或不限次卡。
- `Package.amount_cents` 可为空，用于赠课包或金额未知。
- 课包状态可由字段记录，也可根据有效期和流水计算辅助判断，但不能只靠 UI 文案判断。
- 课包余额由关联 `CreditTransaction` 求和得到，不手工维护单个余额字段。

建议余额计算：

```text
package_balance = sum(CreditTransaction.credit_units_delta where package_id = current_package.id)
course_balance = sum(CreditTransaction.credit_units_delta where kid_course_id = current_course.id)
```

周期卡如果没有固定课时，余额展示应显示“周期卡 / 不限次 / 按有效期”，不要伪造课时余额。

## 上课记录与课时流水

`ClassRecord` 是事实事件，`CreditTransaction` 是课时账本。

规则：

- 已上课、缺课、补课等是否扣课时，由本次记录的 `credit_units_cost` 和状态共同决定。
- 请假、取消通常不创建扣课流水，除非用户明确记录扣课。
- `credit_units_cost = 0` 时不创建消耗流水。
- 生成消耗流水时，`CreditTransaction.credit_units_delta` 必须为负数。
- 购课或赠课流水为正数。
- 调整、退款、作废必须有备注。
- 如果扣课但无法确定课包，可创建待确认流水，`package_id` 为空，`type = pending` 或明确待确认状态。
- 修改已入账上课记录时，不直接覆盖旧流水造成账不清。优先使用事务重建相关流水，或保留调整流水。第一版可采用“同一记录相关流水删除后重建”，但必须限定在该 `class_record_id` 下。

## 防重复处理计划课

上课计划运行时生成待处理课程，不提前批量写入数据库。

为了避免同一节计划课重复处理，来自计划的 `ClassRecord` 应保存：

- `schedule_id`
- `schedule_occurrence_date`
- `schedule_occurrence_start_time`
- `schedule_occurrence_key`

建议唯一约束：

```text
unique(schedule_id, schedule_occurrence_key)
```

手动补录的记录可以没有 `schedule_id`。

## 默认值规则

记录上课时默认值来源顺序：

1. 最近一次同课程、同上课类型的记录。
2. 最近一次同课程记录。
3. `KidCourse.default_credit_units_cost` 和 `KidCourse.default_duration_minutes`。
4. 用户手动输入。

默认值只用于带出表单，保存后以本次 `ClassRecord` 为准。历史记录不随课程默认值变化而变化。

## 自动选择课包

推荐算法必须限制在当前 `KidCourse` 下。

候选过滤：

- 排除已作废课包。
- 排除已过期课包，除非用户手动选择并确认。
- 排除已用完课包，除非用户手动调整。
- 生效日期晚于上课日期的课包不自动推荐。

排序规则：

1. 最近一次同课程、同上课类型使用过的可用课包。
2. 最近一次同课程使用过的可用课包。
3. 更早购买的课包。
4. 更早到期的课包。
5. 仍无法判断时标记待确认。

用户始终可以手动改成其他可用课包。

## 附件规则

- 文件本体存入 App 私有目录。
- 数据库只保存相对路径和元数据，不保存绝对系统路径。
- 附件必须有 `owner_type` 和 `owner_id`。
- 删除业务对象前要检查附件归属，避免孤儿文件。
- 备份时必须包含数据库和附件文件。
- 恢复时先校验 manifest，再恢复数据库和附件，避免半恢复状态。

## 统计规则

课程回顾至少区分：

- 上课次数：符合统计口径的 `ClassRecord` 数量。
- 实际上课时长：`duration_minutes` 求和。
- 消耗课时：消耗类 `CreditTransaction` 求和的绝对值。
- 费用投入：`Payment.amount_cents` 求和。
- 当前剩余：课包或课程相关流水求和。

不要用“上课次数”替代“消耗课时”，两者在集训、补课、试听场景下不同。

## 删除与归档

第一版建议：

- 有历史记录的 `Child`、`KidCourse`、`Package` 不做硬删除，改为归档或作废。
- 新建后未产生关联数据的草稿对象可以硬删除。
- 所有会影响账本的删除或作废操作必须可解释，并保留备注。

## 事务边界

以下操作必须使用事务：

- 购课或续费：创建 `Package`、`Payment`、购入流水。
- 记录扣课：创建或更新 `ClassRecord`、消耗流水。
- 修改已入账记录：更新记录、重建或调整相关流水。
- 恢复备份：替换数据库和附件索引。
- 删除带附件的对象：更新业务对象、附件记录和文件状态。

## 迁移规则

- Drift schema 版本每次结构变更都要递增。
- 每次迁移必须保留用户已有数据。
- 迁移测试至少覆盖从上一版本到当前版本。
- 不要随意重命名系统语义 code；必须改名时提供数据迁移。
