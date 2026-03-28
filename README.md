# Control Center · 中控系统

> 一个给 AI 用的上下文枢纽——让每一个 AI、在每一台设备上，都认识同一个你。

---

## 为什么需要它？

你有没有遇到过这三种情况：

- 换了一个 AI 工具，又要重新介绍一遍自己是谁、习惯怎么工作
- 换了台电脑，项目上下文全断了，AI 不知道你上次做到哪里
- 同时用 Claude Code、Codex 和 OpenClaw，三个 AI 各说各话，完全没有协同

**Control Center 解决的就是这三个问题。**

---

## 它怎么解决？

**1. AI 认识你了**
通过一次 Onboarding，建立你的用户画像。所有接入的 AI 共享这份画像，不需要每次重新解释。

**2. 项目不会断**
每个项目自动维护一份上下文档案（`.ai/project.md`），AI 静默更新，下次打开就能接着做。

**3. 越用越聪明**
AI 从工作中积累经验，通过 Profile Sync 写回你的画像。用得越久，AI 越了解你。

---

## 快速开始（5 分钟）

```bash
# 1. 用模板创建你的私有仓库（在 GitHub 页面点 "Use this template" → "Create a private repository"）

# 2. 克隆到本地
git clone git@github.com:你的用户名/你的仓库名.git ~/control-center

# 3. 运行配置向导
cd ~/control-center && bash setup.sh
```

`setup.sh` 会引导你完成：
- 5 个问题建立你的用户画像
- 自动配置 Claude Code / Codex / OpenClaw 接入
- 安装自动同步 hooks

---

## 核心概念

### 用户画像层 `profile/`

| 文件 | 内容 |
|------|------|
| `profile/user.md` | 你是谁、你怎么思考、你的工作方式 |
| `profile/goals.md` | 你当前最想推进的目标 |
| `profile/rules.md` | AI 永远要做的 / 永远不要做的 |

每次 AI 启动时自动读取。这是 AI 了解你的起点。

---

### AI 记忆层 `memory/`

| 文件 | 内容 |
|------|------|
| `memory/global.md` | 跨项目积累的经验，由 Reflect 写入 |
| `memory/projects/` | 每个项目一张卡片，AI 静默维护 |

画像是你告诉 AI 的，记忆是 AI 从工作中学到的。两者都共享给所有接入的 AI。

---

### 项目记忆 `.ai/project.md`

每个项目目录下自动创建的上下文档案：

```
目标：
当前阶段：
关键决策：
下一步：
注意事项：
```

你不需要手动维护——AI 每次有实质进展后会静默更新它。

---

### 三个内置 Skill

| Skill | 触发词 | 作用 |
|-------|--------|------|
| **Reflect** | "复盘" / "我不满意" / "回顾一下" | 提炼经验，写入记忆层 |
| **Init Project** | "初始化项目" / `/init-project` | 显性查看或更新项目档案 |
| **Profile Sync** | "更新我的档案" | 把 AI 学到的写回用户画像 |

这三个 Skill 构成完整的记忆闭环：建立 → 维护 → 回顾 → 生长。

---

## AI 接入

| AI 工具 | 接入方式 | 配置路径 |
|---------|---------|---------|
| **Claude Code** | CLAUDE.md @引用 | `connectors/claude-code/` |
| **Codex** | instructions.md | `connectors/codex/` |
| **OpenClaw** | workspace.md | `connectors/openclaw/` |

`setup.sh` 会自动完成所有配置，无需手动操作。

---

## 完整配置

```bash
# 查看当前配置状态
cat ~/control-center/profile/user.md

# 重新运行 Onboarding（如果想重置画像）
bash ~/control-center/setup.sh --onboarding

# 手动同步到远端
cd ~/control-center && git push
```

---

## 添加更多 Skill

Control Center 内置 3 个核心 Skill，但你可以按需添加更多。

在 `skills/` 目录下创建 `.md` 文件，然后在 `connectors/claude-code/CLAUDE.md` 里注册触发词即可。

参考：[Claude Code Skills 文档](https://docs.anthropic.com/claude-code)

---

## 可视化记忆仪表盘

运行构建脚本后，用浏览器打开 `visualization.html` 查看你的记忆成长：

```bash
python3 scripts/build-viz.py
open visualization.html
```

展示内容：
- **用户画像**：你是谁、协作规则一览
- **记忆时间线**：每条经验的来龙去脉，成长曲线可视
- **项目档案**：所有项目的当前状态和下一步
- **目标追踪**：当前主线目标

---

## 版本规划

- **v1**：Onboarding + 三个 Skill + 三个 AI 接入 + 跨设备同步
- **v1.5**（当前）：后台自动同步（跨 AI 实时同步）+ Profile Sync 与 Reflect 自动联动
- **v3**：可视化记忆仪表盘 ✅

---

## 参与贡献

欢迎提交 Issue 和 PR。详见 [CONTRIBUTING.md](CONTRIBUTING.md)。

## 许可证

MIT License — 详见 [LICENSE](LICENSE)
