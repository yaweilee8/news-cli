# 🚀 快速开始 - GitHub + Netlify 自动部署

## 一键设置（3步完成）

### 步骤 1: 创建 GitHub 仓库（1分钟）

1. 访问: https://github.com/new
2. 仓库名: `news-cli`
3. 描述: `中国热门新闻CLI工具 - 支持百度热搜和知乎热榜`
4. ❌ 不要勾选任何初始化选项
5. 点击 **"Create repository"**

### 步骤 2: 推送代码（30秒）

```bash
cd ~/news-cli
git push -u origin main
```

### 步骤 3: 关联 Netlify（2分钟）

1. 访问: https://app.netlify.com/projects/charming-dolphin-4ef2cb/settings/deploys
2. 找到 **"Continuous Deployment"** → **"GitHub"**
3. 点击 **"Connect to GitHub"**
4. 选择 `news-cli` 仓库
5. 保存设置

✅ **完成！** 现在每次推送代码，Netlify 会自动部署。

---

## 📖 详细指南

查看完整配置文档: [GITHUB_SETUP.md](GITHUB_SETUP.md)

---

## 💻 日常使用

### 修改代码后一键部署

```bash
./push.sh
```

输入提交信息（例如：`feat: 添加新功能`），脚本会自动：
1. 添加所有更改
2. 创建提交
3. 推送到 GitHub
4. 触发 Netlify 自动部署

### 手动提交（传统方式）

```bash
git add .
git commit -m "your message"
git push
```

---

## 🎯 提交信息规范

使用约定式提交格式：

```bash
# 新功能
./push.sh
# 输入: feat: 添加知乎热榜数据源

# 修复bug
./push.sh
# 输入: fix: 修复API调用错误

# 文档更新
./push.sh
# 输入: docs: 更新README

# 样式调整
./push.sh
# 输入: style: 优化CSS颜色

# 代码重构
./push.sh
# 输入: refactor: 重构API处理逻辑

# 测试相关
./push.sh
# 输入: test: 添加单元测试

# 构建/工具
./push.sh
# 输入: chore: 更新依赖包版本
```

---

## 🔍 验证部署

推送代码后，访问：

- **部署日志**: https://app.netlify.com/projects/charming-dolphin-4ef2cb/deploys
- **网站地址**: https://charming-dolphin-4ef2cb.netlify.app

---

## 📊 项目文件

- `push.sh` - 快速提交脚本（日常使用）
- `deploy.sh` - Netlify 部署脚本（手动部署）
- `setup-github.sh` - GitHub 初始化脚本
- `GITHUB_SETUP.md` - 完整配置指南
- `NETLIFY_DEPLOY.md` - Netlify 部署详解
- `DEPLOYMENT.md` - 当前部署信息

---

## ⚡ 快速命令参考

```bash
# 查看当前状态
git status

# 查看提交历史
git log --oneline

# 查看远程仓库
git remote -v

# 查看最新部署
open https://app.netlify.com/projects/charming-dolphin-4ef2cb/deploys

# 访问网站
open https://charming-dolphin-4ef2cb.netlify.app

# 访问 GitHub 仓库
open https://github.com/yaweilee/news-cli
```

---

## 🎉 开始使用吧！

现在你可以：
1. ✅ 修改代码
2. ✅ 运行 `./push.sh`
3. ✅ 自动部署到 Netlify
4. ✅ 几分钟后网站更新

享受自动化开发的便利！ 🚀
