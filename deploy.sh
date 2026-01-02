#!/bin/bash

# 中国热门新闻 - Netlify 快速部署脚本

echo "📰 准备部署到 Netlify..."
echo ""

# 检查是否已登录 Netlify
if ! npx netlify status 2>/dev/null; then
    echo "🔐 请先登录 Netlify..."
    npx netlify login
fi

echo ""
echo "📦 正在部署..."
echo ""

# 使用 npx 运行 netlify deploy
npx netlify deploy --prod --dir=public --functions=netlify/functions

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ 部署成功！"
    echo ""
    echo "🌐 你的站点已上线！"
    echo "📝 请查看上面的 URL 访问你的网站"
else
    echo ""
    echo "❌ 部署失败，请检查错误信息"
    exit 1
fi
