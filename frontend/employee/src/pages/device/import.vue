<template>
  <div class="dashboard-main-body">
    <Breadcrumb title="輔具批次匯入" :breadcrumbs="[
      { name: '輔具管理', path: '/device/list' },
      { name: '批次匯入' }
    ]" />

    <!-- 批次匯入卡片 -->
    <div class="card">
      <div class="card-header">
        <h4 class="card-title">CSV 批次匯入</h4>
        <button class="btn btn-sm btn-info-main">
          <i class="ri-download-line"></i> 下載範本
        </button>
      </div>
      <div class="card-body">
        <div class="file-upload-area">
          <!-- 這裡可以放檔案上傳元件 -->
          <p>輔具批次匯入功能開發中...</p>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import Breadcrumb from '@/components/breadcrumb/Breadcrumb.vue'

export default {
  name: "DeviceImport",
  components: {
    Breadcrumb,
  },
};
</script>