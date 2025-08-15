<template>
  <div class="card h-100 p-0 radius-12">
    <div class="card-body p-24">
      <div class="row justify-content-center">
        <div class="col-xxl-6 col-xl-8 col-lg-10">
          <div class="card border">
            <div class="card-body">
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
</template>

<script>
import { ref, reactive } from 'vue';
import { useRouter } from 'vue-router';
import defaultUserImage from "@/assets/images/user-grid/user-grid-img13.png";
import { caregiverApi } from '@/api/caregiverApi';
import { useCaregivers } from '@/composables/useCaregivers';
import { useToast } from '@/composables/useToast'; // 引入 toast 元件
export default {
  name: 'AddCareWorker',
  setup() {
    const router = useRouter();
    const { createCaregiver } = useCaregivers();
    
    const { showToast } = useToast(); // 使用 Toast 通知功能
    // 表單資料
    const form = reactive({
      chineseName: '',
      gender: false, // 預設女性
      phone: '',
      email: '',
      experienceYears: null,
      photo: '',
      address: '',
      serviceArea: ''
    });

    // 預設圖片和上傳的檔案
    const imagePreview = ref(defaultUserImage);
    const uploadFile = ref(null);
    const isSubmitting = ref(false);
    const phoneExists = ref(false);

    // 服務區域選項
    const serviceAreas = [
      '台北市', '新北市', '桃園市', '台中市', '台南市', '高雄市', 
      '基隆市', '新竹市', '新竹縣', '苗栗縣', '彰化縣', '南投縣', 
      '雲林縣', '嘉義市', '嘉義縣', '屏東縣', '宜蘭縣', '花蓮縣', 
      '台東縣', '澎湖縣', '金門縣', '連江縣'
    ];

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

    // 檢查電話是否已存在
    const checkPhoneExists = async () => {
      if (!form.phone) return;
      
      try {
        const response = await caregiverApi.checkPhoneExists(form.phone);
        phoneExists.value = response.data.exists;
      } catch (error) {
        console.error('檢查電話號碼時發生錯誤:', error);
      }
    };

    // 取消表單
    const cancelForm = () => {
      Object.keys(form).forEach(key => {
        if (key === 'gender') {
          form[key] = false;
        } else if (key === 'experienceYears') {
          form[key] = null;
        } else {
          form[key] = '';
        }
      });
      imagePreview.value = defaultUserImage;
      uploadFile.value = null;
      phoneExists.value = false;
      
      // 返回照服員列表頁面
      router.push('/caregiver/list');
    };

    // 提交表單
    const submitForm = async () => {
      isSubmitting.value = true;
      
      try {
        // 先創建照服員
        const newCaregiver = await createCaregiver(form);
        
        // 如果有上傳照片，執行上傳
        if (uploadFile.value && newCaregiver && newCaregiver.id) {
          await caregiverApi.uploadPhoto(newCaregiver.id, uploadFile.value);
        }
        
        // 提示成功並返回列表頁
        showToast({
          title: '新增成功',
          message: `新增照服員: ${newCaregiver.chineseName}`,
          type: 'success'
        });
        router.push('/caregiver/list');
      } catch (error) {
        showToast({
          title: '新增失敗 !',
          message: error.message,
          type: 'error'
        });
      } finally {
        isSubmitting.value = false;
      }
    };

    return {
      form,
      imagePreview,
      serviceAreas,
      phoneExists,
      isSubmitting,
      onImageChange,
      checkPhoneExists,
      cancelForm,
      submitForm
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
