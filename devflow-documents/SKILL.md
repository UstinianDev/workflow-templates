---
name: devflow-documents
description: devflow 家族·文档管理变体。自动分析项目文档现状，创建/整理/更新 README、TODO 及模块文档到 docs 文件夹，实时同步 CLAUDE.md。
argument-hint: ""
user-invocable: true
---

# /devflow-documents — 文档管理工作流（devflow 家族·文档变体）

纯文档管理，不涉及代码实现，不引用 devflow-core。

## 执行流程

### Step 1: 快速扫描（Glob + 读关键文件）

不做 Explore 全量扫描，只做最小必要收集：

1. **文档存在性**（Glob 一次搞定）：
   - `README.md` 或 `docs/README.md`
   - `TODO.md` 或 `docs/TODO.md`
   - `API.md` 或 `docs/API.md`
   - `docs/modules/` 目录

2. **devflow 产出**（优先读取，作为文档生成的主要输入）：
   - `docs/plan/*.plan.md` — 实施计划，含变更清单和进度
   - `docs/requirements/*.req.md` — 需求文档
   - `docs/testing/*.tdd.md` — 测试报告
   - 有 devflow 产出时，优先从产出提取内容，不重复分析代码

3. **项目信息**（直接读，不扫描）：
   - `package.json` / `requirements.txt` / `go.mod` / `Cargo.toml`（任一存在）
   - `ls` 顶层目录结构

4. **跳过**：Git 历史、配置文件细节、代码结构深度扫描

### Step 2: 增量判断 + 按需处理

对每个文档先判断再动手，存在且结构合理则跳过：

| 文档 | 跳过条件 | 处理条件 |
|------|----------|----------|
| README.md | 存在且含"项目简介""技术栈""如何运行"章节 | 缺失或位置不对或关键章节缺失 |
| TODO.md | 存在且含"已完成""进行中""待开发"章节 | 缺失或位置不对或关键章节缺失 |
| API.md | 存在且有接口条目 | 缺失或位置不对或为空 |
| modules/ | 目录存在且有 ≥1 个模块文档 | 目录不存在或为空 |

**不存在** → 创建并填充
**存在但位置不对** → 询问用户"是否需要将文件移动到 docs/"，用户确认后才移动
**存在但缺章节** → 只补缺失章节，不重写全文

### Step 3: 文档生成规范

#### README.md

```markdown
# {项目名}

## 项目简介
{做什么、解决什么问题，2-3 句}

## 技术栈
{框架、语言、关键依赖，简要列出}

## 目录结构
{主要文件夹的作用，只列关键的}

## 如何运行
{安装依赖、启动命令}
```

- 开发规范只在项目有 .eslintrc / .prettierrc 等配置时才写
- 不单独生成 TECH_STACK.md，技术栈信息在 README 里；项目特别复杂（>10 个核心依赖）时才拆

#### TODO.md

```markdown
# TODO

## 已完成
- {}

## 进行中
- {}

## 待开发
- {}

## 已知问题
- {}
```

- **有 devflow 计划文档时**：从 `docs/plan/*.plan.md` 的"已完成/进行中/待开发"章节直接提取
- **无 devflow 产出时**：从已有文档提取，commit message 仅作补充参考
- 不臆测，不深度扫描代码推断完成度

#### API.md

从代码中提取接口定义，按以下策略扫描：

1. **识别框架**（从 package.json/requirements.txt 依赖判断）：
   - Express/Koa → Grep `router.get/post/put/delete` 或 `app.get/post/...`
   - NestJS → Grep `@Get/@Post/@Put/@Delete` + `@Controller`
   - FastAPI/Flask → Grep `@app.get/post/...` 或 `@router.get/post/...`
   - Spring Boot → Grep `@GetMapping/@PostMapping/@RequestMapping`
   - Go net/http → Grep `http.HandleFunc` 或框架路由注册

2. **提取接口**：从匹配到的路由文件中提取路径、方法、参数、响应类型

3. **无框架或识别失败**：列出疑似路由文件路径，让用户确认

```markdown
# API 接口文档

## 认证
{认证方式说明，如无认证则省略}

## 接口列表

### {模块名/资源名}

#### {METHOD} {路径}
- **说明**：{接口用途}
- **请求参数**：
  | 参数 | 类型 | 必填 | 说明 |
  |------|------|------|------|
  | | | | |
- **响应示例**：
  ```json
  {}
  ```
- **错误码**：
  | 码 | 说明 |
  |----|------|
  | | |
```

- 按模块/资源分组，不分组会导致接口一多就混乱
- 只记录对外暴露的接口，内部函数不写
- 请求参数和响应示例从代码中的类型定义/Schema 提取，不臆测

#### modules/{模块名}.md

只对**已有明确模块划分**的项目生成，不对每个文件都写文档。

**数量控制**：模块 >5 个时，先列出模块清单让用户确认哪些需要生成文档，确认后再执行。

```markdown
# {模块名}

## 做什么
{1-2 句}

## 关键实现
{核心文件、主要逻辑}

## 注意事项
{已知坑、依赖关系}
```

### Step 4: 更新项目级 CLAUDE.md

在**项目根目录**的 `CLAUDE.md` 中追加文档索引（已存在则更新，不重复追加）。不动全局 `~/.claude/CLAUDE.md`。

```markdown
## 项目文档

- [README](docs/README.md) — 项目简介、技术栈、运行方式
- [TODO](docs/TODO.md) — 功能进度、已知问题
- [API](docs/API.md) — 接口文档
- [modules/](docs/modules/) — 各模块文档
- [testing/](docs/testing/) — TDD 测试报告（devflow 生成）

### 查阅规则（渐进式披露）
- 项目是什么、怎么跑 → README.md
- 接口参数、响应格式 → API.md
- 模块实现细节、架构 → docs/modules/{模块名}.md
- 功能进度、已知问题 → TODO.md
- 测试覆盖、验证证据 → docs/testing/
```

### 可选：渐进式拆分

**不自动执行**。仅当用户明确要求或文档确实超过 500 行时，才执行模块化拆分：

1. 识别独立章节
2. 拆分到 `docs/{文档名}/` 子目录
3. 主文档保留索引

## 输出

完成后报告：
1. 创建/更新/跳过了哪些文档
2. CLAUDE.md 变更摘要

## 简洁规范

- 存在且合理 → 跳过，不浪费 token
- 只补缺失项，不重写已有内容
- 内容基于代码事实，不臆测
