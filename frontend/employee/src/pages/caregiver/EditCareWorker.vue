<template>
    <div class="dashboard-main-body">
        <Breadcrumb title="編輯照服員" :breadcrumbs="[
            { name: '照服員管理', path: '/caregiver/list' },
            { name: '編輯照服員' }
        ]" />

        <EditCareWorkerForm :caregiverId="$route.params.id" />
    </div>
</template>

<script>
import { useRoute } from 'vue-router';
import Breadcrumb from '@/components/breadcrumb/Breadcrumb.vue';
import EditCareWorkerForm from '@/components/Caregiver/EditCareWorker.vue'

export default {
  name: "EditCareWorkerPage",
  components: {
    Breadcrumb,
    EditCareWorkerForm,
  },
  setup() {
    const route = useRoute();
    console.log('編輯頁面載入，ID參數:', route.params.id);
    
    return {
      // 返回必要的數據
    };
  }
}
</script>
