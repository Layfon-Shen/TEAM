import axios from 'axios';


// 設定 axios 實例的基礎 URL
const apiClient = axios.create({
  baseURL: 'http://localhost:8080/api', // 更新為正確的 API 路徑
  headers: {
    'Content-Type': 'application/json'
  }
});

/**
 * 活動 API 模組 - 負責 HTTP 請求
 * 對應後端 ActivityController 的所有端點
 */
export const activityApi = {
    /**
     * 查詢所有活動 - 對應 @GetMapping
     * @returns {Promise} axios response
     */
    async getAllActivities() {
        try {
            console.log('正在獲取所有活動...');
            return await apiClient.get('/activities');
        } catch (error) {
            console.error('獲取活動列表失敗:', error);
            throw error;
        }
    },

    /**
     * 查詢單筆活動 - 對應 @GetMapping("/{id}")
     * @param {number} id - 活動 ID
     * @returns {Promise} axios response
     */
    async getActivityById(id) {
        try {
            console.log(`正在獲取活動 ID: ${id}`);
            return await apiClient.get(`/activities/${id}`);
        } catch (error) {
            console.error(`獲取活動 ${id} 失敗:`, error);
            throw error;
        }
    },

    /**
     * 新增活動 - 對應 @PostMapping
     * @param {Object} activityRequest - 活動請求資料，對應 ActivityRequest DTO
     * @returns {Promise} axios response
     */
    async addActivity(activityRequest) {
        try {
            console.log('正在新增活動:', activityRequest);
            return await apiClient.post('/activities', activityRequest);
        } catch (error) {
            console.error('新增活動失敗:', error);
            throw error;
        }
    },

    /**
     * 更新活動 - 對應 @PutMapping("/{id}")
     * @param {number} id - 活動 ID
     * @param {Object} activityRequest - 活動請求資料，對應 ActivityRequest DTO
     * @returns {Promise} axios response
     */
    async updateActivity(id, activityRequest) {
        try {
            console.log(`正在更新活動 ID: ${id}`, activityRequest);
            return await apiClient.put(`/activities/${id}`, activityRequest);
        } catch (error) {
            console.error(`更新活動 ${id} 失敗:`, error);
            throw error;
        }
    },

    /**
     * 刪除活動 - 對應 @DeleteMapping("/{id}")
     * @param {number} id - 活動 ID
     * @returns {Promise} axios response
     */
    async deleteActivity(id) {
        try {
            console.log(`正在刪除活動 ID: ${id}`);
            return await apiClient.delete(`/activities/${id}`);
        } catch (error) {
            console.error(`刪除活動 ${id} 失敗:`, error);
            throw error;
        }
    }
};