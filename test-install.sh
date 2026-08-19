#!/bin/bash

# DevFlow 工作流安装测试脚本

echo "🔍 检查 DevFlow 工作流安装..."

# 检查 Claude Code skills 目录
CLAUDE_SKILLS_DIR="$HOME/.claude/skills"
INSTALL_DIR="$CLAUDE_SKILLS_DIR/devflow-workflows"

if [ ! -d "$INSTALL_DIR" ]; then
    echo "❌ 未找到安装目录: $INSTALL_DIR"
    echo "请先运行 install.sh 安装工作流。"
    exit 1
fi

echo "✅ 找到安装目录: $INSTALL_DIR"

# 检查必要的文件
REQUIRED_FILES=(
    "devflow-core/SKILL.md"
    "devflow-refactor/SKILL.md"
    "grill-me/SKILL.md"
    "grilling/SKILL.md"
    "tdd-workflow/SKILL.md"
    "code-refactor-master/SKILL.md"
    "testing-quality-agent/SKILL.md"
    "skill-comply/SKILL.md"
    "agent-skill-creator/SKILL.md"
)

echo ""
echo "📋 检查必要文件："

for file in "${REQUIRED_FILES[@]}"; do
    if [ -f "$INSTALL_DIR/$file" ]; then
        echo "  ✅ $file"
    else
        echo "  ❌ $file (缺失)"
    fi
done

# 检查 user-invocable 设置
echo ""
echo "🔧 检查工作流配置："

for skill in devflow-core devflow-refactor; do
    if grep -q "user-invocable: true" "$INSTALL_DIR/$skill/SKILL.md" 2>/dev/null; then
        echo "  ✅ $skill - 用户可调用"
    else
        echo "  ❌ $skill - 未设置为用户可调用"
    fi
done

# 检查其他 skills 不应该被用户调用
echo ""
echo "🔒 检查内部依赖 skills（不应显示在 / 命令中）："

INTERNAL_SKILLS=(
    "grill-me"
    "grilling"
    "tdd-workflow"
    "code-refactor-master"
    "testing-quality-agent"
    "skill-comply"
    "agent-skill-creator"
)

for skill in "${INTERNAL_SKILLS[@]}"; do
    if grep -q "user-invocable: true" "$INSTALL_DIR/$skill/SKILL.md" 2>/dev/null; then
        echo "  ⚠️  $skill - 仍然设置为用户可调用（可能需要修复）"
    else
        echo "  ✅ $skill - 正确设置为内部依赖"
    fi
done

echo ""
echo "🎉 检查完成！"
echo ""
echo "如果所有检查都通过，你可以在 Claude Code 中使用："
echo "  /devflow-core <需求描述>"
echo "  /devflow-refactor <重构目标>"
