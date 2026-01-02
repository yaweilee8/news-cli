# 部署信息

## 当前部署

- **部署日期**: 2026-01-02
- **部署平台**: Netlify
- **生产 URL**: https://charming-dolphin-4ef2cb.netlify.app
- **站点 ID**: charming-dolphin-4ef2cb
- **状态**: ✅ 已上线

## API 端点

- **百度热搜**: `/.netlify/functions/baidu-hot`
- **知乎热榜**: `/.netlify/functions/zhihu-hot`

## 技术栈

- **前端**: HTML + CSS + JavaScript (纯静态)
- **后端**: Netlify Functions (Serverless)
- **数据源**: 百度热搜API、知乎热榜API

## 部署方式

使用以下命令更新部署：

```bash
./deploy.sh
```

或手动执行：

```bash
npx netlify deploy --prod --dir=public --functions=netlify/functions
```

## 测试结果

- ✅ 百度热搜 API: 正常
- ⚠️ 知乎热榜 API: 需要认证（预期行为）
- ✅ 前端页面: 正常加载
- ✅ Functions: 已部署 2 个

## 项目链接

- **Netlify Dashboard**: https://app.netlify.com/projects/charming-dolphin-4ef2cb/
- **构建日志**: https://app.netlify.com/projects/charming-dolphin-4ef2cb/deploys/
- **Function 日志**: https://app.netlify.com/projects/charming-dolphin-4ef2cb/logs/functions
