<template>
  <div class="dashboard-main-body">
    <Breadcrumb title="輔具分類管理" :breadcrumbs="[
      { name: '輔具管理', path: '/device/list' },
      { name: '輔具分類' }
    ]" />

    <!-- 分類表格卡片 -->
    <DeviceCategory />
    
  </div>
</template>

<script>
import Breadcrumb from '@/components/breadcrumb/Breadcrumb.vue'
import DeviceCategory from '@/components/Device/DeviceCategory.vue'

export default {
  name: "DeviceCategoryPage",
  components: {
    Breadcrumb,
    DeviceCategory
  },
};
</script>