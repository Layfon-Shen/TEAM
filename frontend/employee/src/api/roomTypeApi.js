// src/api/roomTypeApi.js
import axios from 'axios';

const apiClient = axios.create({
  baseURL: 'http://localhost:8080/api/room-types',
  headers: {
    'Content-Type': 'application/json',
  },
});

export const roomTypeApi = {
  getAllRoomTypes() {
    return apiClient.get('');
  },

  getRoomTypeById(id) {
    return apiClient.get(`/${id}`);
  },

  getByDescription(keyword) {
    return apiClient.get('/search', {
      params: { keyword },
    });
  },

  getByPriceRange(min, max) {
    return apiClient.get('/price-range', {
      params: { min, max },
    });
  },

  getByCapacity(capacity) {
    return apiClient.get('/capacity', {
      params: { capacity },
    });
  },

  addRoomType(room) {
    return apiClient.post('', room);
  },

  updateRoomType(room) {
    return apiClient.put('/', room); // ✅ 不要帶 ID
  },

  deleteRoomType(id) {
    return apiClient.delete(`/${id}`);
  },

  patchRoomType(id, updates) {
    return apiClient.patch(`/${id}`, updates);
  },
};
