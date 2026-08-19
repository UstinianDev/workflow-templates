#!/bin/bash

# DevFlow 工作流安装脚本

set -e

echo "🚀 开始安装 DevFlow 工作流..."

# 检测 Claude Code 安装路径
CLAUDE_SKILLS_DIR="$HOME/.claude/skills"
PROJECT_SKILLS_DIR=".claude/skills"

# 获取脚本所在目录
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILL_NAME="devflow-workflows"

# 选择安装位置
echo "请选择安装位置："
echo "1) 用户级（推荐）- $CLAUDE_SKILLS_DIR/$SKILL_NAME"
echo "2) 项目级 - $PROJECT_SKILLS_DIR/$SKILL_NAME"
read -p "请输入选项 (1/2，默认1): " choice

case $choice in
    2)
        INSTALL_DIR="$PROJECT_SKILLS_DIR/$SKILL_NAME"
        echo "📁 安装到项目级目录: $INSTALL_DIR"
        ;;
    *)
        INSTALL_DIR="$CLAUDE_SKILLS_DIR/$SKILL_NAME"
        echo "📁 安装到用户级目录: $INSTALL_DIR"
        ;;
esac

# 创建目标目录
mkdir -p "$INSTALL_DIR"

# 复制文件
echo "📦 复制工作流文件..."
cp -r "$SCRIPT_DIR"/* "$INSTALL_DIR/"

# 设置权限
chmod +x "$INSTALL_DIR/install.sh" 2>/dev/null || true

echo "✅ 安装完成！"
echo ""
echo "📋 使用方法："
echo "  在 Claude Code 中输入："
echo "    /devflow-core <需求描述>    - 启动开发工作流"
echo "    /devflow-refactor <重构目标> - 启动重构工作流"
echo ""
echo "📁 安装位置: $INSTALL_DIR"
echo ""
echo "💡 提示：用户输入 / 时只会显示这两个工作流，其他依赖的 skills 不会显示。"
