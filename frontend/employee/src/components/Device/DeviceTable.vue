<template>
  <div class="card">
    <div class="card-header d-flex flex-wrap align-items-center justify-content-between gap-3">
      <div class="d-flex flex-wrap align-items-center gap-3">
        <!-- 顯示筆數選項 -->
        <div class="d-flex align-items-center gap-2">
          <span>顯示</span>
          <select class="form-select form-select-sm w-auto" v-model="selectedShow">
            <option value="10">10</option>
            <option value="15">15</option>
            <option value="20">20</option>
          </select>
        </div>

        <!-- 搜尋輸入框 -->
        <div class="icon-field">
          <input type="text" class="form-control form-control-sm w-auto" v-model="searchText" placeholder="搜尋輔具名稱">
          <span class="icon">
            <iconify-icon icon="ion:search-outline"></iconify-icon>
          </span>
        </div>
      </div>

      <div class="d-flex flex-wrap align-items-center gap-3">
        <!-- 狀態過濾 -->
        <select class="form-select form-select-sm w-auto" v-model="selectedStatus">
          <option value="">狀態</option>
          <option value="true">已上架</option>
          <option value="false">未上架</option>
        </select>

        <!-- 匯出CSV按鈕 -->
        <button class="btn btn-sm btn-success-main" @click="exportToCSV">
          <i class="ri-file-download-line"></i> 匯出CSV
        </button>

        <!-- 批次操作按鈕群組 -->
        <div class="btn-group">
          <!-- 批次修改按鈕 -->
          <div class="dropdown">
            <button class="btn btn-sm btn-warning" type="button" id="batchActionDropdown" 
                    data-bs-toggle="dropdown" aria-expanded="false"
                    :disabled="selectedIds.length === 0">
              <i class="ri-settings-line"></i> 批次修改 <i class="ri-arrow-down-s-line"></i>
            </button>
            <ul class="dropdown-menu" aria-labelledby="batchActionDropdown">
              <!-- 批次編輯表格模式 (新版) -->
              <li><a class="dropdown-item" href="#" @click.prevent="openBatchEditTableModal">
                <i class="ri-table-line"></i> <strong>批次編輯表格</strong>
              </a></li>
              <li><hr class="dropdown-divider"></li>
              <!-- 單屬性批次修改選項 (舊版) -->
              <li><a class="dropdown-item" href="#" @click.prevent="openBatchEditModal('isOnline')">
                <i class="ri-toggle-line"></i> 批次上下架
              </a></li>
              <li><a class="dropdown-item" href="#" @click.prevent="openBatchEditModal('unitPrice')">
                <i class="ri-money-cny-circle-line"></i> 批次修改價格
              </a></li>
              <li><a class="dropdown-item" href="#" @click.prevent="openBatchEditModal('inventory')">
                <i class="ri-store-2-line"></i> 批次修改庫存
              </a></li>
              <li><a class="dropdown-item" href="#" @click.prevent="openBatchEditModal('categoryId')">
                <i class="ri-price-tag-3-line"></i> 批次修改分類
              </a></li>
            </ul>
          </div>
          
          <!-- 獨立的批次刪除按鈕 -->
          <button class="btn btn-sm btn-danger" 
                  @click="batchDelete"
                  :disabled="selectedIds.length === 0"
                  v-tooltip="'批次刪除選中的輔具'">
            <i class="ri-delete-bin-line"></i> 批次刪除 
            <span v-if="selectedIds.length > 0" class="badge bg-light text-dark ms-1">{{ selectedIds.length }}</span>
          </button>
        </div>

        <!-- 新增輔具按鈕 -->
        <button class="btn btn-sm btn-primary-600" @click="openAddDeviceModal">
          <i class="ri-add-line"></i> 新增輔具
        </button>
      </div>
    </div>

    <!-- 輔具表格 -->
    <div class="card-body">
      <table class="table bordered-table mb-0">
        <thead>
          <tr>
            <th scope="col">
              <div class="form-check style-check d-flex align-items-center">
                <input class="form-check-input" type="checkbox" v-model="selectAll" @change="toggleSelectAll">
                <label class="form-check-label">序號</label>
              </div>
            </th>
            <th scope="col">輔具圖片</th>
            <th scope="col">輔具名稱</th>
            <th scope="col">商品貨號</th>
            <th scope="col">單價</th>
            <th scope="col">庫存數量</th>
            <th scope="col">上架狀態</th>
            <th scope="col">操作</th>
          </tr>
        </thead>
        <tbody>
          <!-- 重要：確保 filteredDevices 是有效陣列 -->
          <tr v-for="(device, index) in filteredDevices || []" :key="device.id">
            <td>
              <div class="form-check style-check d-flex align-items-center">
                <input class="form-check-input" type="checkbox" v-model="selectedIds" :value="device.id">
                <label class="form-check-label">{{ device.id }}</label>
              </div>
            </td>
            <!-- 輔具圖片欄 -->
            <td class="text-center">
              <img :src="getDeviceImage(device)" alt="" class="radius-8" style="width: 40px; height: 40px; object-fit: cover;">
            </td>
            <td>
              <h6 class="text-md mb-0 fw-medium">{{ device.name }}</h6>
            </td>
            <td>{{ device.sku }}</td>
            <td>NT$ {{ device.unitPrice }}</td>
            <td>{{ device.inventory }}</td>
            <td>
              <span :class="statusClasses(device.isOnline)" class="px-24 py-4 rounded-pill fw-medium text-sm">
                {{ device.isOnline ? '已上架' : '未上架' }}
              </span>
            </td>
            <td class="d-flex gap-2">
              <a href="#"
                class="w-32-px h-32-px bg-primary-light text-primary-600 rounded-circle d-inline-flex align-items-center justify-content-center"
                @click.prevent="showDeviceDetail(device)">
                <iconify-icon icon="iconamoon:eye-light"></iconify-icon>
              </a>
              <a href="#"
                class="w-32-px h-32-px bg-success-focus text-success-main rounded-circle d-inline-flex align-items-center justify-content-center"
                @click.prevent="openEditModal(device)">
                <iconify-icon icon="lucide:edit"></iconify-icon>
              </a>
              <a href="#"
                class="w-32-px h-32-px bg-danger-focus text-danger-main rounded-circle d-inline-flex align-items-center justify-content-center"
                @click.prevent="deleteDevice(device.id)">
                <iconify-icon icon="mingcute:delete-2-line"></iconify-icon>
              </a>
            </td>
          </tr>
          <!-- 如果沒有資料顯示提示 -->
          <tr v-if="!filteredDevices || filteredDevices.length === 0">
            <td colspan="8" class="text-center py-4">
              <p class="mb-0">目前沒有輔具資料</p>
            </td>
          </tr>
        </tbody>
      </table>
      <!-- 分頁組件 -->
      <Pagination :currentPage="currentPage" :totalPages="totalPages" :startIndex="startIndex" :endIndex="endIndex"
        :totalItems="totalEntries" @page-changed="changePage" />
    </div>

    <!-- 編輯輔具對話框 -->
    <div class="modal fade" :class="{ 'show d-block': showEditModal }" tabindex="-1" role="dialog" 
         :style="{ 'background-color': showEditModal ? 'rgba(0,0,0,0.5)' : '' }">
      <div class="modal-dialog">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title">{{ isNewDevice ? '新增輔具' : '編輯輔具' }}</h5>
            <button type="button" class="btn-close" @click="closeEditModal"></button>
          </div>
          <div class="modal-body">
            <form @submit.prevent="submitDeviceForm">
              <div class="mb-3">
                <label for="deviceName" class="form-label">輔具名稱</label>
                <input type="text" class="form-control" id="deviceName" v-model="editingDevice.name" required>
              </div>
              <div class="mb-3">
                <label for="deviceSku" class="form-label">商品貨號</label>
                <input type="text" class="form-control" id="deviceSku" v-model="editingDevice.sku" required>
              </div>
              
              <!-- 新增輔具分類下拉選單及按鈕 -->
              <div class="mb-3">
                <label for="deviceCategory" class="form-label">輔具分類</label>
                <div class="input-group">
                  <select class="form-select" id="deviceCategory" v-model="editingDevice.categoryId" required>
                    <option value="" disabled>請選擇分類</option>
                    <option v-for="category in categories" :key="category.id" :value="category.id">
                      {{ category.name }}
                    </option>
                  </select>
                  <!-- 新增分類按鈕 -->
                  <button class="btn btn-outline-secondary" type="button" @click="openCategoryModal">
                    <i class="ri-add-line"></i>
                  </button>
                </div>
                <!-- 載入狀態顯示 -->
              </div>
              
              <div class="mb-3">
                <label for="devicePrice" class="form-label">單價</label>
                <input type="number" class="form-control" id="devicePrice" v-model.number="editingDevice.unitPrice" min="0" required>
              </div>
              <div class="mb-3">
                <label for="deviceInventory" class="form-label">庫存數量</label>
                <input type="number" class="form-control" id="deviceInventory" v-model.number="editingDevice.inventory" min="0" required>
              </div>
              <div class="mb-3">
                <label for="deviceDescription" class="form-label">商品描述</label>
                <textarea class="form-control" id="deviceDescription" v-model="editingDevice.description" rows="3"></textarea>
              </div>
              
              <!-- 圖片選擇和預覽 -->
              <div class="mb-3">
                <label for="deviceImage" class="form-label">輔具圖片</label>
                
                <!-- 圖片選擇下拉選單 -->
                <select class="form-select mb-2" v-model="editingDevice.image" @change="previewImage">
                  <option v-for="option in imageOptions" :key="option.value" :value="option.value">
                    {{ option.label }}
                  </option>
                </select>
                
                <!-- 圖片預覽區域 -->
                <div v-if="imagePreviewUrl" class="mt-3 text-center">
                  <div class="border rounded p-2 d-inline-block">
                    <img :src="imagePreviewUrl" alt="圖片預覽" style="max-width: 100%; max-height: 200px;">
                  </div>
                  <div class="mt-2">
                    <span class="badge bg-success">✓ 圖片預覽</span>
                  </div>
                </div>
                <div v-else-if="editingDevice.image" class="mt-3 text-center">
                  <div class="alert alert-warning">
                    <i class="ri-error-warning-line"></i> 無法載入圖片，請確認URL是否正確
                  </div>
                </div>
              </div>
              
              <div class="mb-3 form-check">
                <input type="checkbox" class="form-check-input" id="deviceIsOnline" v-model="editingDevice.isOnline">
                <label class="form-check-label" for="deviceIsOnline">上架狀態</label>
              </div>
            </form>
          </div>
          <div class="modal-footer">
            <button type="button" class="btn btn-secondary" @click="closeEditModal">取消</button>
            <button type="button" class="btn btn-primary" @click="submitDeviceForm">儲存</button>
          </div>
        </div>
      </div>
    </div>

    <!-- 新增輔具分類對話框 -->
    <div class="modal fade" :class="{ 'show d-block': showCategoryModal }" tabindex="-1" role="dialog">
      <div class="modal-dialog modal-sm">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title">新增輔具分類</h5>
            <button type="button" class="btn-close" @click="closeCategoryModal"></button>
          </div>
          <div class="modal-body">
            <form @submit.prevent="submitCategoryForm">
              <!-- 分類名稱 -->
              <div class="mb-3">
                <label for="categoryName" class="form-label">分類名稱</label>
                <input type="text" class="form-control" id="categoryName" v-model="newCategory.name" required>
                <div v-if="categoryFormError.name" class="form-text text-danger">{{ categoryFormError.name }}</div>
              </div>
              
              <!-- 排序用分類ID -->
              <div class="mb-3">
                <label for="categoryId" class="form-label">排序順序</label>
                <input type="number" class="form-control" id="categoryId" v-model.number="newCategory.categoryId" min="0">
                <div class="form-text text-muted">數字越小越靠前顯示</div>
              </div>
            </form>
          </div>
          <div class="modal-footer">
            <button type="button" class="btn btn-secondary" @click="closeCategoryModal">取消</button>
            <button type="button" class="btn btn-primary" @click="submitCategoryForm" :disabled="categoryFormLoading">
              <span v-if="categoryFormLoading" class="spinner-border spinner-border-sm me-2" role="status" aria-hidden="true"></span>
              新增
            </button>
          </div>
        </div>
      </div>
    </div>

    
    <!-- 批次修改對話框 (舊版單一屬性批次修改，保留但不使用) -->
    <div class="modal fade" :class="{ 'show d-block': showBatchEditModal }" tabindex="-1" role="dialog" 
         :style="{ 'background-color': showBatchEditModal ? 'rgba(0,0,0,0.5)' : '' }">
      <div class="modal-dialog">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title">{{ getBatchEditTitle() }}</h5>
            <button type="button" class="btn-close" @click="closeBatchEditModal"></button>
          </div>
          <div class="modal-body">
            <div v-if="selectedIds.length > 0" class="alert alert-info">
              <i class="ri-information-line me-2"></i>
              <span>您已選擇 {{ selectedIds.length }} 個輔具進行批次修改</span>
            </div>
            
            <!-- 選擇輔具列表 (可摺疊) -->
            <div class="mb-3">
              <a 
                class="d-flex justify-content-between text-decoration-none" 
                data-bs-toggle="collapse" 
                href="#selectedDevicesList"
              >
                <span>已選擇的輔具</span>
                <i class="ri-arrow-down-s-line"></i>
              </a>
              <div class="collapse" id="selectedDevicesList">
                <div class="card card-body mt-2">
                  <ul class="list-group list-group-flush">
                    <li v-for="id in selectedIds" :key="id" class="list-group-item px-0 py-1 d-flex justify-content-between">
                      <span>{{ getDeviceNameById(id) }}</span>
                      <button class="btn btn-sm btn-link text-danger p-0" 
                              @click="removeFromSelection(id)">
                        <i class="ri-close-line"></i>
                      </button>
                    </li>
                  </ul>
                </div>
              </div>
            </div>
            
            <!-- 批次修改屬性表單 -->
            <div class="mb-3">
              <template v-if="batchEditField === 'isOnline'">
                <label class="form-label">上架狀態</label>
                <div class="d-flex gap-3">
                  <div class="form-check">
                    <input class="form-check-input" type="radio" id="statusOnline" 
                          v-model="batchEditValue" :value="true">
                    <label class="form-check-label" for="statusOnline">
                      上架
                    </label>
                  </div>
                  <div class="form-check">
                    <input class="form-check-input" type="radio" id="statusOffline" 
                          v-model="batchEditValue" :value="false">
                    <label class="form-check-label" for="statusOffline">
                      下架
                    </label>
                  </div>
                </div>
              </template>
              
              <template v-else-if="batchEditField === 'unitPrice'">
                <label for="batchPrice" class="form-label">單價調整</label>
                <div class="mb-3">
                  <select class="form-select mb-2" v-model="priceAdjustmentType">
                    <option value="fixed">設定為固定價格</option>
                    <option value="increase">增加固定金額</option>
                    <option value="decrease">減少固定金額</option>
                    <option value="percentage_increase">百分比增加</option>
                    <option value="percentage_decrease">百分比減少</option>
                  </select>
                  
                  <div class="input-group mt-2">
                    <span v-if="priceAdjustmentType === 'percentage_increase' || priceAdjustmentType === 'percentage_decrease'" 
                          class="input-group-text">%</span>
                    <span v-else class="input-group-text">NT$</span>
                    <input type="number" class="form-control" id="batchPrice" 
                          v-model.number="batchEditValue" min="0" step="10">
                  </div>
                  
                  <div class="form-text text-muted mt-2">
                    <template v-if="priceAdjustmentType === 'fixed'">所有選擇的輔具價格將設為 NT$ {{ batchEditValue }}</template>
                    <template v-else-if="priceAdjustmentType === 'increase'">所有選擇的輔具價格將增加 NT$ {{ batchEditValue }}</template>
                    <template v-else-if="priceAdjustmentType === 'decrease'">所有選擇的輔具價格將減少 NT$ {{ batchEditValue }}</template>
                    <template v-else-if="priceAdjustmentType === 'percentage_increase'">所有選擇的輔具價格將增加 {{ batchEditValue }}%</template>
                    <template v-else-if="priceAdjustmentType === 'percentage_decrease'">所有選擇的輔具價格將減少 {{ batchEditValue }}%</template>
                  </div>
                </div>
              </template>
              
              <template v-else-if="batchEditField === 'inventory'">
                <label for="batchInventory" class="form-label">庫存調整</label>
                <div class="mb-3">
                  <select class="form-select mb-2" v-model="inventoryAdjustmentType">
                    <option value="fixed">設定為固定數量</option>
                    <option value="increase">增加數量</option>
                    <option value="decrease">減少數量</option>
                  </select>
                  
                  <input type="number" class="form-control mt-2" id="batchInventory" 
                        v-model.number="batchEditValue" min="0">
                        
                  <div class="form-text text-muted mt-2">
                    <template v-if="inventoryAdjustmentType === 'fixed'">所有選擇的輔具庫存將設為 {{ batchEditValue }}</template>
                    <template v-else-if="inventoryAdjustmentType === 'increase'">所有選擇的輔具庫存將增加 {{ batchEditValue }}</template>
                    <template v-else-if="inventoryAdjustmentType === 'decrease'">所有選擇的輔具庫存將減少 {{ batchEditValue }} (若結果為負數將自動設為 0)</template>
                  </div>
                </div>
              </template>
              
              <template v-else-if="batchEditField === 'categoryId'">
                <label for="batchCategory" class="form-label">選擇分類</label>
                <select class="form-select" id="batchCategory" v-model="batchEditValue" required>
                  <option value="" disabled>請選擇分類</option>
                  <option v-for="category in categories" :key="category.id" :value="category.id">
                    {{ category.name }}
                  </option>
                </select>
              </template>
            </div>
            
            <div class="alert alert-warning mt-3">
              <i class="ri-alert-line"></i>
              注意：此操作將批次修改所有選擇的輔具。請確認後執行。
            </div>
          </div>
          <div class="modal-footer">
            <button type="button" class="btn btn-secondary" @click="closeBatchEditModal">取消</button>
            <button type="button" class="btn btn-primary" @click="submitBatchEdit" 
                    :disabled="batchLoading || selectedIds.length === 0">
              <span v-if="batchLoading" class="spinner-border spinner-border-sm me-2" role="status" aria-hidden="true"></span>
              {{ batchLoading ? '處理中...' : '確認修改' }}
            </button>
          </div>
        </div>
      </div>
    </div>
    
    <!-- 新版批次編輯對話框 (可同時修改多個屬性) -->
    <div class="modal fade" :class="{ 'show d-block': showBatchEditTableModal }" tabindex="-1" role="dialog" 
         :style="{ 'background-color': showBatchEditTableModal ? 'rgba(0,0,0,0.5)' : '' }">
      <div class="modal-dialog modal-xl">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title">批次編輯輔具</h5>
            <button type="button" class="btn-close" @click="closeBatchEditTableModal"></button>
          </div>
          <div class="modal-body">
            <div v-if="selectedIds.length > 0" class="alert alert-info mb-3">
              <i class="ri-information-line me-2"></i>
              <span>您已選擇 {{ selectedIds.length }} 個輔具進行批次編輯</span>
            </div>
            
            <!-- 批次編輯表格 -->
            <div class="table-responsive">
              <table class="table table-bordered table-hover">
                <thead class="table-light">
                  <tr>
                    <th style="width: 50px">序號</th>
                    <th style="width: 80px">輔具圖片</th>
                    <th style="width: 150px">輔具名稱</th>
                    <th style="width: 120px">商品貨號</th>
                    <th style="width: 120px">單價</th>
                    <th style="width: 100px">庫存數量</th>
                    <th style="width: 120px">分類</th>
                    <th style="width: 100px">上架狀態</th>
                  </tr>
                </thead>
                <tbody>
                  <tr v-for="device in editingDevices" :key="device.id">
                    <td class="text-center">{{ device.id }}</td>
                    <td class="text-center">
                      <img :src="getDeviceImage(device)" alt="" class="radius-8" style="width: 40px; height: 40px; object-fit: cover;">
                      <div class="mt-1">
                        <button class="btn btn-sm btn-outline-secondary p-0 px-1" @click="openImageSelector(device)">
                          <i class="ri-image-line"></i>
                        </button>
                      </div>
                    </td>
                    <td>
                      <input type="text" class="form-control form-control-sm" v-model="device.name">
                    </td>
                    <td>
                      <input type="text" class="form-control form-control-sm" v-model="device.sku">
                    </td>
                    <td>
                      <div class="input-group input-group-sm">
                        <span class="input-group-text">NT$</span>
                        <input type="number" class="form-control" v-model.number="device.unitPrice" min="0">
                      </div>
                    </td>
                    <td>
                      <input type="number" class="form-control form-control-sm" v-model.number="device.inventory" min="0">
                    </td>
                    <td>
                      <select class="form-select form-select-sm" v-model="device.categoryId">
                        <option v-for="category in categories" :key="category.id" :value="category.id">
                          {{ category.name }}
                        </option>
                      </select>
                    </td>
                    <td>
                      <div class="form-check form-switch">
                        <input class="form-check-input" type="checkbox" v-model="device.isOnline"
                               :id="'status-switch-' + device.id">
                        <label class="form-check-label" :for="'status-switch-' + device.id">
                          {{ device.isOnline ? '已上架' : '未上架' }}
                        </label>
                      </div>
                    </td>
                  </tr>
                </tbody>
              </table>
            </div>
            
            <div class="alert alert-warning mt-3">
              <i class="ri-alert-line"></i>
              注意：此操作將批次修改所有選擇的輔具資料。請確認後執行。
            </div>
          </div>
          <div class="modal-footer">
            <button type="button" class="btn btn-secondary" @click="closeBatchEditTableModal">取消</button>
            <button type="button" class="btn btn-primary" @click="submitBatchTableEdit" 
                    :disabled="batchLoading">
              <span v-if="batchLoading" class="spinner-border spinner-border-sm me-2" role="status" aria-hidden="true"></span>
              {{ batchLoading ? '處理中...' : '確認修改' }}
            </button>
          </div>
        </div>
      </div>
    </div>
    
    <!-- 圖片選擇對話框 -->
    <div class="modal fade" :class="{ 'show d-block': showImageSelectorModal }" tabindex="-1" role="dialog" 
         :style="{ 'background-color': showImageSelectorModal ? 'rgba(0,0,0,0.5)' : '' }">
      <div class="modal-dialog modal-sm">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title">選擇輔具圖片</h5>
            <button type="button" class="btn-close" @click="closeImageSelector"></button>
          </div>
          <div class="modal-body">
            <div class="image-grid">
              <div v-for="(imagePath, idx) in Object.values(deviceImages)" :key="idx" 
                   class="image-item" 
                   :class="{ 'selected': currentEditingDevice && currentEditingDevice.image === imagePath }"
                   @click="selectDeviceImage(imagePath)">
                <img :src="imagePath" alt="輔具圖片" class="img-thumbnail">
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
    
    <!-- 批次刪除確認對話框 -->
    <div class="modal fade" :class="{ 'show d-block': showDeleteConfirmModal }" tabindex="-1" role="dialog" 
         :style="{ 'background-color': showDeleteConfirmModal ? 'rgba(0,0,0,0.5)' : '' }">
      <div class="modal-dialog">
        <div class="modal-content">
          <div class="modal-header bg-danger text-white">
            <h5 class="modal-title">
              <i class="ri-error-warning-line me-2"></i>
              確認批次刪除
            </h5>
            <button type="button" class="btn-close btn-close-white" @click="closeDeleteConfirmModal"></button>
          </div>
          <div class="modal-body">
            <div class="alert alert-danger">
              <strong>警告：</strong> 您即將刪除 <strong>{{ selectedIds.length }}</strong> 個輔具，此操作<strong>不可復原</strong>！
            </div>
            
            <p>即將刪除的輔具清單：</p>
            <div class="delete-list-container">
              <ul class="list-group">
                <li v-for="id in selectedIds" :key="id" class="list-group-item d-flex justify-content-between align-items-center">
                  <span>{{ getDeviceNameById(id) }}</span>
                  <span class="badge bg-danger rounded-pill">ID: {{ id }}</span>
                </li>
              </ul>
            </div>
            
            <div class="form-check mt-3">
              <input class="form-check-input" type="checkbox" v-model="deleteConfirmed" id="deleteConfirmCheck">
              <label class="form-check-label" for="deleteConfirmCheck">
                我已了解此操作將永久刪除所選輔具，且不可恢復。
              </label>
            </div>
          </div>
          <div class="modal-footer">
            <button type="button" class="btn btn-secondary" @click="closeDeleteConfirmModal">取消</button>
            <button type="button" class="btn btn-danger" 
                   @click="confirmBatchDelete" 
                   :disabled="!deleteConfirmed || batchLoading">
              <span v-if="batchLoading" class="spinner-border spinner-border-sm me-2" role="status" aria-hidden="true"></span>
              {{ batchLoading ? '處理中...' : '確認刪除' }}
            </button>
          </div>
        </div>
      </div>
    </div>

    <!-- 檢視輔具的 Modal -->
    <div class="modal fade" id="viewDeviceModal" tabindex="-1" aria-labelledby="viewDeviceModalLabel" aria-hidden="true">
      <div class="modal-dialog modal-lg">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title" id="viewDeviceModalLabel">輔具詳情</h5>
            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
          </div>
          <div class="modal-body" v-if="viewingDevice">
            <div class="row">
              <div class="col-md-4 text-center">
                <img :src="viewingDevice.image || defaultImage" class="img-fluid mb-3" alt="輔具圖片">
              </div>
              <div class="col-md-8">
                <table class="table table-bordered">
                  <tbody>
                    <tr>
                      <th width="30%">輔具名稱</th>
                      <td>{{ viewingDevice.name }}</td>
                    </tr>
                    <tr>
                      <th>商品貨號</th>
                      <td>{{ viewingDevice.sku }}</td>
                    </tr>
                    <tr>
                      <th>單價</th>
                      <td>NT$ {{ viewingDevice.unitPrice }}</td>
                    </tr>
                    <tr>
                      <th>庫存數量</th>
                      <td>{{ viewingDevice.inventory }}</td>
                    </tr>
                    <tr>
                      <th>上架狀態</th>
                      <td>
                        <span :class="viewingDevice.isOnline ? 'badge bg-success' : 'badge bg-secondary'">
                          {{ viewingDevice.isOnline ? '已上架' : '未上架' }}
                        </span>
                      </td>
                    </tr>
                    <tr>
                      <th>輔具分類</th>
                      <td>{{ getCategoryName(viewingDevice.categoryId) }}</td>
                    </tr>
                  </tbody>
                </table>
              </div>
            </div>
            <div class="row mt-3">
              <div class="col-12">
                <h6>輔具描述</h6>
                <p>{{ viewingDevice.description || '無描述資料' }}</p>
              </div>
            </div>
          </div>
          <div class="modal-footer">
            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">關閉</button>
          </div>
        </div>
      </div>
    </div>
    
    <!-- 輔具詳情側邊檢視面板 -->
    <div class="device-detail-panel" :class="{ 'active': isDeviceDetailVisible }">
      <div class="device-detail-content">
        <!-- 關閉按鈕 -->
        <div class="device-detail-header">
          <h5 class="mb-0">輔具詳情</h5>
          <button type="button" class="btn-close" @click="closeDeviceDetail"></button>
        </div>
        
        <!-- 輔具詳情內容，參照 ViewProfile.vue 的左側面板設計 -->
        <div v-if="currentDevice" class="device-detail-body">
          <!-- 輔具圖片和名稱區域 -->
          <div class="user-grid-card position-relative border radius-16 overflow-hidden bg-base h-100">
            <div class="pb-3 text-center mt--50">
              <!-- 輔具圖片 -->
              <img :src="getDeviceImage(currentDevice)" alt=""
                class="border border-2 bg-white shadow-sm rounded-circle object-fit-cover"
                style="width: 100px; height: 100px;"
              />
              <!-- 輔具名稱和貨號 -->
              <h6 class="mb-0 mt-3">{{ currentDevice.name }}</h6>
              <span class="text-secondary-light">{{ currentDevice.sku }}</span>
            </div>
          </div>
          
          <!-- 輔具基本資訊區域 -->
          <div class="mt-4">
            <h6 class="text-xl mb-3">輔具基本資料</h6>
            <ul class="list-unstyled">
              <!-- 編號 -->
              <li class="d-flex align-items-center gap-2 mb-3">
                <span class="w-30 text-md fw-semibold text-primary-light">編號</span>
                <span class="w-70 text-secondary-light fw-medium">: {{ currentDevice.id }}</span>
              </li>
              
              <!-- 輔具名稱 -->
              <li class="d-flex align-items-center gap-2 mb-3">
                <span class="w-30 text-md fw-semibold text-primary-light">輔具名稱</span>
                <span class="w-70 text-secondary-light fw-medium">: {{ currentDevice.name }}</span>
              </li>
              
              <!-- SKU 商品貨號 -->
              <li class="d-flex align-items-center gap-2 mb-3">
                <span class="w-30 text-md fw-semibold text-primary-light">商品貨號</span>
                <span class="w-70 text-secondary-light fw-medium">: {{ currentDevice.sku }}</span>
              </li>
              
              <!-- 單價 -->
              <li class="d-flex align-items-center gap-2 mb-3">
                <span class="w-30 text-md fw-semibold text-primary-light">單價</span>
                <span class="w-70 text-secondary-light fw-medium">: NT$ {{ currentDevice.unitPrice }}</span>
              </li>
              
              <!-- 庫存數量 -->
              <li class="d-flex align-items-center gap-2 mb-3">
                <span class="w-30 text-md fw-semibold text-primary-light">庫存數量</span>
                <span class="w-70 text-secondary-light fw-medium">: {{ currentDevice.inventory }}</span>
              </li>
              
              <!-- 上架狀態 -->
              <li class="d-flex align-items-center gap-2 mb-3">
                <span class="w-30 text-md fw-semibold text-primary-light">上架狀態</span>
                <span class="w-70">
                  <span :class="statusClasses(currentDevice.isOnline)" class="px-3 py-1 rounded-pill fw-medium text-sm">
                    {{ currentDevice.isOnline ? '已上架' : '未上架' }}
                  </span>
                </span>
              </li>
              
              <!-- 分類 -->
              <li class="d-flex align-items-center gap-2 mb-3">
                <span class="w-30 text-md fw-semibold text-primary-light">輔具分類</span>
                <span class="w-70 text-secondary-light fw-medium">: {{ getCategoryName(currentDevice.categoryId) }}</span>
              </li>
            </ul>
          </div>
          
          <!-- 輔具描述區域 -->
          <div class="mt-4">
            <h6 class="text-xl mb-3">輔具描述</h6>
            <p class="text-secondary-light">{{ currentDevice.description || '暫無描述資料' }}</p>
          </div>
        </div>
      </div>
      
      <!-- 修改這個遮罩層，只在側邊面板顯示時才出現 -->
      <div class="device-detail-backdrop" v-if="isDeviceDetailVisible" @click="closeDeviceDetail"></div>
    </div>
  </div>
</template>

<script>
import { ref, computed, onMounted } from 'vue';
import Pagination from '@/components/pagination/index.vue';
import deviceService from '@/services/deviceService';
import useDevices from '@/composables/useDevices';
import useDeviceCategories from '@/composables/useDeviceCategories';

// 引入輔具圖片
import defaultImageUrl from '@/assets/images/device/tri-walker.png';
import caneImage from '@/assets/images/device/cane.jpg';
import triWalkerImage from '@/assets/images/device/tri-walker.png';
import bedrailImage from '@/assets/images/device/Bed rail.png';
import hospitalBedImage from '@/assets/images/device/Electric hospital bed.png';
import wheelchairImage from '@/assets/images/device/wheelchair.jpg';

// 引入其他輔具圖片
import commedechairImageSrc from '@/assets/images/device/Commode chair.webp';
import showerchairImageSrc from '@/assets/images/device/Shower chair.webp';
import nursingBedImageSrc from '@/assets/images/device/Multi-functional nursing bed.jpg';
import patientLiftImageSrc from '@/assets/images/device/Electric patient lift.webp';
import nonslipmatImageSrc from '@/assets/images/device/Non-slip mat.jpg';
import { useToast } from '@/composables/useToast'; // 引入 toast 元件

// 定義輔具圖片常數
const commodechairImage = commedechairImageSrc;
const showerchairImage = showerchairImageSrc;
const nonslipmatImage = nonslipmatImageSrc;
const nursingBedImage = nursingBedImageSrc;
const patientLiftImage = patientLiftImageSrc;

export default {
  name: "DeviceTable",
  components: { Pagination },
  setup() {
    // 使用輔具狀態管理
    const { devices, isLoading, error, fetchDevices } = useDevices();

    // 使用分類狀態管理
    const { 
      categories, 
      isLoading: isCategoryLoading, 
      error: categoryError, 
      fetchCategories,
      addCategory
    } = useDeviceCategories();
    
    // 提前初始化變數，避免 undefined 錯誤
    const filteredDevices = ref([]);
    
    // 載入分類資料
    onMounted(async () => {
      try {
        await fetchCategories();
      } catch (err) {
        console.error('載入分類資料失敗:', err);
      }
    });
    
    const { 
      batchUpdateDeviceStatus, 
      batchUpdateDeviceProperty,
      batchDeleteDevices
    } = useDevices();
    
    return {
      devices,
      isLoading,
      error,
      fetchDevices,
      filteredDevices,
      // 返回分類相關資料
      categories,
      isCategoryLoading,
      categoryError,
      fetchCategories,
      addCategory,
      // 批次操作方法
      batchUpdateDeviceStatus,
      batchUpdateDeviceProperty,
      batchDeleteDevices
    };
  },
  data() {
    return {
      selectedShow: 10,
      searchText: '',
      selectedStatus: '',
      selectAll: false,
      selectedIds: [],
      currentPage: 1,
      loading: false,
      error: null,
      
      // 批次修改相關
      showBatchEditModal: false,
      batchEditField: null, // 要批次修改的欄位
      batchEditValue: null, // 批次修改的值
      priceAdjustmentType: 'fixed', // 價格調整類型
      inventoryAdjustmentType: 'fixed', // 庫存調整類型
      
      // 批次編輯表格相關
      showBatchEditTableModal: false,
      editingDevices: [], // 用於批次編輯的輔具陣列
      
      // 圖片選擇對話框相關
      showImageSelectorModal: false,
      currentEditingDevice: null, // 當前正在編輯圖片的輔具
      
      // 批次刪除確認對話框
      showDeleteConfirmModal: false,
      deleteConfirmed: false, // 刪除確認勾選框
      
      // 圖片相關
      imagePreviewUrl: '',
      defaultImage: defaultImageUrl, // 使用引入的預設圖片
      
      // 建立輔具圖片映射表，保存正確引入的圖片路徑
      deviceImages: {
        '三段式拐杖': caneImage,
        '拐杖': caneImage,
        '標準助行器': triWalkerImage,
        '助行器': triWalkerImage,
        '便盆椅': commodechairImage,
        '洗澡椅': showerchairImage,
        '防滑墊': nonslipmatImage,
        '床欄桿': bedrailImage,
        '電動病床': hospitalBedImage,
        '電動照護床': nursingBedImage,
        '多功能照護床': nursingBedImage,
        '電動移位機': patientLiftImage,
        '輪椅': wheelchairImage,
        '電動輪椅': wheelchairImage,
        '鋁面輪椅': wheelchairImage
      },
      
      // 圖片選項 - 用於下拉選單
      imageOptions: [
        { label: '請選擇圖片', value: '' },
        { label: '拐杖', value: caneImage },
        { label: '標準助行器', value: triWalkerImage },
        { label: '便盆椅', value: commodechairImage },
        { label: '洗澡椅', value: showerchairImage },
        { label: '防滑墊', value: nonslipmatImage },
        { label: '床欄桿', value: bedrailImage },
        { label: '電動病床', value: hospitalBedImage },
        { label: '多功能照護床', value: nursingBedImage },
        { label: '電動移位機', value: patientLiftImage },
        { label: '輪椅', value: wheelchairImage }
      ],
      
      // 是否為管理員
      isAdmin: true,
      
      // 批次操作共用狀態
      batchLoading: false,
      
      // 編輯相關狀態
      showEditModal: false,
      isNewDevice: false,
      editingDevice: {
        id: null,
        name: '',
        sku: '',
        unitPrice: 0,
        inventory: 0,
        description: '',
        image: '',
        isOnline: true,
        categoryId: '', // 更改為空字串，預設需要選擇
        createdByEmpId: 1
      },
      originalDevice: {},
      
      // 新增分類相關資料
      showCategoryModal: false,
      categoryFormLoading: false,
      newCategory: {
        name: '',
        categoryId: 0
      },
      categoryFormError: {
        name: ''
      },
      
      // 新增輔具詳情相關狀態
      isDeviceDetailVisible: false,
      currentDevice: null,
    };
  },
  computed: {
    // 計算每頁顯示數量
    entriesPerPage() {
      return Number(this.selectedShow);
    },
    
    // 過濾資料 - 確保 devices 不為 undefined
    filteredData() {
      // 防止 devices 為 undefined
      if (!this.devices || !Array.isArray(this.devices)) {
        return [];
      }
      
      let result = this.devices;

      // 關鍵字搜尋過濾
      if (this.searchText) {
        const search = this.searchText.toLowerCase();
        result = result.filter(device =>
          device.name?.toLowerCase().includes(search) ||
          device.sku?.toLowerCase().includes(search)
        );
      }

      // 狀態過濾
      if (this.selectedStatus !== '') {
        // 將字串轉為布林值進行比較
        const status = this.selectedStatus === 'true';
        result = result.filter(device => device.isOnline === status);
      }

      return result;
    },
    
    // 計算總項目數
    totalEntries() {
      return this.filteredData.length;
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
    
    // 獲取當前頁顯示的輔具資料
    filteredDevices() {
      // 確保 filteredData 不為 undefined
      return Array.isArray(this.filteredData) ? this.filteredData.slice(this.startIndex, this.endIndex) : [];
    }
  },
  watch: {
    // 監聽篩選條件變化，重置頁碼
    selectedShow() {
      this.currentPage = 1;
    },
    searchText() {
      this.currentPage = 1;
    },
    selectedStatus() {
      this.currentPage = 1;
    }
  },
  created() {
    // 元件建立時載入資料
    this.loadDevices();
  },
  methods: {
    // 使用 Toast 通知功能
    showToast(message) {
      const { showToast } = useToast();
      showToast(message);
    },
    // 將 showToast 方法注入到 this 中，讓所有方法都能使用
    injectToast() {
      const { showToast } = useToast();
      this.showToast = showToast;
    },
    // 載入輔具資料
    async loadDevices() {
      try {
        // 使用 fetchDevices 方法獲取輔具資料
        await this.fetchDevices(true);
      } catch (error) {
        console.error('載入輔具資料失敗:', error);
        this.error = '無法載入輔具資料，請稍後再試';
      }
    },
    
    // 切換全選
    toggleSelectAll() {
      if (!this.filteredDevices) return; // 防止 undefined 錯誤
      
      if (this.selectAll) {
        this.selectedIds = this.filteredDevices.map(device => device.id);
      } else {
        this.selectedIds = [];
      }
    },
    
    // 狀態樣式設定
    statusClasses(isOnline) {
      return {
        'bg-success-focus text-success-main': isOnline === true,
        'bg-warning-focus text-warning-main': isOnline === false
      };
    },
    
    // 切換頁碼
    goToPage(page) {
      if (page >= 1 && page <= this.totalPages) {
        this.currentPage = page;
      }
    },
    
    changePage(page) {
      this.goToPage(page);
    },
    
    // 刪除輔具
    async deleteDevice(id) {
      if (confirm('確定要刪除此輔具嗎？')) {
        try {
          await deviceService.deleteDevice(id);
          // 重新載入資料
          this.fetchDevices(true);
          this.showToast({
            title: '刪除成功',
            message: `已刪除輔具 ID :${id}`,
            type: 'success'
          });
        } catch (error) {
          this.showToast({
            title: '刪除失敗 !',
            message: error.message,
            type: 'error'
          });
        }
      }
    },
    
    // 預覽圖片 - 修正路徑處理
    previewImage() {
      // 先清空預覽
      this.imagePreviewUrl = '';
      
      // 檢查URL是否存在
      if (!this.editingDevice.image) return;
      
      // 直接使用引入的圖片路徑
      this.imagePreviewUrl = this.editingDevice.image;
    },
    
    // 開啟編輯對話框
    openEditModal(device) {
      this.isNewDevice = false;
      // 深拷貝裝置資料，避免直接修改原始資料
      this.editingDevice = JSON.parse(JSON.stringify(device));
      this.originalDevice = JSON.parse(JSON.stringify(device));
      this.showEditModal = true;
      
      // 預覽現有圖片
      this.$nextTick(() => {
        this.previewImage();
      });
      
      // 確保分類資料已載入
      this.loadCategories();
    },
    
    // 關閉編輯對話框
    closeEditModal() {
      this.showEditModal = false;
      this.imagePreviewUrl = '';
      
      // 延遲清空編輯資料，避免對話框關閉時的閃爍
      setTimeout(() => {
        this.editingDevice = {
          id: null,
          name: '',
          sku: '',
          unitPrice: 0,
          inventory: 0,
          description: '',
          image: '',
          isOnline: true,
          categoryId: '', // 更改為空字串，預設需要選擇
          createdByEmpId: 1
        };
      }, 300);
    },
    
    // 開啟新增輔具對話框
    openAddDeviceModal() {
      this.isNewDevice = true;
      this.editingDevice = {
        id: null,
        name: '',
        sku: '',
        unitPrice: 0,
        inventory: 0,
        description: '',
        image: '',
        isOnline: true,
        categoryId: '', // 預設為空，需要選擇
        createdByEmpId: 1
      };
      this.showEditModal = true;
      this.imagePreviewUrl = '';
      
      // 確保分類資料已載入
      this.loadCategories();
    },
    
    // 載入分類資料
    async loadCategories() {
      // 如果分類尚未載入，則載入分類資料
      if (this.categories.length === 0 && !this.isCategoryLoading) {
        try {
          await this.fetchCategories();
        } catch (error) {
          console.error('載入分類資料失敗:', error);
        }
      }
    },
    
    // 開啟新增分類對話框
    openCategoryModal() {
      // 重置分類表單資料
      this.newCategory = {
        name: '',
        categoryId: 0
      };
      this.categoryFormError = { name: '' };
      this.showCategoryModal = true;
    },
    
    // 關閉分類對話框
    closeCategoryModal() {
      this.showCategoryModal = false;
    },
    
    // 提交新增分類表單
    async submitCategoryForm() {
      // 表單驗證
      this.categoryFormError = { name: '' };
      
      if (!this.newCategory.name || this.newCategory.name.trim() === '') {
        this.categoryFormError.name = '分類名稱不能為空';
        return;
      }
      
      this.categoryFormLoading = true;
      
      try {
        // 呼叫新增分類 API
        const newCategoryId = await this.addCategory(
          this.newCategory.name,
          this.newCategory.categoryId
        );
        
        // 如果成功新增，重新載入分類清單並選擇新分類
        if (newCategoryId) {
          // 重新載入分類資料
          await this.fetchCategories();
          
          // 設定當前編輯輔具的分類為新增的分類
          this.editingDevice.categoryId = newCategoryId;
          
          // 顯示成功訊息
          this.showToast({
            title: '新增成功',
            message: '新增分類成功',
            type: 'success'
          });
          
          // 關閉新增分類對話框
          this.closeCategoryModal();
        }
      } catch (error) {
        this.categoryFormError = { name: `新增失敗: ${error.message || '未知錯誤'}` };
        this.showToast({
          title: '新增失敗 !',
          message: error.message,
          type: 'error'
        });
      } finally {
        this.categoryFormLoading = false;
      }
    },
    
    // 提交輔具表單
    async submitDeviceForm() {
      // 表單驗證
      if (!this.editingDevice.name || !this.editingDevice.sku) {
        this.$toast?.error('請填寫輔具名稱和商品貨號') || alert('請填寫輔具名稱和商品貨號');
        return;
      }
      
      // 分類驗證
      if (!this.editingDevice.categoryId) {
        this.$toast?.error('請選擇輔具分類') || alert('請選擇輔具分類');
        return;
      }
      
      try {
        if (this.isNewDevice) {
          // 新增輔具
          await deviceService.addDevice(this.editingDevice);
          this.showToast({
            title: '新增成功',
            message: `新增輔具: ${this.editingDevice.name}`,
            type: 'success'
          });
        } else {
          // 更新輔具
          await deviceService.updateDevice(this.editingDevice);
          await deviceService.addDevice(this.editingDevice);
          this.showToast({
            title: '更新成功',
            message: `更新輔具: ${this.editingDevice.name}`,
            type: 'success'
          });
        }
        // 關閉對話框並重新載入資料
        this.closeEditModal();
        this.fetchDevices(true);
      } catch (error) {
          this.showToast({
            title: '存取失敗',
            message: error.message,
            type: 'error'
          });
      }
    },
    
    // 匯出CSV功能 - 前端直接處理
    exportToCSV() {
      try {
        // 確保有資料可匯出
        if (!this.devices || this.devices.length === 0) {
          alert('沒有資料可匯出');
          return;
        }
        
        // 1. 準備CSV資料
        const headers = ['序號', '輔具名稱', '商品貨號', '單價', '庫存數量', '上架狀態', '描述', '圖片連結'];
        
        const csvData = this.devices.map(device => {
          return [
            device.id,
            device.name,
            device.sku,
            device.unitPrice,
            device.inventory,
            device.isOnline ? '已上架' : '未上架',
            (device.description || '').replace(/"/g, '""'), // 處理描述中的引號
            device.image || ''
          ].map(field => typeof field === 'string' ? `"${field}"` : field);
        });
        
        // 2. 組合CSV內容
        const csvContent = `\uFEFF${headers.join(',')}\n${csvData.map(row => row.join(',')).join('\n')}`;
        
        // 3. 建立下載連結
        const blob = new Blob([csvContent], { type: 'text/csv;charset=utf-8;' });
        const url = URL.createObjectURL(blob);
        const link = document.createElement('a');
        const currentDate = new Date().toISOString().split('T')[0];
        
        // 4. 設定檔案名稱並觸發下載
        link.setAttribute('href', url);
        link.setAttribute('download', `輔具列表_${currentDate}.csv`);
        document.body.appendChild(link);
        link.click();
        document.body.removeChild(link);
        this.showToast({
            title: '匯入成功',
            message: `成功匯入一堆輔具`,
            type: 'success'
        });
      } catch (error) {
          this.showToast({
            title: '匯入失敗',
            message: error.message,
            type: 'error'
          });
      }
    },
    
    // 批量更新圖片功能已移除
    
    // 獲取輔具圖片 - 修正路徑處理
    getDeviceImage(device) {
      // 防止 device 為 undefined
      if (!device) return this.defaultImage;
      
      // 如果設備有圖片
      if (device.image) {
        return device.image;
      }
      
      // 嘗試根據名稱匹配圖片
      for (const [keyword, imagePath] of Object.entries(this.deviceImages)) {
        if (device.name && device.name.includes(keyword)) {
          return imagePath;
        }
      }
      
      // 否則使用預設圖片
      return this.defaultImage;
    },
    
    // 批次修改相關方法
    
    // 開啟批次修改對話框
    openBatchEditModal(field) {
      // 如果未選擇任何輔具，提示並返回
      if (this.selectedIds.length === 0) {
        this.$toast?.warning('請至少選擇一個輔具') || alert('請至少選擇一個輔具');
        return;
      }
      
      this.batchEditField = field;
      
      // 根據欄位類型設定預設值
      switch (field) {
        case 'isOnline':
          this.batchEditValue = true; // 預設為上架
          break;
        case 'unitPrice':
          this.batchEditValue = 0;
          this.priceAdjustmentType = 'fixed';
          break;
        case 'inventory':
          this.batchEditValue = 0;
          this.inventoryAdjustmentType = 'fixed';
          break;
        case 'categoryId':
          this.batchEditValue = '';
          break;
        default:
          this.batchEditValue = null;
      }
      
      this.showBatchEditModal = true;
    },
    
    // 關閉批次修改對話框
    closeBatchEditModal() {
      this.showBatchEditModal = false;
      this.batchEditField = null;
      this.batchEditValue = null;
    },
    
    // 根據批次修改欄位獲取標題
    getBatchEditTitle() {
      switch (this.batchEditField) {
        case 'isOnline':
          return '批次修改上架狀態';
        case 'unitPrice':
          return '批次修改價格';
        case 'inventory':
          return '批次修改庫存';
        case 'categoryId':
          return '批次修改分類';
        default:
          return '批次修改';
      }
    },
    
    // 根據 ID 獲取輔具名稱 (用於已選擇輔具列表)
    getDeviceNameById(id) {
      const device = this.devices.find(d => d.id === id);
      return device ? device.name : `輔具 ID: ${id}`;
    },
    
    // 從選中列表中移除某個輔具
    removeFromSelection(id) {
      this.selectedIds = this.selectedIds.filter(selectedId => selectedId !== id);
    },
    
    // 執行批次刪除
    async batchDelete() {
      if (this.selectedIds.length === 0) {
        this.$toast?.warning('請至少選擇一個輔具') || alert('請至少選擇一個輔具');
        return;
      }
      
      // 顯示批次刪除確認對話框
      this.showDeleteConfirmModal = true;
    },
    
    // 確認執行批次刪除
    async confirmBatchDelete() {
      this.batchLoading = true;
      
      try {
        await this.batchDeleteDevices(this.selectedIds);
        
        // 關閉確認對話框
        this.closeDeleteConfirmModal();
        
        // 清空選擇
        this.selectedIds = [];
        this.selectAll = false;
        
        // 顯示操作成功通知
        this.showToast({
          title: '刪除成功',
          message: `已執行批次刪除`,
          type: 'success'
        });
      } catch (error) {
        this.showToast({
          title: '刪除失敗 !',
          message: error.message,
          type: 'error'
        });
      } finally {
        this.batchLoading = false;
      }
    },
    
    // 關閉刪除確認對話框
    closeDeleteConfirmModal() {
      this.showDeleteConfirmModal = false;
    },
    
    // 提交批次修改
    async submitBatchEdit() {
      if (this.selectedIds.length === 0) {
        this.$toast?.warning('請至少選擇一個輔具') || alert('請至少選擇一個輔具');
        return;
      }
      
      this.batchLoading = true;
      
      try {
        // 根據不同欄位執行不同的批次修改邏輯
        switch (this.batchEditField) {
          case 'isOnline':
            // 簡單的上架/下架狀態修改
            await this.batchUpdateDeviceStatus(this.selectedIds, this.batchEditValue);
            break;
            
          case 'unitPrice':
            // 複雜的價格調整邏輯
            await this.handleBatchPriceUpdate();
            break;
            
          case 'inventory':
            // 複雜的庫存調整邏輯
            await this.handleBatchInventoryUpdate();
            break;
            
          case 'categoryId':
            // 分類修改
            await this.batchUpdateDeviceProperty(this.selectedIds, 'categoryId', this.batchEditValue);
            break;
            
          default:
            throw new Error('未知的批次修改欄位');
        }
        
        // 清空選擇
        this.selectedIds = [];
        this.selectAll = false;
        
        // 關閉對話框
        this.closeBatchEditModal();
        
        // 顯示成功消息
        this.showToast({
          title: '修改成功',
          message: `已執行批次修改`,
          type: 'success'
        });
      } catch (error) {
        this.showToast({
          title: '修改失敗',
          message: error.message,
          type: 'error'
        });
      } finally {
        this.batchLoading = false;
      }
    },
    
    // 處理批次價格更新的複雜邏輯
    async handleBatchPriceUpdate() {
      // 根據不同的價格調整類型進行處理
      const devicesToUpdate = this.devices.filter(device => this.selectedIds.includes(device.id));
      
      // 對每個裝置應用價格調整
      const updatedDevices = devicesToUpdate.map(device => {
        const original = { ...device };
        let newPrice = original.unitPrice;
        
        switch (this.priceAdjustmentType) {
          case 'fixed':
            // 設定為固定價格
            newPrice = this.batchEditValue;
            break;
            
          case 'increase':
            // 增加固定金額
            newPrice = original.unitPrice + this.batchEditValue;
            break;
            
          case 'decrease':
            // 減少固定金額，但不低於0
            newPrice = Math.max(0, original.unitPrice - this.batchEditValue);
            break;
            
          case 'percentage_increase':
            // 百分比增加
            newPrice = original.unitPrice * (1 + this.batchEditValue / 100);
            break;
            
          case 'percentage_decrease':
            // 百分比減少，但不低於0
            newPrice = Math.max(0, original.unitPrice * (1 - this.batchEditValue / 100));
            break;
        }
        
        // 四捨五入到整數
        newPrice = Math.round(newPrice);
        
        return { ...original, unitPrice: newPrice };
      });
      
      // 調用批次更新 API
      await this.batchUpdateDeviceProperty(this.selectedIds, 'unitPrice', null, updatedDevices);
    },
    
    // 處理批次庫存更新的複雜邏輯
    async handleBatchInventoryUpdate() {
      // 根據不同的庫存調整類型進行處理
      const devicesToUpdate = this.devices.filter(device => this.selectedIds.includes(device.id));
      
      // 對每個裝置應用庫存調整
      const updatedDevices = devicesToUpdate.map(device => {
        const original = { ...device };
        let newInventory = original.inventory;
        
        switch (this.inventoryAdjustmentType) {
          case 'fixed':
            // 設定為固定庫存
            newInventory = this.batchEditValue;
            break;
            
          case 'increase':
            // 增加庫存
            newInventory = original.inventory + this.batchEditValue;
            break;
            
          case 'decrease':
            // 減少庫存，但不低於0
            newInventory = Math.max(0, original.inventory - this.batchEditValue);
            break;
        }
        
        return { ...original, inventory: newInventory };
      });
      
      // 調用批次更新 API
      await this.batchUpdateDeviceProperty(this.selectedIds, 'inventory', null, updatedDevices);
    },
    
    // 批次編輯表格相關方法
    
    // 開啟批次編輯表格對話框
    openBatchEditTableModal() {
      if (this.selectedIds.length === 0) {
        this.$toast?.warning('請至少選擇一個輔具') || alert('請至少選擇一個輔具');
        return;
      }
      
      // 深度複製選中的輔具資料
      this.editingDevices = this.devices
        .filter(device => this.selectedIds.includes(device.id))
        .map(device => JSON.parse(JSON.stringify(device)));
      
      this.showBatchEditTableModal = true;
    },
    
    // 關閉批次編輯表格對話框
    closeBatchEditTableModal() {
      this.showBatchEditTableModal = false;
      this.editingDevices = [];
    },
    
    // 提交批次表格編輯
    async submitBatchTableEdit() {
      this.batchLoading = true;
      
      try {
        // 直接批次更新所有修改後的輔具
        await this.batchUpdateDeviceProperty(
          this.selectedIds, 
          null, 
          null, 
          this.editingDevices
        );
        
        // 清空選擇
        this.selectedIds = [];
        this.selectAll = false;
        
        // 關閉對話框
        this.closeBatchEditTableModal();
        
        this.showToast({
          title: '編輯成功',
          message: `已執行批次編輯`,
          type: 'success'
        });
      } catch (error) {
        this.showToast({
          title: '編輯失敗 !',
          message: error.message,
          type: 'error'
        });
      } finally {
        this.batchLoading = false;
      }
    },
    
    // 圖片選擇相關方法
    
    // 開啟圖片選擇器
    openImageSelector(device) {
      this.currentEditingDevice = device;
      this.showImageSelectorModal = true;
    },
    
    // 關閉圖片選擇器
    closeImageSelector() {
      this.showImageSelectorModal = false;
      this.currentEditingDevice = null;
    },
    
    // 選擇輔具圖片
    selectDeviceImage(imagePath) {
      if (this.currentEditingDevice) {
        this.currentEditingDevice.image = imagePath;
      }
      this.closeImageSelector();
    },
    
    // 新增顯示輔具詳情的方法
    showDeviceDetail(device) {
      // 設置當前選中的輔具
      this.currentDevice = JSON.parse(JSON.stringify(device));
      
      // 延遲顯示面板，增加過渡效果
      setTimeout(() => {
        this.isDeviceDetailVisible = true;
      }, 50);
    },
    
    // 關閉輔具詳情
    closeDeviceDetail() {
      // 先隱藏面板
      this.isDeviceDetailVisible = false;
      
      // 延遲清除當前選中的輔具，確保過渡動畫完成
      setTimeout(() => {
        this.currentDevice = null;
      }, 300);
    },
    
    // 根據分類 ID 獲取分類名稱
    getCategoryName(categoryId) {
      const category = this.categories.find(c => c.id === categoryId);
      return category ? category.name : '未分類';
    }
  }
};
</script>

<style scoped>
/* 確保模態框在顯示時有正確的z-index */
.modal.show {
  z-index: 1050;
}

/* 確保表格內容垂直置中 */
.table td {
  vertical-align: middle;
}

/* 圖片樣式 */
.radius-8 {
  border-radius: 8px;
  object-fit: cover;
}

/* 按鈕間距 */
.card-header .btn {
  margin-left: 4px;
}

/* 分類下拉選單右側按鈕樣式 */
.input-group .btn-outline-secondary {
  border-color: #ced4da;
}

.input-group .btn-outline-secondary:hover {
  background-color: #f8f9fa;
}

/* 批次修改相關樣式 */
.dropdown-menu {
  box-shadow: 0 3px 12px rgba(0, 0, 0, 0.15);
  border-radius: 8px;
}

.dropdown-item {
  padding: 8px 16px;
}

.dropdown-item i {
  margin-right: 8px;
  font-size: 1rem;
}

/* 已選擇輔具列表樣式 */
#selectedDevicesList .list-group-item {
  border-left: none;
  border-right: none;
  border-radius: 0;
}

#selectedDevicesList .list-group-item:first-child {
  border-top: none;
}

#selectedDevicesList .list-group-item:last-child {
  border-bottom: none;
}

/* 批次編輯表格樣式 */
.modal-xl {
  max-width: 90%;
}

.table-hover tbody tr:hover {
  background-color: rgba(0, 123, 255, 0.05);
}

/* 圖片選擇器樣式 */
.image-grid {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 10px;
  max-height: 400px;
  overflow-y: auto;
}

.image-item {
  cursor: pointer;
  border: 2px solid transparent;
  border-radius: 4px;
  transition: all 0.2s ease-in-out;
}

.image-item:hover {
  transform: scale(1.05);
}

.image-item.selected {
  border-color: #4CAF50;
  background-color: rgba(76, 175, 80, 0.1);
}

.image-item img {
  width: 100%;
  height: 80px;
  object-fit: contain;
}

/* 批次編輯表格中的表單元素樣式 */
.table td .form-control-sm {
  padding: 0.25rem 0.5rem;
  height: auto;
}

.table td .form-check-input {
  cursor: pointer;
}

.form-switch {
  padding-left: 2.5em;
}

/* 批次刪除確認對話框樣式 */
.delete-list-container {
  max-height: 300px;
  overflow-y: auto;
  border: 1px solid #dee2e6;
  border-radius: 4px;
}

.delete-list-container .list-group-item {
  padding: 0.5rem 1rem;
  border-left: none;
  border-right: none;
}

.delete-list-container .list-group-item:first-child {
  border-top: none;
}

.delete-list-container .list-group-item:last-child {
  border-bottom: none;
}

/* 刪除按鈕數量徽章樣式 */
.btn-danger .badge {
  position: relative;
  top: -1px;
}

/* 輔具詳情側邊面板樣式 */
.device-detail-panel {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100vh;
  z-index: 1060;
  display: flex;
  justify-content: center; /* 水平置中 */
  align-items: center; /* 垂直置中 */
  opacity: 0;
  visibility: hidden;
  transition: opacity 0.3s ease-in-out, visibility 0.3s ease-in-out;
}

.device-detail-panel.active {
  opacity: 1;
  visibility: visible;
}

.device-detail-content {
  width: 90%;
  max-width: 600px; /* 調整適合的最大寬度 */
  height: 80%; /* 高度調整為視窗的80% */
  max-height: 700px; /* 最大高度限制 */
  background-color: white;
  box-shadow: 0 5px 15px rgba(0, 0, 0, 0.2);
  border-radius: 8px;
  z-index: 1060; /* 確保高於遮罩層 */
  overflow-y: auto;
  display: flex;
  flex-direction: column;
  transform: translateY(-20px);
  transition: transform 0.3s ease-in-out;
}

.device-detail-panel.active .device-detail-content {
  transform: translateY(0);
}

.device-detail-backdrop {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background-color: rgba(0, 0, 0, 0.5);
  z-index: 1059; /* 確保低於內容但高於其他頁面元素 */
}

/* 調整面板頂部樣式，改為更像標準對話框 */
.device-detail-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 16px 20px;
  border-bottom: 1px solid #dee2e6;
  background-color: #f8f9fa;
  border-radius: 8px 8px 0 0; /* 圓角頂部 */
}

/* 響應式調整，使在小螢幕上也能正確顯示 */
@media (max-width: 576px) {
  .device-detail-content {
    width: 95%;
    height: 90%;
    max-height: none;
  }
}
</style>