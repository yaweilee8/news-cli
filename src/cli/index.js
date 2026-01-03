#!/usr/bin/env node

const axios = require('axios');
const cheerio = require('cheerio');
const { format, subDays, parseISO } = require('date-fns');
const chalk = require('chalk');

/**
 * 获取昨天的日期
 */
function getYesterday() {
  return format(subDays(new Date(), 1), 'yyyy-MM-dd');
}

/**
 * 获取百度热搜数据
 * 使用免费的聚合API
 */
async function fetchBaiduHotNews() {
  try {
    // 使用免费的热搜API
    const response = await axios.get('https://api.1314.cool/getbaiduhot/', {
      timeout: 10000
    });

    if (response.data && response.data.data) {
      return response.data.data;
    }
    return [];
  } catch (error) {
    console.error(chalk.red('获取热搜数据失败:'), error.message);
    return [];
  }
}

/**
 * 获取知乎热榜数据
 */
async function fetchZhihuHotNews() {
  const apiSources = [
    {
      name: '知乎官方API',
      url: 'https://www.zhihu.com/api/v3/feed/topstory/hot-lists/total?limit=20',
      headers: {
        'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36'
      },
      parser: (data) => {
        if (data && data.data && Array.isArray(data.data)) {
          return data.data.map((item, index) => ({
            rank: index + 1,
            title: item.target?.title || item.title || '未知标题',
            url: item.target?.url || item.url || `https://www.zhihu.com/question/${item.target?.id || ''}`,
            hot: item.detail_text || item.hot || ''
          }));
        }
        return null;
      }
    },
    {
      name: 'RSSHub',
      url: 'https://rsshub.app/zhihu/hotlist/json',
      headers: {},
      parser: (data) => {
        if (data && data.data && Array.isArray(data.data)) {
          return data.data.map((item, index) => ({
            rank: index + 1,
            title: item.title || '未知标题',
            url: item.url || item.link || '',
            hot: ''
          }));
        }
        return null;
      }
    }
  ];

  for (const source of apiSources) {
    try {
      console.log(chalk.gray(`正在尝试 ${source.name}...`));

      const response = await axios.get(source.url, {
        timeout: 10000,
        headers: source.headers
      });

      const parsedData = source.parser(response.data);

      if (parsedData && parsedData.length > 0) {
        console.log(chalk.green(`✓ ${source.name} 成功获取数据`));
        return parsedData;
      }
    } catch (error) {
      console.log(chalk.yellow(`${source.name} 失败: ${error.message}`));
      continue;
    }
  }

  console.log(chalk.red('\n⚠️  知乎热榜暂时无法获取，API需要认证或受限制'));
  console.log(chalk.gray('提示: 百度热搜功能正常，知乎热榜API可能需要付费服务\n'));
  return [];
}

/**
 * 获取 Hacker News 数据
 */
async function fetchHackerNews() {
  try {
    console.log(chalk.gray('正在获取 Hacker News 数据...'));

    // 获取热门故事ID列表
    const response = await axios.get('https://hacker-news.firebaseio.com/v0/topstories.json', {
      timeout: 10000
    });

    if (!response.data) {
      return [];
    }

    // 获取前20个故事的详细信息
    const topStoryIds = response.data.slice(0, 20);
    const storyPromises = topStoryIds.map(id =>
      axios.get(`https://hacker-news.firebaseio.com/v0/item/${id}.json`, {
        timeout: 5000
      }).catch(() => null)
    );

    const stories = await Promise.all(storyPromises);

    const news = stories
      .filter(story => story && story.data)
      .map((story, index) => ({
        rank: index + 1,
        title: story.data.title || 'Unknown Title',
        url: story.data.url || `https://news.ycombinator.com/item?id=${story.data.id}`,
        hot: story.data.score || 0,
        author: story.data.by || 'unknown'
      }));

    console.log(chalk.green(`✓ Hacker News 成功获取 ${news.length} 条数据`));
    return news;
  } catch (error) {
    console.error(chalk.red('获取 Hacker News 失败:'), error.message);
    return [];
  }
}

/**
 * 格式化输出新闻列表
 */
function displayNews(news, source) {
  console.log(chalk.cyan.bold('\n════════════════════════════════════════'));
  console.log(chalk.cyan.bold(`    ${source} - ${getYesterday()}`));
  console.log(chalk.cyan.bold('════════════════════════════════════════\n'));

  if (!news || news.length === 0) {
    console.log(chalk.yellow('暂无热搜数据'));
    return;
  }

  news.slice(0, 20).forEach((item, index) => {
    const rank = index + 1;
    const title = item.title || item.word || item.name || '未知标题';
    const url = item.url || item.link || item.mobileUrl || '';
    const hot = item.hot || item.hotScore || item.hotNum || '';
    const hotStr = hot ? chalk.red(`🔥 ${hot}`) : '';

    console.log(
      chalk.green.bold(`${rank.toString().padStart(2, '0')}. `) +
      chalk.white(title) +
      (hotStr ? ' ' + hotStr : '')
    );

    if (url) {
      console.log(chalk.gray(`    ${url}\n`));
    }
  });

  console.log(chalk.cyan.bold('════════════════════════════════════════\n'));
}

/**
 * 主函数
 */
async function main() {
  console.log(chalk.bold.blue('\n📰 全球热门新闻抓取工具'));
  console.log(chalk.gray(`当前日期: ${format(new Date(), 'yyyy年MM月dd日')}`));
  console.log(chalk.gray(`抓取日期: ${getYesterday()}\n`));

  // 并行获取多个数据源的新闻
  const [baiduNews, zhihuNews, hackerNews] = await Promise.all([
    fetchBaiduHotNews(),
    fetchZhihuHotNews(),
    fetchHackerNews()
  ]);

  // 显示百度热搜
  if (baiduNews.length > 0) {
    displayNews(baiduNews, '百度热搜');
  }

  // 显示知乎热榜
  if (zhihuNews.length > 0) {
    displayNews(zhihuNews, '知乎热榜');
  }

  // 显示 Hacker News
  if (hackerNews.length > 0) {
    displayNews(hackerNews, 'Hacker News');
  }

  console.log(chalk.green.bold('✅ 数据抓取完成！'));
}

// 运行主函数
main().catch(error => {
  console.error(chalk.red('\n❌ 发生错误:'), error.message);
  process.exit(1);
});
