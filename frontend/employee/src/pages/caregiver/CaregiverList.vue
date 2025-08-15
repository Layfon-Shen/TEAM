<template>
  <div class="dashboard-main-body">
    <!-- 麵包屑導航 -->
    <Breadcrumb title="照服員列表" :breadcrumbs="[
      { name: '照服員管理' },
      { name: '照服員列表' }
    ]" />

    <!-- 引入照服員表格元件 -->
    <CaregiverTable
      :careWorkers="caregivers"
      :loading="isLoading"
      :error="error"
      @view="viewCaregiver"
      @edit="editCaregiver"
      @delete="deleteCaregiver"
    />

    <!-- 開發模式下顯示原始資料 -->
    <div v-if="isDev && caregivers.length > 0" class="card mt-4">
      <div class="card-header">
        <h5 class="card-title mb-0">原始資料 (僅供開發參考)</h5>
      </div>
      <div class="card-body">
        <pre class="bg-light p-3 border rounded small" style="max-height: 300px; overflow-y: auto;">{{ JSON.stringify(caregivers, null, 2) }}</pre>
      </div>
    </div>
  </div>
</template>

<script>
import Breadcrumb from '@/components/breadcrumb/Breadcrumb.vue';
import CaregiverTable from '@/components/Caregiver/CaregiverTable.vue';
import { useCaregivers } from '@/composables/useCaregivers.js';
import { ref } from 'vue';
import { useRouter } from 'vue-router';

export default {
  name: "CaregiverList",
  components: {
    Breadcrumb,
    CaregiverTable
  },
  setup() {
    // 使用照服員資料 composable
    const {
      caregivers,
      loading: isLoading,
      error,
      loadCaregivers,
      searchCaregivers,
      deleteCaregiver: apiDeleteCaregiver
    } = useCaregivers({ autoLoad: true });

    // 使用路由
    const router = useRouter();

    // 開發模式標誌
    const isDev = ref(import.meta.env.DEV);

    /**
     * 查看照服員詳情
     * @param {Object} caregiver 照服員資料
     */
    const viewCaregiver = (caregiver) => {
      console.log('查看照服員詳情:', caregiver);
      // 導航到照服員詳情頁面
      router.push(`/care-worker/${caregiver.id}`);
    };

    /**
     * 編輯照服員資料
     * @param {Object} caregiver 照服員資料
     */
    const editCaregiver = (caregiver) => {
      console.log('編輯照服員資料:', caregiver);
      // 導航到編輯頁面
      router.push(`/care-worker/edit/${caregiver.id}`);
    };

    /**
     * 刪除照服員
     * @param {Object} caregiver 照服員資料
     */
    const deleteCaregiver = async (caregiver) => {
      console.log('刪除照服員:', caregiver);
      try {
        await apiDeleteCaregiver(caregiver.id);
        // 刪除後重新載入資料
        await loadCaregivers(true);
      } catch (error) {
        console.error('刪除照服員失敗:', error);
        // TODO: 顯示錯誤訊息給使用者
      }
    };

    return {
      // 狀態
      caregivers,
      isLoading,
      error,
      isDev,

      // 方法
      viewCaregiver,
      editCaregiver,
      deleteCaregiver
    };
  }
}
</script>