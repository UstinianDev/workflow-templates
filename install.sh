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

# 复制文件（只复制含 SKILL.md 的 skills 目录，排除构建产物）
echo "📦 复制工作流文件..."
for skill_dir in "$SCRIPT_DIR"/*/; do
    skill_name="$(basename "$skill_dir")"
    if [ -f "$skill_dir/SKILL.md" ]; then
        rm -rf "$INSTALL_DIR/$skill_name"
        cp -r "$skill_dir" "$INSTALL_DIR/$skill_name"
        echo "  ✅ $skill_name"
    fi
done

# 清理构建产物（不入库也不安装）
find "$INSTALL_DIR" -type d -name "__pycache__" -prune -exec rm -rf {} + 2>/dev/null || true
find "$INSTALL_DIR" -type f -name "*.pyc" -delete 2>/dev/null || true

echo ""
echo "✅ 安装完成！"
echo ""
echo "📋 使用方法："
echo "  在 Claude Code 中输入："
echo "    /devflow <需求描述>          - 启动开发工作流"
echo "    /devflow-refactor <重构目标> - 启动重构工作流"
echo "    /devflow-documents           - 启动文档管理工作流"
echo "    /devflow-perf <优化目标>     - 启动性能优化工作流"
echo "    /devflow-video <需求> [模板] - 启动视频提示词生成工作流"
echo ""
echo "📁 安装位置: $INSTALL_DIR"
echo ""
echo "💡 提示："
echo "  1. 用户输入 / 时只会显示上述 5 个工作流。"
echo "  2. devflow-base 是公共骨架（disable-model-invocation），仅供工作流内部读取，不显示。"
echo "  3. 其余依赖 skills（grill-me、tdd-workflow、docs-cli 等）由工作流自动调用。"
