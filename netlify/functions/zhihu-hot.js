const axios = require('axios');

exports.handler = async (event, context) => {
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
        return {
          statusCode: 200,
          headers: {
            'Access-Control-Allow-Origin': '*',
            'Content-Type': 'application/json'
          },
          body: JSON.stringify({
            success: true,
            data: parsedData.slice(0, 20),
            timestamp: new Date().toISOString()
          })
        };
      }
    } catch (error) {
      console.error(`知乎API源失败: ${error.message}`);
      continue;
    }
  }

  return {
    statusCode: 200,
    headers: {
      'Access-Control-Allow-Origin': '*',
      'Content-Type': 'application/json'
    },
    body: JSON.stringify({
      success: false,
      error: '知乎热榜API需要认证或受限制',
      data: []
    })
  };
};
