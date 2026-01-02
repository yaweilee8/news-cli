# GitHub 和 Netlify 自动部署配置指南

## 📋 步骤概览

1. ✅ 在 GitHub 创建仓库
2. ✅ 推送代码到 GitHub
3. ✅ 在 Netlify 关联 GitHub 仓库
4. ✅ 测试自动部署

---

## 步骤 1: 在 GitHub 创建仓库

### 方法 A: 通过网页创建（推荐）

1. 访问: https://github.com/new
2. 填写仓库信息：
   - **Repository name**: `news-cli`
   - **Description**: `中国热门新闻CLI工具 - 支持百度热搜和知乎热榜，可部署到Netlify`
   - **Visibility**: 🔘 Public
   - **⚠️ 重要**: 不要勾选以下选项（我们已有这些文件）:
     - ❌ Add a README file
     - ❌ Add .gitignore
     - ❌ Choose a license

3. 点击 **"Create repository"**

### 方法 B: 使用 GitHub CLI (如果已安装)

```bash
# 安装 GitHub CLI (macOS)
brew install gh

# 登录
gh auth login

# 创建仓库
gh repo create news-cli --public --source=. --remote=origin --description="中国热门新闻CLI工具 - 支持百度热搜和知乎热榜"

# 推送代码
git push -u origin main
```

---

## 步骤 2: 推送代码到 GitHub

创建仓库后，在项目目录运行以下命令：

```bash
cd ~/news-cli

# 添加远程仓库（如果还没有）
git remote add origin https://github.com/yaweilee/news-cli.git

# 推送代码
git push -u origin main
```

**预期输出**:
```
Enumerating objects: XX, done.
Counting objects: 100% (XX/XX), done.
...
To https://github.com/yaweilee/news-cli.git
 * [new branch]      main -> main
```

✅ 成功后，访问: https://github.com/yaweilee/news-cli

---

## 步骤 3: 在 Netlify 关联 GitHub 仓库

### 3.1 访问 Netlify 项目设置

1. 访问: https://app.netlify.com/projects/charming-dolphin-4ef2cb
2. 点击 **"Site configuration"** 或 **"Settings"**

### 3.2 配置持续部署

1. 在左侧菜单找到 **"Build & deploy"**
2. 点击 **"Continuous Deployment"**
3. 找到 **"GitHub"** 部分
4. 点击 **"Edit settings"**

### 3.3 连接 GitHub 仓库

1. 点击 **"Connect to GitHub"**
2. 如果需要，授权 Netlify 访问你的 GitHub
3. 在仓库列表中选择 `news-cli`
4. 配置构建设置：
   ```
   Build command: (留空)
   Publish directory: public
   Functions directory: netlify/functions
   Branch to deploy: main
   ```
5. 点击 **"Save"**

### 3.4 配置部署钩子（可选）

在 **"Build & deploy"** → **"Deploy contexts"** → **"Branch deploy commits"** 中：
- 确保勾选了 **"Stop builds if not needed"**（节省构建时间）

---

## 步骤 4: 配置 .gitignore 和 .netlify

### 确保 .gitignore 文件正确

```bash
cat .gitignore
```

应该包含：
```
node_modules/
.DS_Store
.env
*.log
.netlify/
```

### .netlify 目录

首次部署后，Netlify 会创建 `.netlify` 目录：
- `.netlify/state.json` - 项目链接信息
- 此文件不应提交到 Git（已在 .gitignore 中排除）

---

## 步骤 5: 测试自动部署

### 5.1 提交一个测试更改

```bash
# 修改 README 添加一行测试
echo "## 测试自动部署" >> README.md

# 提交更改
git add .
git commit -m "test: 测试自动部署功能"

# 推送到 GitHub
git push
```

### 5.2 观察自动部署

1. 访问: https://app.netlify.com/projects/charming-dolphin-4ef2cb/deploys
2. 应该看到新的部署正在构建
3. 部署完成后，网站会自动更新

### 5.3 验证部署成功

访问: https://charming-dolphin-4ef2cb.netlify.app

---

## 🔄 日常工作流程

配置完成后，你的工作流程变为：

### 1️⃣ 修改代码

```bash
# 编辑文件
vim index.js
# 或
vim public/index.html
```

### 2️⃣ 测试本地更改

```bash
# 测试 CLI
npm start

# 测试 Web 服务器
npm run web
```

### 3️⃣ 提交到 GitHub

```bash
git add .
git commit -m "feat: 添加新功能描述"
git push
```

### 4️⃣ 自动部署 ✨

- Netlify 自动检测到推送
- 开始构建和部署
- 几分钟后网站更新完成！

---

## 📊 监控部署状态

### Netlify Dashboard

- **部署历史**: https://app.netlify.com/projects/charming-dolphin-4ef2cb/deploys
- **Function 日志**: https://app.netlify.com/projects/charming-dolphin-4ef2cb/logs/functions
- **部署预览**: Pull Request 会自动生成预览链接

### GitHub

- **仓库**: https://github.com/yaweilee/news-cli
- **提交历史**: https://github.com/yaweilee/news-cli/commits/main
- **分支保护**: Settings → Branches → Add rule

---

## 🔔 Netlify 通知（可选）

### 配置部署通知

1. 访问: https://app.netlify.com/projects/charming-dolphin-4ef2cb/settings/notifications
2. 可以配置：
   - 📧 Email 通知
   - 💬 Slack 通知
   - 📱 Discord 通知
   - 🔔 Webhook 通知

---

## 🎯 最佳实践

### 提交信息规范

使用约定式提交（Conventional Commits）:

```bash
git commit -m "feat: 添加新的数据源"
git commit -m "fix: 修复API调用错误"
git commit -m "docs: 更新README文档"
git commit -m "style: 优化CSS样式"
git commit -m "refactor: 重构代码结构"
git commit -m "test: 添加测试用例"
git commit -m "chore: 更新依赖包"
```

### 分支策略

```bash
# 创建功能分支
git checkout -b feature/add-new-source

# 开发和提交
git add .
git commit -m "feat: 添加新数据源"

# 推送到 GitHub
git push origin feature/add-new-source

# 创建 Pull Request
# 在 GitHub 网页上创建 PR

# 合并后自动部署到生产环境
```

### 环境变量管理

如果需要添加环境变量：

1. 访问: https://app.netlify.com/projects/charming-dolphin-4ef2cb/settings/variables
2. 点击 **"Add a variable"**
3. 添加变量（例如）:
   - `API_TIMEOUT`: `10000`
   - `MAX_NEWS_COUNT`: `20`

在 Functions 中使用：

```javascript
const timeout = process.env.API_TIMEOUT || 10000;
```

---

## 🐛 常见问题

### Q1: 推送后 Netlify 没有自动部署？

**A**: 检查：
1. GitHub 仓库是否正确关联到 Netlify
2. 推送的分支是否是 `main`
3. Netlify 设置中是否启用了该分支的自动部署

### Q2: 部署失败怎么办？

**A**:
1. 查看部署日志: https://app.netlify.com/projects/charming-dolphin-4ef2cb/deploys
2. 检查 `netlify.toml` 配置是否正确
3. 检查 Functions 是否有语法错误

### Q3: 如何回滚到之前的版本？

**A**:
1. 访问 Deploys 页面
2. 找到要回滚的部署
3. 点击 **"Publish deploy"** → **"Publish to current branch"**

---

## 📚 相关文档

- **项目 README**: [README.md](README.md)
- **Netlify 部署指南**: [NETLIFY_DEPLOY.md](NETLIFY_DEPLOY.md)
- **当前部署信息**: [DEPLOYMENT.md](DEPLOYMENT.md)

---

## ✅ 配置检查清单

完成以下检查确保一切正常：

- [ ] GitHub 仓库已创建
- [ ] 代码已推送到 GitHub
- [ ] Netlify 已关联 GitHub 仓库
- [ ] 构建设置正确配置
- [ ] 测试提交并观察自动部署
- [ ] 验证网站可以正常访问
- [ ] 配置部署通知（可选）

---

## 🎉 完成！

现在你的项目已经完全配置好了：
- ✅ 代码托管在 GitHub
- ✅ 推送代码自动触发部署
- ✅ Netlify 自动构建和发布
- ✅ 全球 CDN 加速
- ✅ 免费 SSL 证书

享受自动化部署的便利吧！ 🚀
