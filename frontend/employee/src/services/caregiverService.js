import { caregiverApi } from '@/api/caregiverApi';

/**
 * 照服員服務模組 - 封裝業務邏輯和資料轉換
 */
export const caregiverService = {
  /**
   * 獲取照服員清單並進行資料轉換
   * @param {Object} filters - 篩選條件
   * @param {boolean|null} filters.isActive - 是否啟用
   * @param {string|null} filters.name - 姓名搜尋
   * @param {string|null} filters.serviceArea - 服務區域
   * @returns {Promise<Array>} 轉換後的照服員資料陣列
   */
  async getCaregivers(filters = {}) {
    try {
      let response;

      // 根據篩選條件選擇對應的 API
      if (filters.name) {
        // 按姓名搜尋
        response = await caregiverApi.searchCaregivers(filters.name);
      } else if (filters.serviceArea) {
        // 按服務區域搜尋
        response = await caregiverApi.getCaregiversByServiceArea(filters.serviceArea);
      } else if (filters.isActive !== undefined && filters.isActive !== null) {
        // 按狀態篩選
        response = await caregiverApi.getCaregiversByStatus(filters.isActive);
      } else {
        // 取得所有照服員
        response = await caregiverApi.getAllCaregivers();
      }

      // 檢查回應是否成功
      if (response.status === 200 && response.data.success) {
        // 轉換資料格式為前端表格所需的格式
        return this.transformCaregiverList(response.data.data);
      }

      throw new Error(response.data.message || '獲取照服員資料失敗');
    } catch (error) {
      console.error('照服員服務錯誤:', error);
      throw error;
    }
  },

  /**
   * 根據 ID 獲取單一照服員
   * @param {number} id - 照服員 ID
   * @returns {Promise<Object>} 照服員資料
   */
  async getCaregiverById(id) {
    try {
      const response = await caregiverApi.getCaregiverById(id);
      
      if (response.status === 200 && response.data.success) {
        return this.transformCaregiverData(response.data.data);
      }

      throw new Error(response.data.message || '獲取照服員資料失敗');
    } catch (error) {
      console.error('獲取照服員詳細資料錯誤:', error);
      throw error;
    }
  },

  /**
   * 新增照服員
   * @param {Object} caregiverData - 照服員資料
   * @returns {Promise<Object>} 新增結果
   */
  async createCaregiver(caregiverData) {
    try {
      // 轉換前端資料格式為後端所需格式
      const requestDto = this.transformToRequestDto(caregiverData);
      
      const response = await caregiverApi.createCaregiver(requestDto);
      
      if (response.status === 201 && response.data.success) {
        return this.transformCaregiverData(response.data.data);
      }

      throw new Error(response.data.message || '新增照服員失敗');
    } catch (error) {
      console.error('新增照服員錯誤:', error);
      throw error;
    }
  },

  /**
   * 更新照服員資料
   * @param {number} id - 照服員 ID
   * @param {Object} caregiverData - 更新的照服員資料
   * @returns {Promise<Object>} 更新結果
   */
  async updateCaregiver(id, caregiverData) {
    try {
      const requestDto = this.transformToRequestDto(caregiverData);
      
      const response = await caregiverApi.updateCaregiver(id, requestDto);
      
      if (response.status === 200 && response.data.success) {
        return this.transformCaregiverData(response.data.data);
      }

      throw new Error(response.data.message || '更新照服員失敗');
    } catch (error) {
      console.error('更新照服員錯誤:', error);
      throw error;
    }
  },

  /**
 * 刪除照服員
 * @param {number} id - 照服員 ID
 * @returns {Promise<boolean>} 刪除結果
 */
async deleteCaregiver(id) {
  try {
    const response = await caregiverApi.deleteCaregiver(id);
    
    // 檢查回應狀態
    if (response.status === 200 || response.status === 204) {
      return true;
    }

    // 如果有自訂回傳內容，則使用回傳的 success 狀態
    if (response.data && response.data.success !== undefined) {
      return response.data.success;
    }

    return false;
  } catch (error) {
    // 處理錯誤情況
    const errorMsg = error.response ? 
      `錯誤 ${error.response.status}: ${error.response.data?.message || '未知錯誤'}` : 
      error.message || '無法連接到伺服器';
    
    console.error('刪除照服員錯誤:', errorMsg);
    throw new Error(errorMsg);
  }
},

  /**
   * 檢查電話號碼是否已存在
   * @param {string} phone - 電話號碼
   * @param {number|null} excludeId - 排除的照服員 ID
   * @returns {Promise<boolean>} 是否存在
   */
  async checkPhoneExists(phone, excludeId = null) {
    try {
      const response = await caregiverApi.checkPhoneExists(phone, excludeId);
      
      if (response.status === 200 && response.data.success) {
        return response.data.exists;
      }

      return false;
    } catch (error) {
      console.error('檢查電話號碼錯誤:', error);
      return false;
    }
  },

  /**
   * 轉換照服員列表資料格式
   * @param {Array} caregiverList - 原始照服員資料
   * @returns {Array} 轉換後的資料
   */
  transformCaregiverList(caregiverList) {
    return caregiverList.map(caregiver => this.transformCaregiverData(caregiver));
  },

  /**
   * 轉換單一照服員資料格式
   * @param {Object} caregiver - 原始照服員資料
   * @returns {Object} 轉換後的資料
   */
  transformCaregiverData(caregiver) {
    return {
      id: caregiver.caregiverId,
      chineseName: caregiver.chineseName,
      gender: caregiver.gender,
      genderDisplay: caregiver.gender ? '男' : '女',
      phone: caregiver.phone,
      email: caregiver.email,
      experienceYears: caregiver.experienceYears,
      // 確保照片路徑正確儲存
      photo: caregiver.photo,
      address: caregiver.address,
      serviceArea: caregiver.serviceArea,
      averageRating: caregiver.averageRating || 0,
      totalRatings: caregiver.totalRatings || 0,
      totalPoints: caregiver.totalPoints || 0,
      isActive: caregiver.isActive,
      statusDisplay: caregiver.isActive ? '在職' : '離職',
      createdAt: caregiver.createdAt,
      updatedAt: caregiver.updatedAt,
      // 格式化日期顯示
      createdAtDisplay: caregiver.createdAt ? new Date(caregiver.createdAt).toLocaleDateString('zh-TW') : '',
      updatedAtDisplay: caregiver.updatedAt ? new Date(caregiver.updatedAt).toLocaleDateString('zh-TW') : ''
    };
  },

  /**
   * 將前端資料轉換為後端 RequestDTO 格式
   * @param {Object} caregiverData - 前端照服員資料
   * @returns {Object} RequestDTO 格式的資料
   */
  transformToRequestDto(caregiverData) {
    return {
      chineseName: caregiverData.chineseName,
      gender: caregiverData.gender,
      phone: caregiverData.phone,
      email: caregiverData.email,
      experienceYears: parseInt(caregiverData.experienceYears) || 0,
      photo: caregiverData.photo || null,
      address: caregiverData.address || null,
      serviceArea: caregiverData.serviceArea || null,
      averageRating: caregiverData.averageRating || null,
      totalRatings: caregiverData.totalRatings || null,
      totalPoints: caregiverData.totalPoints || null,
      isActive: caregiverData.isActive !== undefined ? caregiverData.isActive : true
    };
  }
};