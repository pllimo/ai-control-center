# Control Center · 项目文档

## 是什么

**Control Center**（中控系统）是一个开源的 AI 上下文枢纽。
让每一个 AI（Claude Code / Codex / OpenClaw）、在每一台设备上，都认识同一个用户。

**GitHub**：https://github.com/pllimo/ai-control-center（公开）
**本地路径**：`/Users/zhuyueyi/Projects/control center/`
**项目总**：zhuyueyi

---

## 当前进度

**已完成（v1 + v1.5 + v3 全部上线）**
- Round 1：方向定位、模块设计、功能范围、DECISION.md 产出
- Round 2：完整实现并推送 GitHub
  - v1：Onboarding + 三个 Skill + 三个 AI connector + 两个 Hook
  - v1.5：后台自动同步（sync.sh + launchd）+ Reflect/ProfileSync 自动联动
  - v3：可视化记忆仪表盘（visualization.html + build-viz.py）
  - README 重写（面向完全不了解的新用户）

**下一步**
- [ ] 补充 SECURITY.md
- [ ] 测试 setup.sh 在全新设备上的完整流程
- [ ] 收集早期用户反馈，规划下一轮迭代

---

## 关键决策

| 决策 | 选择 | 原因 |
|------|------|------|
| 项目名称 | Control Center | 用户确认，清晰表达系统性质 |
| v1 AI 接入 | Claude Code + Codex + OpenClaw | 用户现有工具链，优先接通 |
| 数据存储方式 | GitHub Template + 用户私有仓库 | 用户数据不公开，结构可公开 |
| 文档语言 | 中文主 | 面向中文用户优先 |
| 可视化方案 | 纯 HTML/Canvas，不用 D3 | 原创设计，避免与 ITO Engine 雷同 |
| 跨 AI 同步 | sync.sh + launchd，每 2 分钟 | 全自动，用户无感知 |

---

## 注意事项

- 不公开用户现有 `~/claude-learnings/` 的任何私人内容（画像、prompt、记忆）
- 公开的是结构和能力，不是内容
- visualization.html 是原创设计，不能与 `~/my-brain` 的知识图谱雷同
- `local/` 目录永远不入库（.gitignore 已配置）
- PROJECT-PLAN.md 是执行单，DECISION.md 是设计决策稿，两者分工不同

---

## 重要文件

| 文件 | 用途 |
|------|------|
| `DECISION.md` | 所有设计决策（已拍板） |
| `PROJECT-PLAN.md` | 任务执行单（含勾选状态） |
| `README.md` | 对外公开说明，面向新用户 |
| `setup.sh` | 用户配置入口 |
| `sync.sh` | 后台同步主脚本 |
| `skills/` | 三个内置 Skill 文件 |
| `visualization.html` | 记忆仪表盘 |
