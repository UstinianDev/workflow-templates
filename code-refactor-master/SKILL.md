---
name: code-refactor-master
description: 代码重构专家（devflow 家族精简版）。提供坏味道清单、重构目录与按档位执行的重构流程。支持档位参数（S/M/L）。
allowed-tools: Read, Glob, Grep, Edit, LSP
---

# Code Refactor Master（档位驱动精简版）

## 何时使用

- 重构既有代码、消除坏味道、提升可读性与可维护性、优化性能且不改变行为、清理技术债。
- 由 `devflow-refactor` 按档位调用；S 级小重构可不调用本 skill。

## Golden Rule

- 改动内部结构，不改变外部行为；一次只做一种重构；每步跑测试；保持向后兼容。
- 重构与功能开发分离。

## 需要重构的信号

- 重复代码（DRY）、长方法（>20-30 行）、大类（>300-500 行）、过长参数表（>3-4 个）、深度嵌套（>3 层）、解释性注释。

## 坏味道清单

- **Bloaters**：长方法、大类、原始类型偏执、长参数表、数据泥团。
- **OO 滥用**：switch 语句（考虑多态）、临时字段、被拒绝的遗赠、异族同类接口。
- **变更阻碍者**：发散式变化、霰弹式修改、平行继承体系。
- **可有可无**：解释性注释、重复代码、懒惰类、死代码、过度前瞻性泛化。
- **耦合**：依恋情结、过度亲密、消息链、中间人。

## 重构目录（要点）

- **方法级**：Extract Method / Inline Method / Replace Temp with Query（拆分过长方法、消除临时变量）。
- **变量级**：Rename Variable / Split Temporary Variable。
- **类级**：Extract Class / Replace Conditional with Polymorphism（拆大类、消灭条件分支）。
- **Java 惯用**：Lambda 替换匿名类、Streams、StringBuilder / String.join、Optional 替代判空返回、Enum 替代类型码。
- **Python 惯用**：列表推导式、collections.Counter、with 上下文管理器、f-string、类型注解、@dataclass。
- **性能**：算法降阶（如 set 判重 O(n²)→O(n)）、惰性求值（findFirst 替代 collect 全量）、lru_cache 记忆化。

## 执行流程（按档位）

### S（轻量重构）

1. 跑通现有测试作基线。
2. 一次一个改动 → 每步跑测试 → 保持行为不变。
3. 不强制 Git checkpoint（交给总指挥交付阶段统一核对）。

### M / L（标准/重型）

1. 确认测试基线存在且全绿（无测试先补）。
2. 一次只做一种重构 → 每步跑测试 → 保持行为不变、向后兼容。
3. 消除坏味道：从重复、长方法、大类别、嵌套、参数表入手。
4. 记录重构报告 `docs/refactor/<task>.refactor.md`（前后对比、应用的模式、每步测试结果）。
5. L 级每步重构后按需 Git checkpoint；commit 由总指挥统一放行，本 skill 不自行提交。

## 检查清单

- **前**：测试存在且通过、理解行为、有明确目标、知道用哪种重构。
- **中**：小步改动、每步跑测试、保持随时可运行。
- **后**：全测试通过、可读性提升、复杂度下降、无行为变化、文档已同步（如需）。

## Anti-Patterns（不要做）

- 无测试重构、重构中改变行为、一次多个改动、重构与加功能混做、过度设计、过早优化。

## 工具

- 优先用 IDE 自动重构（重命名、提取方法/变量、内联、移动）——安全且有预览。
