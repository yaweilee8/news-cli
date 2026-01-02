# 中国热门新闻CLI工具 📰

一个简单的Node.js命令行工具，用于抓取并展示中国热门新闻。支持CLI模式和Web界面，可部署到Netlify。

## 功能特性

### 命令行模式 (CLI)
- ✅ 抓取百度热搜实时数据
- ✅ 抓取知乎热榜数据
- ✅ 自动计算昨天的日期
- ✅ 使用 `date-fns` 处理时间
- ✅ 使用 `axios` 发起HTTP请求
- ✅ 使用 `chalk` 美化终端输出
- ✅ 显示新闻标题和链接

### Web界面模式
- ✅ 支持2个数据源切换（百度热搜、知乎热榜）
- ✅ 美观的网页界面展示热搜数据
- ✅ 点击新闻卡片查看详细信息
- ✅ 响应式设计，支持移动端
- ✅ 实时刷新功能
- ✅ 支持部署到 Netlify 🌐

## 支持的新闻源

| 数据源 | CLI模式 | Web模式 | 状态 |
|--------|---------|---------|------|
| 百度热搜 | ✅ | ✅ | 稳定可用 |
| 知乎热榜 | ⚠️ | ⚠️ | API需要认证 |

## 安装依赖

```bash
npm install
```

## 使用的依赖

- `axios` - HTTP客户端，用于获取API数据
- `cheerio` - HTML解析器（用于网页抓取）
- `date-fns` - 日期处理库
- `chalk` - 终端输出美化工具
- `express` - Web服务器框架 🆕

## 运行方式

### 🖥️ 命令行模式

#### 方式1：使用npm脚本
```bash
npm start
```

#### 方式2：直接运行
```bash
node index.js
```

#### 方式3：全局安装（可选）
```bash
npm link
news  # 可以在任何地方运行
```

### 🌐 Web界面模式 🆕

#### 启动Web服务器
```bash
npm run web
```

然后访问: **http://localhost:3000**

#### API端点

```bash
# 获取百度热搜
curl http://localhost:3000/api/baidu-hot

# 获取微博热搜
curl http://localhost:3000/api/weibo-hot
```

#### Web界面功能
- 🔄 实时刷新热搜数据
- 🔀 百度热搜/知乎热榜快速切换
- 📱 点击卡片查看详情弹窗
- 📊 热度值智能格式化（万、亿）
- 🎨 渐变色彩设计
- 📱 响应式布局

### 🚀 部署到 Netlify

#### 快速部署

1. **使用部署脚本（最简单）**
```bash
# 1. 登录 Netlify（首次需要）
npx netlify login

# 2. 运行部署脚本
./deploy.sh
```

2. **手动部署**
```bash
# 使用 Netlify CLI
npx netlify deploy --prod --dir=public --functions=netlify/functions
```

3. **拖放部署**
   - 访问 [app.netlify.com](https://app.netlify.com/)
   - 将整个项目文件夹拖入上传区域
   - 设置发布目录为 `public`

#### GitHub 自动部署 ⭐（推荐）

配置 GitHub + Netlify 自动部署，每次推送代码自动更新网站：

**一键自动配置（推荐）：**

```bash
# 运行自动化配置脚本
./quick-setup.sh
```

脚本会自动：
- 🌐 打开浏览器创建 GitHub 仓库
- 📤 推送代码到 GitHub
- 🔗 打开 Netlify 配置页面
- 🧪 测试自动部署
- ✅ 完成所有配置！

**手动配置（3步）：**

1. **创建 GitHub 仓库**
   ```bash
   # 访问 https://github.com/new 创建仓库 "news-cli"
   ```

2. **推送代码**
   ```bash
   git push -u origin main
   ```

3. **在 Netlify 关联 GitHub**
   - 访问: https://app.netlify.com/projects/charming-dolphin-4ef2cb/settings/deploys
   - 点击 "Connect to GitHub"
   - 选择 `news-cli` 仓库

✅ 完成！现在每次推送代码都会自动部署。

**日常使用：**
```bash
# 修改代码后，一键提交并自动部署
./push.sh

# 或手动提交
git add .
git commit -m "feat: 添加新功能"
git push  # Netlify 自动部署 🚀
```

📖 **详细指南**: 查看 [QUICKSTART.md](QUICKSTART.md) 或 [GITHUB_SETUP.md](GITHUB_SETUP.md)

#### 详细部署指南

查看 [NETLIFY_DEPLOY.md](NETLIFY_DEPLOY.md) 获取完整的部署说明，包括：
- 通过 GitHub 持续部署
- 自定义域名配置
- 环境变量设置
- 性能优化建议

#### 架构说明

Netlify 部署架构：
```
用户浏览器
    ↓
Netlify CDN (静态文件)
    ↓
Netlify Functions (Serverless API)
    ↓
外部API (百度/知乎)
```

**优势：**
- ✅ 全球 CDN 加速
- ✅ 自动 HTTPS/SSL
- ✅ Serverless Functions 免费额度充足
- ✅ 支持持续部署
- ✅ 无需服务器维护

## 输出示例

```
📰 中国热门新闻抓取工具
当前日期: 2026年01月02日
抓取日期: 2026-01-01

════════════════════════════════════════
    百度热搜 - 2026-01-01
════════════════════════════════════════

01. 中国车企在欧洲卖爆了
    https://www.baidu.com/s?wd=中国车企在欧洲卖爆了

02. 天宫与神州同框的中国式浪漫
    https://www.baidu.com/s?wd=天宫与神州同框的中国式浪漫

...

✅ 数据抓取完成！
```

## 新闻源说明

本项目使用了免费的公开API：

- **百度热搜**: `https://api.1314.cool/getbaiduhot/`
  - 提供实时热搜数据
  - 更新频率：约每3分钟
  - 返回30条热搜数据
  - ✅ 当前可用

- **微博热搜**: 多个API源（自动尝试）
  - 由于微博API限制和反爬虫措施
  - ⚠️  目前大部分免费API已失效
  - 工具会自动尝试多个源并显示友好提示

## 注意事项

1. **API稳定性**: 该工具使用的是第三方免费API，可能存在不稳定的情况
2. **微博限制**: 微博热搜API受到严格的反爬虫限制（403错误），这是平台故意设置的防护措施
3. **百度可用**: 百度热搜API目前稳定可用
4. **建议添加错误处理和重试机制**
5. **请遵守相关API的使用条款和限制**

## 微博热搜API情况说明

### 当前状况
- 大部分免费微博热搜API已失效或需要认证
- 微博平台有严格的反爬虫措施
- 直接抓取微博页面会遇到403禁止访问

### 替代方案

如果需要微博热搜数据，可以考虑：

1. **付费API服务**
   - [天聚数行 TianAPI](https://www.tianapi.com/apiview/100) - 提供免费额度
   - [ALAPI](https://www.alapi.cn/api/16/api_document)

2. **自建爬虫**
   - 使用 [DailyHotApi](https://github.com/imsyy/DailyHotApi) 部署自己的热搜API
   - 支持多平台聚合

3. **浏览器自动化**
   - 使用 Puppeteer 或 Selenium
   - 模拟真实浏览器访问

## 后续改进建议

- [x] 支持百度热搜
- [ ] 微博热搜（需要付费API或自建服务）
- [ ] 添加缓存机制减少API请求
- [ ] 支持自定义日期查询
- [ ] 添加过滤关键词功能
- [ ] 导出为JSON/CSV格式
- [ ] 支持配置文件

## 许可证

MIT
