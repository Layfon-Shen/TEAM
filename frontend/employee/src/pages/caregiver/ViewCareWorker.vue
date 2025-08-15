<template>
    <div class="dashboard-main-body">
        <Breadcrumb title="照服員詳細資料" :breadcrumbs="[
            { name: '照服員管理', path: '/caregiver/list' },
            { name: '照服員詳細資料' }
        ]" />

        <ViewCareWorker :caregiverId="$route.params.id" />
    </div>
</template>

<script>
import { useRoute } from 'vue-router';
import Breadcrumb from '@/components/breadcrumb/Breadcrumb.vue';
import ViewCareWorker from '@/components/Caregiver/ViewCareWorker.vue';

export default {
  name: "ViewCareWorkerPage",
  components: {
    Breadcrumb,
    ViewCareWorker
  },
  setup() {
    const route = useRoute();
    console.log('詳細資料頁面載入，ID參數:', route.params.id);
    
    return {
      // 返回必要的數據
    };
  }
}
</script>
