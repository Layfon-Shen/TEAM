import { ref } from 'vue';
import { activityService } from '@/services/activityService';

/**
 * 活動狀態管理 Composable
 * 負責元件狀態管理、快取和與服務層的互動
 */
export function useActivity() {
    // 響應式狀態管理
    const activities = ref([]);
    const loading = ref(false);
    const error = ref(null);
    const success = ref(null);

    /**
     * 載入活動列表
     * @returns {Promise<void>}
     */
    const loadActivities = async () => {
        loading.value = true;
        error.value = null;

        try {
            activities.value = await activityService.getActivities();
        } catch (err) {
            error.value = err.message;
            activities.value = [];
            console.error('載入活動列表失敗:', err);
        } finally {
            loading.value = false;
        }
    };

    /**
     * 根據 ID 獲取單一活動
     * @param {number} id - 活動 ID
     * @returns {Promise<Object|null>} 活動資料或 null
     */
    const getActivity = async (id) => {
        loading.value = true;
        error.value = null;

        try {
            return await activityService.getActivityById(id);
        } catch (err) {
            error.value = err.message;
            console.error(`獲取活動 ${id} 失敗:`, err);
            return null;
        } finally {
            loading.value = false;
        }
    };

    /**
     * 新增活動
     * @param {Object} activityData - 活動資料
     * @returns {Promise<boolean>} 新增是否成功
     */
    const addActivity = async (activityData) => {
        loading.value = true;
        error.value = null;
        success.value = null;

        try {
            const result = await activityService.addActivity(activityData);

            if (result.success) {
                // 新增成功後重新載入活動列表以同步資料
                await loadActivities();
                success.value = result.message;
                return true;
            } else {
                error.value = result.message;
                return false;
            }
        } catch (err) {
            error.value = err.message;
            console.error('新增活動失敗:', err);
            return false;
        } finally {
            loading.value = false;
        }
    };

    /**
     * 更新活動
     * @param {number} id - 活動 ID
     * @param {Object} activityData - 活動資料
     * @returns {Promise<boolean>} 更新是否成功
     */
    const updateActivity = async (id, activityData) => {
        loading.value = true;
        error.value = null;
        success.value = null;

        try {
            const result = await activityService.updateActivity(id, activityData);

            if (result.success) {
                // 更新成功後重新載入活動列表以同步資料
                await loadActivities();
                success.value = result.message;
                return true;
            } else {
                error.value = result.message;
                return false;
            }
        } catch (err) {
            error.value = err.message;
            console.error('更新活動失敗:', err);
            return false;
        } finally {
            loading.value = false;
        }
    };

    /**
     * 刪除活動
     * @param {number} id - 活動 ID
     * @returns {Promise<boolean>} 刪除是否成功
     */
    const removeActivity = async (id) => {
        loading.value = true;
        error.value = null;
        success.value = null;

        try {
            const result = await activityService.deleteActivity(id);

            if (result.success) {
                // 從本地狀態中移除已刪除的活動（樂觀更新）
                activities.value = activities.value.filter(a => a.id !== id);
                success.value = result.message;
                return true;
            } else {
                error.value = result.message;
                return false;
            }
        } catch (err) {
            error.value = err.message;
            console.error('刪除活動失敗:', err);
            return false;
        } finally {
            loading.value = false;
        }
    };

    /**
     * 清除錯誤和成功訊息
     */
    const clearMessages = () => {
        error.value = null;
        success.value = null;
    };

    return {
        // 響應式狀態
        activities,
        loading,
        error,
        success,

        // 操作方法
        loadActivities,
        getActivity,
        addActivity,
        updateActivity,
        removeActivity,
        clearMessages
    };
}