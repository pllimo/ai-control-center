# Control Center — Codex 接入

> 此文件由 setup.sh 自动生成并写入 ~/.codex/instructions.md。
> 让 Codex 在每次会话中共享用户画像和 AI 记忆。

## 关于我

以下是我的用户画像，请在整个会话中记住这些信息：

@CONTROL_CENTER_HOME/profile/user.md

## 我的目标

@CONTROL_CENTER_HOME/profile/goals.md

## 协作规则

@CONTROL_CENTER_HOME/profile/rules.md

## 共享经验

@CONTROL_CENTER_HOME/memory/global.md

## 当前项目

如果当前目录下存在 `.ai/project.md`，请优先读取它作为项目上下文。

## 行为要求

- 每次有实质进展后，更新当前项目的 `.ai/project.md`
- 严格遵守 rules.md 中的协作规则
- 遇到风险或不确定，主动说出来
