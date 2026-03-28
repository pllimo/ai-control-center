# 决策稿 · Control Center（已拍板）

> 轮次：Round 1 完成
> 状态：所有决策已确认，可进入实现阶段

---

## 一、项目定位

### 名称

**Control Center**（中控系统）

### 一句话

> 一个给 AI 用的上下文枢纽——让每一个 AI、在每一台设备上，都认识同一个你。

### 三个核心体验

1. **AI 认识你了** — 换个 AI 工具，不用重新解释你是谁
2. **项目不会断** — 换台设备或换个 session，项目上下文还在
3. **越用越聪明** — AI 的画像随时间生长，不是永远停在第一次设置

---

## 二、已拍板的所有决策

| 决策项 | 结论 |
|--------|------|
| 项目名称 | Control Center |
| 文档语言 | 中文主 |
| 数据隐私模型 | GitHub Template，用户使用模板创建自己的私有仓库 |
| v1 接入 AI | Claude Code、Codex、OpenClaw |
| 内置 Skill | Reflect、Init Project、Profile Sync |
| 是否预装其他 Skill | 否，README 教用户按需自行添加 |
| 可视化 | v3 再做 |

---

## 三、Onboarding 问卷（5 题）

目标：让 AI 像认识朋友一样了解你，而不是填项目调研表。

```
Q1. 你是做什么的，现在处于哪个阶段？
    不只是职业名称——是你在这个职业里的位置和状态

Q2. 你在思考和工作上，有没有什么特别的地方？
    你的优势、你的思维方式、你容易忽略的
    AI 根据这个判断如何解释事情、如何补足你的盲区

Q3. 你现在最想推进的 1-3 件事是什么？
    半年到一年的真实目标，不一定是当前任务

Q4. 在和 AI 协作时，有没有什么是你非常在意的？
    你希望 AI 怎么做，以及你不想要什么

Q5. 你现在在推进哪些具体项目？（名字 + 一句话就够）
    建立初始项目卡片，AI 后续静默维护
```

**输出文件**：
- `profile/user.md` — Q1 + Q2
- `profile/goals.md` — Q3
- `profile/rules.md` — Q4
- `memory/projects/[name].md` — Q5

---

## 四、三个内置 Skill（记忆内核）

### Reflect（复盘）

触发词：复盘 / 我不满意 / 回顾一下

- 回顾当前项目的决策、进展、教训
- 提炼有价值的经验写入 `memory/global.md`

---

### Init Project（项目初始化）

**隐性**（用户感知不到）：
- SessionStart hook 检测当前目录，若无 `.ai/project.md` 则静默创建
- CLAUDE.md 内置指令：每次有实质进展后静默更新 `.ai/project.md`
- AI 每次 session 自动读取，始终带着项目上下文

**显性**（用户需要时可调用）：
- `/init-project` — 查看当前项目档案，或手动触发更新

`.ai/project.md` 模板：
```
# [项目名]
目标：
当前阶段：
关键决策：
下一步：
注意事项：
最后更新：
```

---

### Profile Sync（画像更新）

触发词：更新我的档案 / 作为 Reflect 收尾步骤

- 读取近期 project.md 的更新记录
- 读取 Reflect 的输出
- 提炼 AI 在工作中新学到的关于用户的认知
- 写回 `profile/user.md`

---

### 记忆完整闭环

```
建立 → Onboarding（问卷，一次性）
       ↓
维护 → Init Project（项目级，AI 静默更新）
       ↓
回顾 → Reflect（里程碑 / 复盘触发）
       ↓
生长 → Profile Sync（把学到的写回画像）
       ↓
更好的你 → 下次 AI 来了，直接认识你
```

---

## 五、架构

```
control-center/（公开模板仓库）
│
├── profile/                 ← 用户画像（三个 AI 共享）
│   ├── user.md              # 你是谁、你怎么思考
│   ├── goals.md             # 你的目标
│   └── rules.md             # AI 永远要 / 永远不要
│
├── memory/                  ← AI 记忆层（三个 AI 共享）
│   ├── global.md            # 跨项目经验积累
│   └── projects/            # 每个项目一张卡片
│
├── .ai/                     ← 项目级记忆（自动生成）
│   └── project.md           # 当前项目档案，AI 静默维护
│
├── connectors/              ← 各 AI 接入适配层
│   ├── claude-code/
│   │   └── CLAUDE.md        # @引用 profile/ + memory/
│   ├── codex/
│   │   └── instructions.md
│   └── openclaw/
│       └── workspace.md
│
├── skills/                  ← 三个内置 Skill
│   ├── reflect.md
│   ├── init-project.md
│   └── profile-sync.md
│
├── hooks/                   ← 自动化
│   ├── session-start.sh     # 启动时 git pull + 检测项目
│   └── auto-push.sh         # 修改后自动 commit + push
│
└── local/                   ← 本地专用，.gitignore 屏蔽
    └── .env
```

---

## 六、版本规划

| 版本 | 内容 |
|------|------|
| **v1** | Onboarding、三个 Skill、三个 connector、两个 hook、README |
| **v1.5** | Profile Sync 与 Reflect 自动联动、跨设备冲突检测优化 |
| **v3** | 可视化：跨项目记忆图谱（参考 ITO Engine 知识图谱方向） |

---

## 七、README 结构

```
[Control Center · 一句话定位]

为什么需要它？（三个痛点）
它怎么解决？（三个核心体验）

快速开始（5 分钟）

核心概念
  · 用户画像层
  · AI 记忆层
  · 三个 Skill

接入支持（Claude Code / Codex / OpenClaw）

完整配置

如何添加更多 Skill

参与贡献 / 许可证
```

---

## 八、开源标准件

| 文件 | 优先级 |
|------|--------|
| README.md（中文主） | 必须 |
| LICENSE（MIT） | 必须 |
| .gitignore（屏蔽 local/ 和 .env） | 必须 |
| setup.sh（一键配置） | 核心 |
| CONTRIBUTING.md | 建议 |
| CODE_OF_CONDUCT.md | 建议 |
| SECURITY.md | 建议 |
