---
name: fastcrw-skill
description: 使用 crw 命令行工具抓取网页、爬取网站或进行网络搜索。当需要获取在线文档、最新网页内容或执行网络搜索时使用。
allowed-tools: Bash
---

# fastCRW 网页抓取技能

## 指令
当需要从互联网获取信息时，使用 crw 命令。它支持以下核心操作：

- 抓取单个网页：crw scrape <URL> --format markdown
- 搜索网络：crw search "<查询词>" --limit 5
- 爬取整站：crw crawl <URL> --limit 20

## 示例
用户请求："帮我看看 https://example.com 的最新内容。"
你应该执行：crw scrape https://example.com --format markdown
