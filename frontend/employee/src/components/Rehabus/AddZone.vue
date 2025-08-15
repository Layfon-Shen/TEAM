<template>
  <div class="card border-0 shadow-sm">
    <div class="card-header bg-transparent d-flex justify-content-between align-items-center">
      <h5 class="mb-0">新增行政區資料</h5>
      <div v-if="loading" class="spinner-border spinner-border-sm text-primary" role="status">
        <span class="visually-hidden">載入中...</span>
      </div>
    </div>
    <div class="card-body">
      <form @submit.prevent="submitForm">
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
          <button type="submit" class="btn btn-primary w-100px" :disabled="loading">儲存</button>
          <button type="button" class="btn btn-light w-100px" @click="resetForm" :disabled="loading">重設</button>
        </div>
      </form>
    </div>
  </div>
</template>

<script>
import { ref } from 'vue';
import { useRouter } from 'vue-router';
import { fareZoneService } from '@/services/fareZoneService';
import { useToast } from '@/composables/useToast'; // 引入 toast 元件

export default {
  name: 'AddZone',
  emits: ['add-success'],
  setup(props, { emit }) {
    const router = useRouter();
    const loading = ref(false);
    
    // 表單資料 - 使用 name 欄位與 service 層保持一致
    const form = ref({
      name: '',
      description: ''
    });

    // 使用 Toast 通知功能
    const { showToast } = useToast(); 

    // 提交表單
    const submitForm = async () => {
      // 檢查必填欄位
      if (!form.value.name) {
        alert('請輸入行政區名稱');
        return;
      }
      
      loading.value = true;
      try {
        console.log('新增行政區 - 提交表單資料:', form.value);
        
        // 呼叫服務層新增行政區 - 直接傳遞整個表單資料
         const result = await fareZoneService.addZone({
      name: form.value.name,
      description: form.value.description
    });
    
        // 顯示操作成功通知
        showToast({
          title: '成功新增',
          message: `新增 ${form.value.name} 行政區`,
          type: 'success'
        });
        
        // 發射成功事件通知父元件
        emit('add-success');
        
        // 發送全域事件，通知列表頁面刷新
        window.dispatchEvent(new CustomEvent('zone-status-updated'));
        
        // 重置表單
        resetForm();
        
        // 返回列表頁面
        router.push('/farezone/list');
      } catch (error) {
        showToast({
          title: '新增失敗 !',
          message: error.message,
          type: 'error'
        });
      } finally {
        loading.value = false;
      }
    };

    // 重置表單
    const resetForm = () => {
      form.value = {
        name: '',
        description: ''
      };
    };

    return {
      form,
      loading,
      submitForm,
      resetForm
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