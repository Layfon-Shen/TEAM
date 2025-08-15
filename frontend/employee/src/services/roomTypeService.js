import { roomTypeApi } from '../api/roomTypeApi';
import axios from 'axios'; // 如果還沒引入

const apiClient = axios.create({
  baseURL: 'http://localhost:8080/api/room-types',
  headers: {
    'Content-Type': 'application/json',
  },
});

function transformRoom(room) {
  // 取得 image_url 或 image_path
  let img = room.image_url || room.image_path || '';
  // 若有值且不是以 / 開頭，自動補上 /
  if (img && !img.startsWith('/')) {
    img = 'http://localhost:8080/' + img;
  }
  return {
    id: room.id,
    name: room.name || '未命名',
    price: room.price,
    capacity: room.capacity,
    description: room.description || '無描述',
    imagePath: img,
    isAvailable: room.is_available,
    adminNote: room.admin_note || '',
    createdAt: new Date(room.created_at).toLocaleDateString('zh-TW'),
    updatedAt: room.updated_at
      ? new Date(room.updated_at).toLocaleDateString('zh-TW')
      : '未更新',
    special_features: room.special_features || '', // ★ 加這一行
  };
}

function handleError(error, action) {
  const errorMsg = error.response
    ? `錯誤 ${error.response.status}: ${error.response.data.message || '未知錯誤'}`
    : error.message || '無法連接到伺服器';
  console.error(`${action} 失敗:`, errorMsg);
  throw new Error(errorMsg);
}

export const roomTypeService = {
  async getAllRoomTypes() {
    try {
      const res = await roomTypeApi.getAllRoomTypes();
      if (res.status === 200) {
        return res.data.map(transformRoom);
      }
      throw new Error(`伺服器回應錯誤：${res.status}`);
    } catch (e) {
      handleError(e, '獲取房型清單');
    }
  },

  async getRoomTypeById(id) {
    try {
      const res = await roomTypeApi.getRoomTypeById(id);
      if (res.status === 200) {
        return transformRoom(res.data);
      }
      throw new Error(`伺服器回應錯誤：${res.status}`);
    } catch (e) {
      handleError(e, `獲取房型 ID ${id}`);
    }
  },

  async getRoomTypesByDescription(keyword) {
    try {
      const res = await roomTypeApi.getByDescription(keyword);
      if (res.status === 200) {
        return res.data.map(transformRoom);
      }
      throw new Error(`伺服器回應錯誤：${res.status}`);
    } catch (e) {
      handleError(e, `描述模糊查詢 (${keyword})`);
    }
  },

  async getRoomTypesByPriceRange(min, max) {
    try {
      const res = await roomTypeApi.getByPriceRange(min, max);
      if (res.status === 200) {
        return res.data.map(transformRoom);
      }
      throw new Error(`伺服器回應錯誤：${res.status}`);
    } catch (e) {
      handleError(e, `價格區間查詢 (${min}~${max})`);
    }
  },

  async getRoomTypesByCapacity(capacity) {
    try {
      const res = await roomTypeApi.getByCapacity(capacity);
      if (res.status === 200) {
        return res.data.map(transformRoom);
      }
      throw new Error(`伺服器回應錯誤：${res.status}`);
    } catch (e) {
      handleError(e, `容量查詢 (${capacity})`);
    }
  },

  async addRoomType(roomData) {
    try {
      const res = await roomTypeApi.addRoomType(roomData);
      if (res.status === 200 || res.status === 201) {
        return res.data; // 回傳新增的 ID
      }
      throw new Error(`伺服器回應錯誤：${res.status}`);
    } catch (e) {
      handleError(e, '新增房型');
    }
  },

  async updateRoomType(payload) {
    try {
      const res = await roomTypeApi.updateRoomType(payload);
      if (res.status === 200) {
        return res.data; // true/false
      }
      throw new Error(`伺服器回應錯誤：${res.status}`);
    } catch (e) {
      handleError(e, `修改房型 ID ${payload.id}`);
    }
  },

  async deleteRoomType(id) {
    try {
      const res = await roomTypeApi.deleteRoomType(id);
      return res.data; // 後端回傳 true/false
    } catch (e) {
      handleError(e, `刪除房型 ID ${id}`);
      return false;
    }
  },

  async uploadImage(file) {
    const formData = new FormData();
    formData.append('file', file);
    const res = await axios.post('/api/upload', formData, {
      headers: { 'Content-Type': 'multipart/form-data' }
    });
    return res.data.url; // 後端需回傳圖片網址
  },

  async patchRoomType(id, updates) {
    try {
      const res = await roomTypeApi.patchRoomType(id, updates);
      if (res.status === 200) {
        return res.data;
      }
      throw new Error(`伺服器回應錯誤：${res.status}`);
    } catch (e) {
      handleError(e, `修改房型 ID ${id}`);
    }
  },
};


