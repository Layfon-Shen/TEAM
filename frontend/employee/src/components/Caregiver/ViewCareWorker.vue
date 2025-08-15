<template>
  <div class="row gy-4">
    <!-- 左側個人資料卡片 -->
    <div class="col-lg-5">
      <div class="user-grid-card position-relative border radius-16 overflow-hidden bg-base h-100">
        <img src="@/assets/images/user-grid/user-grid-bg1.png" alt="" class="w-100 object-fit-cover" />
        <div class="pb-24 ms-16 mb-24 me-16 mt--100">
          <div class="text-center border border-top-0 border-start-0 border-end-0">
            <!-- 照服員照片 -->
            <img :src="getPhotoUrl(caregiver.photo)" alt=""
              class="border br-white border-width-2-px w-200-px h-200-px rounded-circle object-fit-cover"
            />
            <h6 class="mb-0 mt-16">{{ caregiver.chineseName }}</h6>
            <span class="text-secondary-light mb-16 d-block text-break">{{ caregiver.email }}</span>
          </div>
          <div class="mt-24">
            <h6 class="text-xl mb-16">照服員資訊</h6>
            <ul class="px-0">
              <li class="d-flex align-items-center gap-1 mb-12">
                <span class="w-30 text-md fw-semibold text-primary-light">姓名</span>
                <span class="w-70 text-secondary-light fw-medium">: {{ caregiver.chineseName }}</span>
              </li>
              <li class="d-flex align-items-center gap-1 mb-12">
                <span class="w-30 text-md fw-semibold text-primary-light">電子信箱</span>
                <span class="w-70 text-secondary-light fw-medium text-break">: {{ caregiver.email || '未提供' }}</span>
              </li>
              <li class="d-flex align-items-center gap-1 mb-12">
                <span class="w-30 text-md fw-semibold text-primary-light">連絡電話</span>
                <span class="w-70 text-secondary-light fw-medium">: {{ caregiver.phone }}</span>
              </li>
              <li class="d-flex align-items-center gap-1 mb-12">
                <span class="w-30 text-md fw-semibold text-primary-light">性別</span>
                <span class="w-70 text-secondary-light fw-medium">: {{ caregiver.genderDisplay }}</span>
              </li>
              <li class="d-flex align-items-center gap-1 mb-12">
                <span class="w-30 text-md fw-semibold text-primary-light">服務區域</span>
                <span class="w-70 text-secondary-light fw-medium">: {{ caregiver.serviceArea || '未提供' }}</span>
              </li>
              <li class="d-flex align-items-center gap-1 mb-12">
                <span class="w-30 text-md fw-semibold text-primary-light">服務年資</span>
                <span class="w-70 text-secondary-light fw-medium">: {{ caregiver.experienceYears }} 年</span>
              </li>
              <li class="d-flex align-items-center gap-1 mb-12">
                <span class="w-30 text-md fw-semibold text-primary-light">狀態</span>
                <span class="w-70 text-secondary-light fw-medium">: {{ caregiver.statusDisplay }}</span>
              </li>
              <li class="d-flex align-items-center gap-1">
                <span class="w-30 text-md fw-semibold text-primary-light">居住地址</span>
                <span class="w-70 text-secondary-light fw-medium">: {{ caregiver.address || '未提供' }}</span>
              </li>
            </ul>
          </div>
        </div>
      </div>
    </div>

    <!-- 右側面板 -->
    <div class="col-lg-7">
      <div class="card h-100">
        <div class="card-body p-24">
          <!-- 標籤頁 -->
          <ul class="nav border-gradient-tab nav-pills mb-20 d-inline-flex" role="tablist">
            <li class="nav-item" role="presentation">
              <button class="nav-link d-flex align-items-center px-24" :class="{ active: activeTab === 'basic-info' }" @click="activeTab = 'basic-info'">
                基本資訊
              </button>
            </li>
            <li class="nav-item" role="presentation">
              <button class="nav-link d-flex align-items-center px-24" :class="{ active: activeTab === 'service-history' }" @click="activeTab = 'service-history'">
                服務紀錄
              </button>
            </li>
            <li class="nav-item" role="presentation">
              <button class="nav-link d-flex align-items-center px-24" :class="{ active: activeTab === 'ratings' }" @click="activeTab = 'ratings'">
                評價統計
              </button>
            </li>
          </ul>

          <!-- 標籤內容 -->
          <div class="tab-content">
            <!-- 基本資訊標籤 -->
            <div v-if="activeTab === 'basic-info'">
              <div class="row">
                <div class="col-md-6 mb-20">
                  <div class="border radius-8 p-20">
                    <h6 class="text-primary-light mb-16">個人資訊</h6>
                    <ul class="list-unstyled">
                      <li class="mb-12">
                        <span class="fw-semibold">建立時間：</span>
                        <span>{{ caregiver.createdAtDisplay }}</span>
                      </li>
                      <li class="mb-12">
                        <span class="fw-semibold">最後更新：</span>
                        <span>{{ caregiver.updatedAtDisplay }}</span>
                      </li>
                      <li>
                        <span class="fw-semibold">帳號狀態：</span>
                        <span :class="caregiver.isActive ? 'text-success' : 'text-danger'">
                          {{ caregiver.statusDisplay }}
                        </span>
                      </li>
                    </ul>
                  </div>
                </div>
                
                <div class="col-md-6 mb-20">
                  <div class="border radius-8 p-20">
                    <h6 class="text-primary-light mb-16">評價資訊</h6>
                    <ul class="list-unstyled">
                      <li class="mb-12">
                        <span class="fw-semibold">平均評分：</span>
                        <span>
                          <div class="d-inline-flex align-items-center">
                            <span class="me-8">{{ caregiver.averageRating }}</span>
                            <div>
                              <iconify-icon icon="solar:star-bold" class="text-warning-500" v-for="n in Math.floor(caregiver.averageRating || 0)" :key="n" />
                              <iconify-icon icon="solar:star-outline" class="text-secondary-light" v-for="n in (5 - Math.floor(caregiver.averageRating || 0))" :key="n + 5" />
                            </div>
                          </div>
                        </span>
                      </li>
                      <li class="mb-12">
                        <span class="fw-semibold">評價次數：</span>
                        <span>{{ caregiver.totalRatings }} 次</span>
                      </li>
                      <li>
                        <span class="fw-semibold">總積分：</span>
                        <span>{{ caregiver.totalPoints }} 分</span>
                      </li>
                    </ul>
                  </div>
                </div>
              </div>

              <!-- 操作按鈕 -->
              <div class="d-flex align-items-center justify-content-center gap-3 mt-20">
                <button type="button" @click="goBack" class="border border-danger-600 bg-hover-danger-200 text-danger-600 text-md px-56 py-11 radius-8">返回</button>
                <button type="button" @click="goToEdit" class="btn btn-primary border border-primary-600 text-md px-56 py-12 radius-8">編輯</button>
              </div>
            </div>

            <!-- 服務紀錄標籤 -->
            <div v-if="activeTab === 'service-history'">
              <div class="alert alert-info radius-8 mb-20">
                服務紀錄功能尚在開發中...
              </div>
              
              <!-- 服務紀錄示意 -->
              <div class="border radius-8 p-20 mb-20">
                <h6 class="text-primary-light mb-16">服務統計資訊</h6>
                <div class="row">
                  <div class="col-md-4 mb-16">
                    <div class="d-flex flex-column align-items-center p-16 border radius-8">
                      <h6 class="text-secondary-light">總服務次數</h6>
                      <h2 class="text-primary-600 mb-0">0</h2>
                    </div>
                  </div>
                  <div class="col-md-4 mb-16">
                    <div class="d-flex flex-column align-items-center p-16 border radius-8">
                      <h6 class="text-secondary-light">總服務時數</h6>
                      <h2 class="text-primary-600 mb-0">0</h2>
                    </div>
                  </div>
                  <div class="col-md-4 mb-16">
                    <div class="d-flex flex-column align-items-center p-16 border radius-8">
                      <h6 class="text-secondary-light">完成率</h6>
                      <h2 class="text-primary-600 mb-0">0%</h2>
                    </div>
                  </div>
                </div>
              </div>
            </div>

            <!-- 評價統計標籤 -->
            <div v-if="activeTab === 'ratings'">
              <div class="alert alert-info radius-8 mb-20">
                評價統計功能尚在開發中...
              </div>
              
              <!-- 評價統計示意 -->
              <div class="border radius-8 p-20 mb-20">
                <h6 class="text-primary-light mb-16">評價分布</h6>
                <div class="mb-16" v-for="i in 5" :key="i">
                  <div class="d-flex align-items-center mb-8">
                    <span class="me-16 text-nowrap">{{ 6 - i }} 星</span>
                    <div class="progress w-100 bg-gray-50 radius-pill overflow-hidden" style="height: 8px;">
                      <div class="progress-bar bg-warning-500" :style="{ width: i === 3 ? '60%' : i === 4 ? '30%' : i === 5 ? '10%' : '0%' }"></div>
                    </div>
                    <span class="ms-16 text-nowrap">{{ i === 3 ? '60%' : i === 4 ? '30%' : i === 5 ? '10%' : '0%' }}</span>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { ref, reactive, onMounted } from 'vue';
import { useCaregivers } from '@/composables/useCaregivers.js';
import { useRouter, useRoute } from 'vue-router';
import defaultUserImage from "@/assets/images/user-grid/user-grid-img14.png";

export default {
  name: "ViewCareWorker",
  props: {
    caregiverId: {
      type: [String, Number],
      required: true
    }
  },
  setup(props) {
    // 使用照服員資料 composable
    const { loadCaregiverById, loading, error } = useCaregivers();
    
    // 設定路由
    const router = useRouter();
    const route = useRoute();

    // 設定狀態
    const activeTab = ref('basic-info');
    const caregiver = reactive({
      id: null,
      chineseName: '',
      gender: true,
      genderDisplay: '男',
      phone: '',
      email: '',
      experienceYears: 0,
      photo: null,
      address: '',
      serviceArea: '',
      averageRating: 0,
      totalRatings: 0,
      totalPoints: 0,
      isActive: true,
      statusDisplay: '在職',
      createdAt: null,
      updatedAt: null,
      createdAtDisplay: '',
      updatedAtDisplay: ''
    });

    // 載入照服員資料
    const loadCaregiverData = async () => {
      try {
        // 載入照服員詳細資料
        const data = await loadCaregiverById(props.caregiverId);
        
        // 更新本地資料
        Object.assign(caregiver, data);
      } catch (err) {
        console.error('載入照服員詳細資料失敗:', err);
      }
    };

    // 返回列表
    const goBack = () => {
      router.push('/caregiver/list');
    };

    // 前往編輯頁面
    const goToEdit = () => {
      router.push(`/care-worker/edit/${caregiver.id}`);
    };

    // 處理照片 URL
    const getPhotoUrl = (photoPath) => {
      console.log('照片路徑原始值:', photoPath);
      
      if (!photoPath) {
        console.log('沒有照片路徑，使用預設圖片');
        return defaultUserImage;
      }
      
      // 如果是完整的 URL（以 http:// 或 https:// 開頭）
      if (photoPath.startsWith('http://') || photoPath.startsWith('https://')) {
        console.log('使用完整 URL:', photoPath);
        return photoPath;
      }
      
      // 如果是相對路徑（後端可能返回的是相對路徑），轉為絕對路徑
      const fullPath = `http://localhost:8080${photoPath.startsWith('/') ? '' : '/'}${photoPath}`;
      console.log('轉換為完整路徑:', fullPath);
      return fullPath;
    };

    // 組件載入時抓取資料
    onMounted(() => {
      loadCaregiverData();
    });

    return {
      activeTab,
      caregiver,
      loading,
      error,
      goBack,
      goToEdit,
      getPhotoUrl
    };
  }
};
</script>
