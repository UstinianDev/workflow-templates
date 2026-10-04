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
    "devflow-base/SKILL.md"
    "devflow/SKILL.md"
    "devflow-refactor/SKILL.md"
    "devflow-documents/SKILL.md"
    "devflow-perf/SKILL.md"
    "devflow-video/SKILL.md"
    "devflow-perf/rules/perf-rules-core.md"
    "devflow-perf/rules/perf-rules-frontend.md"
    "devflow-perf/rules/perf-rules-backend.md"
    "devflow-video/rules/core-rules.md"
    "devflow-video/references/term-mapping.md"
    "devflow-video/templates/game-of-thrones-style.md"
    "grill-me/SKILL.md"
    "grilling/SKILL.md"
    "tdd-workflow/SKILL.md"
    "code-refactor-master/SKILL.md"
    "testing-quality-agent/SKILL.md"
    "skill-comply/SKILL.md"
    "agent-skill-creator/SKILL.md"
    "docs-cli/SKILL.md"
    "fastcrw-skill/SKILL.md"
    "ui-ux-pro-max/SKILL.md"
)

echo ""
echo "📋 检查必要文件："

MISSING=0
for file in "${REQUIRED_FILES[@]}"; do
    if [ -f "$INSTALL_DIR/$file" ]; then
        echo "  ✅ $file"
    else
        echo "  ❌ $file (缺失)"
        MISSING=1
    fi
done

# 检查用户可调用工作流的 user-invocable 设置
echo ""
echo "🔧 检查工作流配置："

INVOCABLE_SKILLS=(devflow devflow-refactor devflow-documents devflow-perf devflow-video)

for skill in "${INVOCABLE_SKILLS[@]}"; do
    if grep -q "user-invocable: true" "$INSTALL_DIR/$skill/SKILL.md" 2>/dev/null; then
        echo "  ✅ $skill - 用户可调用"
    else
        echo "  ❌ $skill - 未设置为用户可调用"
        MISSING=1
    fi
done

# 检查公共骨架不被直接调用
echo ""
echo "🔒 检查公共骨架（不应显示在 / 命令中）："

if grep -q "disable-model-invocation: true" "$INSTALL_DIR/devflow-base/SKILL.md" 2>/dev/null; then
    echo "  ✅ devflow-base - 已禁用模型直接调用（仅供工作流读取）"
else
    echo "  ❌ devflow-base - 未设置 disable-model-invocation"
    MISSING=1
fi

# 检查内部依赖 skills 不应被用户调用
echo ""
echo "🔒 检查内部依赖 skills（不应显示在 / 命令中）："

INTERNAL_SKILLS=(
    "grill-me"
    "grilling"
    "tdd-workflow"
    "code-refactor-master"
    "skill-comply"
    "docs-cli"
    "fastcrw-skill"
    "ui-ux-pro-max"
)

for skill in "${INTERNAL_SKILLS[@]}"; do
    if grep -q "user-invocable: true" "$INSTALL_DIR/$skill/SKILL.md" 2>/dev/null; then
        echo "  ⚠️  $skill - 仍然设置为用户可调用（可能需要修复）"
    else
        echo "  ✅ $skill - 正确设置为内部依赖"
    fi
done

echo ""
echo "ℹ️  testing-quality-agent 与 agent-skill-creator 源定义为 user-invocable（可手动调用，主要供工作流内部调用）。"

echo ""
if [ "$MISSING" -eq 0 ]; then
    echo "🎉 检查完成！全部通过"
else
    echo "⚠️ 检查完成，但存在缺失项，请修复后重试。"
    exit 1
fi

echo ""
echo "如果所有检查都通过，你可以在 Claude Code 中使用："
echo "  /devflow <需求描述>"
echo "  /devflow-refactor <重构目标>"
echo "  /devflow-documents"
echo "  /devflow-perf <优化目标>"
echo "  /devflow-video <需求描述> [风格模板名]"
