#!/bin/bash

# 中国热门新闻 - Netlify 快速部署脚本

echo "📰 准备部署到 Netlify..."
echo ""

# 检查是否已链接到项目
if [ ! -f ".netlify/state.json" ]; then
    echo "🔗 首次部署，创建新站点..."
    npx netlify deploy --create-site --prod --dir=public --functions=netlify/functions
else
    echo "📦 更新现有站点..."
    npx netlify deploy --prod --dir=public --functions=netlify/functions
fi

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ 部署成功！"
    echo ""
    echo "🌐 你的站点已上线！"
    echo "📝 请查看上面的 URL 访问你的网站"
    echo ""
    echo "💡 提示: 下次更新只需运行此脚本即可"
else
    echo ""
    echo "❌ 部署失败，请检查错误信息"
    exit 1
fi

