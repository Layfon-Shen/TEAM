import { fareZoneApi } from '@/api/fareZoneApi';

/**
 * 行政區服務模組 - 處理業務邏輯和資料轉換
 */
export const fareZoneService = {
  /**
   * 獲取所有行政區列表
   * @returns {Promise<Array>} 行政區資料陣列
   */
  async getAllZones() {
    try {
      // 呼叫 API 獲取資料
      const response = await fareZoneApi.getAllZones();
      
      // 檢查回應狀態碼
      if (response.status === 200) {
        // 轉換後端資料為前端格式
        return response.data.map(zone => ({
          id: zone.ZONE_ID,
          name: zone.ZONE_NAME,
          description: zone.DESCRIPTION || ''
        }));
      }
      
      throw new Error(`伺服器回應錯誤：${response.status}`);
    } catch (error) {
      console.error('獲取行政區列表失敗:', error);
      throw new Error(error.message || '無法連接到伺服器');
    }
  },

  /**
   * 根據 ID 獲取行政區資料
   * @param {number} zoneId - 行政區 ID
   * @returns {Promise<Object>} 行政區資料
   */
  async getZoneById(zoneId) {
    try {
      // 呼叫 API 獲取資料
      const response = await fareZoneApi.getZoneById(zoneId);
      
      // 檢查回應狀態碼
      if (response.status === 200) {
        const zone = response.data;
        // 轉換為前端格式
        return {
          id: zone.ZONE_ID,
          name: zone.ZONE_NAME,
          description: zone.DESCRIPTION || ''
        };
      }
      
      throw new Error(`伺服器回應錯誤：${response.status}`);
    } catch (error) {
      console.error(`獲取行政區 ID ${zoneId} 失敗:`, error);
      throw new Error(error.message || '無法連接到伺服器');
    }
  },

  /**
   * 搜尋行政區
   * @param {string} query - 搜尋關鍵字
   * @returns {Promise<Array>} 符合搜尋條件的行政區資料陣列
   */
  async searchZones(query) {
    try {
      const response = await fareZoneApi.searchZones(query);
      
      if (response.status === 200) {
        // 轉換後端資料為前端格式
        return response.data.map(zone => ({
          id: zone.ZONE_ID,
          name: zone.ZONE_NAME,
          description: zone.DESCRIPTION || ''
        }));
      }
      
      throw new Error(`伺服器回應錯誤：${response.status}`);
    } catch (error) {
      console.error('搜尋行政區失敗:', error);
      throw new Error(error.message || '無法連接到伺服器');
    }
  },

  /**
   * 新增行政區
   * @param {Object} zoneData - 行政區資料
   * @returns {Promise<Object>} 新增後的行政區資料
   */
  async addZone(zoneData) {
     try {
    console.log('Service 層 - 收到新增行政區請求:', zoneData);
    
    // 檢查必要欄位
    if (!zoneData.name) {
      throw new Error('行政區名稱不能為空');
    }
  // 呼叫 API 層方法
    const response = await fareZoneApi.addZone({
      name: zoneData.name, // 使用統一的欄位名稱
      description: zoneData.description || ''
    });
    
    console.log('Service 層 - 新增行政區回應:', response);
    
    if (response.status === 200 || response.status === 201) {
      const zone = response.data;
      
      console.log('Service 層 - 轉換後端資料:', zone);
      
      // 根據後端回傳的資料格式進行調整
      return {
        id: zone.zoneId || zone.ZONE_ID,
        name: zone.zoneName || zone.ZONE_NAME,
        description: zone.description || zone.DESCRIPTION || ''
      };
    }
    
    throw new Error(`伺服器回應錯誤：${response.status}`);
  } catch (error) {
    console.error('新增行政區失敗:', error);
    throw new Error(error.message || '無法連接到伺服器');
  }
},

/**
 * 根據 ID 獲取行政區資料
 * @param {number} zoneId - 行政區 ID
 * @returns {Promise<Object>} 行政區資料
 */
async getZoneById(zoneId) {
  try {
    console.log('Service 層 - 獲取行政區資料:', zoneId);
    
    // 呼叫 API 獲取資料
    const response = await fareZoneApi.getZoneById(zoneId);
    
    console.log('Service 層 - 獲取行政區回應:', response);
    
    // 檢查回應狀態碼
    if (response.status === 200) {
      const zone = response.data;
      console.log('後端回傳的原始資料:', zone);

     // 根據不同的欄位名稱格式進行兼容處理
      return {
        id: zone.zoneId || zone.ZONE_ID,
        name: zone.zoneName || zone.ZONE_NAME,
        description: zone.description || zone.DESCRIPTION || ''
      };
    }
    
    throw new Error(`伺服器回應錯誤：${response.status}`);
  } catch (error) {
    console.error(`獲取行政區 ID ${zoneId} 失敗:`, error);
    throw new Error(error.message || '無法連接到伺服器');
  }
}, 

  /**
 * 更新行政區資料
 * @param {number} zoneId - 行政區 ID
 * @param {Object} zoneData - 行政區更新資料
 * @returns {Promise<Object>} 更新後的行政區資料
 */
async updateZone(zoneId, zoneData) {
  try {
    console.log('Service 層 - 收到更新行政區請求:', zoneId, zoneData);
    
    // 檢查必要欄位
    if (!zoneData.name) {
      throw new Error('行政區名稱不能為空');
    }

    // 呼叫 API 更新資料
    const response = await fareZoneApi.updateZone(zoneId, zoneData);
    
    console.log('Service 層 - 更新行政區回應:', response);
    
    if (response.status === 200) {
      const zone = response.data;
      
      // 根據後端回傳的資料格式進行調整
      return {
        id: zone.zoneId || zone.ZONE_ID,
        name: zone.zoneName || zone.ZONE_NAME,
        description: zone.description || zone.DESCRIPTION || ''
      };
    }
    
    throw new Error(`伺服器回應錯誤：${response.status}`);
  } catch (error) {
    console.error(`更新行政區 ID ${zoneId} 失敗:`, error);
    throw new Error(error.message || '無法連接到伺服器');
  }
},

  /**
   * 刪除行政區
   * @param {number} zoneId - 行政區 ID
   * @returns {Promise<boolean>} 是否成功刪除
   */
  async deleteZone(zoneId) {
    try {
      const response = await fareZoneApi.deleteZone(zoneId);
      
      // 刪除成功回傳 204 No Content 或 200 OK
      return response.status === 204 || response.status === 200;
    } catch (error) {
      console.error(`刪除行政區 ID ${zoneId} 失敗:`, error);
      throw new Error(error.message || '無法連接到伺服器');
    }
  }
};