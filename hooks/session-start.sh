#!/bin/bash
# session-start.sh
# 触发时机：Claude Code SessionStart（每次会话启动时）
# 作用：同步最新配置 + 静默初始化项目档案

CONTROL_CENTER_HOME="${CONTROL_CENTER_HOME:-$HOME/control-center}"

# ── 1. 同步最新配置 ──────────────────────────────────────────
if [ -d "$CONTROL_CENTER_HOME/.git" ]; then
  cd "$CONTROL_CENTER_HOME"
  # 只在有远端更新时才 pull，避免网络超时拖慢启动
  git fetch origin --quiet 2>/dev/null
  LOCAL=$(git rev-parse HEAD 2>/dev/null)
  REMOTE=$(git rev-parse origin/main 2>/dev/null)
  if [ "$LOCAL" != "$REMOTE" ] && [ -n "$REMOTE" ]; then
    git pull --rebase --quiet 2>/dev/null
  fi
fi

# ── 2. 静默初始化项目档案 ─────────────────────────────────────
# 检测当前工作目录是否是一个项目（有 git 或常见项目文件）
CURRENT_DIR="$(pwd)"
IS_PROJECT=false

if [ -d "$CURRENT_DIR/.git" ] || \
   [ -f "$CURRENT_DIR/package.json" ] || \
   [ -f "$CURRENT_DIR/CLAUDE.md" ] || \
   [ -f "$CURRENT_DIR/Makefile" ] || \
   [ -f "$CURRENT_DIR/pyproject.toml" ]; then
  IS_PROJECT=true
fi

if [ "$IS_PROJECT" = true ]; then
  AI_DIR="$CURRENT_DIR/.ai"
  PROJECT_FILE="$AI_DIR/project.md"

  # 如果还没有项目档案，创建模板
  if [ ! -f "$PROJECT_FILE" ]; then
    mkdir -p "$AI_DIR"
    PROJECT_NAME=$(basename "$CURRENT_DIR")
    TODAY=$(date '+%Y-%m-%d')
    cat > "$PROJECT_FILE" << EOF
# $PROJECT_NAME

## 目标


## 当前阶段


## 关键决策
| 决策 | 选择 | 原因 |
|------|------|------|

## 下一步
- [ ]

## 注意事项


## 最后更新
$TODAY
EOF
  fi
fi

exit 0
