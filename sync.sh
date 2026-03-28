#!/bin/bash
# sync.sh — Control Center 后台自动同步
#
# 作用：定期检测本地改动并推送，检测远端更新并拉取
# 保证所有接入的 AI（Claude Code / Codex / OpenClaw）
# 始终读取同一份最新的 profile 和 memory。
#
# 安装方式：bash setup.sh（会自动注册 launchd 定时任务）
# 手动运行：bash ~/control-center/sync.sh

CONTROL_CENTER_HOME="${CONTROL_CENTER_HOME:-$HOME/control-center}"
LOG="$CONTROL_CENTER_HOME/.sync.log"
MAX_LOG_LINES=200

log() {
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG"
}

# 日志限长
if [ -f "$LOG" ] && [ "$(wc -l < "$LOG")" -gt "$MAX_LOG_LINES" ]; then
  tail -n 100 "$LOG" > "$LOG.tmp" && mv "$LOG.tmp" "$LOG"
fi

cd "$CONTROL_CENTER_HOME" || exit 1

# ── 1. 推送本地改动 ───────────────────────────────────────────
if ! git diff --quiet || ! git diff --cached --quiet; then
  DEVICE=$(hostname -s 2>/dev/null || echo "device")
  TODAY=$(date '+%Y-%m-%d %H:%M')
  git add profile/ memory/ 2>/dev/null
  git commit -m "sync: $TODAY [$DEVICE]" --quiet 2>/dev/null && \
    git push --quiet 2>/dev/null && \
    log "pushed local changes from $DEVICE" || \
    log "push failed (will retry)"
fi

# ── 2. 拉取远端更新 ───────────────────────────────────────────
git fetch origin --quiet 2>/dev/null
LOCAL=$(git rev-parse HEAD 2>/dev/null)
REMOTE=$(git rev-parse origin/main 2>/dev/null)

if [ "$LOCAL" != "$REMOTE" ] && [ -n "$REMOTE" ]; then
  git pull --rebase --quiet 2>/dev/null && \
    log "pulled updates from remote" || \
    log "pull failed (conflict?)"
fi

exit 0
