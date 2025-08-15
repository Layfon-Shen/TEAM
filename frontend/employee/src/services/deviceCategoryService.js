import deviceCategoryApi from '@/api/deviceCategoryApi';

/**
 * 輔具分類服務 - 處理業務邏輯與數據轉換
 */
const deviceCategoryService = {
  /**
   * 獲取所有分類
   * @returns {Promise<Array>} 分類列表
   */
  getAllCategories: async () => {
    try {
      const response = await deviceCategoryApi.getAllCategories();
      
      // 檢查 API 回應結構，處理不同的資料格式
      if (response && response.data) {
        // 如果是標準 axios 回應，data 屬性包含實際資料
        if (Array.isArray(response.data)) {
          return response.data;
        } else if (response.data.data && Array.isArray(response.data.data)) {
          // 有些 API 可能將資料再包一層 data
          return response.data.data;
        } else {
          console.warn('API 回應格式異常:', response.data);
          return [];
        }
      }
      
      console.warn('API 回應為空');
      return [];
    } catch (error) {
      console.error('獲取輔具分類失敗:', error);
      throw new Error(`獲取輔具分類失敗: ${error.message}`);
    }
  },

  /**
   * 根據ID獲取單一分類
   * @param {Number} id - 分類ID
   * @returns {Promise<Object>} 分類對象
   */
  getCategoryById: async (id) => {
    try {
      return await deviceCategoryApi.getCategoryById(id);
    } catch (error) {
      console.error(`獲取輔具分類ID:${id}失敗:`, error);
      throw new Error(`獲取輔具分類失敗: ${error.message}`);
    }
  },

  /**
   * 添加新分類
   * @param {String} name - 分類名稱
   * @param {Number} categoryId - 排序用分類ID
   * @returns {Promise<Number>} 新增分類的ID
   */
  addCategory: async (name, categoryId = 0) => {
    try {
      const category = {
        name: name,
        categoryId: categoryId
      };
      return await deviceCategoryApi.addCategory(category);
    } catch (error) {
      console.error('新增輔具分類失敗:', error);
      throw new Error(`新增輔具分類失敗: ${error.message}`);
    }
  },

  /**
   * 更新分類
   * @param {Object} category - 分類對象
   * @returns {Promise<Boolean>} 更新結果
   */
  updateCategory: async (category) => {
    try {
      return await deviceCategoryApi.updateCategory(category, category.id);
    } catch (error) {
      console.error(`更新輔具分類ID:${category.id}失敗:`, error);
      throw new Error(`更新輔具分類失敗: ${error.message}`);
    }
  },

  /**
   * 刪除分類
   * @param {Number} id - 分類ID
   * @returns {Promise<Boolean>} 刪除結果
   */
  deleteCategory: async (id) => {
    try {
      return await deviceCategoryApi.deleteCategory(id);
    } catch (error) {
      console.error(`刪除輔具分類ID:${id}失敗:`, error);
      throw new Error(`刪除輔具分類失敗: ${error.message}`);
    }
  },

  /**
   * 搜尋分類
   * @param {String} keyword - 搜尋關鍵字
   * @returns {Promise<Array>} 符合條件的分類列表
   */
  searchByName: async (keyword) => {
    try {
      return await deviceCategoryApi.searchByName(keyword);
    } catch (error) {
      console.error(`搜尋輔具分類關鍵字:${keyword}失敗:`, error);
      throw new Error(`搜尋輔具分類失敗: ${error.message}`);
    }
  },

  /**
   * 檢查分類是否存在
   * @param {Number} id - 分類ID
   * @returns {Promise<Boolean>} 存在結果
   */
  categoryExists: async (id) => {
    try {
      return await deviceCategoryApi.existsById(id);
    } catch (error) {
      console.error(`檢查輔具分類ID:${id}是否存在失敗:`, error);
      throw new Error(`檢查輔具分類是否存在失敗: ${error.message}`);
    }
  },

  /**
   * 獲取分類總數
   * @returns {Promise<Number>} 分類總數
   */
  getCount: async () => {
    try {
      return await deviceCategoryApi.countCategories();
    } catch (error) {
      console.error('獲取輔具分類總數失敗:', error);
      throw new Error(`獲取輔具分類總數失敗: ${error.message}`);
    }
  }
};

export default deviceCategoryService;