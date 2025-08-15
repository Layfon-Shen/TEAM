import { activityApi } from '@/api/activityApi';

/**
 * 活動服務模組 - 處理業務邏輯和資料轉換
 * 封裝所有活動相關的業務操作
 */
export const activityService = {
    /**
     * 獲取活動清單並進行資料轉換
     * @returns {Promise<Array>} 轉換後的活動資料陣列
     */
    async getActivities() {
        try {
            // 呼叫 API 層取得資料
            const response = await activityApi.getAllActivities();

            // 檢查回應是否成功
            if (response.status === 200) {
                // 轉換資料格式為前端所需的格式，對應 Activity.java 模型
                return response.data.map(activity => ({
                    id: activity.id,
                    name: activity.name || '未命名活動',
                    category: activity.category || '未分類',
                    limit: activity.limit || 0,
                    current: activity.current || 0,
                    date: activity.date, // 已是 yyyy-MM-dd 格式
                    end: activity.end,
                    time: activity.time || '時間未定',
                    registrationStart: activity.registrationStart,
                    registrationEnd: activity.registrationEnd,
                    location: activity.location || '地點未定',
                    latitude: activity.latitude,
                    longitude: activity.longitude,
                    instructor: activity.instructor || '講師未定',
                    status: activity.status, // boolean 值
                    description: activity.description || '暫無描述',
                    image: activity.image || '/default-activity.jpg'
                }));
            }

            throw new Error(`伺服器回應錯誤：${response.status}`);
        } catch (error) {
            // 整合錯誤訊息處理
            const errorMsg = this._handleError(error, '獲取活動資料');
            throw new Error(errorMsg);
        }
    },

    /**
     * 根據 ID 獲取特定活動資料
     * @param {number} id - 活動 ID
     * @returns {Promise<Object>} 活動資料物件
     */
    async getActivityById(id) {
        try {
            const response = await activityApi.getActivityById(id);

            if (response.status === 200) {
                // 直接回傳活動資料，保持與後端模型一致
                return response.data;
            }

            throw new Error(`伺服器回應錯誤：${response.status}`);
        } catch (error) {
            const errorMsg = this._handleError(error, '獲取活動詳情');
            throw new Error(errorMsg);
        }
    },

    /**
     * 新增活動 - 對應後端的 ActivityRequest DTO
     * @param {Object} activityData - 活動資料
     * @returns {Promise<Object>} 操作結果
     */
    async addActivity(activityData) {
        try {
            // 轉換前端表單資料為後端 ActivityRequest 格式
            const activityRequest = this._transformToActivityRequest(activityData);

            const response = await activityApi.addActivity(activityRequest);

            // 後端回傳 201 Created 狀態
            if (response.status === 201) {
                return {
                    success: true,
                    message: '活動新增成功'
                };
            }

            throw new Error(`伺服器回應錯誤：${response.status}`);
        } catch (error) {
            const errorMsg = this._handleError(error, '新增活動');
            return {
                success: false,
                message: errorMsg
            };
        }
    },

    /**
     * 更新活動 - 對應後端的 ActivityRequest DTO
     * @param {number} id - 活動 ID
     * @param {Object} activityData - 活動資料
     * @returns {Promise<Object>} 操作結果
     */
    async updateActivity(id, activityData) {
        try {
            // 轉換前端表單資料為後端 ActivityRequest 格式
            const activityRequest = this._transformToActivityRequest(activityData);

            const response = await activityApi.updateActivity(id, activityRequest);

            // 後端成功時回傳 200 OK 和 "更新成功" 訊息
            if (response.status === 200) {
                return {
                    success: true,
                    message: response.data || '活動更新成功'
                };
            }

            throw new Error(`伺服器回應錯誤：${response.status}`);
        } catch (error) {
            const errorMsg = this._handleError(error, '更新活動');
            return {
                success: false,
                message: errorMsg
            };
        }
    },

    /**
     * 刪除活動
     * @param {number} id - 活動 ID
     * @returns {Promise<Object>} 操作結果
     */
    async deleteActivity(id) {
        try {
            const response = await activityApi.deleteActivity(id);

            // 後端成功時回傳 200 OK 和 "刪除成功" 訊息
            if (response.status === 200) {
                return {
                    success: true,
                    message: response.data || '活動刪除成功'
                };
            }

            throw new Error(`伺服器回應錯誤：${response.status}`);
        } catch (error) {
            const errorMsg = this._handleError(error, '刪除活動');
            return {
                success: false,
                message: errorMsg
            };
        }
    },

    /**
     * 轉換前端資料為後端 ActivityRequest 格式
     * @param {Object} activityData - 前端活動資料
     * @returns {Object} ActivityRequest 格式的資料
     * @private
     */
    _transformToActivityRequest(activityData) {
        return {
            // 對應 ActivityRequest DTO 的所有欄位
            name: activityData.name?.trim() || '',
            category: activityData.category || '',
            limit: parseInt(activityData.limit) || 0,
            current: parseInt(activityData.current) || 0,
            date: activityData.date || null,
            end: activityData.end || null,
            time: activityData.time?.trim() || '',
            registrationStart: activityData.registrationStart || null,
            registrationEnd: activityData.registrationEnd || null,
            location: activityData.location?.trim() || '',
            latitude: activityData.latitude ? parseFloat(activityData.latitude) : null,
            longitude: activityData.longitude ? parseFloat(activityData.longitude) : null,
            instructor: activityData.instructor?.trim() || '',
            status: Boolean(activityData.status),
            description: activityData.description?.trim() || '',
            image: activityData.image?.trim() || ''
        };
    },

    /**
     * 統一錯誤處理方法
     * @param {Error} error - 錯誤物件
     * @param {string} operation - 操作名稱
     * @returns {string} 格式化的錯誤訊息
     * @private
     */
    _handleError(error, operation) {
        if (error.response) {
            // 伺服器回應了錯誤狀態碼
            const status = error.response.status;
            const message = error.response.data || '未知錯誤';

            switch (status) {
                case 400:
                    return `${operation}失敗：請求參數錯誤`;
                case 404:
                    return `${operation}失敗：找不到指定的活動`;
                case 500:
                    return `${operation}失敗：伺服器內部錯誤`;
                default:
                    return `${operation}失敗：錯誤 ${status} - ${message}`;
            }
        } else if (error.request) {
            // 請求已發送但沒有收到回應
            return `${operation}失敗：無法連接到伺服器，請檢查網路連線`;
        } else {
            // 其他錯誤
            return `${operation}失敗：${error.message}`;
        }
    }
};