import axios from 'axios';

// 設定 axios 實例的基礎 URL
const apiClient = axios.create({
  baseURL: 'http://localhost:8080/api', // 保持原有的 API 路徑不變
  headers: {
    'Content-Type': 'application/json'
  }
});

/**
 * 輔具分類相關 API 請求封裝
 * 對應後端 DeviceCategoryController 的各個 API 端點
 */
const deviceCategoryApi = {
  /**
   * 獲取所有輔具分類
   * @returns {Promise} - 回傳包含所有分類的 Promise
   */
  getAllCategories() {
    // 對應 @GetMapping("/api/device-categories")
    return apiClient.get('/device-categories');
  },

  /**
   * 根據 ID 獲取單一輔具分類
   * @param {Number} id - 分類 ID
   * @returns {Promise} - 回傳包含單一分類的 Promise
   */
  getCategoryById(id) {
    // 對應 @GetMapping("/api/device-categories/{id}")
    return apiClient.get(`/device-categories/${id}`);
  },

  /**
   * 新增輔具分類
   * @param {Object} category - 分類資料
   * @returns {Promise} - 回傳包含新增分類 ID 的 Promise
   */
  addCategory(category) {
    // 對應 @PostMapping("/api/device-categories")
    return apiClient.post('/device-categories', category);
  },

  /**
   * 更新輔具分類
   * @param {Object} category - 更新後的分類資料
   * @param {Number} id - 分類 ID
   * @returns {Promise} - 回傳更新結果的 Promise
   */
  updateCategory(category, id) {
    // 對應 @PutMapping("/api/device-categories/{id}")
    return apiClient.put(`/device-categories/${id}`, category);
  },

  /**
   * 刪除輔具分類
   * @param {Number} id - 分類 ID
   * @returns {Promise} - 回傳刪除結果的 Promise
   */
  deleteCategory(id) {
    // 對應 @DeleteMapping("/api/device-categories/{id}")
    return apiClient.delete(`/device-categories/${id}`);
  },

  /**
   * 檢查分類 ID 是否存在
   * @param {Number} id - 分類 ID
   * @returns {Promise} - 回傳存在結果的 Promise
   */
  existsById(id) {
    // 對應 @GetMapping("/api/device-categories/exists/{id}")
    return apiClient.get(`/device-categories/exists/${id}`);
  },

  /**
   * 根據關鍵字搜尋分類
   * @param {String} keyword - 搜尋關鍵字
   * @returns {Promise} - 回傳搜尋結果的 Promise
   */
  searchByName(keyword) {
    // 對應 @GetMapping("/api/device-categories/search")
    return apiClient.get('/device-categories/search', {
      params: { keyword }
    });
  },

  /**
   * 獲取分類總筆數
   * @returns {Promise} - 回傳分類總數的 Promise
   */
  countCategories() {
    // 對應 @GetMapping("/api/device-categories/count")
    return apiClient.get('/device-categories/count');
  }
};

// 匯出 deviceCategoryApi
export default deviceCategoryApi;