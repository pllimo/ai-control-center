#!/bin/bash
# Control Center · setup.sh
# 一键配置：Onboarding + AI 接入 + Hooks 安装

set -e

# ── 颜色 ─────────────────────────────────────────────────────
BOLD='\033[1m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RESET='\033[0m'

# ── 路径 ─────────────────────────────────────────────────────
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONTROL_CENTER_HOME="$SCRIPT_DIR"
CLAUDE_DIR="$HOME/.claude"
CODEX_DIR="$HOME/.codex"
OPENCLAW_DIR="$HOME/.openclaw/workspace"

echo ""
echo -e "${BOLD}Control Center · 配置向导${RESET}"
echo "────────────────────────────────────────"
echo ""

# ── 模式判断 ─────────────────────────────────────────────────
if [[ "$1" == "--onboarding" ]]; then
  RUN_ONBOARDING=true
elif [ -s "$CONTROL_CENTER_HOME/profile/user.md" ] && \
     ! grep -q "待填写" "$CONTROL_CENTER_HOME/profile/user.md" 2>/dev/null; then
  echo -e "${GREEN}✓ 已有用户画像，跳过 Onboarding${RESET}"
  echo "  如需重新填写，运行：bash setup.sh --onboarding"
  RUN_ONBOARDING=false
else
  RUN_ONBOARDING=true
fi

# ── Onboarding 问卷 ──────────────────────────────────────────
if [ "$RUN_ONBOARDING" = true ]; then
  echo -e "${BOLD}我会通过 5 个问题认识你。${RESET}"
  echo "完成后，所有接入的 AI 都会共享这份画像。"
  echo ""

  echo -e "${BLUE}Q1. 你是做什么的，现在处于哪个阶段？${RESET}"
  echo "    例：UX 设计师新人，正在实习；全栈工程师，独立开发中"
  read -r -p "    > " Q1
  echo ""

  echo -e "${BLUE}Q2. 你在思考和工作上，有没有什么特别的地方？${RESET}"
  echo "    你的优势、你的思维方式、你容易忽略的"
  read -r -p "    > " Q2
  echo ""

  echo -e "${BLUE}Q3. 你现在最想推进的 1-3 件事是什么？${RESET}"
  echo "    半年到一年的真实目标"
  read -r -p "    > " Q3
  echo ""

  echo -e "${BLUE}Q4. 在和 AI 协作时，有没有什么是你非常在意的？${RESET}"
  echo "    你希望 AI 怎么做，以及你不想要什么"
  read -r -p "    > " Q4
  echo ""

  echo -e "${BLUE}Q5. 你现在在推进哪些具体项目？（名字 + 一句话就够）${RESET}"
  echo "    例：个人网站 · 正在重构首页；毕设 · 产品原型阶段"
  read -r -p "    > " Q5
  echo ""

  TODAY=$(date '+%Y-%m-%d')

  # 写入 profile/user.md
  cat > "$CONTROL_CENTER_HOME/profile/user.md" << EOF
# 用户画像

> 这份文件描述的是你这个人。
> AI 每次启动都会读它，让每一次对话都从"认识你"开始。
> 由 setup.sh Onboarding 生成，通过 Profile Sync 持续更新。

---

## 我是谁

$Q1

---

## 思维与工作方式

$Q2

---

## AI 协作背景

**使用的 AI 工具**：Claude Code、Codex、OpenClaw

**协作风格**：
_（AI 会在工作中逐渐了解你的风格）_

---

_最后更新：$TODAY_
EOF

  # 写入 profile/goals.md
  cat > "$CONTROL_CENTER_HOME/profile/goals.md" << EOF
# 我的目标

> 半年到一年内真正在推进的事情。

---

$Q3

---

_最后更新：$TODAY_
EOF

  # 写入 profile/rules.md
  cat > "$CONTROL_CENTER_HOME/profile/rules.md" << EOF
# AI 协作规则

> AI 和你合作时必须遵守的规则。

---

$Q4

---

_最后更新：$TODAY_
EOF

  # 写入初始项目卡片
  if [ -n "$Q5" ]; then
    PROJ_FILE="$CONTROL_CENTER_HOME/memory/projects/initial.md"
    cat > "$PROJ_FILE" << EOF
# 当前项目

_来自 Onboarding：$TODAY_

$Q5
EOF
  fi

  echo -e "${GREEN}✓ 用户画像已生成${RESET}"
  echo ""
fi

# ── 写入 CONTROL_CENTER_HOME 环境变量 ─────────────────────────
ZSHRC="$HOME/.zshrc"
ZSHENV="$HOME/.zshenv"
ENV_LINE="export CONTROL_CENTER_HOME=\"$CONTROL_CENTER_HOME\""

if ! grep -q "CONTROL_CENTER_HOME" "$ZSHENV" 2>/dev/null; then
  echo "$ENV_LINE" >> "$ZSHENV"
fi
if ! grep -q "CONTROL_CENTER_HOME" "$ZSHRC" 2>/dev/null; then
  echo "$ENV_LINE" >> "$ZSHRC"
fi
export CONTROL_CENTER_HOME="$CONTROL_CENTER_HOME"

# ── Claude Code 接入 ─────────────────────────────────────────
echo "配置 Claude Code 接入..."

mkdir -p "$CLAUDE_DIR"
CLAUDE_MD="$CLAUDE_DIR/CLAUDE.md"

# 生成带真实路径的 CLAUDE.md 内容
CONNECTOR_CONTENT="
# Control Center

@$CONTROL_CENTER_HOME/profile/user.md
@$CONTROL_CENTER_HOME/profile/goals.md
@$CONTROL_CENTER_HOME/profile/rules.md
@$CONTROL_CENTER_HOME/memory/global.md

## 内置 Skill 触发词

| 触发词 | Skill |
|--------|-------|
| 复盘 / 我不满意 / 回顾一下 | 读 \`$CONTROL_CENTER_HOME/skills/reflect.md\` 执行 |
| 初始化项目 / /init-project | 读 \`$CONTROL_CENTER_HOME/skills/init-project.md\` 执行 |
| 更新我的档案 | 读 \`$CONTROL_CENTER_HOME/skills/profile-sync.md\` 执行 |

## 重要规则

- 自定义 Skill 必须 Read .md 文件手动执行，不能用 Skill 工具调用
- 每次有实质进展后，静默更新当前项目的 .ai/project.md
"

if [ ! -f "$CLAUDE_MD" ]; then
  echo "# Claude Code 全局配置" > "$CLAUDE_MD"
fi

if ! grep -q "Control Center" "$CLAUDE_MD" 2>/dev/null; then
  echo "$CONNECTOR_CONTENT" >> "$CLAUDE_MD"
fi

echo -e "${GREEN}✓ Claude Code 已接入${RESET}"

# ── Codex 接入 ───────────────────────────────────────────────
if command -v codex &>/dev/null || [ -d "$CODEX_DIR" ]; then
  echo "配置 Codex 接入..."
  mkdir -p "$CODEX_DIR"
  CODEX_FILE="$CODEX_DIR/instructions.md"

  CODEX_CONTENT="
# Control Center

以下是我的用户画像，请在整个会话中记住：

@$CONTROL_CENTER_HOME/profile/user.md
@$CONTROL_CENTER_HOME/profile/goals.md
@$CONTROL_CENTER_HOME/profile/rules.md
@$CONTROL_CENTER_HOME/memory/global.md

如果当前目录存在 .ai/project.md，请读取它作为项目上下文。
每次有实质进展后，更新 .ai/project.md。
"

  if ! grep -q "Control Center" "$CODEX_FILE" 2>/dev/null; then
    echo "$CODEX_CONTENT" >> "$CODEX_FILE"
  fi
  echo -e "${GREEN}✓ Codex 已接入${RESET}"
fi

# ── OpenClaw 接入 ────────────────────────────────────────────
if [ -d "$OPENCLAW_DIR" ]; then
  echo "配置 OpenClaw 接入..."
  OPENCLAW_MEMORY="$OPENCLAW_DIR/MEMORY.md"

  if [ -f "$OPENCLAW_MEMORY" ] && ! grep -q "Control Center" "$OPENCLAW_MEMORY" 2>/dev/null; then
    echo "
# Control Center

@$CONTROL_CENTER_HOME/profile/user.md
@$CONTROL_CENTER_HOME/profile/goals.md
@$CONTROL_CENTER_HOME/profile/rules.md
@$CONTROL_CENTER_HOME/memory/global.md
" >> "$OPENCLAW_MEMORY"
  fi
  echo -e "${GREEN}✓ OpenClaw 已接入${RESET}"
fi

# ── 安装 Hooks ───────────────────────────────────────────────
echo "安装 Hooks..."

chmod +x "$CONTROL_CENTER_HOME/hooks/session-start.sh"
chmod +x "$CONTROL_CENTER_HOME/hooks/auto-push.sh"

SETTINGS_FILE="$CLAUDE_DIR/settings.json"

if [ ! -f "$SETTINGS_FILE" ]; then
  echo '{}' > "$SETTINGS_FILE"
fi

# 用 python3 合并 hooks 配置
python3 << PYEOF
import json, os

settings_file = "$SETTINGS_FILE"
cc_home = "$CONTROL_CENTER_HOME"

with open(settings_file, 'r') as f:
    settings = json.load(f)

hooks = settings.setdefault('hooks', {})

# SessionStart hook
session_start = hooks.setdefault('SessionStart', [])
session_cmd = f"bash {cc_home}/hooks/session-start.sh"
if not any(h.get('command') == session_cmd for h in session_start):
    session_start.append({"type": "command", "command": session_cmd})

# PostToolUse hook (auto-push)
post_tool = hooks.setdefault('PostToolUse', [])
auto_push_cmd = f"bash {cc_home}/hooks/auto-push.sh"
if not any(h.get('command') == auto_push_cmd for h in post_tool):
    post_tool.append({"type": "command", "command": auto_push_cmd})

with open(settings_file, 'w') as f:
    json.dump(settings, f, indent=2, ensure_ascii=False)

print("ok")
PYEOF

echo -e "${GREEN}✓ Hooks 已安装${RESET}"

# ── 安装后台自动同步（launchd） ───────────────────────────────
echo "安装后台同步任务..."

chmod +x "$CONTROL_CENTER_HOME/sync.sh"

PLIST_TEMPLATE="$CONTROL_CENTER_HOME/launchd/com.control-center.sync.plist"
PLIST_TARGET="$HOME/Library/LaunchAgents/com.control-center.sync.plist"

if [ -f "$PLIST_TEMPLATE" ]; then
  # 替换模板中的占位路径
  sed -e "s|CONTROL_CENTER_HOME|$CONTROL_CENTER_HOME|g" \
      -e "s|HOME_PATH|$HOME|g" \
      "$PLIST_TEMPLATE" > "$PLIST_TARGET"

  # 加载 launchd 任务
  launchctl unload "$PLIST_TARGET" 2>/dev/null
  launchctl load "$PLIST_TARGET" 2>/dev/null && \
    echo -e "${GREEN}✓ 后台同步已启动（每 2 分钟自动同步）${RESET}" || \
    echo -e "${YELLOW}⚠ launchd 加载失败，可手动运行：bash $CONTROL_CENTER_HOME/sync.sh${RESET}"
fi

# ── Git 初始化提示 ────────────────────────────────────────────
echo ""
echo "────────────────────────────────────────"
echo -e "${BOLD}配置完成！${RESET}"
echo ""
echo "当前安装路径：$CONTROL_CENTER_HOME"
echo ""

if [ ! -d "$CONTROL_CENTER_HOME/.git" ]; then
  echo -e "${YELLOW}提示：还没有 Git 仓库。${RESET}"
  echo "建议在 GitHub 创建私有仓库，然后运行："
  echo "  cd $CONTROL_CENTER_HOME"
  echo "  git init && git remote add origin <你的仓库地址>"
  echo "  git add . && git commit -m 'init: control center'"
  echo "  git push -u origin main"
fi

echo ""
echo "下次打开 Claude Code，它就认识你了。"
echo ""
