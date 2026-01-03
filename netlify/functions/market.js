const axios = require('axios');

// 缓存（Netlify Functions每个实例独立）
let cache = {
  data: null,
  timestamp: null
};

// 获取加密货币数据（CoinGecko API - 免费无需认证）
async function fetchCrypto() {
  try {
    const response = await axios.get('https://api.coingecko.com/api/v3/simple/price', {
      params: {
        ids: 'bitcoin',
        vs_currencies: 'usd',
        include_24hr_change: true
      },
      timeout: 5000
    });

    const btc = response.data.bitcoin;
    return [{
      name: 'Bitcoin',
      symbol: 'BTC',
      price: btc.usd,
      changePercent: btc.usd_24h_change
    }];
  } catch (error) {
    console.error('获取加密货币数据失败:', error.message);
    return [];
  }
}

// 获取中国股市数据（腾讯财经API - 免费无需认证）
async function fetchChinaStocks() {
  try {
    // 尝试使用腾讯财经API
    const response = await axios.get('https://qt.gtimg.cn/q=sh000001,rt_hkHSI', {
      timeout: 5000,
      headers: {
        'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36'
      }
    });

    const results = [];
    const data = response.data;

    // 解析上证指数 - 腾讯API格式
    const shMatch = data.match(/v_sh000001="([^"]+)"/);
    if (shMatch) {
      const parts = data.split('~');
      if (parts.length >= 33) {
        const current = parseFloat(parts[3]);
        const yesterday = parseFloat(parts[4]);
        const change = current - yesterday;
        const changePercent = (change / yesterday) * 100;

        results.push({
          name: '上证指数',
          symbol: 'SH000001',
          price: current,
          changePercent: changePercent
        });
      }
    }

    // 解析恒生指数
    const hsiMatch = data.match(/v_rt_hkHSI="([^"]+)"/);
    if (hsiMatch) {
      const hsiParts = data.substring(data.indexOf('rt_hkHSI')).split('~');
      if (hsiParts.length >= 5) {
        const current = parseFloat(hsiParts[3]);
        const yesterday = parseFloat(hsiParts[4]);
        const change = current - yesterday;
        const changePercent = yesterday > 0 ? (change / yesterday) * 100 : 0;

        results.push({
          name: '恒生指数',
          symbol: 'HSI',
          price: current,
          changePercent: changePercent
        });
      }
    }

    return results;
  } catch (error) {
    console.error('获取中国股市数据失败:', error.message);
    return [];
  }
}

exports.handler = async (event, context) => {
  const headers = {
    'Access-Control-Allow-Origin': '*',
    'Content-Type': 'application/json'
  };

  // 检查缓存（30秒）
  const now = Date.now();
  if (cache.data && cache.timestamp && now - cache.timestamp < 30000) {
    return {
      statusCode: 200,
      headers,
      body: JSON.stringify({
        success: true,
        data: cache.data,
        cached: true
      })
    };
  }

  try {
    const [crypto, chinaStocks] = await Promise.allSettled([
      fetchCrypto(),
      fetchChinaStocks()
    ]);

    const data = {
      crypto: crypto.status === 'fulfilled' ? crypto.value : [],
      china_stocks: chinaStocks.status === 'fulfilled' ? chinaStocks.value : [],
      us_stocks: [], // 阶段二实现：美股指数
      metals: []     // 阶段二实现：贵金属
    };

    cache.data = data;
    cache.timestamp = now;

    return {
      statusCode: 200,
      headers,
      body: JSON.stringify({
        success: true,
        data,
        timestamp: new Date().toISOString()
      })
    };
  } catch (error) {
    return {
      statusCode: 200,
      headers,
      body: JSON.stringify({
        success: false,
        error: error.message,
        data: null
      })
    };
  }
};
