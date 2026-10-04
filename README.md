# DevFlow 工作流

一套基于 Claude Code 的智能开发工作流系统，包含开发、重构、文档管理、性能优化、视频提示词生成五种可调用工作流，以及一个公共流水线骨架 `devflow-base`。

## 🚀 快速开始

### 从 GitHub 安装（推荐）

```bash
# 克隆仓库
git clone https://github.com/UstinianDev/workflow-templates.git
cd workflow-templates

# 运行安装脚本
chmod +x install.sh
./install.sh
```

安装脚本会自动：
- 检测 Claude Code 安装路径
- 将所有含 `SKILL.md` 的工作流与依赖 skills 复制到 `~/.claude/skills/devflow-workflows/`
- 清理 `__pycache__` 等构建产物
- 验证安装是否成功

### 手动安装

如果自动安装不成功，可以手动复制：

```bash
# 克隆仓库
git clone https://github.com/UstinianDev/workflow-templates.git
cd workflow-templates

# 复制 6 个工作流（含公共骨架）
cp -r devflow-base devflow devflow-refactor devflow-documents devflow-perf devflow-video ~/.claude/skills/

# 复制内部依赖 skills
cp -r grill-me grilling tdd-workflow code-refactor-master testing-quality-agent \
      skill-comply agent-skill-creator docs-cli fastcrw-skill ui-ux-pro-max ~/.claude/skills/
```

### 使用

安装完成后，在 Claude Code 中输入：

- `/devflow <需求描述>` — 启动开发工作流
- `/devflow-refactor <重构目标>` — 启动重构工作流
- `/devflow-documents` — 启动文档管理工作流
- `/devflow-perf <优化目标>` — 启动性能优化工作流
- `/devflow-video <需求描述> [风格模板名]` — 启动视频提示词生成工作流

**注意**：用户输入 `/` 时只会显示上述 5 个工作流。

## 📋 工作流说明

### devflow-base（公共骨架，非入口）

devflow 家族的公共流水线骨架，设置 `disable-model-invocation: true`，**不在 `/` 中显示**，仅供 `/devflow`、`/devflow-refactor`、`/devflow-perf` 等变体读取。内容包括：

- 角色与约束（总指挥 / 子智能体结构化摘要 / 上下文管理）
- 命名约定（`<task>` slug 贯穿所有产物路径）
- 阶段 0 任务分级与分类（请求类型 → 影响面 → 工时 → S/M/L）
- 阶段 1~3：需求对齐（grill-me）、规划与技术调研、并行执行
- 阶段 2.5 前端设计规则加载（涉 UI 时）
- 阶段 6~8：全量测试、模块连通性验证、合规核对、交付核对
- 档位传递规则与 TDD 三档（strict / standard / light）
- Gate 规则：验收不通过即停下报告

### devflow（开发工作流）

适用于新功能开发，按规模分级执行：

1. **任务分级**：自动判断 S/M/L 规模
2. **需求对齐**：通过 `grill-me` 会话一次对齐所有需求
3. **规划**：生成实施计划（L级包含技术调研，涉 UI 时含前端设计调研）
4. **并行执行**：按模块拆分任务并行开发
5. **TDD 开发**：按档位执行测试驱动开发
6. **全量测试**：质量门禁检查
7. **合规核对**：代码与规范一致性检查
8. **交付核对**：变更清单核对

### devflow-refactor（重构工作流）

适用于代码重构，保持外部行为不变：

1. **任务分级**：自动判断 S/M/L 重构规模
2. **需求对齐**：明确重构目标和范围
3. **技术调研**：L级强制，M级按需
4. **建立测试基线**：确保重构不改变行为
5. **按档重构**：S级小步重构，M/L级使用 `code-refactor-master`
6. **代码审查**：L/M级进行独立审查
7. **模块连通性验证**：M/L级强制
8. **全量测试**：质量门禁检查
9. **交付核对**：变更清单核对

### devflow-documents（文档管理工作流）

纯文档管理，不涉及代码实现，不引用 devflow-base：

1. **快速扫描**：检查项目文档存在性和 devflow 产出
2. **增量判断**：对每个文档先判断再动手，存在且合理则跳过
3. **按需创建/更新**：
   - README.md — 项目简介、技术栈、运行方式
   - TODO.md — 功能进度、已知问题
   - API.md — 接口文档（从代码自动提取）
   - modules/ — 各模块文档
4. **同步 CLAUDE.md**：更新项目级文档索引

### devflow-perf（性能优化工作流）

自动扫描瓶颈、分步优化、行为守护：

1. **分级 + 瓶颈扫描**：加载 `rules/perf-rules-*.md` 规则库逐文件扫描，产出瓶颈报告
2. **需求对齐**：M/L 级调用 `grill-me` 对齐优化范围与验收标准
3. **规划**：变更清单即白名单，锁定优化范围
4. **并行执行**：按计划拆分任务派发
5. **逐项优化 + 行为守护**：每项优化后跑回归测试，失败立即回滚（非 TDD）
6. **审查与连通性验证**：/review + 模块连通性验证（M/L 强制）
7. **全量测试与合规核对**
8. **交付**：必须输出修改前后执行速度对比表格

### devflow-video（视频提示词生成工作流）

输入故事/需求 + 可选风格模板，六步流水线产出可直接粘贴进 AI 视频工具的完整提示词：

1. **需求对齐**（grill-me/grilling，含四条客观跳过门槛）
2. **要素提取与映射**：口语→电影术语映射、贯穿主体判定（角色卡 vs chaining）
3. **Plan 分镜规划**：时间轴对齐、参考帧链路标注
4. **提示词生成**：三句话填空法 + 审美参数拆解
5. **四原则自检**：具体性 / 非矛盾 / 正面描述 / 不过度指定
6. **结构化输出**：按 `<项目名>/` 模块分文件夹落盘（storyboard / visual-prompt / self-check / risks 等）
7. **出片对照回修**（可选）：用户回传出片结果时触发，回写规则库

内置规则与资源（渐进式披露，按需读取）：

- `rules/core-rules.md` — 核心规则与四原则可执行规格（每次必读）
- `rules/examples/` — 4 个 few-shot 范例
- `references/` — 术语映射、镜头词库、审美参数、时间戳法、chaining、角色卡、模型矩阵
- `templates/` — 风格模板（如 `game-of-thrones-style.md`）

## 🎯 规模分级

| 规模 | 适用场景 | 流程裁剪 |
|------|----------|----------|
| **S（轻量）** | ≤30分钟，单文件/模块 | 跳过拷问、调研、规划、并行、完整TDD |
| **M（标准）** | 半天内，1-3个模块 | 完整流程，TDD standard |
| **L（重型）** | 跨模块，涉数据/权限/API | 全部阶段，TDD strict，强制调研 |

## 🔧 内部依赖

以下 skills 作为内部依赖，由工作流自动调用：

**不显示在 `/` 命令中（无 user-invocable）：**

- `devflow-base` — 公共骨架（disable-model-invocation）
- `grill-me` / `grilling` — 需求对齐会话
- `tdd-workflow` — 测试驱动开发工作流
- `code-refactor-master` — 代码重构专家
- `skill-comply` — 合规检查工具
- `docs-cli` — 库文档索引与搜索（npx @arabold/docs-mcp-server）
- `fastcrw-skill` — 网页搜索与爬取（crw search / crw crawl）
- `ui-ux-pro-max` — 前端设计智能（涉 UI 需求时加载）

**源定义为可手动调用，主要供工作流内部调用：**

- `testing-quality-agent` — 测试与质量智能体（全量测试与质量门禁）
- `agent-skill-creator` — 智能体创建工具

## 📁 产出物结构

```
docs/
├── requirements/    # 需求文档
├── plan/            # 实施计划、状态、瓶颈报告、设计决策、连通性报告
├── testing/         # TDD 证据报告
├── refactor/        # 重构报告
├── modules/         # 各模块文档（devflow-documents 生成）
├── README.md        # 项目文档索引（devflow-documents 生成）
├── TODO.md          # 功能进度（devflow-documents 生成）
└── API.md           # 接口文档（devflow-documents 生成）
```

## ⚙️ 配置要求

- Claude Code 环境
- `crw` 命令（fastcrw-skill，技术调研与热点检索）
- `npx @arabold/docs-mcp-server`（docs-cli，库文档索引查询）

## 📝 注意事项

1. 每个工作流都会自动判断任务规模并裁剪流程
2. L级任务会强制进行技术调研和详细规划
3. 所有工作流都遵循 Gate 规则：验收不通过会停下报告
4. 测试是安全网：先写测试，保持全绿，绝不削弱测试套件
5. `devflow-base` 及多数依赖 skills 不在 `/` 中显示，仅供工作流内部读取/调用

## 🧪 测试安装

安装后可以运行测试脚本验证安装是否正确：

```bash
chmod +x test-install.sh
./test-install.sh
```

## 🤝 贡献

欢迎提交 Issue 和 Pull Request！

## 📄 许可证

MIT License
