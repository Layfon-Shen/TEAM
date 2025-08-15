import { ref, computed } from 'vue';
import deviceService from '@/services/deviceService';

// 全域狀態
const devices = ref([]);
const isLoading = ref(false);
const error = ref(null);
const lastFetchTime = ref(null);

// 快取時間（毫秒）- 直接在檔案中定義
const CACHE_DURATION = 5 * 60 * 1000; // 5分鐘

export default function useDevices() {
  // 獲取所有輔具，具有快取功能
  const fetchDevices = async (forceRefresh = false) => {
    // 檢查是否需要重新獲取資料
    const shouldRefresh = forceRefresh || 
                          !lastFetchTime.value || 
                          (Date.now() - lastFetchTime.value > CACHE_DURATION);
    
    if (shouldRefresh) {
      isLoading.value = true;
      error.value = null;
      
      try {
        devices.value = await deviceService.getAllDevices();
        lastFetchTime.value = Date.now();
      } catch (err) {
        error.value = '無法獲取輔具資料，請稍後再試';
        console.error(error.value, err);
      } finally {
        isLoading.value = false;
      }
    }
    
    return devices.value;
  };
  
  // 獲取單一輔具
  const getDeviceById = (id) => {
    return devices.value.find(device => device.id === id);
  };
  
  // 低庫存輔具
  const lowStockDevices = computed(() => {
    return devices.value.filter(device => deviceService.checkLowInventory(device));
  });
  
  // 上架中輔具
  const onlineDevices = computed(() => {
    return devices.value.filter(device => device.isOnline);
  });
  
  // 未上架輔具
  const offlineDevices = computed(() => {
    return devices.value.filter(device => !device.isOnline);
  });

  // 匯出CSV功能
  const exportDevicesCSV = () => {
    try {
      const csvContent = deviceService.convertToCSV(devices.value);
      return csvContent;
    } catch (err) {
      error.value = '匯出CSV失敗，請稍後再試';
      console.error(error.value, err);
      throw err;
    }
  };
  
  // 批次更新輔具狀態
  const batchUpdateDeviceStatus = async (deviceIds, newStatus) => {
    isLoading.value = true;
    error.value = null;
    try {
      await deviceService.batchUpdateDeviceStatus(deviceIds, newStatus);
      // 更新成功後重新獲取最新資料
      await fetchDevices(true);
      return true;
    } catch (err) {
      error.value = '批次更新輔具狀態失敗，請稍後再試';
      console.error(error.value, err);
      throw err;
    } finally {
      isLoading.value = false;
    }
  };
  
  // 批次修改輔具屬性
  const batchUpdateDeviceProperty = async (deviceIds, propertyName, propertyValue, preProcessedDevices = null) => {
    isLoading.value = true;
    error.value = null;
    try {
      let updatedDevices;
      
      // 如果已經提供了處理好的裝置列表，直接使用
      if (preProcessedDevices) {
        updatedDevices = preProcessedDevices;
      } else {
        // 獲取要更新的輔具
        const devicesToUpdate = devices.value.filter(device => deviceIds.includes(device.id));
        // 為每個輔具更新指定屬性
        updatedDevices = devicesToUpdate.map(device => ({
          ...device,
          [propertyName]: propertyValue
        }));
      }
      
      // 批次更新
      await deviceService.batchUpdateDevices(updatedDevices);
      // 更新成功後重新獲取最新資料
      await fetchDevices(true);
      return true;
    } catch (err) {
      const fieldName = propertyName || '資料';
      error.value = `批次修改輔具${fieldName}失敗，請稍後再試`;
      console.error(error.value, err);
      throw err;
    } finally {
      isLoading.value = false;
    }
  };
  
  // 批次刪除輔具
  const batchDeleteDevices = async (deviceIds) => {
    isLoading.value = true;
    error.value = null;
    try {
      await deviceService.batchDeleteDevices(deviceIds);
      // 更新成功後重新獲取最新資料
      await fetchDevices(true);
      return true;
    } catch (err) {
      error.value = '批次刪除輔具失敗，請稍後再試';
      console.error(error.value, err);
      throw err;
    } finally {
      isLoading.value = false;
    }
  };
  
  return {
    devices,
    isLoading,
    error,
    fetchDevices,
    getDeviceById,
    lowStockDevices,
    onlineDevices,
    offlineDevices,
    exportDevicesCSV,
    batchUpdateDeviceStatus,
    batchUpdateDeviceProperty,
    batchDeleteDevices
  };
}