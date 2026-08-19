---
name: tdd-workflow
description: 测试驱动开发工作流（devflow 家族精简版）。按档位执行 RED→GREEN→重构循环。支持档位参数（strict/standard/light），无参数默认 standard。
argument-hint: "<档位?:strict|standard|light> <任务/计划>"
---

# TDD Workflow（档位驱动精简版）

按调用方传入的档位执行测试先行开发。**档位未指定时默认 standard。**

## 档位与要求

| 档位 | 适用 | RED 门槛 | 覆盖率 | Git checkpoint | 证据报告 |
|------|------|----------|--------|----------------|----------|
| **strict** | L 级（重型） | 必须实测失败 | ≥80% 门槛 | 强制（RED/GREEN/重构各一次） | 完整版 |
| **standard** | M 级（标准） | 必须实测失败 | 记录数值，不强制门槛 | 可选 | 精简版 |
| **light** | S 级（轻量） | 仅新行为核心测试先行 | 不要求 | 跳过 | 不写，交付时口头核对 |

## 流程

### Step 0：探测测试运行器

- 读 `package.json` 的 `scripts.test` 与现有测试文件，确定 runner（jest / vitest / pytest / go test 等）与命令（`<test>`、`<coverage>`）。
- 不假设 `npm test`；按项目实际命令执行。

### Step 1：RED — 先写失败测试

- 为每个计划行为写最小测试（核心行为优先）。
- 运行并**确认失败原因符合预期**（是目标 bug/缺失实现所致，不是 setup/环境错误）。
- 只写未运行不算 RED。strict 档在 RED 验证后提交 `test: <行为>`。

### Step 2：GREEN — 最小实现

- 写让测试通过的最小代码；重跑同一测试目标，确认转绿。
- strict 档在 GREEN 验证后提交 `fix: <行为>`；standard 档按需提交。

### Step 3：重构

- 保持测试全绿前提下消除重复、改进命名、拆分过长逻辑。每次小步，跑测试确认。

### Step 4：覆盖率（按档）

- strict：跑 `<coverage>`，确认 ≥80%（或项目阈值）；为缺口补测试，不靠删代码/弱断言刷覆盖率。
- standard：跑 `<coverage>` 记录数值，不强制门槛。
- light：跳过。

### Step 5：证据报告（strict/standard）

- 写 `docs/testing/<task>.tdd.md`，内容：行为清单、每条行为的验证命令与实际输出（含 RED/GREEN）、测试保证表（# / 保证内容 / 测试位置 / 类型 / 结果）、覆盖率与已知缺口。
- **只引实际命令输出，不虚构 PASS。**

## 铁律

- 先写测试再实现；未验证 RED 不动生产代码。
- 不删测试、不弱化断言、不跳过失败。
- 测试独立、确定、快速。
- 无档位参数时默认 standard；若调用方显式给出档位，按其分支执行。
