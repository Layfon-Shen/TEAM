import { ref, computed } from 'vue';
import deviceCategoryService from '@/services/deviceCategoryService';

// 快取時間（毫秒）- 直接在檔案中定義
const CACHE_DURATION = 5 * 60 * 1000; // 5分鐘

// 建立共享狀態
const categories = ref([]);
const isLoading = ref(false);
const error = ref(null);
const lastFetched = ref(null);

/**
 * 輔具分類管理 Composable
 * 提供分類資料的狀態管理和快取功能
 * @returns {Object} 分類相關狀態和方法
 */
export default function useDeviceCategories() {
  /**
   * 檢查快取是否有效
   * @returns {Boolean} 快取是否有效
   */
  const isCacheValid = computed(() => {
    return lastFetched.value && 
           (Date.now() - lastFetched.value) < CACHE_DURATION;
  });
  
  /**
   * 獲取分類列表，支援強制重新獲取或使用快取
   * @param {Boolean} forceRefresh - 是否強制重新獲取
   * @returns {Promise<Array>} 分類列表
   */
  const fetchCategories = async (forceRefresh = false) => {
    // 如果快取有效且不強制刷新，則返回現有資料
    if (isCacheValid.value && !forceRefresh && categories.value.length > 0) {
      return categories.value;
    }
    
    isLoading.value = true;
    error.value = null;
    
    try {
      const data = await deviceCategoryService.getAllCategories();
      categories.value = Array.isArray(data) ? data : [];
      lastFetched.value = Date.now();
      return categories.value;
    } catch (err) {
      error.value = err.message || '獲取分類資料失敗';
      console.error('無法載入輔具分類:', err);
      throw err;
    } finally {
      isLoading.value = false;
    }
  };

  /**
   * 添加新分類
   * @param {String} name - 分類名稱
   * @param {Number} categoryId - 排序用分類ID
   * @returns {Promise<Number>} 新分類ID
   */
  const addCategory = async (name, categoryId) => {
    try {
      const newId = await deviceCategoryService.addCategory(name, categoryId);
      // 更新本地快取
      await fetchCategories(true);
      return newId;
    } catch (err) {
      error.value = err.message || '新增分類失敗';
      throw err;
    }
  };

  /**
   * 更新分類資訊
   * @param {Object} category - 更新的分類資料
   * @returns {Promise<Boolean>} 更新結果
   */
  const updateCategory = async (category) => {
    try {
      const result = await deviceCategoryService.updateCategory(category);
      // 更新本地快取
      if (result) {
        await fetchCategories(true);
      }
      return result;
    } catch (err) {
      error.value = err.message || '更新分類失敗';
      throw err;
    }
  };

  /**
   * 刪除分類
   * @param {Number} id - 分類ID
   * @returns {Promise<Boolean>} 刪除結果
   */
  const deleteCategory = async (id) => {
    try {
      const result = await deviceCategoryService.deleteCategory(id);
      // 更新本地快取
      if (result) {
        await fetchCategories(true);
      }
      return result;
    } catch (err) {
      error.value = err.message || '刪除分類失敗';
      throw err;
    }
  };

  /**
   * 搜尋分類
   * @param {String} keyword - 搜尋關鍵字
   * @returns {Promise<Array>} 搜尋結果
   */
  const searchCategories = async (keyword) => {
    try {
      isLoading.value = true;
      error.value = null;
      const result = await deviceCategoryService.searchByName(keyword);
      return result;
    } catch (err) {
      error.value = err.message || '搜尋分類失敗';
      throw err;
    } finally {
      isLoading.value = false;
    }
  };

  return {
    categories,
    isLoading,
    error,
    fetchCategories,
    addCategory,
    updateCategory,
    deleteCategory,
    searchCategories,
    isCacheValid
  };
}