# Control Center — OpenClaw 接入

> 此文件由 setup.sh 自动生成。
> 将此文件内容添加到 OpenClaw 的 workspace 配置，实现上下文共享。

## 用户画像

@CONTROL_CENTER_HOME/profile/user.md

## 目标

@CONTROL_CENTER_HOME/profile/goals.md

## 协作规则

@CONTROL_CENTER_HOME/profile/rules.md

## 共享经验记忆

@CONTROL_CENTER_HOME/memory/global.md

## 项目记忆

当前项目如果存在 `.ai/project.md`，读取它作为项目上下文。

## 手动配置方式

如果 setup.sh 未能自动完成 OpenClaw 配置，请手动将此文件路径
添加到 `~/.openclaw/workspace/MEMORY.md` 的 @引用中：

```
@CONTROL_CENTER_HOME/connectors/openclaw/workspace.md
```
