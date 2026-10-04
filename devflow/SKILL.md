---
name: devflow
description: 开发流程总指挥工作流（devflow 家族·开发变体）。输入需求后按规模分级执行：需求对齐→规划→开发→按级TDD→全量测试→合规检查→交付核对。本对话窗口担任总指挥。
argument-hint: "<需求描述>"
user-invocable: true
---

# /devflow — 开发工作流（devflow 家族·开发变体）

先读取 `~/.claude/skills/devflow-base/SKILL.md` 获取公共骨架（角色与约束、命名约定、阶段 1~3/6~8、Gate 规则），再按下述差异执行。

## 差异点

### 阶段 0（任务分级，启动先判断）
- 启动后立即按**预估工时 + 影响面**判断规模，有疑问先问用户：
  - **S（轻量）**：≤30 分钟、单文件/单模块、无数据/权限/API 结构变更 → 直接写需求文档 → 最小实现 → 轻量测试 → 交付核对；跳过：拷问、技术调研、规划、并行执行、TDD 完整循环。
  - **M（标准）**：半天内、改动 1~3 个模块 → 完整阶段，TDD 用 standard 强度，技术调研仅当方案不确定时。
  - **L（重型）**：跨模块、涉数据迁移/权限/新 API、多天 → 全部阶段，TDD 用 strict 强度，强制技术调研与规划。
- 分级结果与裁剪理由写入 `docs/plan/<task>.status.md`；后续各阶段按此档位执行。

### 阶段 1 补充（需求对齐）
- 调用 `grill-me` 时**一次对齐全部事项**，不遗留到实现期：
  1. 需求逐条确认：目标、范围、验收标准；
  2. **潜在问题对齐**：需求与现有代码/文档的匹配度、需求不完善处、关联小 bug、边界与失败场景、未知项；
  3. 多方案时给出可选方案与推荐项。
- S 级跳过拷问直接写 `docs/requirements/<task>.req.md`（仍须含需求清单 + 已对齐问题清单）。

### 阶段 2 补充（技术调研 + 前端设计调研）
- **按需子步骤**：L 级强制，M 级在技术方案不确定时执行，S 级跳过。
- 用 **`crw search`** 搜索设计方案/最佳实践 → 用 **`npx @arabold/docs-mcp-server@latest search`** 查询已索引的库文档（未索引时先用 `scrape` 建立索引）→ 对比给出推荐与取舍，写入计划。目的：决策贴合实际，避免返工。
- 涉及数据/权限/API 结构变更时，计划须附书面方案（现状、模型、迁移与回滚）；方案写入计划后自动实施。

- **前端设计调研（涉 UI 时强制）**：
  1. 扫描 `项目/.claude/AGENTS.md` 设计规则模块，提取硬性约束（配色、字体、组件规范）。
  2. 调用 `/ui-ux-pro-max-skill` 获取设计智能：配色方案、排版层次、动效策略、无障碍合规、响应式断点。
  3. 用 `npx @arabold/docs-mcp-server@latest search` 查询已索引的 Aceternity UI（React/Next.js 动效组件库）和 IKun UI（Svelte/UnoCSS 组件库）文档，按需求场景选型。未索引时先用 `scrape` 建立索引。
  4. 设计氛围：「《黑客帝国》— 编程语言是用来思考的」→ 极客美学、深色系、高对比、代码质感、赛博朋克气质。
  5. 产出设计决策摘要 `docs/plan/<task>.design.md`，实现阶段必须遵循。

### 阶段 4（实现，按级 TDD）
- 涉及前端组件实现时，**必须**优先使用 Aceternity UI 或 IKun UI 的组件，不得从零手写等效组件。
  - React/Next.js 项目 → Aceternity UI 优先（`npx aceternity-ui`，Tailwind CSS + Framer Motion）。
  - Svelte 项目 → IKun UI 优先（`pnpm add @ikun-ui/<component>`，UnoCSS）。
  - 实现前先用 `npx @arabold/docs-mcp-server@latest search` 查询对应组件的最新用法（未索引时先用 `scrape`），不依赖记忆中的旧 API。
- 按阶段 0 的分级选择 `tdd-workflow` 强度：
  - **L（strict）**：完整 TDD 循环 — RED 实测 → 最小实现 GREEN → 重构 → 覆盖率 ≥80% → Git checkpoint → 写 TDD 证据报告 `docs/testing/<task>.tdd.md`。
  - **M（standard）**：RED 实测 → GREEN → 重构 → 覆盖率记录（不强制 80% 门槛）→ 精简版证据报告。
  - **S（light）**：仅新行为核心测试先行 + 现有测试回归通过；不强制 RED 证据与覆盖率报告。
- 证据须记录实际执行的命令与输出，不得虚构 RED/GREEN 结果。

### 阶段 5（无独立审查）
- 开发变体不设独立代码审查阶段；实现直接进入公共阶段 6（testing-quality-agent 全量测试）。
