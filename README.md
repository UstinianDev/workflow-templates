# DevFlow 工作流

一套基于 Claude Code 的智能开发工作流系统，包含开发和重构两种工作流变体。

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
- 将工作流文件复制到 `~/.claude/skills/` 目录
- 验证安装是否成功

### 手动安装

如果自动安装不成功，可以手动复制：

```bash
# 克隆仓库
git clone https://github.com/UstinianDev/workflow-templates.git
cd workflow-templates

# 复制到用户级 skills 目录
cp -r devflow-core ~/.claude/skills/
cp -r devflow-refactor ~/.claude/skills/
cp -r grill-me ~/.claude/skills/
cp -r grilling ~/.claude/skills/
cp -r tdd-workflow ~/.claude/skills/
cp -r code-refactor-master ~/.claude/skills/
cp -r testing-quality-agent ~/.claude/skills/
cp -r skill-comply ~/.claude/skills/
cp -r agent-skill-creator ~/.claude/skills/
```

### 使用

安装完成后，在 Claude Code 中输入：

- `/devflow-core <需求描述>` — 启动开发工作流
- `/devflow-refactor <重构目标>` — 启动重构工作流

**注意**：用户输入 `/` 时只会显示这两个工作流，其他依赖的 skills 不会显示。

## 📋 工作流说明

### devflow-core（开发工作流）

适用于新功能开发，按规模分级执行：

1. **任务分级**：自动判断 S/M/L 规模
2. **需求对齐**：通过 `grill-me` 会话一次对齐所有需求
3. **规划**：生成实施计划（L级包含技术调研）
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
7. **全量测试**：质量门禁检查
8. **交付核对**：变更清单核对

## 🎯 规模分级

| 规模 | 适用场景 | 流程裁剪 |
|------|----------|----------|
| **S（轻量）** | ≤30分钟，单文件/模块 | 跳过拷问、调研、规划、并行、完整TDD |
| **M（标准）** | 半天内，1-3个模块 | 完整流程，TDD standard |
| **L（重型）** | 跨模块，涉数据/权限/API | 全部阶段，TDD strict，强制调研 |

## 🔧 内部依赖

以下 skills 作为内部依赖，不会显示在 `/` 命令中：

- `grill-me` / `grilling` — 需求对齐会话
- `tdd-workflow` — 测试驱动开发工作流
- `code-refactor-master` — 代码重构专家
- `testing-quality-agent` — 测试与质量智能体
- `skill-comply` — 合规检查工具
- `agent-skill-creator` — 智能体创建工具

## 📁 产出物结构

```
docs/
├── requirements/    # 需求文档
├── plan/           # 实施计划和状态
├── testing/        # TDD 证据报告
└── refactor/       # 重构报告
```

## ⚙️ 配置要求

- Claude Code 环境
- 支持 Firecrawl 搜索（技术调研）
- 支持 Context7 查询（文档查询）

## 📝 注意事项

1. 每个工作流都会自动判断任务规模并裁剪流程
2. L级任务会强制进行技术调研和详细规划
3. 所有工作流都遵循 Gate 规则：验收不通过会停下报告
4. 测试是安全网：先写测试，保持全绿，绝不削弱测试套件

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
