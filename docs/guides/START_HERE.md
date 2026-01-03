# ⚡ 开始配置 GitHub + Netlify 自动部署

## 📋 当前状态

✅ 本地代码已准备好
✅ Git 仓库已初始化
✅ Netlify 站点已创建
✅ 部署脚本已配置

⏳ 需要完成：
1. 在 GitHub 创建仓库
2. 推送代码到 GitHub
3. 在 Netlify 关联 GitHub

---

## 🚀 立即开始（3步完成）

### 第 1 步：在 GitHub 创建仓库

**点击这个链接创建仓库：**
👉 https://github.com/new

**填写信息：**
- **Repository name**: `news-cli`
- **Description**: `中国热门新闻CLI工具 - 支持百度热搜和知乎热榜，可部署到Netlify`
- **Visibility**: 🔘 Public
- **⚠️ 重要**：
  - ❌ 不要勾选 "Add a README file"
  - ❌ 不要勾选 "Add .gitignore"
  - ❌ 不要勾选 "Choose a license"

点击 **"Create repository"** 按钮。

---

### 第 2 步：推送代码到 GitHub

创建仓库后，回到终端运行：

```bash
cd ~/news-cli
git push -u origin main
```

**预期输出：**
```
Enumerating objects: XX, done.
...
To https://github.com/yaweilee/news-cli.git
 * [new branch]      main -> main
```

✅ 成功后，访问你的仓库：https://github.com/yaweilee/news-cli

---

### 第 3 步：在 Netlify 关联 GitHub

**1. 访问 Netlify 设置：**
👉 https://app.netlify.com/projects/charming-dolphin-4ef2cb/settings/deploys

**2. 连接 GitHub：**
- 找到 **"Continuous Deployment"** 部分
- 点击 **"Edit settings"**
- 点击 **"Connect to GitHub"** 按钮

**3. 授权并选择仓库：**
- 如果需要，授权 Netlify 访问 GitHub
- 在仓库列表中找到并选择 `news-cli`
- 点击仓库连接

**4. 配置构建设置：**
- **Build command**: 留空
- **Publish directory**: `public`
- **Functions directory**: `netlify/functions`
- **Branch to deploy**: `main`

点击 **"Save"** 保存设置。

---

## 🎉 完成！

配置完成后，你的工作流程：

### 💻 日常开发

```bash
# 1. 修改代码
vim index.js

# 2. 一键提交并自动部署
./push.sh
# 输入提交信息，例如：feat: 添加新功能

# ✅ Netlify 自动检测并部署
```

### 📊 监控部署

- **部署状态**: https://app.netlify.com/projects/charming-dolphin-4ef2cb/deploys
- **网站地址**: https://charming-dolphin-4ef2cb.netlify.app
- **GitHub 仓库**: https://github.com/yaweilee/news-cli

---

## 📖 相关文档

- **快速指南**: [QUICKSTART.md](QUICKSTART.md)
- **详细配置**: [GITHUB_SETUP.md](GITHUB_SETUP.md)
- **部署说明**: [NETLIFY_DEPLOY.md](NETLIFY_DEPLOY.md)
- **项目文档**: [README.md](README.md)

---

## ❓ 遇到问题？

### 问题 1: git push 失败，提示 "Repository not found"

**解决方法**:
1. 确认已在 GitHub 创建了 `news-cli` 仓库
2. 确认仓库名称正确
3. 确认你有权限访问该仓库

### 问题 2: Netlify 找不到 GitHub 仓库

**解决方法**:
1. 确保 Netlify 已获得 GitHub 授权
2. 仓库必须是 Public 或 Netlify 账号有访问权限
3. 刷新 Netlify 页面重试

### 问题 3: 推送后 Netlify 没有自动部署

**解决方法**:
1. 检查推送的分支是 `main` 而不是其他分支
2. 在 Netlify 设置中确认已启用该分支的自动部署
3. 查看 Netlify 部署日志是否有错误

---

## ✅ 检查清单

完成以下检查确认配置成功：

- [ ] GitHub 仓库已创建并可访问
- [ ] 代码已成功推送到 GitHub
- [ ] Netlify 已连接到 GitHub 仓库
- [ ] Netlify 构建设置正确
- [ ] 推送测试代码，观察自动部署
- [ ] 网站可正常访问并显示最新内容

---

## 🎯 下一步

配置完成后，你可以：

1. **添加更多功能**: 修改 `index.js` 或 `public/index.html`
2. **配置自定义域名**: 在 Netlify 设置中添加
3. **启用分支部署**: PR 会自动生成预览链接
4. **配置环境变量**: 添加 API 密钥等
5. **设置部署通知**: Email、Slack 等

---

## 📞 需要帮助？

- **GitHub 支持**: https://support.github.com
- **Netlify 支持**: https://www.netlify.com/support/
- **项目文档**: 查看 `*.md` 文件

---

**准备好了吗？开始配置吧！** 🚀

1. 👉 创建 GitHub 仓库: https://github.com/new
2. 👉 运行: `git push -u origin main`
3. 👉 在 Netlify 连接 GitHub
4. ✅ 完成！
