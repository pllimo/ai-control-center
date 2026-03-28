# PROJECT-PLAN

> 这是一份项目执行单，不是代码文档。
> 只写自然语言、任务、验收、阻塞和交接，不写代码或命令。
> 这份文档的用途，是直接交给 Claude Code 继续执行。

## 0. 当前接手入口

- 当前状态：v1 + v1.5 + v3 全部完成并推送，进入收尾 / 迭代阶段
- 当前轮次：Round 3
- 当前负责人：Claude Code
- 当前唯一下一步：补 SECURITY.md，测试新设备 setup.sh 流程，收集用户反馈
- GitHub：https://github.com/pllimo/ai-control-center
- 如果换人 / 换 session，请先从这里继续

---

## 1. 项目目标

- 在 `/Users/zhuyueyi/Projects/control center/` 孵化一个新的开源项目
- 这个项目不是公开用户现有的 `control-center`，而是吸收其中最有价值、最可复用的能力，重新包装成一个专业的 public 项目
- 目标是让陌生用户拿到项目后，能理解并使用这些能力：
  - 多个 AI 共享用户画像、项目记忆、协作规则
  - 多个 AI 在同一套上下文里协作成长
  - 同一套 AI 工作流跨设备连续使用
  - 新用户通过 onboarding 建立最小基础信息，让 AI 后续越用越懂他

---

## 2. 项目背景

- 用户现有系统里最有价值的，不是某一份私人 prompt，而是以下抽象能力：
  - 文档驱动的长期协作
  - 高质量的非 UX 类 skills 中的一部分高频能力
  - 与功能直接相关的 hooks
  - 多 AI 共享与跨设备连接

- 用户的最高标准要求：
  - 项目必须专业，不像私人 dotfiles
  - 项目必须做好新手引导
  - 项目要像脑仓一样，通过基础问题了解用户
  - 项目要能清楚讲明两个核心模块：
    - 用户模块：让 AI 先理解“这个用户是谁”
    - AI 记忆模块：让 AI 的智力和协作能力随着使用提升
  - 项目要支持三方 AI 共享与跨设备连接
  - 项目需要把 README、提示词思路、功能解释整理清楚，让用户一眼看懂

- 用户明确要求：
  - 这里只需要写好执行计划给 Claude
  - 不需要由当前执行者替 Claude 往下写完整产物

---

## 3. 不做什么

- 不公开用户现在的 `control-center`
- 不直接搬运用户私人记忆、私人储藏室、私人 prompt
- 不把 `my-vault`、`my-brain` 直接打包进来
- 不先做重 UI、大而全的“超级大脑”
- 不在当前轮次直接写完整实现代码，先完成定位、结构、模块边界、公开叙事和执行路线

---

## 4. 参考输入

- 用户现有系统与参考仓库：
  - `/Users/zhuyueyi/claude-learnings`
  - `/Users/zhuyueyi/my-brain`
  - `/Users/zhuyueyi/Projects/clawd-on-desk`
  - `/Users/zhuyueyi/Projects/claude-code-tamagotchi`

- 参考重点：
  - 从 `claude-learnings` 提炼可公开的结构优势、skills 思路、hooks 思路、文档体系
  - 从 `my-brain` 学 onboarding、用户理解、记忆分层、专业叙事
  - 从 `clawd-on-desk` 学专业 README、Quick Start、多 agent 接入说明、技术可信度表达
  - 从 `claude-code-tamagotchi` 学安装分层、功能分档、配置文档组织

- 允许 Claude 自行补充外部研究，优先查：
  - 真实用户对多 AI 断联、上下文重复解释、跨设备工作流的痛点表达
  - 成熟开源项目的 README / CONTRIBUTING / SECURITY / LICENSE 规范

---

## 5. 当前判断

- 这个新项目更适合被定义为：
  - `AI context hub`
  - 或 `personal AI control center`
  - 或 `shared memory workspace for AI agents`

- 当前最强的产品卖点不是“第二大脑”，而是：
  - 换个 AI，不用重讲一遍
  - 换台电脑，不用重新接上下文
  - 多个 AI 一起做事，不会各说各话

- 项目最值得抽象的 6 个模块：
  - `Onboarding`
  - `User Profile`
  - `AI Memory Engine`
  - `Agent Connectors`
  - `Cross-Device Sync`
  - `Workflow Packs`

---

## 6. 本轮范围

- 完成这个新项目的专业级执行框架
- 输出后续 public 发布前必需的决策与文档骨架
- 明确：
  - 项目命名方向
  - README 首页结构
  - onboarding 问题流
  - 用户模块与记忆模块的边界
  - v1 支持哪些 AI
  - 哪些 skills / hooks 值得公开抽象
  - 开源基础件清单

---

## 7. 验收标准

- 用户把这份计划交给 Claude 后，Claude 不需要重新听背景，就能开始执行
- Claude 最终应能输出：
  - 明确的新项目定位
  - 专业的 README 结构方案
  - 新手 onboarding 问题流
  - 用户模块 / 记忆模块 / 连接器模块边界
  - v1 功能与范围
  - 开源标准件清单
- 整体结果必须看起来像一个准备 public 的专业开源项目，而不是私人工作流备忘

---

## 8. 任务清单

### Phase 1 · 方向收束

- [x] T1. 用最小必要研究确认项目定位与赛道表达
  执行路由：direct-execution
  输入：
  - 本文件
  - 本地参考仓库
  - 必要的外部公开资料
  产物：
  - 一段清晰的项目定义
  - 2-3 个命名方向
  - 1-2 句对外价值主张
  负责人：Claude Code
  完成标准：
  - 项目不再被表述成“公开用户自己的系统”
  - 项目一句话就能讲清楚
  依赖：无

- [x] T2. 明确项目与 `control-center` / `my-brain` / `my-vault` 的边界
  执行路由：direct-execution
  输入：
  - 用户要求
  - 本地三个系统的结构与用途
  产物：
  - 一份边界说明
  负责人：Claude Code
  完成标准：
  - 讲清楚哪些能力继承，哪些内容不公开
  依赖：T1

### Phase 2 · 用户引导与模块设计

- [x] T3. 设计首次 onboarding 问题流
  执行路由：direct-execution
  输入：
  - 用户要求“像脑仓一样先通过基础问题了解用户”
  产物：
  - 一套面向新用户的初始问答
  负责人：Claude Code
  完成标准：
  - 问题足够建立最小用户画像
  - 不压迫，不像调查问卷
  - 能直接支撑后续 AI 记忆与协作
  依赖：T1

- [x] T4. 定义两个核心模块
  执行路由：direct-execution
  输入：
  - 用户要求中的 “customer / 用户模块”
  - 用户要求中的 “AI 记忆模块”
  产物：
  - 两个模块的边界、职责、数据范围
  负责人：Claude Code
  完成标准：
  - 用户模块与 AI 记忆模块区别清楚
  - 能解释“AI 智力不断升级”具体在什么层面发生
  依赖：T3

- [x] T5. 定义共享层与私有层
  执行路由：direct-execution
  输入：
  - 多 AI 共享
  - agent 角色差异
  产物：
  - 共享信息与私有信息的分层方案
  负责人：Claude Code
  完成标准：
  - 至少讲清楚用户共享画像、项目共享记忆、agent 私有角色
  依赖：T4

### Phase 3 · 功能与接入范围

- [x] T6. 评估现有高频 skills 中哪些值得公开产品化
  执行路由：direct-execution
  输入：
  - `claude-learnings` 中除 UX 设计以外的高频 skills
  产物：
  - 一份可公开 workflow packs 候选清单
  负责人：Claude Code
  完成标准：
  - 只保留高频、通用、可公开、真正提升用户价值的能力
  依赖：T2

- [x] T7. 评估 hooks 中哪些和产品功能强相关
  执行路由：direct-execution
  输入：
  - `claude-learnings/hooks`
  产物：
  - hooks 价值评估
  负责人：Claude Code
  完成标准：
  - 区分“应该产品化的 hooks”与“只适合留在私人系统里的 hooks”
  依赖：T2

- [x] T8. 固定 v1 AI 接入范围
  执行路由：user-review
  输入：
  - 用户要求的三方 AI 共享
  - 实现复杂度
  产物：
  - v1 / v1.5 / later 支持表
  负责人：Claude Code
  完成标准：
  - 明确 Claude Code、Codex、OpenClaw 的优先级和接入方式
  依赖：T5、T7

- [x] T9. 设计跨设备连接方案
  执行路由：direct-execution
  输入：
  - Git 同步思路
  - 本地文件系统思路
  - 如有需要，远程接入思路
  产物：
  - 跨设备连续性的设计方案
  负责人：Claude Code
  完成标准：
  - 方案清楚、可信、不过度承诺
  依赖：T8

### Phase 4 · 对外专业表达

- [x] T10. 设计 README 首页结构
  执行路由：direct-execution
  输入：
  - 前面全部判断
  - 参考项目 README 形式
  产物：
  - README 章节结构
  负责人：Claude Code
  完成标准：
  - 首页先讲用户痛点，再讲产品承诺，再讲 Quick Start，再讲架构和接入
  依赖：T1、T4、T8、T9

- [x] T11. 设计安装分层
  执行路由：direct-execution
  输入：
  - 参考项目的 quick start / full setup 做法
  产物：
  - Quick Start / Full Setup / Optional Connectors 三级安装路径
  负责人：Claude Code
  完成标准：
  - 新手可以先上手，进阶用户可以逐步接满
  依赖：T8、T9

- [x] T12. 列出开源专业度标准件
  执行路由：direct-execution
  输入：
  - GitHub / Open Source Guides 最低标准
  产物：
  - 开源标准件清单
  负责人：Claude Code
  完成标准：
  - 至少包含 README、LICENSE、CONTRIBUTING、CODE_OF_CONDUCT、SECURITY
  依赖：T10

### Phase 5 · 交付给用户确认

- [x] T13. 汇总成一份面向用户的决策稿
  执行路由：user-review
  输入：
  - T1-T12 的结果
  产物：
  - 一份让用户拍板的方案稿
  负责人：Claude Code
  完成标准：
  - 用户可以根据这份结果决定是否进入真正实现阶段
  依赖：T10、T11、T12

---

## 9. 阻塞 / 待确认

- [x] 项目最终命名 → Control Center
- [x] 哪些 skills 值得公开 → Reflect / Init Project / Profile Sync
- [x] 哪些 hooks 产品化 → session-start / auto-push / sync.sh
- [x] v1 是否接入 OpenClaw → 是，三个 AI 全接

### 当前待确认

- [ ] SECURITY.md 尚未补充
- [ ] setup.sh 未经全新设备测试

---

## 10. 验收反馈

- F1. 用户要求这是一个新项目，不是改原项目
  状态：已转任务

- F2. 用户要求只写好计划给 Claude，不由当前执行者继续代写产物
  状态：已转任务

- F3. 用户要求 onboarding 做好，新手拿到产品要被引导起来
  状态：已转任务

- F4. 用户要求突出用户模块、AI 记忆模块、三方共享、跨设备连接
  状态：已转任务

- F5. 用户要求整体呈现足够专业，能面向 public 发布
  状态：已转任务

---

## 11. Review 与计划调整

- 本轮 review 结论：
  - 当前阶段应该只交付计划，不继续代做内容
  - 计划必须单文件自带上下文，方便直接交给 Claude
- 新增任务：
  - 把背景、边界、参考输入全部折叠进本文件
- 作废任务：
  - 由当前执行者继续写 brief、research、README 等产物
- 重新排序原因：
  - 用户明确要求由 Claude 接手后续工作，而不是当前执行者替他完成

---

## 12. 交接记录

- 本次完成：
  - 清理了多余文档
  - 保留单文件 `PROJECT-PLAN.md`
  - 把背景、目标、边界、任务拆解全部折叠到本文件里

- 当前正在做：
  - 无

- 下一步：
  - 把本文件交给 Claude Code

- 接手前先看：
  - 只需要先看本文件

- 注意事项：
  - 不要直接公开用户现有系统内容
  - 不要跳过定位与表达，直接开始造功能
  - 优先完成对外表达、模块边界和执行方案

---

## 13. 迭代记录

### Round 1
- 目标：写出一份可直接交给 Claude Code 的项目执行单
- 结果：已完成
- 验收结论：可交接

### Round 2（已完成）
- 目标：搭建项目骨架，完成可运行的 v1 + v1.5 + v3
- 结果：全部完成，推送至 https://github.com/pllimo/ai-control-center
- 核心交付：
  - [x] 完整文件结构（profile / memory / connectors / skills / hooks）
  - [x] 三个 Skill（reflect / init-project / profile-sync）
  - [x] 三个 connector（claude-code / codex / openclaw）
  - [x] 两个 hook（session-start / auto-push）
  - [x] Onboarding 问卷（setup.sh）
  - [x] v1.5：sync.sh + launchd 后台自动同步
  - [x] v1.5：Reflect 结束自动触发 Profile Sync
  - [x] v3：visualization.html 记忆仪表盘（原创设计）
  - [x] v3：scripts/build-viz.py 数据生成脚本
  - [x] README 重写（面向新用户，含完整 Skill 说明）

### Round 3（当前）
- 目标：补充遗漏项，收集反馈，规划下一迭代
- 待完成：
  - [ ] 补充 SECURITY.md
  - [ ] 测试全新设备 setup.sh 完整流程
  - [ ] 收集早期用户反馈
