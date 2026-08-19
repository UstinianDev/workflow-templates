---
name: grilling
description: Grill the user relentlessly about a plan, decision, or idea. 需求对齐模式：一次确认需求、潜在问题与多方案。Use when the user wants to stress-test their thinking, or uses any 'grill' trigger phrases.
---

Interview the user relentlessly until you reach a shared understanding.

## 需求对齐模式（devflow 家族调用时启用）

当本次会话目标是**需求对齐 / 需求拷问**（如 `/devflow`、`/devflow-refactor` 调用 `grill-me` 时），**第一轮前先输出结构化对齐清单**，一次对齐全部事项，不遗留到实现期：

1. **需求逐条确认**：目标、范围、验收标准。
2. **潜在问题对齐**：
   - 需求与现有代码/文档的匹配度（有没有"看起来合理但实现不匹配"处）；
   - 需求不完善处、需补充的边界与失败场景；
   - 关联的已知小 bug / 待清理项；
   - 未知项、需查证的事实。
3. **多方案**：有多个合理方向时，给出可选方案与推荐项及理由。

按清单逐项提问并记录结论；所有项确认后，再按下方通用机制处理余下开放决策。

## 通用机制：设计树 + rounds

Map this as a **design tree**: every decision branches into the decisions that hang off it.

Work the tree in **rounds**. The **frontier** is every decision whose prerequisites are already settled — the questions you can ask _now_ without guessing at answers you haven't heard yet. Ask the whole frontier in one round: number each question and give your recommended answer. Then wait for the user's answers before the next round.

Each question should be formatted like so:

```
❓ **Q1** - **<question title>**: <question body, might be multiple paragraphs, including multiple choices>

➡️ <your recommended answer>
```

Each round the user answers reshapes the tree — settled decisions push the frontier outward and unblock questions that depended on them. Recompute the frontier and ask the next round. A question whose answer depends on another question still open in this round belongs to a _later_ round, not this one.

Finding _facts_ is your job, never the user's. When a frontier question needs a fact from the environment (filesystem, tools, etc.), dispatch a sub-agent to find it — don't ask the user for anything you could look up yourself. Don't block on it: a running exploration is an unsettled prerequisite, so only the questions downstream of it wait for the sub-agent to report — ask the rest of the frontier now. The _decisions_ are the user's — put each to them and wait.

The session is done when the frontier is empty: every branch of the design tree visited, nothing left silently assumed. Do not act on it until the user confirms you have reached a shared understanding.
