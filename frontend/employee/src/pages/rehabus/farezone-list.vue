<template>
  <div class="dashboard-main-body">
    <Breadcrumb title="行政區管理" :breadcrumbs="[
      { name: '行政區列表' }
    ]" />

    <!-- 引入行政區列表元件 -->
    <ZoneList />
  </div>
</template>

<script>
import Breadcrumb from '@/components/breadcrumb/Breadcrumb.vue';
import ZoneList from '@/components/Rehabus/ZoneList.vue';

export default {
  name: "FareZoneList",
  components: {
    Breadcrumb,
    ZoneList
  }
};
</script>