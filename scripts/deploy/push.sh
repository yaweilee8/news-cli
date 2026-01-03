#!/bin/bash

# 快速提交并推送到 GitHub，触发 Netlify 自动部署

# 颜色定义
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}🔄 Git 快速提交和部署脚本${NC}"
echo "=================================="
echo ""

# 检查是否有更改
if [ -z "$(git status --porcelain)" ]; then
    echo -e "${YELLOW}⚠️  没有检测到任何更改${NC}"
    echo "工作目录是干净的，无需提交。"
    exit 0
fi

# 显示当前状态
echo -e "${BLUE}📝 当前更改：${NC}"
git status --short
echo ""

# 询问提交信息
echo -n "请输入提交信息 (使用约定式提交格式): "
read -r commit_message

if [ -z "$commit_message" ]; then
    echo -e "${RED}❌ 提交信息不能为空${NC}"
    exit 1
fi

echo ""
echo -e "${BLUE}📦 提交步骤：${NC}"
echo "1. 添加所有更改..."
git add .

if [ $? -ne 0 ]; then
    echo -e "${RED}❌ git add 失败${NC}"
    exit 1
fi

echo "   ✅ 文件已添加"

echo "2. 创建提交..."
git commit -m "$commit_message"

if [ $? -ne 0 ]; then
    echo -e "${RED}❌ git commit 失败${NC}"
    exit 1
fi

echo "   ✅ 提交已创建"

echo "3. 推送到 GitHub..."
git push

if [ $? -ne 0 ]; then
    echo -e "${RED}❌ git push 失败${NC}"
    echo "请检查："
    echo "   - 网络连接是否正常"
    echo "   - GitHub 仓库是否已创建"
    echo "   - 认证信息是否正确"
    exit 1
fi

echo "   ✅ 代码已推送"

echo ""
echo -e "${GREEN}✅ 成功！${NC}"
echo ""
echo "📊 提交信息: $commit_message"
echo "🌐 Netlify 将自动开始部署..."
echo ""
echo "🔗 查看部署状态:"
echo "   https://app.netlify.com/projects/charming-dolphin-4ef2cb/deploys"
echo ""
echo -e "${GREEN}⏳ 预计 1-2 分钟后网站将更新完成${NC}"
