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

    const response = await fetch(url, {
      method: 'GET',
      headers: {
        'Content-Type': 'application/json'
      }
    });

    if (!response.ok) {
      throw new Error(`HTTP 錯誤 ${response.status}`);
    }

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

    const response = await fetch(url, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json'
      },
      body: body ? JSON.stringify(body) : null
    });

    if (!response.ok) {
      throw new Error(`HTTP 錯誤 ${response.status}`);
    }

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
    const response = await fetch(`${BASE_URL}${endpoint}`, {
      method: 'PUT',
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify(body)
    });
    
    if (!response.ok) {
      throw new Error(`HTTP 錯誤 ${response.status}`);
    }
    
    const data = await response.json();
    return { status: response.status, data };
  },

   /**
   * 發送 DELETE 請求
   * @param {string} endpoint - API 端點
   * @returns {Promise} 回應的 Promise 物件
   */
  async delete(endpoint) {
    const response = await fetch(`${BASE_URL}${endpoint}`, {
      method: 'DELETE',
      headers: {
        'Content-Type': 'application/json'
      }
    });
    
    return { status: response.status };
  }
};


  /**
   * 復康巴士 API 模組 - 只負責處理 HTTP 請求和回應
   * 根據 BusController.java 中的端點實作對應的方法
   */
  export const busApi = {
    /**
     * 取得所有復康巴士列表
     * @returns {Promise} 包含所有復康巴士資料的 Promise 物件
     */
    getAllBuses() {
    return httpClient.get('/rehabus/findAll');
  },

    /**
     * 根據 ID 取得單一復康巴士
     * @param {number} busId - 復康巴士 ID
     * @returns {Promise} 包含復康巴士資料的 Promise 物件
     */
     getBusById(busId) {
    return httpClient.get(`/rehabus/${busId}`);
  },


/**
 * 搜尋復康巴士
 * @param {Object} params - 搜尋參數
 * @returns {Promise} 包含搜尋結果的 Promise 物件
 */
searchBuses(params) {
  // 構建查詢參數
  const queryParams = {};
  
  if (params.minSeats !== null && params.minSeats !== undefined) {
    queryParams.minSeats = params.minSeats;
  }
  
  if (params.minWheels !== null && params.minWheels !== undefined) {
    queryParams.minWheels = params.minWheels;
  }
  
  return httpClient.get('/rehabus/search', queryParams);
},

    /**
   * 新增復康巴士
   * @param {Object} busRequest - 復康巴士資料
   * @returns {Promise} 包含新增後復康巴士資料的 Promise 物件
   */
  addBus(busRequest) {
    return httpClient.post('/rehabus', busRequest);
  },


    
  /**
   * 更新復康巴士資料
   * @param {number} busId - 復康巴士 ID
   * @param {Object} busRequest - 復康巴士更新資料
   * @returns {Promise} 包含更新後復康巴士資料的 Promise 物件
   */
  updateBus(busId, busRequest) {
    return httpClient.put(`/rehabus/update/${busId}`, busRequest);
  },

  /**
   * 刪除復康巴士
   * @param {number} busId - 復康巴士 ID
   * @returns {Promise} 包含刪除結果的 Promise 物件
   */
  deleteBus(busId) {
    return httpClient.delete(`/rehabus/delete/${busId}`);
  },


    /**
   * 從 CSV 檔案匯入復康巴士資料
   * @param {string} filePath - CSV 檔案路徑
   * @returns {Promise} 包含匯入筆數的 Promise 物件
   */
  importFromCsv(filePath) {
    return httpClient.post('/rehabus/importcsv', null, { filePath });
  }
};