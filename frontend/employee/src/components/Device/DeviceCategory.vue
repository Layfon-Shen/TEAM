<template>
  <div class="card">
    <!-- 連線錯誤提示 -->
    <div v-if="connectionError" class="alert alert-danger mx-3 mt-3">
      <strong><i class="ri-error-warning-line me-2"></i>伺服器連線錯誤</strong>
      <p class="mb-0">{{ connectionError }}</p>
      <div class="mt-2">
        <button class="btn btn-sm btn-outline-danger" @click="retryConnection">
          <i class="ri-refresh-line me-1"></i> 重試連線
        </button>
      </div>
    </div>

    <div class="card-header d-flex flex-wrap align-items-center justify-content-between gap-3">
      <div class="d-flex flex-wrap align-items-center gap-3">
        <div class="d-flex align-items-center gap-2">
          <span>顯示</span>
          <select class="form-select form-select-sm w-auto" v-model="selectedShow">
            <option value="10">10</option>
            <option value="15">15</option>
            <option value="20">20</option>
          </select>
        </div>

        <div class="icon-field">
          <input type="text" class="form-control form-control-sm w-auto" v-model="searchText" 
                placeholder="搜尋分類" @keyup.enter="searchCategories">
          <span class="icon">
            <iconify-icon icon="ion:search-outline"></iconify-icon>
          </span>
        </div>
      </div>

      <div class="d-flex flex-wrap align-items-center gap-3">
        <button class="btn btn-sm btn-primary-600" @click="openAddModal">
          <i class="ri-add-line"></i> 新增分類
        </button>
      </div>
    </div>

    <!-- Table -->
    <div class="card-body">
      <!-- 載入中提示 -->
      <div v-if="isLoading" class="text-center p-4">
        <div class="spinner-border text-primary" role="status">
          <span class="visually-hidden">載入中...</span>
        </div>
        <p class="mt-2">載入分類資料中...</p>
      </div>

      <!-- 錯誤提示 -->
      <div v-else-if="error" class="alert alert-danger">
        <i class="ri-error-warning-line me-2"></i> {{ error }}
      </div>
      
      <!-- 沒有數據提示 -->
      <div v-else-if="filteredCategories.length === 0" class="text-center p-4">
        <div class="alert alert-info">
          <i class="ri-information-line me-2"></i> 
          {{ searchText ? '沒有找到匹配的分類資料' : '目前沒有輔具分類資料' }}
        </div>
      </div>

      <!-- 分類表格 -->
      <table v-else class="table bordered-table mb-0">
        <thead>
          <tr>
            <th scope="col">
              <div class="form-check style-check d-flex align-items-center">
                <input class="form-check-input" type="checkbox" v-model="selectAll" @change="toggleSelectAll">
                <label class="form-check-label">序號</label>
              </div>
            </th>
            <th scope="col">分類名稱</th>
            <th scope="col">排序</th>
            <th scope="col">相關輔具數量</th>
            <th scope="col">操作</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="(category, index) in filteredCategories" :key="category.id">
            <td>
              <div class="form-check style-check d-flex align-items-center">
                <input class="form-check-input" type="checkbox" v-model="selectedIds" :value="category.id">
                <label class="form-check-label">{{ category.id }}</label>
              </div>
            </td>
            <td>{{ category.name }}</td>
            <td>{{ category.categoryId }}</td>
            <td>{{ getDeviceCountForCategory(category.id) }}</td>
            <td class="d-flex gap-2">
              <a href="#"
                class="w-32-px h-32-px bg-success-focus text-success-main rounded-circle d-inline-flex align-items-center justify-content-center"
                @click.prevent="openEditModal(category)">
                <iconify-icon icon="lucide:edit"></iconify-icon>
              </a>
              <a href="#"
                class="w-32-px h-32-px bg-danger-focus text-danger-main rounded-circle d-inline-flex align-items-center justify-content-center"
                @click.prevent="confirmDelete(category.id)">
                <iconify-icon icon="mingcute:delete-2-line"></iconify-icon>
              </a>
            </td>
          </tr>
        </tbody>
      </table>
      <!-- Pagination -->
      <Pagination :currentPage="currentPage" :totalPages="totalPages" :startIndex="startIndex" :endIndex="endIndex"
        :totalItems="totalEntries" @page-changed="changePage" />
    </div>

    <!-- 新增/編輯分類對話框 -->
    <div class="modal fade" :class="{ 'show d-block': showModal }" tabindex="-1" role="dialog"
      :style="{ 'background-color': showModal ? 'rgba(0,0,0,0.5)' : '' }">
      <div class="modal-dialog">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title">{{ isEditMode ? '編輯輔具分類' : '新增輔具分類' }}</h5>
            <button type="button" class="btn-close" @click="closeModal"></button>
          </div>
          <div class="modal-body">
            <form @submit.prevent="submitForm">
              <!-- 分類名稱 -->
              <div class="mb-3">
                <label for="categoryName" class="form-label">分類名稱</label>
                <input type="text" class="form-control" id="categoryName" v-model="editingCategory.name" required>
                <div v-if="errors.name" class="form-text text-danger">{{ errors.name }}</div>
              </div>
              
              <!-- 排序用分類ID -->
              <div class="mb-3">
                <label for="categoryId" class="form-label">排序順序</label>
                <input type="number" class="form-control" id="categoryId" v-model.number="editingCategory.categoryId" min="0">
                <div class="form-text text-muted">數字越小越靠前顯示</div>
              </div>
            </form>
          </div>
          <div class="modal-footer">
            <button type="button" class="btn btn-secondary" @click="closeModal">取消</button>
            <button type="button" class="btn btn-primary" @click="submitForm" :disabled="formLoading">
              <span v-if="formLoading" class="spinner-border spinner-border-sm me-2" role="status" aria-hidden="true"></span>
              {{ isEditMode ? '更新' : '新增' }}
            </button>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { ref, computed, onMounted, watch } from 'vue';
import Pagination from '@/components/pagination/index.vue';
import useDeviceCategories from '@/composables/useDeviceCategories';

export default {
  name: "DeviceCategoryTable",
  components: { Pagination },
  setup() {
    // 新增連線錯誤狀態
    const connectionError = ref('');
    
    // 使用 Composable 獲取分類相關功能
    const { 
      categories, 
      isLoading, 
      error, 
      fetchCategories,
      addCategory,
      updateCategory,
      deleteCategory,
      searchCategories 
    } = useDeviceCategories();
    
    // 初始載入資料
    onMounted(async () => {
      await loadInitialData();
    });
    
    // 初始資料載入函式
    const loadInitialData = async () => {
      try {
        connectionError.value = ''; // 清除之前的錯誤
        await fetchCategories();
      } catch (err) {
        console.error('初始載入分類資料失敗:', err);
        connectionError.value = `無法連線到伺服器：${err.message || '未知錯誤'}`;
      }
    };
    
    // 重試連線
    const retryConnection = async () => {
      await loadInitialData();
    };
    
    return {
      categories,
      isLoading,
      error,
      connectionError,
      fetchCategories,
      addCategory,
      updateCategory,
      deleteCategory,
      searchCategories,
      retryConnection
    };
  },
  data() {
    return {
      // 表格相關
      selectedShow: 10,
      searchText: '',
      selectAll: false,
      selectedIds: [],
      currentPage: 1,
      
      // 編輯對話框相關
      showModal: false,
      isEditMode: false,
      editingCategory: {
        id: null,
        name: '',
        categoryId: 0
      },
      originalCategory: null,
      formLoading: false,
      errors: {
        name: ''
      },
      
      // 假資料：各分類關聯的輔具數量（實際應從API獲取）
      categoryDeviceCounts: {},
      
      // 搜尋結果
      searchResults: []
    };
  },
  computed: {
    // 計算每頁顯示數量
    entriesPerPage() {
      return Number(this.selectedShow);
    },
    
    // 過濾資料
    filteredData() {
      // 如果有搜尋結果，使用搜尋結果
      if (Array.isArray(this.searchResults) && this.searchResults.length > 0 && this.searchText) {
        return this.searchResults;
      }
      
      // 否則使用全部資料，確保是陣列
      return Array.isArray(this.categories) ? this.categories : [];
    },
    
    // 計算總項目數
    totalEntries() {
      return Array.isArray(this.filteredData) ? this.filteredData.length : 0;
    },
    
    // 計算總頁數
    totalPages() {
      return Math.ceil(this.totalEntries / this.entriesPerPage) || 1;
    },
    
    // 計算當前頁起始索引
    startIndex() {
      return (this.currentPage - 1) * this.entriesPerPage;
    },
    
    // 計算當前頁結束索引
    endIndex() {
      return Math.min(this.startIndex + this.entriesPerPage, this.totalEntries);
    },
    
    // 獲取當前頁顯示的分類
    filteredCategories() {
      if (!Array.isArray(this.filteredData)) {
        return [];
      }
      return this.filteredData.slice(this.startIndex, this.endIndex);
    }
  },
  watch: {
    // 監聽篩選條件變化，重置頁碼
    selectedShow() {
      this.currentPage = 1;
    }
  },
  methods: {
    // 切換全選
    toggleSelectAll() {
      if (this.selectAll) {
        this.selectedIds = this.filteredCategories.map(cat => cat.id);
      } else {
        this.selectedIds = [];
      }
    },
    
    // 切換頁碼
    changePage(page) {
      if (page >= 1 && page <= this.totalPages) {
        this.currentPage = page;
      }
    },
    
    // 開啟新增對話框
    openAddModal() {
      this.isEditMode = false;
      this.editingCategory = {
        id: null,
        name: '',
        categoryId: 0
      };
      this.originalCategory = null;
      this.errors = { name: '' };
      this.showModal = true;
    },
    
    // 開啟編輯對話框
    openEditModal(category) {
      this.isEditMode = true;
      // 深拷貝防止直接修改原始資料
      this.editingCategory = JSON.parse(JSON.stringify(category));
      this.originalCategory = JSON.parse(JSON.stringify(category));
      this.errors = { name: '' };
      this.showModal = true;
    },
    
    // 關閉對話框
    closeModal() {
      this.showModal = false;
      setTimeout(() => {
        this.editingCategory = { id: null, name: '', categoryId: 0 };
        this.originalCategory = null;
        this.errors = { name: '' };
      }, 300);
    },
    
    // 提交表單
    async submitForm() {
      // 表單驗證
      this.errors = { name: '' };
      if (!this.editingCategory.name || this.editingCategory.name.trim() === '') {
        this.errors.name = '分類名稱不能為空';
        return;
      }
      
      this.formLoading = true;
      
      try {
        if (this.isEditMode) {
          // 更新分類
          const success = await this.updateCategory(this.editingCategory);
          if (success) {
            this.$toast.success('分類更新成功');
            this.closeModal();
          } else {
            this.$toast.error('更新分類失敗');
          }
        } else {
          // 新增分類
          const newId = await this.addCategory(this.editingCategory.name, this.editingCategory.categoryId);
          if (newId) {
            this.$toast.success('新增分類成功');
            this.closeModal();
          } else {
            this.$toast.error('新增分類失敗');
          }
        }
      } catch (error) {
        console.error('提交表單失敗:', error);
        this.$toast.error(`操作失敗: ${error.message || '未知錯誤'}`);
      } finally {
        this.formLoading = false;
      }
    },
    
    // 確認刪除
    confirmDelete(id) {
      if (confirm('確定要刪除此分類嗎？這將影響所有使用此分類的輔具。')) {
        this.deleteSelectedCategory(id);
      }
    },
    
    // 刪除分類
    async deleteSelectedCategory(id) {
      try {
        const result = await this.deleteCategory(id);
        if (result) {
          this.$toast.success('分類已成功刪除');
        } else {
          this.$toast.error('刪除分類失敗，可能有輔具正在使用此分類');
        }
      } catch (error) {
        console.error('刪除分類失敗:', error);
        this.$toast.error(`刪除失敗: ${error.message || '未知錯誤'}`);
      }
    },
    
    // 搜尋分類
    async performSearch() {
      if (!this.searchText.trim()) {
        // 如果搜尋框為空，重新載入所有資料
        this.searchResults = [];
        try {
          await this.fetchCategories();
        } catch (error) {
          console.error('重新載入分類資料失敗:', error);
          this.$toast?.error?.('重新載入資料失敗，請稍後再試') || alert('重新載入資料失敗');
        }
        return;
      }
      
      try {
        const results = await this.searchCategories(this.searchText);
        this.searchResults = results;
        this.currentPage = 1; // 重置頁碼
      } catch (error) {
        console.error('搜尋分類失敗:', error);
        this.$toast?.error?.(`搜尋失敗: ${error.message || '未知錯誤'}`) || 
          alert(`搜尋失敗: ${error.message || '未知錯誤'}`);
      }
    },
    
    // 獲取分類相關聯的輔具數量
    getDeviceCountForCategory(categoryId) {
      // 這裡應該從API獲取，暫時使用假資料
      if (!this.categoryDeviceCounts[categoryId]) {
        // 生成0-15之間的隨機數字作為示例
        this.categoryDeviceCounts[categoryId] = Math.floor(Math.random() * 16);
      }
      return this.categoryDeviceCounts[categoryId];
    }
  }
};
</script>