<template>
  <div class="dashboard-main-body">
    <Breadcrumb title="新增行政區" :breadcrumbs="[
      { name: '行政區列表', path: '/farezone/list' },
      { name: '新增行政區' }
    ]" />

    <!-- 引入行政區新增元件 -->
    <AddZone @add-success="handleAddSuccess" />
  </div>
</template>

<script>
import Breadcrumb from '@/components/breadcrumb/Breadcrumb.vue';
import AddZone from '@/components/Rehabus/AddZone.vue';
import { useRouter } from 'vue-router';

export default {
  name: "FareZoneAdd",
  components: {
    Breadcrumb,
    AddZone
  },
  setup() {
    const router = useRouter();

    // 處理新增成功
    const handleAddSuccess = () => {
      // 可選：導航回列表頁面
      // router.push('/farezone/list');
    };

    return {
      handleAddSuccess
    };
  }
};
</script>