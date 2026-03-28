# Control Center — Claude Code 接入

> 此文件由 setup.sh 自动生成并注入到 ~/.claude/CLAUDE.md。
> 通过 @引用 将用户画像和 AI 记忆注入每次会话。

## 自动加载的上下文

@CONTROL_CENTER_HOME/profile/user.md
@CONTROL_CENTER_HOME/profile/goals.md
@CONTROL_CENTER_HOME/profile/rules.md
@CONTROL_CENTER_HOME/memory/global.md

## 项目级记忆

当前项目如果存在 `.ai/project.md`，优先读取它作为项目上下文。

## 内置 Skill 触发词

| 触发词 | Skill | 操作 |
|--------|-------|------|
| "复盘" / "我不满意" / "回顾一下" | reflect | 读 `skills/reflect.md` 执行 |
| "初始化项目" / `/init-project` | init-project | 读 `skills/init-project.md` 执行 |
| "更新我的档案" | profile-sync | 读 `skills/profile-sync.md` 执行 |

## 重要执行规则

- 自定义 Skill 不能用 Skill 工具调用，必须直接 Read 对应 .md 文件手动执行
- 每次有实质进展后，静默更新当前项目的 `.ai/project.md`
- 遇到技术风险，主动说出来，不等用户发现
