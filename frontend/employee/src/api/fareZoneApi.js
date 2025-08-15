// 設定基礎 URL
const BASE_URL = 'http://localhost:8080';

/**
 * 基礎 HTTP 請求功能
 */
const httpClient = {
  /**
   * 發送 GET 請求
   * @param {string} endpoint - API 端點
   * @param {Object} params - URL 參數
   * @returns {Promise} 回應的 Promise 物件
   */
  async get(endpoint, params = {}) {
    // 建構查詢參數
    const queryParams = new URLSearchParams();
    for (const key in params) {
      if (params[key] !== null && params[key] !== undefined) {
        queryParams.append(key, params[key]);
      }
    }

    const queryString = queryParams.toString();
    const url = `${BASE_URL}${endpoint}${queryString ? `?${queryString}` : ''}`;

    // 使用 fetch 發送 GET 請求
    const response = await fetch(url, {
      method: 'GET',
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      }
    });

    // 處理錯誤狀態
    if (!response.ok) {
      let errorMsg;
      try {
        const errorData = await response.json();
        errorMsg = errorData.message || `HTTP 錯誤: ${response.status}`;
      } catch (e) {
        errorMsg = `HTTP 錯誤: ${response.status}`;
      }
      throw new Error(errorMsg);
    }

    // 處理成功回應
    if (response.status === 204) {
      return { status: response.status, data: null };
    }

    // 解析 JSON 回應
    const data = await response.json();
    return { status: response.status, data };
  },

  /**
   * 發送 POST 請求
   * @param {string} endpoint - API 端點
   * @param {Object} body - 請求主體
   * @param {Object} params - URL 參數
   * @returns {Promise} 回應的 Promise 物件
   */
  async post(endpoint, body = null, params = {}) {
    // 建構查詢參數
    const queryParams = new URLSearchParams();
    for (const key in params) {
      if (params[key] !== null && params[key] !== undefined) {
        queryParams.append(key, params[key]);
      }
    }

    const queryString = queryParams.toString();
    const url = `${BASE_URL}${endpoint}${queryString ? `?${queryString}` : ''}`;

    // 使用 fetch 發送 POST 請求
    const response = await fetch(url, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      },
      body: body ? JSON.stringify(body) : null
    });

    // 處理錯誤狀態
    if (!response.ok) {
      let errorMsg;
      try {
        const errorData = await response.json();
        errorMsg = errorData.message || `HTTP 錯誤: ${response.status}`;
      } catch (e) {
        errorMsg = `HTTP 錯誤: ${response.status}`;
      }
      throw new Error(errorMsg);
    }

    // 處理成功回應
    if (response.status === 204) {
      return { status: response.status, data: null };
    }

    // 解析 JSON 回應
    const data = await response.json();
    return { status: response.status, data };
  },

  /**
   * 發送 PUT 請求
   * @param {string} endpoint - API 端點
   * @param {Object} body - 請求主體
   * @returns {Promise} 回應的 Promise 物件
   */
  async put(endpoint, body) {
    // 使用 fetch 發送 PUT 請求
    const response = await fetch(`${BASE_URL}${endpoint}`, {
      method: 'PUT',
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      },
      body: JSON.stringify(body)
    });
    
    // 處理錯誤狀態
    if (!response.ok) {
      let errorMsg;
      try {
        const errorData = await response.json();
        errorMsg = errorData.message || `HTTP 錯誤: ${response.status}`;
      } catch (e) {
        errorMsg = `HTTP 錯誤: ${response.status}`;
      }
      throw new Error(errorMsg);
    }
    
    // 處理成功回應
    if (response.status === 204) {
      return { status: response.status, data: null };
    }
    
    // 解析 JSON 回應
    const data = await response.json();
    return { status: response.status, data };
  },

  /**
   * 發送 DELETE 請求
   * @param {string} endpoint - API 端點
   * @returns {Promise} 回應的 Promise 物件
   */
  async delete(endpoint) {
    // 使用 fetch 發送 DELETE 請求
    const response = await fetch(`${BASE_URL}${endpoint}`, {
      method: 'DELETE',
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      }
    });
    
    // 處理回應 (DELETE 通常返回 204 No Content)
    if (response.status === 204) {
      return { status: response.status, data: true };
    } else if (!response.ok) {
      let errorMsg;
      try {
        const errorData = await response.json();
        errorMsg = errorData.message || `HTTP 錯誤: ${response.status}`;
      } catch (e) {
        errorMsg = `HTTP 錯誤: ${response.status}`;
      }
      throw new Error(errorMsg);
    }
    
    // 嘗試解析回應 (如果有)
    try {
      const data = await response.json();
      return { status: response.status, data };
    } catch (e) {
      // 如果沒有內容但狀態碼正常，視為成功
      return { status: response.status, data: true };
    }
  }
};

/**
 * 行政區域 API 服務
 * 處理與行政區相關的 HTTP 請求
 */
export const fareZoneApi = {
  /**
   * 獲取所有行政區
   * @returns {Promise} 包含所有行政區資料的 Promise
   */
  getAllZones() {
    // 使用 httpClient.get 方法發送請求至行政區列表端點
    return httpClient.get('/farezone/findAll');
  },

  /**
   * 根據 ID 獲取行政區資料
   * @param {number} zoneId - 行政區 ID
   * @returns {Promise} 包含行政區資料的 Promise
   */
  getZoneById(zoneId) {
    // 檢查參數有效性
    if (!zoneId) throw new Error('行政區 ID 不能為空');
    
    // 使用 httpClient.get 方法發送請求至獲取單一行政區端點
    return httpClient.get(`/farezone/${zoneId}`);
  },

  /**
   * 搜尋行政區
   * @param {string} query - 搜尋關鍵字
   * @returns {Promise} 包含搜尋結果的 Promise
   */
  searchZones(query) {
    // 使用 httpClient.get 方法發送請求至搜尋端點
    return httpClient.get('/farezone/search', { query });
  },

  /**
   * 新增行政區
   * @param {Object} zoneData - 行政區資料
   * @returns {Promise} 包含新增後行政區資料的 Promise
   */
  addZone(zoneData) {
    // 檢查參數有效性
    if (!zoneData) throw new Error('行政區資料不能為空');

    // 轉換欄位名稱為後端預期格式
    const payload = {
     zoneName:    zoneData.name || zoneData.zoneName, // 支援兩種欄位名稱
     description: zoneData.description || ''
   };
    
   console.log('API 層 - 準備新增行政區資料:', payload);

    // 使用 httpClient.post 方法發送請求至新增行政區端點
    return httpClient.post('/farezone', payload);
  },

  /**
   * 更新行政區資料
   * @param {number} zoneId - 行政區 ID
   * @param {Object} zoneData - 行政區更新資料
   * @returns {Promise} 包含更新後行政區資料的 Promise
   */
  updateZone(zoneId, zoneData) {
    // 檢查參數有效性
    if (!zoneId) throw new Error('行政區 ID 不能為空');
    if (!zoneData) throw new Error('行政區更新資料不能為空');
    
  // 將前端資料轉換為後端 API 預期的格式
  // 後端要求 zoneName 欄位，但前端使用 name 欄位
  const payload = {
    zoneName: zoneData.name || zoneData.zoneName, // 支援兩種欄位名稱
    description: zoneData.description || ''
  };

  console.log('API 層 - 準備更新行政區資料:', zoneId, payload);
   
  // 使用 httpClient.put 方法發送請求至更新行政區端點
  return httpClient.put(`/farezone/update/${zoneId}`, payload);
},



  /**
   * 刪除行政區
   * @param {number} zoneId - 行政區 ID
   * @returns {Promise} 刪除操作結果的 Promise
   */
  deleteZone(zoneId) {
    // 檢查參數有效性
    if (!zoneId) throw new Error('行政區 ID 不能為空');
    
    // 使用 httpClient.delete 方法發送請求至刪除行政區端點
    return httpClient.delete(`/farezone/delete/${zoneId}`);
  }
};