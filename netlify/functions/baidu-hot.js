const axios = require('axios');

exports.handler = async (event, context) => {
  try {
    const response = await axios.get('https://api.1314.cool/getbaiduhot/', {
      timeout: 10000
    });

    if (response.data && response.data.data) {
      return {
        statusCode: 200,
        headers: {
          'Access-Control-Allow-Origin': '*',
          'Content-Type': 'application/json'
        },
        body: JSON.stringify({
          success: true,
          data: response.data.data.slice(0, 20),
          timestamp: new Date().toISOString()
        })
      };
    } else {
      return {
        statusCode: 200,
        headers: {
          'Access-Control-Allow-Origin': '*',
          'Content-Type': 'application/json'
        },
        body: JSON.stringify({ success: false, data: [] })
      };
    }
  } catch (error) {
    console.error('获取百度热搜失败:', error.message);
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
