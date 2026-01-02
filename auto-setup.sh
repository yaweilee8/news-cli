#!/bin/bash

# 🚀 GitHub + Netlify 自动化配置脚本
# 一键完成所有配置！

set -e  # 遇到错误立即退出

# 颜色定义
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# 配置信息
REPO_NAME="news-cli"
USERNAME="yaweilee"
DESCRIPTION="中国热门新闻CLI工具 - 支持百度热搜和知乎热榜，可部署到Netlify"
GITHUB_REPO_URL="https://github.com/$USERNAME/$REPO_NAME"
NETLIFY_SITE="https://app.netlify.com/projects/charming-dolphin-4ef2cb/settings/deploys"

echo -e "${CYAN}"
echo "╔════════════════════════════════════════════════════════════╗"
echo "║        GitHub + Netlify 自动化配置脚本                      ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo -e "${NC}"
echo ""

# 检查 git 是否配置
if ! git config user.name >/dev/null 2>&1; then
    echo -e "${RED}❌ Git 未配置，请先运行：${NC}"
    echo "   git config --global user.name 'Your Name'"
    echo "   git config --global user.email 'your@email.com'"
    exit 1
fi

echo -e "${GREEN}✓${NC} Git 已配置"
echo ""

# 检查是否需要 GitHub Token
echo -e "${BLUE}📝 步骤 1/4: 创建 GitHub 仓库${NC}"
echo "================================"
echo ""

# 尝试使用 GitHub API 创建仓库
read -p "是否已有 GitHub Personal Access Token? (y/n): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "请输入 GitHub Token (需要有 repo 权限):"
    echo "获取方式: GitHub Settings → Developer settings → Personal access tokens → Tokens (classic)"
    read -s GITHUB_TOKEN
    echo ""

    echo "正在创建 GitHub 仓库..."

    # 使用 GitHub API 创建仓库
    RESPONSE=$(curl -s -X POST \
        -H "Authorization: token $GITHUB_TOKEN" \
        -H "Accept: application/vnd.github.v3+json" \
        https://api.github.com/user/repos \
        -d "{
            \"name\": \"$REPO_NAME\",
            \"description\": \"$DESCRIPTION\",
            \"private\": false,
            \"auto_init\": false
        }")

    # 检查是否创建成功
    if echo "$RESPONSE" | jq -e '.html_url' >/dev/null 2>&1; then
        REPO_URL=$(echo "$RESPONSE" | jq -r '.html_url')
        echo -e "${GREEN}✅ 仓库创建成功!${NC}"
        echo "   📂 $REPO_URL"
    else
        echo -e "${RED}❌ 创建失败，可能原因：${NC}"
        echo "   - Token 无效或权限不足"
        echo "   - 仓库名称冲突"
        echo ""
        echo "请手动创建: https://github.com/new"
        echo "然后按回车继续..."
        read
    fi
else
    echo -e "${YELLOW}⚠️  未提供 GitHub Token${NC}"
    echo ""
    echo "请手动创建仓库:"
    echo "  1. 访问: https://github.com/new"
    echo "  2. 仓库名: $REPO_NAME"
    echo "  3. 描述: $DESCRIPTION"
    echo "  4. Public"
    echo "  5. 不要勾选任何初始化选项"
    echo ""
    read -p "创建完成后按回车继续..." -r
fi

echo ""
echo -e "${BLUE}📤 步骤 2/4: 推送代码到 GitHub${NC}"
echo "================================"
echo ""

# 配置远程仓库
if git remote get-url origin >/dev/null 2>&1; then
    echo "更新远程仓库 URL..."
    git remote set-url origin $GITHUB_REPO_URL.git
else
    echo "添加远程仓库..."
    git remote add origin $GITHUB_REPO_URL.git
fi

echo "远程仓库: $GITHUB_REPO_URL"
echo ""
echo "正在推送代码..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

if git push -u origin main 2>&1; then
    echo -e "${GREEN}✅ 代码推送成功!${NC}"
else
    echo -e "${RED}❌ 推送失败!${NC}"
    echo ""
    echo "可能的原因:"
    echo "  1. GitHub 仓库未创建"
    echo "  2. 网络连接问题"
    echo "  3. 认证失败"
    echo ""
    echo "请手动运行: git push -u origin main"
    exit 1
fi

echo ""
echo -e "${BLUE}🔗 步骤 3/4: 配置 Netlify 自动部署${NC}"
echo "================================"
echo ""

echo "现在需要在 Netlify 中关联 GitHub 仓库"
echo ""
echo "请按照以下步骤操作:"
echo ""
echo "  1. 🔗 打开 Netlify 设置:"
echo -e "     ${CYAN}$NETLIFY_SITE${NC}"
echo ""
echo "  2. 找到 'Continuous Deployment' → 'GitHub'"
echo ""
echo "  3. 点击 'Connect to GitHub'"
echo ""
echo "  4. 选择仓库: $REPO_NAME"
echo ""
echo "  5. 配置构建设置:"
echo "     - Build command: (留空)"
echo "     - Publish directory: ${CYAN}public${NC}"
echo "     - Functions directory: ${CYAN}netlify/functions${NC}"
echo ""
echo "  6. 点击 'Save'"
echo ""

# 自动打开浏览器
if command -v open >/dev/null 2>&1; then
    echo "正在打开浏览器..."
    sleep 2
    open "$NETLIFY_SITE"
elif command -v xdg-open >/dev/null 2>&1; then
    xdg-open "$NETLIFY_SITE"
fi

read -p "配置完成后按回车继续..." -r

echo ""
echo -e "${BLUE}🧪 步骤 4/4: 测试自动部署${NC}"
echo "================================"
echo ""

echo "正在创建测试提交..."

# 添加一行到 README
echo "" >> README.md
echo "## 测试自动部署" >> README.md
echo "" >> README.md
echo "✅ GitHub + Netlify 自动部署配置完成！$(date '+%Y-%m-%d %H:%M:%S')" >> README.md

git add README.md
git commit -m "test: 测试自动部署功能" >/dev/null 2>&1

echo "正在推送测试提交..."
git push >/dev/null 2>&1

echo -e "${GREEN}✅ 测试提交已推送!${NC}"
echo ""
echo "Netlify 正在自动部署..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "📊 查看部署状态:"
echo -e "   ${CYAN}https://app.netlify.com/projects/charming-dolphin-4ef2cb/deploys${NC}"
echo ""
echo "🌐 访问网站:"
echo -e "   ${CYAN}https://charming-dolphin-4ef2cb.netlify.app${NC}"
echo ""

# 等待几秒让部署开始
echo "等待部署开始..."
sleep 5

echo ""
echo -e "${GREEN}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║                   ✅ 配置完成！                            ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${BLUE}📝 日常使用:${NC}"
echo "   修改代码后运行: ${CYAN}./push.sh${NC}"
echo "   输入提交信息，自动触发部署"
echo ""
echo -e "${BLUE}🔗 重要链接:${NC}"
echo "   • GitHub 仓库: $GITHUB_REPO_URL"
echo "   • Netlify 部署: https://app.netlify.com/projects/charming-dolphin-4ef2cb/deploys"
echo "   • 访问网站: https://charming-dolphin-4ef2cb.netlify.app"
echo ""
echo -e "${GREEN}🎉 享受自动化开发吧！${NC}"
echo ""
