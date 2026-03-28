# 参与贡献

感谢你对 Control Center 的兴趣。

---

## 贡献方式

### 提交 Issue

遇到问题或有想法？欢迎提交 Issue：

- **Bug**：描述复现步骤、期望行为、实际行为
- **功能建议**：说明使用场景和解决的问题
- **文档改进**：哪里不够清楚，或者有遗漏

### 提交 PR

1. Fork 本仓库
2. 基于 `main` 创建新分支（`git checkout -b feat/你的功能名`）
3. 修改并测试
4. 提交 PR，描述你改了什么、为什么改

---

## 项目结构

```
control-center/
├── profile/        用户画像模板
├── memory/         AI 记忆层模板
├── connectors/     各 AI 接入配置
├── skills/         内置 Skill
├── hooks/          自动化脚本
└── setup.sh        配置向导
```

---

## 什么值得贡献

- 新的 AI 接入 connector（Cursor、Copilot 等）
- 优化 Onboarding 问卷的问题
- 改进 Skill 的执行逻辑
- setup.sh 兼容性修复（Linux、Windows WSL）
- 文档翻译

---

## 行为准则

参与本项目即表示你同意遵守 [Code of Conduct](CODE_OF_CONDUCT.md)。
