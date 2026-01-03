#!/bin/bash

# GitHub 仓库设置和自动部署配置脚本

REPO_NAME="news-cli"
USERNAME="yaweilee"
GITHUB_REPO="https://github.com/$USERNAME/$REPO_NAME"

echo "🔧 配置 GitHub 仓库和自动部署"
echo "================================"
echo ""

# 检查是否已经是git仓库
if [ ! -d ".git" ]; then
    echo "❌ 当前目录不是git仓库"
    exit 1
fi

echo "📝 步骤 1: 在GitHub上创建仓库"
echo "-------------------------------"
echo "请先在 GitHub 上手动创建仓库:"
echo ""
echo "1. 访问: https://github.com/new"
echo "2. 仓库名称: $REPO_NAME"
echo "3. 描述: 中国热门新闻CLI工具 - 支持百度热搜和知乎热榜"
echo "4. 设置为: Public"
echo "5. ❌ 不要初始化 README, .gitignore, license（我们已有这些文件）"
echo "6. 点击 'Create repository'"
echo ""
read -p "按回车继续，确认你已在GitHub创建仓库..."

echo ""
echo "📤 步骤 2: 推送代码到 GitHub"
echo "-------------------------------"

# 添加远程仓库
if git remote get-url origin &>/dev/null; then
    echo "⚠️  远程仓库 origin 已存在"
    git remote set-url origin $GITHUB_REPO.git
else
    git remote add origin $GITHUB_REPO.git
fi

echo "远程仓库: $GITHUB_REPO"

# 推送代码
echo "正在推送代码..."
git push -u origin main

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ 代码已成功推送到 GitHub!"
    echo "🌉 仓库地址: $GITHUB_REPO"
else
    echo ""
    echo "❌ 推送失败，请检查："
    echo "   1. GitHub 仓库是否已创建"
    echo "   2. 是否有权限访问该仓库"
    echo "   3. GitHub 认证是否正确配置"
    exit 1
fi

echo ""
echo "🔗 步骤 3: 在 Netlify 关联 GitHub 仓库"
echo "---------------------------------------"
echo "1. 访问: https://app.netlify.com/projects/charming-dolphin-4ef2cb"
echo "2. 点击 'Site configuration' 或 'Settings'"
echo "3. 找到 'Build & deploy' → 'Continuous Deployment'"
echo "4. 点击 'Edit settings'"
echo "5. 在 'GitHub' 部分点击 'Connect to GitHub'"
echo "6. 授权 Netlify 访问你的 GitHub"
echo "7. 选择仓库: $REPO_NAME"
echo "8. 配置构建设置："
echo "   - Build command: (留空)"
echo "   - Publish directory: public"
echo "   - Functions directory: netlify/functions"
echo "9. 点击 'Save'"
echo ""
echo "✅ 配置完成！"
echo ""
echo "🎉 从现在开始，每次推送代码到 GitHub 主分支，Netlify 会自动部署！"
echo ""
echo "📝 工作流程："
echo "   1. 修改代码"
echo "   2. git add ."
echo "   3. git commit -m 'your message'"
echo "   4. git push"
echo "   5. Netlify 自动部署 ✨"
