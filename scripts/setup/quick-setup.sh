#!/bin/bash

# 🚀 超级自动化配置脚本 - 无需 Token 也能自动完成！

set -e

# 颜色
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

REPO_NAME="news-cli"
USERNAME="yaweilee"
GITHUB_URL="https://github.com/$USERNAME/$REPO_NAME"
NETLIFY_URL="https://app.netlify.com/projects/charming-dolphin-4ef2cb/settings/deploys"

echo -e "${CYAN}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║     🚀 GitHub + Netlify 一键自动化配置                        ║${NC}"
echo -e "${CYAN}╚════════════════════════════════════════════════════════════╝${NC}"
echo ""

# 生成创建仓库的 URL（预填充表单）
GITHUB_CREATE_URL="https://github.com/new?name=$REPO_NAME&description=$(echo '中国热门新闻CLI工具 - 支持百度热搜和知乎热榜' | sed 's/ /%20/g')&visibility=public"

echo -e "${BLUE}📋 配置清单${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✓ Git 仓库已初始化"
echo "✓ 代码已准备完成"
echo "✓ Netlify 站点已创建"
echo ""
echo -e "${YELLOW}⏳ 需要完成 3 步配置${NC}"
echo ""

# 步骤 1: 打开 GitHub 创建页面
echo -e "${BLUE}[1/3] 创建 GitHub 仓库${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "正在打开浏览器..."
echo ""
echo "请完成以下操作:"
echo "  1. 确认仓库名称: ${CYAN}$REPO_NAME${NC}"
echo "  2. 确认描述已填写"
echo "  3. 选择: ${CYAN}Public${NC}"
echo "  4. ${YELLOW}重要: 不要勾选任何选项${NC} (README, .gitignore, license)"
echo "  5. 点击: ${GREEN}Create repository${NC}"
echo ""

if command -v open >/dev/null 2>&1; then
    open "$GITHUB_CREATE_URL"
elif command -v xdg-open >/dev/null 2>&1; then
    xdg-open "$GITHUB_CREATE_URL"
fi

read -p "创建完成后按回车继续..." -r
echo ""

# 步骤 2: 推送代码
echo -e "${BLUE}[2/3] 推送代码到 GitHub${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

if git remote get-url origin >/dev/null 2>&1; then
    git remote set-url origin "$GITHUB_URL.git"
else
    git remote add origin "$GITHUB_URL.git"
fi

echo "正在推送代码到 $GITHUB_URL ..."
echo ""

if GIT_TERMINAL_PROMPT=0 git push -u origin main 2>&1 | tee /tmp/git-push.log; then
    echo -e "${GREEN}✅ 代码推送成功!${NC}"
else
    if grep -i "Repository not found" /tmp/git-push.log >/dev/null; then
        echo -e "${YELLOW}⚠️  仓库尚未创建${NC}"
        echo ""
        echo "请确认:"
        echo "  1. 已在 GitHub 创建仓库"
        echo "  2. 仓库名称正确: $REPO_NAME"
        echo ""
        read -p "完成后按回车重试..." -r
        GIT_TERMINAL_PROMPT=0 git push -u origin main
    else
        echo -e "${RED}❌ 推送失败${NC}"
        cat /tmp/git-push.log
        exit 1
    fi
fi

echo ""
echo -e "${GREEN}✅ GitHub 仓库: $GITHUB_URL${NC}"
echo ""

# 步骤 3: 配置 Netlify
echo -e "${BLUE}[3/3] 配置 Netlify 自动部署${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "正在打开 Netlify 设置..."
echo ""
echo "请完成以下操作:"
echo ""
echo "  1. 在 'Continuous Deployment' 下找到 'GitHub'"
echo "  2. 点击 ${CYAN}Connect to GitHub${NC}"
echo "  3. 如需授权，点击 Authorize Netlify"
echo "  4. 在仓库列表中选择: ${CYAN}$REPO_NAME${NC}"
echo "  5. 确认配置:"
echo "     • Build command: ${YELLOW}(留空)${NC}"
echo "     • Publish directory: ${CYAN}public${NC}"
echo "     • Functions directory: ${CYAN}netlify/functions${NC}"
echo "  6. 点击 ${GREEN}Save${NC}"
echo ""

sleep 2

if command -v open >/dev/null 2>&1; then
    open "$NETLIFY_URL"
elif command -v xdg-open >/dev/null 2>&1; then
    xdg-open "$NETLIFY_URL"
fi

read -p "配置完成后按回车继续..." -r
echo ""

# 测试自动部署
echo -e "${BLUE}🧪 测试自动部署${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "正在创建测试提交..."

echo "" >> README.md
echo "## ✅ 自动部署配置测试" >> README.md
echo "" >> README.md
echo "配置完成时间: $(date '+%Y-%m-%d %H:%M:%S')" >> README.md
echo "" >> README.md

git add README.md
git commit -m "test: 验证自动部署功能" >/dev/null 2>&1
git push >/dev/null 2>&1

echo -e "${GREEN}✅ 测试提交已推送！${NC}"
echo ""
echo "Netlify 正在自动部署..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo -e "${CYAN}📊 实时监控部署:${NC}"
echo "   https://app.netlify.com/projects/charming-dolphin-4ef2cb/deploys"
echo ""
echo -e "${CYAN}🌐 访问你的网站:${NC}"
echo "   https://charming-dolphin-4ef2cb.netlify.app"
echo ""

# 等待
sleep 3

echo ""
echo -e "${GREEN}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║                  ✨ 配置全部完成！ ✨                        ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${BLUE}💻 日常开发流程:${NC}"
echo ""
echo "   1️⃣  修改代码"
echo "   2️⃣  运行: ${CYAN}./push.sh${NC}"
echo "   3️⃣  输入提交信息"
echo "   4️⃣  ✨ Netlify 自动部署！"
echo ""
echo -e "${BLUE}🔗 快速链接:${NC}"
echo "   • GitHub:  $GITHUB_URL"
echo "   • Netlify: https://app.netlify.com/projects/charming-dolphin-4ef2cb"
echo "   • 网站:    https://charming-dolphin-4ef2cb.netlify.app"
echo ""
echo -e "${GREEN}🎉 开始享受自动化开发吧！${NC}"
echo ""

# 可选：打开网站
read -p "是否打开网站查看？(y/n): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    if command -v open >/dev/null 2>&1; then
        open "https://charming-dolphin-4ef2cb.netlify.app"
    fi
fi
