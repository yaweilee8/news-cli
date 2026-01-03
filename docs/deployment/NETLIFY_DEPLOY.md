# Netlify 部署指南

本指南将帮助你将中国热门新闻应用部署到 Netlify。

## 前置准备

1. 注册 [Netlify](https://www.netlify.com/) 账号
2. 安装 Git（如果尚未安装）
3. 安装 Node.js

## 方式一：通过 Netlify CLI 部署（推荐）

### 1. 初始化 Git 仓库

```bash
cd ~/news-cli
git init
git add .
git commit -m "Initial commit: News hot search app"
```

### 2. 安装 Netlify CLI

```bash
# 全局安装（需要sudo权限）
sudo npm install -g netlify-cli

# 或使用 npx（无需全局安装）
npx netlify --version
```

### 3. 登录 Netlify

```bash
netlify login
```

这会打开浏览器进行授权。

### 4. 初始化项目

```bash
netlify init
```

按提示操作：
- 选择 "Create & configure a new site"
- 选择团队（个人账号）
- 输入站点名称，例如：`china-hot-news`
- 选择部署命令：留空（静态站点）
- 发布目录：`public`

### 5. 部署

```bash
# 手动部署
netlify deploy --prod

# 或启用自动部署（需要先推送到GitHub）
git push origin main
```

## 方式二：通过 Netlify 网站手动部署

### 1. 准备部署文件

确保你的项目包含以下文件：
```
news-cli/
├── public/
│   └── index.html          # 前端页面
├── netlify/
│   └── functions/
│       ├── baidu-hot.js    # 百度热搜 API
│       └── zhihu-hot.js    # 知乎热榜 API
├── netlify.toml            # Netlify 配置
├── package.json            # 依赖配置
└── .gitignore              # Git忽略文件
```

### 2. 登录 Netlify

访问 [https://app.netlify.com/](https://app.netlify.com/)

### 3. 部署步骤

1. **创建新站点**
   - 点击 "Add new site" → "Deploy manually"

2. **拖放部署**
   - 将整个 `news-cli` 文件夹拖入 Netlify 上传区域
   - 或选择文件夹上传

3. **配置构建设置**
   - Publish directory: `public`
   - Functions directory: `netlify/functions`
   - Build command: 留空（静态站点）

4. **部署站点**
   - 点击 "Deploy site"
   - 等待部署完成（通常需要几秒钟）

5. **获取站点 URL**
   - 部署成功后，Netlify 会提供一个随机URL，例如：`https://amazing-pudding-123456.netlify.app`
   - 你可以在 Site settings → Domain management 中修改为自定义域名

## 方式三：通过 GitHub + Netlify 持续部署（推荐用于开发）

### 1. 创建 GitHub 仓库

```bash
# 在 GitHub 上创建新仓库
# 然后关联到本地仓库
git remote add origin https://github.com/你的用户名/news-cli.git
git branch -M main
git push -u origin main
```

### 2. 在 Netlify 中连接 GitHub

1. 登录 Netlify
2. 点击 "Add new site" → "Import an existing project"
3. 选择 "GitHub" 并授权
4. 选择 `news-cli` 仓库
5. 配置构建设置：
   - Build command: 留空
   - Publish directory: `public`
   - Functions directory: `netlify/functions`
6. 点击 "Deploy site"

### 3. 自动部署

现在每次推送到 GitHub 主分支，Netlify 会自动重新部署！

## 验证部署

部署完成后，访问你的 Netlify URL：

1. **测试主页**
   - 访问 `https://你的站点.netlify.app`
   - 应该看到百度热搜和知乎热榜两个标签

2. **测试 API 端点**
   - 访问 `https://你的站点.netlify.app/.netlify/functions/baidu-hot`
   - 应该返回 JSON 格式的百度热搜数据

3. **测试功能**
   - 点击 "刷新数据" 按钮
   - 切换 "百度热搜" 和 "知乎热榜" 标签
   - 点击新闻卡片查看详情

## 更新部署

### 方式1：通过 CLI

```bash
# 修改代码后
git add .
git commit -m "Update features"
netlify deploy --prod
```

### 方式2：通过 GitHub（持续部署）

```bash
git add .
git commit -m "Update features"
git push
# Netlify 会自动部署
```

### 方式3：手动拖放重新部署

在 Netlify 网站上：
1. 进入你的站点
2. 点击 "Deploys"
3. 点击 "Drag and drop your site output here"
4. 上传新的文件

## 环境变量（可选）

如果需要配置环境变量：

1. 进入 Site settings → Environment variables
2. 添加变量，例如：
   - `API_TIMEOUT`: `10000`
   - `MAX_NEWS_COUNT`: `20`

然后在 Functions 中使用：
```javascript
const timeout = process.env.API_TIMEOUT || 10000;
```

## 自定义域名（可选）

1. 进入 Site settings → Domain management
2. 点击 "Add custom domain"
3. 输入你的域名（例如 `news.yourdomain.com`）
4. 按提示配置 DNS 记录

## 常见问题

### Q: Functions 报错 "Cannot find module 'axios'"
**A**: 确保 `package.json` 中包含 `axios` 依赖，并且在 `netlify/functions` 目录中正确安装。

### Q: 部署成功但页面显示 "加载失败"
**A**: 检查浏览器控制台错误信息，可能是：
- CORS 问题（已在 Functions 中添加 CORS 头）
- API 端点路径错误（应该是 `/.netlify/functions/...`）
- 外部 API 限制访问

### Q: 知乎热榜一直显示 "API受限"
**A**: 这是正常的，知乎官方 API 需要认证。当前系统会自动尝试多个 API 源，并显示友好提示。

### Q: 如何查看 Functions 日志？
**A**:
1. 进入 Netlify 站点
2. 点击 "Functions"
3. 选择具体的 Function 查看日志

## 性能优化建议

1. **启用 CDN 缓存**
   - 在 `netlify.toml` 中添加缓存规则

2. **压缩资源**
   - Netlify 自动压缩 JS/CSS/HTML

3. **设置缓存头**
   ```toml
   [[headers]]
     for = "/*"
     [headers.values]
       Cache-Control = "public, max-age=3600"
   ```

## 成本说明

- Netlify 免费套餐包含：
  - 100GB 带宽/月
  - 300分钟构建时间/月
  - 无限站点和项目
  - Serverless Functions 免费额度：125,000次调用/月
  - 免费SSL证书

对于个人项目或小型应用，免费套餐完全足够！

## 技术架构

```
用户浏览器
    ↓
Netlify CDN (静态文件)
    ↓
Netlify Functions (Serverless API)
    ↓
外部API (百度/知乎)
```

## 部署状态检查

部署后，可以使用以下命令检查状态：

```bash
# 查看站点状态
netlify status

# 查看部署日志
netlify logs

# 查看站点信息
netlify sites:list
```

## 下一步

- [ ] 设置自定义域名
- [ ] 配置 CDN 缓存策略
- [ ] 启用表单通知（如需要）
- [ ] 设置 GitHub Actions 自动测试
- [ ] 配置监控和告警

祝部署顺利！ 🚀
