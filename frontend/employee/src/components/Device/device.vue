<template>
  <div class="dashboard-main-body">
    <Breadcrumb title="輔具管理" :breadcrumbs="[
      { name: '輔具列表' }
    ]" />

    <!-- 輔具表格卡片 -->
    <DeviceTable />

  </div>
</template>

<script>
import Breadcrumb from '@/components/breadcrumb/Breadcrumb.vue'
import DeviceTable from '@/components/Device/DeviceTable.vue'

export default {
  name: "DevicePage",
  components: {
    Breadcrumb,
    DeviceTable,
  },
};
</script>