#!/bin/bash
# auto-push.sh
# 触发时机：PostToolUse（Write / Edit / MultiEdit 完成后）
# 作用：当 Control Center 自身的文件被修改时，自动 commit + push

CONTROL_CENTER_HOME="${CONTROL_CENTER_HOME:-$HOME/control-center}"

INPUT=$(cat)
TOOL_NAME=$(echo "$INPUT" | python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('tool_name',''))" 2>/dev/null)
FILE_PATH=$(echo "$INPUT" | python3 -c "import sys,json; d=json.load(sys.stdin); p=d.get('tool_input',{}); print(p.get('file_path',''))" 2>/dev/null)

# 只处理文件写入类操作
if [[ "$TOOL_NAME" != "Write" && "$TOOL_NAME" != "Edit" && "$TOOL_NAME" != "MultiEdit" ]]; then
  exit 0
fi

# 只处理 Control Center 目录内的文件
if [[ "$FILE_PATH" != "$CONTROL_CENTER_HOME"* ]]; then
  exit 0
fi

# 不处理 local/ 目录（私密数据）
if [[ "$FILE_PATH" == "$CONTROL_CENTER_HOME/local/"* ]]; then
  exit 0
fi

# 自动 commit + push
cd "$CONTROL_CENTER_HOME" || exit 0

if git diff --quiet && git diff --cached --quiet; then
  exit 0
fi

TODAY=$(date '+%Y-%m-%d %H:%M')
RELATIVE_PATH="${FILE_PATH#$CONTROL_CENTER_HOME/}"

git add "$FILE_PATH" 2>/dev/null
git commit -m "auto: $TODAY [$RELATIVE_PATH]" --quiet 2>/dev/null
git push --quiet 2>/dev/null

exit 0
