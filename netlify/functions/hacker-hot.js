const axios = require('axios');

exports.handler = async (event, context) => {
  try {
    // 获取热门故事ID列表
    const response = await axios.get('https://hacker-news.firebaseio.com/v0/topstories.json', {
      timeout: 10000
    });

    if (!response.data) {
      return {
        statusCode: 200,
        headers: {
          'Access-Control-Allow-Origin': '*',
          'Content-Type': 'application/json'
        },
        body: JSON.stringify({
          success: false,
          data: []
        })
      };
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

    return {
      statusCode: 200,
      headers: {
        'Access-Control-Allow-Origin': '*',
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({
        success: true,
        data: news,
        timestamp: new Date().toISOString()
      })
    };
  } catch (error) {
    console.error('获取 Hacker News 失败:', error.message);
    return {
      statusCode: 200,
      headers: {
        'Access-Control-Allow-Origin': '*',
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({
        success: false,
        error: error.message,
        data: []
      })
    };
  }
};
