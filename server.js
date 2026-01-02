const express = require('express');
const axios = require('axios');
const path = require('path');
const app = express();
const PORT = 3000;

// 静态文件服务
app.use(express.static('public'));

// API端点：获取百度热搜
app.get('/api/baidu-hot', async (req, res) => {
  try {
    const response = await axios.get('https://api.1314.cool/getbaiduhot/', {
      timeout: 10000
    });

    if (response.data && response.data.data) {
      res.json({
        success: true,
        data: response.data.data.slice(0, 20),
        timestamp: new Date().toISOString()
      });
    } else {
      res.json({ success: false, data: [] });
    }
  } catch (error) {
    console.error('获取百度热搜失败:', error.message);
    res.json({ success: false, error: error.message, data: [] });
  }
});

// API端点：获取知乎热榜
app.get('/api/zhihu-hot', async (req, res) => {
  const apiSources = [
    {
      url: 'https://www.zhihu.com/api/v3/feed/topstory/hot-lists/total?limit=20',
      headers: { 'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36' },
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
      const response = await axios.get(source.url, {
        timeout: 10000,
        headers: source.headers
      });

      const parsedData = source.parser(response.data);

      if (parsedData && parsedData.length > 0) {
        res.json({
          success: true,
          data: parsedData.slice(0, 20),
          timestamp: new Date().toISOString()
        });
        return;
      }
    } catch (error) {
      console.error(`知乎API源失败: ${error.message}`);
      continue;
    }
  }

  res.json({
    success: false,
    error: '知乎热榜API需要认证或受限制',
    data: []
  });
});

// 主页
app.get('/', (req, res) => {
  res.sendFile(path.join(__dirname, 'public', 'index.html'));
});

app.listen(PORT, () => {
  console.log(`\n🚀 新闻服务已启动!`);
  console.log(`📱 访问地址: http://localhost:${PORT}`);
  console.log(`🔗 API端点:`);
  console.log(`   - GET /api/baidu-hot  (百度热搜)`);
  console.log(`   - GET /api/zhihu-hot  (知乎热榜)\n`);
});
