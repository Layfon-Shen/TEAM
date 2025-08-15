<template>
  <div class="card h-100 p-0 radius-12">
    <div class="card-body p-24">
      <div class="row justify-content-center">
        <div class="col-xxl-6 col-xl-8 col-lg-10">
          <div class="card border">
            <div class="card-header bg-base py-16 px-24 d-flex align-items-center justify-content-between border-bottom">
              <h6 class="text-lg font-weight-medium mb-0">編輯照服員資料</h6>
              <div v-if="loading" class="spinner-border spinner-border-sm text-primary" role="status">
                <span class="visually-hidden">載入中...</span>
              </div>
            </div>
            <div class="card-body">
              <!-- 載入中狀態 -->
              <div v-if="loading && !form.id" class="text-center py-5">
                <div class="spinner-border text-primary" role="status">
                  <span class="visually-hidden">載入中...</span>
                </div>
                <p class="mt-2">正在載入照服員資料...</p>
              </div>

              <!-- 錯誤訊息 -->
              <div v-else-if="error" class="alert alert-danger">
                <iconify-icon icon="akar-icons:circle-alert" class="me-2"></iconify-icon>
                {{ error }}
                <button class="btn btn-sm btn-outline-danger ms-2" @click="loadCaregiverData">重試</button>
              </div>

              <!-- 表單內容 -->
              <div v-else>
                <h6 class="text-md text-primary-light mb-16">照服員照片</h6>

                <!-- 上傳圖片區域 -->
                <div class="mb-24 mt-16">
                  <div class="avatar-upload">
                    <div class="avatar-edit position-absolute bottom-0 end-0 me-24 mt-16 z-1 cursor-pointer">
                      <input
                        type="file"
                        id="imageUpload"
                        accept=".png, .jpg, .jpeg"
                        @change="onImageChange"
                        hidden
                      />
                      <label
                        for="imageUpload"
                        class="w-32-px h-32-px d-flex justify-content-center align-items-center bg-primary-50 text-primary-600 border border-primary-600 bg-hover-primary-100 text-lg rounded-circle"
                      >
                        <iconify-icon icon="solar:camera-outline" class="icon"></iconify-icon>
                      </label>
                    </div>
                    <div class="avatar-preview">
                      <div
                        v-bind:style="{ backgroundImage: 'url(' + imagePreview + ')' }"
                        id="imagePreview"
                      ></div>
                    </div>
                  </div>
                </div>
                <!-- 上傳圖片區域結束 -->

                <form @submit.prevent="submitForm">
                  <!-- 照服員姓名 -->
                  <div class="mb-20">
                    <label for="chineseName" class="form-label fw-semibold text-primary-light text-sm mb-8">
                      中文姓名 <span class="text-danger-600">*</span>
                    </label>
                    <input
                      v-model="form.chineseName"
                      type="text"
                      class="form-control radius-8"
                      id="chineseName"
                      placeholder="請輸入中文姓名"
                      required
                    />
                  </div>

                  <!-- 性別 -->
                  <div class="mb-20">
                    <label class="form-label fw-semibold text-primary-light text-sm mb-8">
                      性別 <span class="text-danger-600">*</span>
                    </label>
                    <div class="d-flex gap-4">
                      <div class="form-check">
                        <input
                          class="form-check-input"
                          type="radio"
                          name="gender"
                          id="male"
                          :value="true"
                          v-model="form.gender"
                        />
                        <label class="form-check-label" for="male">男性</label>
                      </div>
                      <div class="form-check">
                        <input
                          class="form-check-input"
                          type="radio"
                          name="gender"
                          id="female"
                          :value="false"
                          v-model="form.gender"
                        />
                        <label class="form-check-label" for="female">女性</label>
                      </div>
                    </div>
                  </div>

                  <!-- 連絡電話 -->
                  <div class="mb-20">
                    <label for="phone" class="form-label fw-semibold text-primary-light text-sm mb-8">
                      連絡電話 <span class="text-danger-600">*</span>
                    </label>
                    <input
                      v-model="form.phone"
                      type="text"
                      class="form-control radius-8"
                      id="phone"
                      placeholder="請輸入連絡電話"
                      required
                      @blur="checkPhoneExists"
                    />
                    <small v-if="phoneExists" class="text-danger">此電話號碼已存在，請確認</small>
                  </div>

                  <!-- 電子郵件 -->
                  <div class="mb-20">
                    <label for="email" class="form-label fw-semibold text-primary-light text-sm mb-8">
                      電子信箱 <span class="text-danger-600">*</span>
                    </label>
                    <input
                      v-model="form.email"
                      type="email"
                      class="form-control radius-8"
                      id="email"
                      placeholder="請輸入電子信箱"
                      required
                    />
                  </div>

                  <!-- 服務年資 -->
                  <div class="mb-20">
                    <label for="experienceYears" class="form-label fw-semibold text-primary-light text-sm mb-8">
                      服務年資 <span class="text-danger-600">*</span>
                    </label>
                    <input
                      v-model="form.experienceYears"
                      type="number"
                      min="0"
                      class="form-control radius-8"
                      id="experienceYears"
                      placeholder="請輸入服務年資"
                      required
                    />
                  </div>

                  <!-- 居住地址 -->
                  <div class="mb-20">
                    <label for="address" class="form-label fw-semibold text-primary-light text-sm mb-8">
                      居住地址 <span class="text-danger-600">*</span>
                    </label>
                    <input
                      v-model="form.address"
                      type="text"
                      class="form-control radius-8"
                      id="address"
                      placeholder="請輸入居住地址"
                      required
                    />
                  </div>

                  <!-- 服務區域 -->
                  <div class="mb-20">
                    <label for="serviceArea" class="form-label fw-semibold text-primary-light text-sm mb-8">
                      服務區域 <span class="text-danger-600">*</span>
                    </label>
                    <select v-model="form.serviceArea" class="form-control radius-8 form-select" id="serviceArea" required>
                      <option value="">請選擇服務區域</option>
                      <option v-for="area in serviceAreas" :key="area" :value="area">{{ area }}</option>
                    </select>
                  </div>

                  <!-- 在職狀態 -->
                  <div class="mb-20">
                    <label class="form-label fw-semibold text-primary-light text-sm mb-8">
                      在職狀態 <span class="text-danger-600">*</span>
                    </label>
                    <div class="d-flex gap-4">
                      <div class="form-check">
                        <input
                          class="form-check-input"
                          type="radio"
                          name="isActive"
                          id="active"
                          :value="true"
                          v-model="form.isActive"
                        />
                        <label class="form-check-label" for="active">在職</label>
                      </div>
                      <div class="form-check">
                        <input
                          class="form-check-input"
                          type="radio"
                          name="isActive"
                          id="inactive"
                          :value="false"
                          v-model="form.isActive"
                        />
                        <label class="form-check-label" for="inactive">離職</label>
                      </div>
                    </div>
                  </div>

                  <!-- 表單按鈕 -->
                  <div class="d-flex align-items-center justify-content-center gap-3">
                    <button
                      type="button"
                      class="border border-danger-600 bg-hover-danger-200 text-danger-600 text-md px-56 py-11 radius-8"
                      @click="cancelForm"
                    >
                      取消
                    </button>
                    <button
                      type="submit"
                      class="btn btn-primary border border-primary-600 text-md px-56 py-12 radius-8"
                      :disabled="isSubmitting || phoneExists"
                    >
                      {{ isSubmitting ? '儲存中...' : '儲存' }}
                    </button>
                  </div>
                </form>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { ref, reactive, onMounted, watch } from 'vue';
import { useRouter, useRoute } from 'vue-router';
import defaultUserImage from "@/assets/images/user-grid/user-grid-img13.png";
import { caregiverApi } from '@/api/caregiverApi';
import { useCaregivers } from '@/composables/useCaregivers';
import { useToast } from '@/composables/useToast'; // 引入 toast 元件

const { showToast } = useToast(); // 使用 Toast 通知功能
// 處理照片 URL 的工具函數
const getPhotoUrl = (photoPath) => {
  console.log('編輯頁照片路徑原始值:', photoPath);
  
  if (!photoPath) {
    return defaultUserImage;
  }
  
  // 如果是完整的 URL
  if (photoPath.startsWith('http://') || photoPath.startsWith('https://')) {
    return photoPath;
  }
  
  // 如果是 Base64 編碼的圖片數據
  if (photoPath.startsWith('data:image')) {
    return photoPath;
  }
  
  // 如果是相對路徑，轉為絕對路徑
  const fullPath = `http://localhost:8080${photoPath.startsWith('/') ? '' : '/'}${photoPath}`;
  console.log('轉換為完整路徑:', fullPath);
  return fullPath;
};

export default {
  name: 'EditCareWorker',
  props: {
    caregiverId: {
      type: [String, Number],
      required: false
    }
  },
  setup(props) {
    const router = useRouter();
    const route = useRoute();
    const { loadCaregiverById, updateCaregiver } = useCaregivers();
    
    // 從 props 或路由參數獲取照服員ID
    const caregiverId = ref(props.caregiverId || route.params.id);
    
    // 開發階段日誌，方便排除問題
    console.log('組件參數 props:', props);
    console.log('路由參數:', route.params);
    console.log('使用的照服員ID:', caregiverId.value);
    
    // 表單資料
    const form = reactive({
      id: null,
      chineseName: '',
      gender: false, // 預設女性
      phone: '',
      email: '',
      experienceYears: null,
      photo: '',
      address: '',
      serviceArea: '',
      isActive: true
    });

    // 預設圖片和上傳的檔案
    const imagePreview = ref(defaultUserImage);
    const uploadFile = ref(null);
    const isSubmitting = ref(false);
    const phoneExists = ref(false);
    const loading = ref(false);
    const error = ref(null);

    // 服務區域選項
    const serviceAreas = [
      '台北市', '新北市', '桃園市', '台中市', '台南市', '高雄市', 
      '基隆市', '新竹市', '新竹縣', '苗栗縣', '彰化縣', '南投縣', 
      '雲林縣', '嘉義市', '嘉義縣', '屏東縣', '宜蘭縣', '花蓮縣', 
      '台東縣', '澎湖縣', '金門縣', '連江縣'
    ];

    // 載入照服員資料
    const loadCaregiverData = async () => {
      // 檢查是否有照服員ID
      if (!caregiverId.value) {
        error.value = '未提供照服員ID，無法載入資料';
        console.error('未提供照服員ID，無法載入資料');
        return;
      }
      
      loading.value = true;
      error.value = null;
      
      try {
        console.log('開始載入照服員資料，ID:', caregiverId.value);
        const caregiverData = await loadCaregiverById(caregiverId.value);
        console.log('成功獲取照服員資料:', caregiverData);
        
        if (!caregiverData) {
          throw new Error('未找到照服員資料');
        }
        
        // 填充表單資料
        Object.keys(form).forEach(key => {
          if (key in caregiverData) {
            form[key] = caregiverData[key];
          }
        });
        
        // 確保ID正確設置
        form.id = caregiverId.value;
        
        // 設置圖片預覽
        if (caregiverData.photo) {
          // 處理照片路徑
          imagePreview.value = getPhotoUrl(caregiverData.photo);
          console.log('設置圖片預覽路徑:', imagePreview.value);
        }
      } catch (err) {
        error.value = err.message || '載入照服員資料失敗';
        console.error('載入照服員資料時發生錯誤:', err);
      } finally {
        loading.value = false;
      }
    };

    // 處理圖片上傳
    const onImageChange = (event) => {
      const file = event.target.files[0];
      if (file) {
        uploadFile.value = file;
        const reader = new FileReader();
        reader.onload = (e) => {
          imagePreview.value = e.target.result;
        };
        reader.readAsDataURL(file);
      }
    };

    // 檢查電話是否已存在 (排除自己)
    const checkPhoneExists = async () => {
      if (!form.phone) return;
      
      try {
        const response = await caregiverApi.checkPhoneExists(form.phone, form.id);
        phoneExists.value = response.data.exists;
      } catch (error) {
        console.error('檢查電話號碼時發生錯誤:', error);
      }
    };

    // 取消表單
    const cancelForm = () => {
      // 返回照服員列表頁面
      router.push('/caregiver/list');
    };

    // 提交表單
    const submitForm = async () => {
      if (!form.id) {
        alert('照服員ID不存在，無法更新資料');
        return;
      }
      
      isSubmitting.value = true;
      console.log('開始更新照服員資料:', form);
      
      try {
        // 確保使用正確的ID
        const caregiverId = parseInt(form.id) || parseInt(route.params.id);
        if (!caregiverId) {
          throw new Error('無效的照服員ID');
        }
        
        // 更新照服員資料
        const updatedCaregiver = await updateCaregiver(caregiverId, form);
        console.log('更新成功:', updatedCaregiver);
        
        // 如果有上傳照片，執行上傳
        if (uploadFile.value) {
          try {
            console.log('開始上傳照片，檔案大小:', uploadFile.value.size, '檔案類型:', uploadFile.value.type);
            const photoResponse = await caregiverApi.uploadPhoto(caregiverId, uploadFile.value);
            console.log('照片上傳成功，回應數據:', photoResponse);
            
            // 提取照片路徑（這裡可能需要根據後端 API 的實際回傳格式調整）
            if (photoResponse && photoResponse.data) {
              console.log('照片上傳回應:', photoResponse.data);
              if (photoResponse.data.photo || photoResponse.data.path || photoResponse.data.url) {
                const photoPath = photoResponse.data.photo || photoResponse.data.path || photoResponse.data.url;
                console.log('獲取的照片路徑:', photoPath);
                form.photo = photoPath;
              }
            }
            
            // 確保獲取最新資料，包含更新後的照片路徑
            const refreshedData = await loadCaregiverById(caregiverId);
            console.log('更新照片後重新載入的照服員資料:', refreshedData);
            
            // 強制更新照片預覽
            if (refreshedData && refreshedData.photo) {
              imagePreview.value = getPhotoUrl(refreshedData.photo);
              console.log('更新後的照片預覽路徑:', imagePreview.value);
            }
          } catch (photoError) {
            console.error('照片上傳失敗:', photoError);
            alert('照服員資料已更新，但照片上傳失敗，請再試一次。');
          }
        }
        
        showToast({
          title: '更新成功',
          message: `更新照服員: ${form.chineseName} 資料`,
          type: 'success'
        });
        router.push('/caregiver/list');
      } catch (error) {
        showToast({
          title: '更新失敗 !',
          message: error.message,
          type: 'error'
        });
      } finally {
        isSubmitting.value = false;
      }
    };

    // 監聽 ID 變更
    watch(caregiverId, (newId) => {
      if (newId) {
        console.log('照服員ID變更，重新載入資料:', newId);
        loadCaregiverData();
      }
    });

    // 組件掛載時載入資料
    onMounted(() => {
      // 確保有路由參數時才載入資料
      if (caregiverId.value) {
        console.log('組件掛載時載入照服員資料, ID:', caregiverId.value);
        loadCaregiverData();
      } else {
        console.error('缺少照服員ID參數，無法載入資料');
        error.value = '缺少照服員ID參數，請從列表頁面選擇照服員進行編輯';
      }
    });

    return {
      form,
      imagePreview,
      serviceAreas,
      phoneExists,
      isSubmitting,
      loading,
      error,
      onImageChange,
      checkPhoneExists,
      cancelForm,
      submitForm,
      loadCaregiverData
    };
  }
};
</script>

<style scoped>
.avatar-upload {
  position: relative;
  max-width: 205px;
  margin: 0 auto;
}

.avatar-preview {
  width: 192px;
  height: 192px;
  position: relative;
  border-radius: 100%;
  overflow: hidden;
  border: 2px solid #ccc;
  margin: 0 auto;
}

.avatar-preview > div {
  width: 100%;
  height: 100%;
  background-size: cover;
  background-repeat: no-repeat;
  background-position: center;
}
</style>
