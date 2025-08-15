import axios from 'axios';

// 設定 axios 實例的基礎 URL
const apiClient = axios.create({
  baseURL: 'http://localhost:8080/api', // 保持原有的 API 路徑不變
  headers: {
    'Content-Type': 'application/json'
  }
});

/**
 * 輔具相關 API 請求封裝
 */
const deviceApi = {
  /**
   * 獲取所有輔具，可選依類別篩選
   * @param {Object} params - 查詢參數 (可選，包含 categoryId)
   * @returns {Promise} 包含輔具資料的 Promise 物件
   */
  getAllDevices(params = {}) {
    // 對應 @GetMapping("/api/devices")
    return apiClient.get('/devices', { params });
  },

  /**
   * 根據 ID 獲取單一輔具
   * @param {number} id - 輔具 ID
   * @returns {Promise} 包含輔具資料的 Promise 物件
   */
  getDeviceById(id) {
    // 對應 @GetMapping("/api/devices/{id}")
    return apiClient.get(`/devices/${id}`);
  },

  /**
   * 新增輔具
   * @param {Object} deviceRequest - 輔具建立資料
   * @returns {Promise} 包含新建輔具資料的 Promise 物件
   */
  addDevice(deviceRequest) {
    // 對應 @PostMapping("/api/devices")
    return apiClient.post('/devices', deviceRequest);
  },

  /**
   * 更新輔具
   * @param {Object} deviceRequest - 輔具更新資料
   * @param {number} id - 輔具 ID
   * @returns {Promise} 包含更新後輔具資料的 Promise 物件
   */
  updateDevice(deviceRequest, id) {
    // 對應 @PutMapping("/api/devices") 及 @RequestParam Integer id
    return apiClient.put('/devices', deviceRequest, { params: { id } });
  },

  /**
   * 刪除輔具
   * @param {number} id - 輔具 ID
   * @returns {Promise} 刪除結果的 Promise 物件
   */
  deleteDevice(id) {
    // 對應 @DeleteMapping("/api/devices/{id}")
    return apiClient.delete(`/devices/${id}`);
  },

  /**
   * 根據關鍵字搜尋輔具
   * @param {string} keyword - 搜尋關鍵字
   * @returns {Promise} 包含搜尋結果的 Promise 物件
   */
  searchDevices(keyword) {
    // 對應 @GetMapping("/api/devices/search")
    return apiClient.get('/devices/search', { params: { keyword } });
  },

  /**
   * 獲取輔具總數
   * @returns {Promise} 包含輔具總數的 Promise 物件
   */
  countDevices() {
    // 對應 @GetMapping("/api/devices/count")
    return apiClient.get('/devices/count');
  },

  /**
   * 排序查詢輔具
   * @param {string} sortBy - 排序欄位
   * @returns {Promise} 包含排序結果的 Promise 物件
   */
  getSortedDevices(sortBy) {
    // 對應 @GetMapping("/api/devices/sort")
    return apiClient.get('/devices/sort', { params: { sortBy } });
  },

  /**
   * 分頁查詢輔具
   * @param {number} offset - 起始位置
   * @param {number} limit - 每頁筆數
   * @returns {Promise} 包含分頁結果的 Promise 物件
   */
  getPagedDevices(offset, limit) {
    // 對應 @GetMapping("/api/devices/page")
    return apiClient.get('/devices/page', { params: { offset, limit } });
  },

  /**
   * 分頁+排序查詢輔具
   * @param {number} offset - 起始位置
   * @param {number} limit - 每頁筆數
   * @param {string} sortBy - 排序欄位
   * @returns {Promise} 包含分頁+排序結果的 Promise 物件
   */
  getPagedSortedDevices(offset, limit, sortBy) {
    // 對應 @GetMapping("/api/devices/page-sort")
    return apiClient.get('/devices/page-sort', { params: { offset, limit, sortBy } });
  },

  /**
   * 匯入 CSV
   * @param {File} file - CSV 檔案
   * @returns {Promise} 匯入結果的 Promise 物件
   */
  importCsv(file) {
    // 對應 @PostMapping("/api/devices/import")
    const formData = new FormData();
    formData.append('file', file);
    return apiClient.post('/devices/import', formData, {
      headers: {
        'Content-Type': 'multipart/form-data'
      }
    });
  },

  /**
   * 匯出 CSV
   * @returns {Promise} 匯出結果的 Promise 物件
   */
  exportCsv() {
    // 對應 @GetMapping("/api/devices/export")
    return apiClient.get('/devices/export');
  },

  /**
   * 批次更新輔具
   * @param {Array} devices - 要更新的輔具資料陣列
   * @returns {Promise} 批次更新結果的 Promise 物件
   */
  batchUpdateDevices(devices) {
    // 對應 @PutMapping("/api/devices/batch")
    return apiClient.put('/devices/batch', devices);
  },

  /**
   * 批次刪除輔具
   * @param {Array} ids - 要刪除的輔具 ID 陣列
   * @returns {Promise} 批次刪除結果的 Promise 物件
   */
  batchDeleteDevices(ids) {
    // 對應 @DeleteMapping("/api/devices/batch")
    return apiClient.delete('/devices/batch', { data: ids });
  }
};

// 匯出 deviceApi
export default deviceApi;