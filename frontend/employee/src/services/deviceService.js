import deviceApi from '@/api/deviceApi';

/**
 * 輔具服務 - 處理業務邏輯與數據轉換
 */
const deviceService = {
  /**
   * 獲取所有輔具
   * @returns {Promise<Array>} 輔具清單
   */
  getAllDevices: async () => {
    try {
      const response = await deviceApi.getAllDevices();
      return response.data;
    } catch (error) {
      console.error('獲取輔具資料失敗:', error);
      throw new Error(`獲取輔具資料失敗: ${error.message}`);
    }
  },

  /**
   * 獲取單一輔具
   * @param {Number} id - 輔具ID
   * @returns {Promise<Object>} 輔具對象
   */
  getDeviceById: async (id) => {
    try {
      const response = await deviceApi.getDeviceById(id);
      return response.data;
    } catch (error) {
      console.error(`獲取輔具ID:${id}失敗:`, error);
      throw new Error(`獲取輔具失敗: ${error.message}`);
    }
  },

  /**
   * 新增輔具
   * @param {Object} device - 輔具資料
   * @returns {Promise<Number>} 新增輔具的ID
   */
  addDevice: async (device) => {
    try {
      const response = await deviceApi.addDevice(device);
      return response.data;
    } catch (error) {
      console.error('新增輔具失敗:', error);
      throw new Error(`新增輔具失敗: ${error.message}`);
    }
  },

  /**
   * 更新輔具
   * @param {Object} device - 輔具資料
   * @returns {Promise<Boolean>} 更新結果
   */
  updateDevice: async (device) => {
    try {
      // 檢查是否有 ID
      if (!device.id) {
        throw new Error('輔具ID為空，無法更新');
      }
      
      // 使用 ID 作為參數傳遞
      const id = device.id;
      const response = await deviceApi.updateDevice(device, id);
      
      return response.data;
    } catch (error) {
      console.error(`更新輔具ID:${device.id}失敗:`, error);
      throw new Error(`更新輔具失敗: ${error.message}`);
    }
  },

  /**
   * 刪除輔具
   * @param {Number} id - 輔具ID
   * @returns {Promise<Boolean>} 刪除結果
   */
  deleteDevice: async (id) => {
    try {
      const response = await deviceApi.deleteDevice(id);
      return response.data;
    } catch (error) {
      console.error(`刪除輔具ID:${id}失敗:`, error);
      throw new Error(`刪除輔具失敗: ${error.message}`);
    }
  },

  /**
   * 搜尋輔具
   * @param {String} keyword - 關鍵字
   * @returns {Promise<Array>} 符合條件的輔具清單
   */
  searchDevices: async (keyword) => {
    try {
      const response = await deviceApi.searchDevices(keyword);
      return response.data;
    } catch (error) {
      console.error(`搜尋輔具關鍵字:${keyword}失敗:`, error);
      throw new Error(`搜尋輔具失敗: ${error.message}`);
    }
  },

  /**
   * 檢查庫存是否不足
   * @param {Object} device - 輔具對象
   * @param {Number} threshold - 閾值，預設為10
   * @returns {Boolean} 是否庫存不足
   */
  checkLowInventory: (device, threshold = 10) => {
    return device.inventory < threshold;
  },

  /**
   * 將輔具資料轉換為CSV格式
   * @param {Array} devices - 輔具清單
   * @returns {String} CSV格式的輔具資料
   */
  convertToCSV: (devices) => {
    if (!devices || devices.length === 0) return '';

    // 1. 定義CSV欄位標題
    const headers = ['ID', '輔具名稱', '商品貨號', '單價', '庫存數量', '上架狀態', '描述', '圖片連結', '分類ID'];

    // 2. 將每筆資料轉換為CSV行
    const rows = devices.map(device => {
      return [
        device.id,
        device.name,
        device.sku,
        device.unitPrice,
        device.inventory,
        device.isOnline ? '已上架' : '未上架',
        device.description || '',
        device.image || '',
        device.categoryId
      ].map(field => {
        // 如果欄位包含逗號、引號或換行符，需要用引號包起來
        if (typeof field === 'string' && (field.includes(',') || field.includes('"') || field.includes('\n'))) {
          // 轉義引號
          return `"${field.replace(/"/g, '""')}"`;
        }
        return field;
      }).join(',');
    });

    // 3. 組合成完整的CSV
    return `\uFEFF${headers.join(',')}\n${rows.join('\n')}`;
  },

  /**
   * 批次更新多個輔具的狀態
   * @param {Array<Number>} ids - 輔具ID列表
   * @param {Boolean} isOnline - 新的上架狀態
   * @returns {Promise<Boolean>} 更新結果
   */
  batchUpdateDeviceStatus: async (ids, isOnline) => {
    try {
      // 1. 先獲取這些輔具的資訊
      const devices = [];
      for (const id of ids) {
        try {
          const device = await deviceService.getDeviceById(id);
          if (device) {
            device.isOnline = isOnline;
            devices.push(device);
          }
        } catch (error) {
          console.error(`無法獲取輔具ID:${id}的資訊:`, error);
        }
      }

      // 2. 批次更新這些輔具
      if (devices.length > 0) {
        const response = await deviceApi.batchUpdateDevices(devices);
        return response.data;
      }
      return false;
    } catch (error) {
      console.error('批次更新輔具狀態失敗:', error);
      throw new Error(`批次更新輔具狀態失敗: ${error.message}`);
    }
  },

  /**
   * 批次更新多個輔具
   * @param {Array<Object>} devices - 輔具列表
   * @returns {Promise<Boolean>} 更新結果
   */
  batchUpdateDevices: async (devices) => {
    try {
      const response = await deviceApi.batchUpdateDevices(devices);
      return response.data;
    } catch (error) {
      console.error('批次更新輔具失敗:', error);
      throw new Error(`批次更新輔具失敗: ${error.message}`);
    }
  },

  /**
   * 批次刪除多個輔具
   * @param {Array<Number>} ids - 輔具ID列表
   * @returns {Promise<Boolean>} 刪除結果
   */
  batchDeleteDevices: async (ids) => {
    try {
      const response = await deviceApi.batchDeleteDevices(ids);
      return response.data;
    } catch (error) {
      console.error('批次刪除輔具失敗:', error);
      throw new Error(`批次刪除輔具失敗: ${error.message}`);
    }
  }
};

export default deviceService;