---
name: docs-cli
description: 使用 @arabold/docs-mcp-server 的 CLI 模式索引、搜索和获取外部技术文档。当需要查询 LangChain、React、FastAPI 等库的最新文档，或需要将某个文档网站索引到本地以便后续搜索时使用。
allowed-tools: Bash
---

# Docs CLI 外部文档索引与搜索技能

## 核心原则
通过 npx @arabold/docs-mcp-server@latest 的 CLI 命令工作，不需要启动任何 MCP 服务器或常驻进程。所有数据存储在本地，完全免费且无使用次数限制。

## 命令速查

### 1. 索引文档（首次使用或文档更新时）
npx @arabold/docs-mcp-server@latest scrape <库名> <文档URL>
- 可选参数：--version <版本号> 锁定版本，--max-pages <数量> 限制页面数，--max-depth <深度> 限制爬取深度
- 示例：npx @arabold/docs-mcp-server@latest scrape langchain https://python.langchain.com/docs/ --max-pages 100 --max-depth 3

### 2. 搜索已索引文档
npx @arabold/docs-mcp-server@latest search <库名> "<查询词>"
- 可选参数：--output yaml 或 --output json 控制输出格式，--limit <数量> 限制结果数
- 示例：npx @arabold/docs-mcp-server@latest search langchain "How to use memory" --output yaml --limit 5

### 3. 获取单个页面（不加入索引）
npx @arabold/docs-mcp-server@latest fetch-url <URL>
- 返回纯 Markdown 文本，适合快速阅读某篇文档
- 示例：npx @arabold/docs-mcp-server@latest fetch-url https://python.langchain.com/docs/get_started/introduction

### 4. 管理索引
npx @arabold/docs-mcp-server@latest list
npx @arabold/docs-mcp-server@latest remove <库名>

## 使用流程
1. 用户询问某个库的文档时，先检查是否已索引：运行 list 命令。
2. 如果未索引，先运行 scrape 建立本地索引。
3. 索引完成后，用 search 查询用户的具体问题。
4. 如果只需要看某篇文档，直接用 fetch-url。

## 注意事项
- 第一次 scrape 可能耗时较长，因为需要抓取和索引页面。用 --max-pages 控制范围。
- 所有数据存储在本地，不依赖任何云端服务或 API 密钥。
- 完全免费，无次数限制。
