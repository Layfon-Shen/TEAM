<template>
  <div class="dashboard-main-body">
    <Breadcrumb title="編輯行政區" :breadcrumbs="[
      { name: '行政區列表', path: '/farezone/list' },
      { name: '編輯行政區' }
    ]" />

    <!-- 引入行政區編輯元件 -->
    <EditZone />
  </div>
</template>

<script>
import Breadcrumb from '@/components/breadcrumb/Breadcrumb.vue';
import EditZone from '@/components/Rehabus/EditZone.vue';

export default {
  name: "FareZoneEdit",
  components: {
    Breadcrumb,
    EditZone
  }
};
</script>