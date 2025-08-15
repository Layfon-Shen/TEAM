<template>
  <div class="card border-0 shadow-sm">
    <div class="card-header bg-transparent d-flex justify-content-between align-items-center">
      <h5 class="mb-0">編輯行政區資料</h5>
      <div v-if="loading" class="spinner-border spinner-border-sm text-primary" role="status">
        <span class="visually-hidden">載入中...</span>
      </div>
    </div>
    <div class="card-body">
      <form @submit.prevent="submitForm">
        <div class="row mb-3">
          <div class="col-md-6">
            <label for="zoneId" class="form-label">區域編號</label>
            <input 
              type="text"
              id="zoneId"
              v-model="form.id"
              class="form-control"
              disabled
            >
          </div>
        </div>
        <div class="row mb-3">
          <div class="col-md-6">
            <label for="zoneName" class="form-label">區域名稱 <span class="text-danger">*</span></label>
            <input 
              type="text"
              id="zoneName"
              v-model="form.name"
              class="form-control"
              placeholder="請輸入行政區名稱"
              required
            >
          </div>
        </div>
        <div class="row mb-4">
          <div class="col-md-12">
            <label for="description" class="form-label">補充說明</label>
            <textarea
              id="description"
              v-model="form.description"
              class="form-control"
              rows="3"
              placeholder="請輸入補充說明（選填）"
            ></textarea>
          </div>
        </div>
        <div class="d-flex gap-2">
          <button type="submit" class="btn btn-primary w-100px" :disabled="loading">更新</button>
          <button type="button" class="btn btn-light w-100px" @click="goBack" :disabled="loading">取消</button>
        </div>
      </form>
    </div>
  </div>
</template>

<script>
import { ref, onMounted } from 'vue';
import { useRoute, useRouter } from 'vue-router';
import { fareZoneService } from '@/services/fareZoneService';
import { useToast } from '@/composables/useToast'; // 引入 toast 元件

export default {
  name: 'EditZone',
  setup() {
    const route = useRoute();
    const router = useRouter();
    const loading = ref(false);
    
    // 使用 Toast 通知功能
    const { showToast } = useToast(); 
    
    // 表單資料
    const form = ref({
      id: '',
      name: '',
      description: ''
    });

    // 載入行政區資料
    const loadZoneData = async () => {
      // 確保從路由參數中獲取正確的 ID
      const zoneId = parseInt(route.params.id);
      console.log('路由參數 zoneId:', zoneId);
      
      if (isNaN(zoneId)) {
        alert('無效的行政區編號');
        router.push('/farezone/list');
        return;
      }

      loading.value = true;
      try {
        console.log('開始載入行政區 ID:', zoneId);
        const zoneData = await fareZoneService.getZoneById(zoneId);
        console.log('取得的行政區資料:', zoneData);
        
        // 確保取得的資料有效
        if (zoneData && zoneData.id) {
          // 設定表單資料
          form.value = {
            id: zoneData.id,
            name: zoneData.name || '',
            description: zoneData.description || ''
          };
          console.log('表單資料已設定:', form.value);
        } else {
          console.error('取得的行政區資料無效:', zoneData);
          throw new Error('無法取得有效的行政區資料');
        }
      } catch (error) {
        console.error('載入行政區資料失敗:', error);
        alert(`載入失敗: ${error.message}`);
        router.push('/farezone/list');
      } finally {
        loading.value = false;
      }
    };

    // 提交表單
    const submitForm = async () => {
      if (!form.value.name) {
        alert('請輸入行政區名稱');
        return;
      }

      loading.value = true;
      try {
        console.log('準備更新資料:', form.value);
        
        await fareZoneService.updateZone(form.value.id, form.value);
        
        showToast({
          title: '修改成功',
          message: `成功修改 ${form.value.name} 行政區`,
          type: 'success'
        });
        
        // 發送全域事件，通知列表頁面刷新
        window.dispatchEvent(new CustomEvent('zone-status-updated'));
        
        // 返回列表頁
        router.push('/farezone/list');
      } catch (error) {
        showToast({
          title: '修改失敗 !',
          message: error.message,
          type: 'error'
        });
      } finally {
        loading.value = false;
      }
    };

    // 返回列表頁
    const goBack = () => {
      router.push('/farezone/list');
    };

    // 頁面載入時獲取資料
    onMounted(() => {
      loadZoneData();
    });

    return {
      loading,
      form,
      submitForm,
      goBack
    };
  }
};
</script>

<style scoped>
.card {
  border-radius: 0.5rem;
}

/* 設定按鈕固定寬度，使兩個按鈕長度一致 */
.w-100px {
  width: 100px;
}
</style>