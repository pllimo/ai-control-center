# Control Center · 中控系统

> 一个给 AI 用的上下文枢纽——让每一个 AI、在每一台设备上，都认识同一个你。

---

## 这是什么？

你有没有遇到过这三种情况：

- 换了一个 AI 工具，又要重新介绍一遍自己是谁、习惯怎么工作
- 换了台电脑，项目上下文全断了，AI 不知道你上次做到哪里
- 同时用 Claude Code、Codex 和 OpenClaw，三个 AI 各说各话，完全没有协同

**Control Center 是一套共享记忆系统。**

你做一次 Onboarding 问卷，建立你的用户画像。之后无论你用哪个 AI、在哪台设备上，它们都会读到同一份关于你的信息，不需要每次重新解释。AI 在工作中学到的经验，也会自动写回系统，越用越聪明。

---

## 快速开始（5 分钟上手）

**第一步：创建你的私有仓库**

打开本项目页面，点击右上角 **Use this template** → **Create a private repository**。

> ⚠️ 你的用户画像和记忆数据会存在你自己的仓库里，必须用私有仓库。

**第二步：克隆到本地**

```bash
git clone git@github.com:你的用户名/你的仓库名.git ~/control-center
```

**第三步：运行配置向导**

```bash
cd ~/control-center && bash setup.sh
```

向导会引导你完成：
1. 5 个问题建立你的用户画像
2. 自动配置 Claude Code / Codex / OpenClaw 接入
3. 安装自动同步（每 2 分钟后台运行）

**完成后，打开任意一个 AI，它就已经认识你了。**

---

## 系统架构

Control Center 由三层组成：

```
profile/          ← 用户画像层（你告诉 AI 的）
  user.md         你是谁、你怎么思考
  goals.md        你当前在追求什么
  rules.md        AI 永远要 / 永远不要做什么

memory/           ← AI 记忆层（AI 从工作中学到的）
  global.md       跨项目经验积累
  projects/       每个项目一张档案卡

.ai/              ← 项目级记忆（自动生成，你感知不到）
  project.md      当前项目的目标、决策、下一步

connectors/       ← AI 接入适配层
  claude-code/    Claude Code 专用配置
  codex/          Codex 专用配置
  openclaw/       OpenClaw 专用配置

skills/           ← 三个内置 Skill
sync.sh           后台自动同步脚本
```

**用户画像层**是你主动填写的，描述你这个人。
**AI 记忆层**是 AI 通过工作自动积累的，记录经验和项目状态。
两层都会被所有接入的 AI 共享读取。

---

## 三个内置 Skill

Skill 是你与 AI 之间的协作约定。说出触发词，AI 就会读取对应的 Skill 文件并按步骤执行，不需要你解释背景，不需要你记住流程。

---

### Skill 1：Reflect（复盘）

**用途**：把这次工作中有价值的东西沉淀下来，写入记忆层，让 AI 越来越了解你。

Reflect 有两种模式：

#### 模式一：经验复盘（针对具体工作或项目）

适合在一个工作 session 完成后，或者对某次合作不满意时使用。

AI 会回顾这次对话，提炼出真正有价值的经验——不只是"沟通是否顺畅"，更包括技术选型、设计判断、流程决策、踩过的坑。提炼结果写入 `memory/global.md`（跨项目通用经验）和当前项目的 `.ai/project.md`（项目特有经验）。

**触发词（任意一个都可以）：**

```
复盘
回顾一下
我不满意
这里不对
做得不好
总结经验
```

#### 模式二：个人状态更新

适合当你的个人情况发生变化时——换了工作、学会了新技能、发现了自己的新习惯——让 AI 同步更新对你的认知。

这类内容会写入 `profile/user.md`，更新你的用户画像。

**触发词（任意一个都可以）：**

```
我最近...
我最近干了什么
我现在的情况是...
我已经会了...
我换工作了
我最近在学...
```

**示例**：

> 「我最近开始系统学习产品思维了，之前只做执行，现在想在业务理解上补课」

AI 会把这条信息更新到你的画像里，以后在涉及产品方向的话题时，会主动帮你补足这方面的视角。

#### 复盘结束后自动触发 Profile Sync

每次 Reflect 执行完毕，AI 会自动判断：这次复盘有没有揭示出关于你的新认知？如果有，自动更新 `profile/user.md`，不需要你额外触发。

**完整触发词列表** → 详见 [`skills/reflect.md`](skills/reflect.md)

---

### Skill 2：Init Project（项目初始化）

**用途**：为每个项目建立和维护一份上下文档案（`.ai/project.md`），让 AI 每次打开项目时都知道"这个项目是干什么的、现在到哪了"。

#### 隐性模式（全自动，你感知不到）

每次你在一个项目目录里打开 Claude Code，session-start hook 会自动检测：

- 如果该目录下还没有 `.ai/project.md`，自动创建模板文件
- AI 读取该文件，获取项目背景
- 每次会话有实质进展后（完成功能、做了关键决策、发现了新问题），AI 会静默更新这个文件

你不会看到任何通知。AI 只是默默地把项目记忆维护好。

`.ai/project.md` 的内容结构：

```
目标：这个项目要达到什么
当前阶段：现在进行到哪里了
关键决策：做过的重要选择和原因
下一步：当前最优先的任务
注意事项：已知的限制和容易踩的坑
最后更新：日期
```

#### 显性模式（用户主动触发）

如果你想查看当前项目的档案，或者手动更新它：

**触发词：**

```
初始化项目
/init-project
```

AI 会展示当前 `.ai/project.md` 的内容，你可以查看、编辑或告诉 AI 需要更新什么。

**适用场景**：
- 项目刚开始，想给 AI 说清楚背景
- 切换到一个很久没碰的旧项目，让 AI 快速恢复上下文
- 向另一个 AI 交接项目

**完整触发词列表** → 详见 [`skills/init-project.md`](skills/init-project.md)

---

### Skill 3：Profile Sync（画像更新）

**用途**：把 AI 在工作中新学到的关于你的认知，写回 `profile/user.md`，让你的画像随时间生长。

#### 这解决了什么问题

Onboarding 问卷填写的是你刚设置时的状态，但你在变化：工作方向会调整、习惯会改变、AI 也在合作中发现你的新特征。Profile Sync 是让画像"活起来"的机制——它不是你在维护，是 AI 在帮你维护。

#### 触发方式

**手动触发词：**

```
更新我的档案
同步画像
```

**自动触发**：每次 Reflect 执行完毕后，AI 自动判断是否有新认知值得写入（见上方 Reflect 说明）。

#### AI 会更新什么

- 发现了你新的思维特征或工作偏好 → 更新 `profile/user.md` 的思维方式部分
- 你的角色或目标发生变化 → 更新对应字段
- AI 发现你有某类反复出现的盲点 → 记录进画像，以后主动帮你补

**原则**：只写真正有价值的新认知，不记流水账。有疑虑的内容，AI 会先告诉你再写入。

**完整触发词列表** → 详见 [`skills/profile-sync.md`](skills/profile-sync.md)

---

## 记忆完整闭环

```
第一次使用
    ↓
Onboarding 问卷（5 题）
    ↓ 生成 profile/user.md + goals.md + rules.md
开始用 AI 工作
    ↓
每次打开项目
    ↓ Init Project 自动检测，维护 .ai/project.md
工作过程中
    ↓ AI 读取 profile/ + memory/ + .ai/project.md，始终带着上下文
一段工作结束
    ↓
Reflect 触发
    ↓ 经验写入 memory/global.md + .ai/project.md
    ↓ 自动触发 Profile Sync
    ↓ 新认知写回 profile/user.md
下次 AI 来了
    ↓
它认识你，还比上次更了解你
```

---

## AI 接入支持

| AI 工具 | 接入方式 | setup.sh 是否自动配置 |
|--------|---------|-------------------|
| **Claude Code** | `~/.claude/CLAUDE.md` @引用 | ✅ 自动 |
| **Codex** | `~/.codex/instructions.md` | ✅ 自动（检测到 Codex 时） |
| **OpenClaw** | `~/.openclaw/workspace/MEMORY.md` | ✅ 自动（检测到 OpenClaw 时） |

**配置原理**：`setup.sh` 向每个 AI 的全局配置文件追加 @引用，指向你的 `profile/` 和 `memory/` 目录。之后每次 AI 启动，都会自动读取这些文件作为上下文的一部分。

---

## 跨设备与跨 AI 自动同步

### 工作原理

Control Center 通过 Git 实现跨设备同步。你的数据存在你的私有 GitHub 仓库里，每台设备通过 `sync.sh` 保持一致。

### 同步是全自动的

`setup.sh` 会安装一个后台任务（macOS launchd），**每 2 分钟自动运行一次**：

1. 检测本地是否有改动 → 有则自动 `commit + push`
2. 检测远端是否有更新 → 有则自动 `pull`

你不需要手动触发，也不需要记任何命令。

### 具体场景

**场景 1：你在家用 Claude Code 复盘，公司电脑上的 Codex 也能看到**

1. 家里 Claude Code 执行 Reflect，AI 把经验写入 `memory/global.md`
2. sync.sh（家里）在 2 分钟内检测到改动，自动 push 到 GitHub
3. 公司电脑的 sync.sh 在 2 分钟内检测到远端更新，自动 pull
4. 公司 Codex 下次启动时，读到的 `memory/global.md` 已经包含最新经验

**场景 2：三个 AI 同时在用，记忆保持一致**

Claude Code、Codex、OpenClaw 读取的是同一套文件（`profile/` + `memory/`）。任何一个 AI 写入了新内容，sync.sh 会在后台自动推送，其他 AI 在下一次 session 启动时就能读到。

**场景 3：新设备上手**

```bash
git clone git@github.com:你的用户名/你的仓库名.git ~/control-center
cd ~/control-center && bash setup.sh
```

运行完 `setup.sh`，新设备上的所有 AI 就自动接上了你已有的全部记忆，不需要重新 Onboarding。

### 手动触发同步

如果需要立即同步（不等 2 分钟）：

```bash
bash ~/control-center/sync.sh
```

### 关于私密数据

`local/` 目录和 `.env` 文件被 `.gitignore` 排除，永远不会上传。你的 API Key 等敏感信息放在 `local/` 里即可。

---

## 可视化记忆仪表盘

查看你的记忆成长状况：

```bash
# 生成数据
python3 ~/control-center/scripts/build-viz.py

# 用浏览器打开
open ~/control-center/visualization.html
```

**仪表盘展示**：
- **用户画像面板**：你是谁、协作规则一览
- **记忆时间线**：每条经验的内容和时间，带成长曲线图
- **项目档案卡片**：所有项目的当前状态和下一步
- **统计概览**：记忆总条数、项目数、画像更新时间

---

## 如何添加更多 Skill

Control Center 内置 3 个核心 Skill。你可以按需添加更多：

1. 在 `skills/` 目录下创建 `.md` 文件，写明触发词和执行步骤
2. 在 `connectors/claude-code/CLAUDE.md` 的触发词表格里注册它

格式参考：

```markdown
---
name: your-skill
description: 说明这个 Skill 做什么，触发词是什么
---

# Skill 名称

## 触发词
...

## 执行步骤
...
```

更多 Skill 可参考社区资源：[Claude Code Skills](https://docs.anthropic.com)

---

## 文件结构

```
control-center/
│
├── profile/                    用户画像层
│   ├── user.md                 你是谁、你怎么思考
│   ├── goals.md                你的目标
│   └── rules.md                AI 永远要 / 不要做的事
│
├── memory/                     AI 记忆层
│   ├── global.md               跨项目经验（由 Reflect 写入）
│   └── projects/               每个项目一张档案卡
│
├── .ai/                        项目级记忆（在各项目目录下生成）
│   └── project.md              当前项目档案（AI 静默维护）
│
├── connectors/                 AI 接入层
│   ├── claude-code/CLAUDE.md   Claude Code 配置模板
│   ├── codex/instructions.md   Codex 配置模板
│   └── openclaw/workspace.md   OpenClaw 配置模板
│
├── skills/                     内置 Skill
│   ├── reflect.md              复盘 + 个人状态更新
│   ├── init-project.md         项目初始化与档案维护
│   └── profile-sync.md         画像更新
│
├── hooks/
│   ├── session-start.sh        会话启动时自动拉取 + 检测项目
│   └── auto-push.sh            文件修改后自动 commit + push
│
├── sync.sh                     后台同步主脚本（每 2 分钟运行）
├── launchd/                    macOS 自动启动配置
├── scripts/build-viz.py        可视化数据生成脚本
├── visualization.html          记忆仪表盘
├── setup.sh                    一键配置向导
└── local/                      本地私密数据（不入库）
```

---

## 常见问题

**Q：setup.sh 运行完，Claude Code 里看不到效果？**

重启 Claude Code 让它重新加载 `~/.claude/CLAUDE.md` 即可。

**Q：我在一台设备上更新了记忆，另一台什么时候能同步到？**

最长 2 分钟（sync.sh 的运行间隔）。如果需要立刻同步，运行 `bash ~/control-center/sync.sh`。

**Q：三个 AI 用的是同一份 profile 吗？**

是的。Claude Code、Codex、OpenClaw 读取的都是你 `profile/` 目录下的同一批文件。你只需要维护一份。

**Q：`.ai/project.md` 应该提交到项目仓库吗？**

建议加到项目的 `.gitignore` 里——它是你的私人上下文，不是项目代码的一部分。也可以选择保留，方便团队共享项目状态。

**Q：Onboarding 填错了怎么办？**

直接编辑 `profile/user.md`、`profile/goals.md`、`profile/rules.md`，或者重新运行：

```bash
bash ~/control-center/setup.sh --onboarding
```

**Q：在 Linux 或 Windows WSL 上能用吗？**

`sync.sh` 可以用，`launchd` 是 macOS 专用。Linux 用户可以用 `crontab` 代替：

```bash
*/2 * * * * bash ~/control-center/sync.sh
```

---

## 参与贡献

欢迎提交 Issue 和 PR。详见 [CONTRIBUTING.md](CONTRIBUTING.md)。

特别欢迎：
- 更多 AI 工具的 connector（Cursor、Copilot 等）
- Linux / Windows WSL 兼容支持
- 新的通用 Skill

## 许可证

MIT License — 详见 [LICENSE](LICENSE)
