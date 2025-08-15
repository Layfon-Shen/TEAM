<template>
  <div class="card border-0 shadow-sm">
    <div class="card-header bg-transparent d-flex justify-content-between align-items-center">
      <h4 class="mb-0">行政區列表</h4>
      <div class="d-flex align-items-center">
        <!-- 搜尋欄位 -->
        <div class="d-flex me-3 gap-2">
          <div class="input-group me-3">
            <input 
              type="text" 
              class="form-control search-input" 
              placeholder="搜尋行政區名稱..."
              v-model="searchQuery"
              @input="handleSearch"
            >
            <span class="input-group-text bg-transparent">
              <i class="bi bi-search"></i>
            </span>
          </div>
          <!-- 新增按鈕 -->
          <button class="btn btn-success d-flex align-items-center" @click="handleAddNew">
            <i class="bi bi-plus-lg me-2"></i>
            <span class="d-flex horizontal-text">
              <span class="me-0">新</span><span>增</span>
            </span>
          </button>
        </div>
      </div>
    </div>

    <div class="card-body p-0">
      <!-- 資料表格 -->
      <div class="table-responsive">
        <table class="table mb-0">
          <thead class="table-light">
            <tr>
              <th>區域編號</th>
              <th>區域名稱</th>
              <th>補充說明</th>
              <th>操作</th>
            </tr>
          </thead>
          <tbody>
            <!-- 載入中顯示 -->
            <tr v-if="loading">
              <td colspan="4" class="text-center py-4">
                <div class="spinner-border text-primary" role="status">
                  <span class="visually-hidden">載入中...</span>
                </div>
              </td>
            </tr>
            <!-- 無資料顯示 -->
            <tr v-else-if="zoneList.length === 0">
              <td colspan="4" class="text-center py-4">
                找不到符合條件的行政區資料
              </td>
            </tr>
            <!-- 資料列表 -->
            <tr v-for="zone in zoneList" :key="zone.id">
              <td>{{ zone.id }}</td>
              <td>{{ zone.name }}</td>
              <td>{{ zone.description || '無' }}</td>
              <!-- 操作欄位 -->
              <td>
                <div class="d-flex gap-2">
                  <!-- 編輯按鈕 -->
                  <a href="#" @click.prevent="handleEdit(zone.id)"
                     class="w-32-px h-32-px bg-success-focus text-success-main rounded-circle d-inline-flex align-items-center justify-content-center">
                    <iconify-icon icon="lucide:edit"></iconify-icon>
                  </a>
                  <!-- 刪除按鈕 -->
                  <a href="#" @click.prevent="handleDelete(zone.id)"
                     class="w-32-px h-32-px bg-danger-focus text-danger-main rounded-circle d-inline-flex align-items-center justify-content-center">
                    <iconify-icon icon="mingcute:delete-2-line"></iconify-icon>
                  </a>
                </div>
              </td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>

    <!-- 分頁元件 -->
    <div class="card-footer bg-transparent d-flex justify-content-between align-items-center">
      <div>共 {{ totalItems }} 筆資料</div>
      <nav aria-label="行政區列表分頁">
        <ul class="pagination pagination-sm mb-0">
          <li class="page-item" :class="{ disabled: currentPage === 1 }">
            <a class="page-link" href="#" @click.prevent="handlePageChange(currentPage - 1)">上一頁</a>
          </li>
          <li 
            v-for="page in totalPages" 
            :key="page" 
            class="page-item" 
            :class="{ active: page === currentPage }"
          >
            <a class="page-link" href="#" @click.prevent="handlePageChange(page)">{{ page }}</a>
          </li>
          <li class="page-item" :class="{ disabled: currentPage === totalPages }">
            <a class="page-link" href="#" @click.prevent="handlePageChange(currentPage + 1)">下一頁</a>
          </li>
        </ul>
      </nav>
    </div>
  </div>
</template>

<script>
import { ref, onMounted, computed, watch } from 'vue';
import { useRouter } from 'vue-router';
import { fareZoneService } from '@/services/fareZoneService';
import { useToast } from '@/composables/useToast'; // 引入 toast 元件

export default {
  name: 'ZoneList',
  setup() {
    // 基本狀態
    const zoneList = ref([]);
    const loading = ref(true);
    const error = ref(null);
    const router = useRouter();

    // 使用 Toast 通知功能
    const { showToast } = useToast(); 

    // 分頁相關
    const currentPage = ref(1);
    const pageSize = ref(10);
    const totalItems = ref(0);
    
    // 搜尋參數
    const searchQuery = ref('');
    const allZones = ref([]); // 保存所有資料用於前端篩選

    // 計算總頁數
    const totalPages = computed(() => {
      return Math.ceil(totalItems.value / pageSize.value);
    });

    // 載入行政區資料
    const loadZones = async () => {
      loading.value = true;
      try {
        // 獲取全部資料
        const data = await fareZoneService.getAllZones();
        allZones.value = data;
        
        // 根據搜尋條件過濾
        let filteredData = data;
        
        if (searchQuery.value) {
          filteredData = data.filter(zone => 
            zone.name.toLowerCase().includes(searchQuery.value.toLowerCase()) ||
            (zone.description && zone.description.toLowerCase().includes(searchQuery.value.toLowerCase()))
          );
        }
        
        // 更新總筆數
        totalItems.value = filteredData.length;
        
        // 分頁處理
        const startIndex = (currentPage.value - 1) * pageSize.value;
        const endIndex = startIndex + pageSize.value;
        zoneList.value = filteredData.slice(startIndex, endIndex);
        
      } catch (err) {
        error.value = err.message;
        console.error('載入行政區資料失敗:', err);
      } finally {
        loading.value = false;
      }
    };

    // 處理頁面變更
    const handlePageChange = (page) => {
      if (page < 1 || page > totalPages.value) return;
      currentPage.value = page;
      loadZones();
    };

    // 處理搜尋
    const handleSearch = () => {
      currentPage.value = 1;
      loadZones();
    };

    // 處理編輯
    const handleEdit = (zoneId) => {
      router.push(`/farezone/edit/${zoneId}`);
    };

    // 處理刪除
    const handleDelete = async (zoneId) => {
      if (confirm('確定要刪除此行政區記錄嗎？')) {
        try {
          await fareZoneService.deleteZone(zoneId);
          showToast({
            title: '成功刪除',
            message: '行政區已刪除',
            type: 'success'
          });
          // 刪除成功後重新載入資料
          loadZones();
        } catch (err) {
          showToast({
            title: '刪除失敗',
            message: err.message,
            type: 'error'
          });
        }
      }
    };

    // 處理新增
    const handleAddNew = () => {
      router.push('/farezone/add');
    };

    // 監聽路由變更，從編輯頁返回時重新載入資料
    watch(() => router.currentRoute.value.fullPath, (newPath) => {
      if (newPath === '/farezone/list') {
        loadZones();
      }
    });

    // 頁面載入時獲取資料
    onMounted(() => {
      loadZones();
      
      // 添加全域事件監聽器，用於其他頁面通知列表刷新
      window.addEventListener('zone-status-updated', () => {
        loadZones();
      });
    });

    return {
      zoneList,
      loading,
      error,
      currentPage,
      totalPages,
      totalItems,
      searchQuery,
      handlePageChange,
      handleSearch,
      handleEdit,
      handleDelete,
      handleAddNew
    };
  }
};
</script>

<style scoped>
.card {
  border-radius: 0.5rem;
}

.table th {
  font-weight: 600;
  color: #555;
}

.table td, .table th {
  padding: 0.75rem 1rem;
  vertical-align: middle;
}

/* 水平文字排列樣式 */
.horizontal-text {
  display: flex;
  flex-direction: row;
  align-items: center;
  letter-spacing: 0.5px;
}

/* 確保按鈕內容水平居中對齊 */
.btn {
  display: inline-flex;
  align-items: center;
  justify-content: center;
}

/* 圓形按鈕樣式 */
.w-32-px {
  width: 32px;
}

.h-32-px {
  height: 32px;
}

.bg-success-focus {
  background-color: rgba(0, 171, 85, 0.12);
}

.text-success-main {
  color: #00ab55;
}

.bg-danger-focus {
  background-color: rgba(255, 48, 48, 0.12);
}

.text-danger-main {
  color: #ff3030;
}
</style>