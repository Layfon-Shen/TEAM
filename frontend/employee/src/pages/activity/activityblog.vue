<template>
    <div class="dashboard-main-body">
        <Breadcrumb title="活動管理" :breadcrumbs="[
            { name: '活動管理' }
        ]" />

        <div class="row gy-4">
            <!-- 活動列表 -->
            <div class="col-12">
                <div class="card">
                    <div class="card-header d-flex justify-content-between align-items-center">
                        <h5 class="card-title">活動列表</h5>
                        <!-- 新增活動按鈕 -->
                        <button class="btn btn-primary" @click="openAddModal">
                            <i class="fas fa-plus"></i> 新增活動
                        </button>
                    </div>
                    <div class="card-body">
                        <!-- 搜索和篩選 -->
                        <div class="row mb-3">
                            <div class="col-md-4">
                                <input type="text" class="form-control" v-model="searchText" placeholder="搜尋活動名稱...">
                            </div>
                            <div class="col-md-3">
                                <select class="form-select" v-model="filterCategory">
                                    <option value="">所有類別</option>
                                    <option value="手作">手作</option>
                                    <option value="音樂">音樂</option>
                                    <option value="運動">運動</option>
                                    <option value="烹飪">烹飪</option>
                                    <option value="展覽">展覽</option>
                                </select>
                            </div>
                            <div class="col-md-3">
                                <select class="form-select" v-model="filterStatus">
                                    <option value="">所有狀態</option>
                                    <option value="true">報名中</option>
                                    <option value="false">過去活動</option>
                                </select>
                            </div>
                        </div>

                        <!-- 活動卡片列表 -->
                        <div class="row gy-4">
                            <div class="col-lg-4 col-md-6" v-for="activity in filteredActivities" :key="activity.id">
                                <div class="card activity-card">
                                    <div class="position-relative">
                                        <img :src="activity.image || '/default-activity.jpg'" 
                                             class="card-img-top activity-image" 
                                             :alt="activity.name">
                                        <span class="badge position-absolute top-0 end-0 m-2" 
                                              :class="activity.status ? 'bg-success' : 'bg-danger'">
                                            {{ activity.status ? '報名中' : '過去活動' }}
                                        </span>
                                    </div>
                                    <div class="card-body">
                                        <h6 class="card-title">{{ activity.name }}</h6>
                                        <p class="text-muted small mb-2">{{ activity.category }}</p>
                                        
                                        <div class="activity-info">
                                            <div class="d-flex justify-content-between mb-2">
                                                <span class="text-muted">報名人數：</span>
                                                <span>{{ activity.current }}/{{ activity.limit }}</span>
                                            </div>
                                            <div class="progress mb-2" style="height: 6px;">
                                                <div class="progress-bar" 
                                                     :style="{width: (activity.current / activity.limit * 100) + '%'}">
                                                </div>
                                            </div>
                                            
                                            <div class="mb-2">
                                                <i class="fas fa-calendar text-muted"></i>
                                                <small class="ms-1">{{ formatDate(activity.date) }} - {{ formatDate(activity.end) }}</small>
                                            </div>
                                            <div class="mb-2">
                                                <i class="fas fa-clock text-muted"></i>
                                                <small class="ms-1">{{ activity.time }}</small>
                                            </div>
                                            <div class="mb-2">
                                                <i class="fas fa-map-marker-alt text-muted"></i>
                                                <small class="ms-1">{{ activity.location }}</small>
                                            </div>
                                            <div class="mb-2">
                                                <i class="fas fa-user text-muted"></i>
                                                <small class="ms-1">講師：{{ activity.instructor }}</small>
                                            </div>
                                            
                                            <div class="registration-period text-muted small">
                                                報名期間：{{ formatDate(activity.registrationStart) }} ~ {{ formatDate(activity.registrationEnd) }}
                                            </div>
                                        </div>
                                        
                                        <div class="mt-3">
                                            <p class="card-text small text-muted">{{ truncateDescription(activity.description) }}</p>
                                        </div>
                                    </div>
                                    <!-- 操作按鈕區域 -->
                                    <div class="card-footer d-flex justify-content-between">
                                        <button class="btn btn-sm btn-outline-info" @click="viewActivity(activity)">
                                            <i class="fas fa-eye"></i> 查看
                                        </button>
                                        <button class="btn btn-sm btn-outline-warning" @click="openEditModal(activity)">
                                            <i class="fas fa-edit"></i> 編輯
                                        </button>
                                        <button 
                                            class="btn btn-sm btn-outline-danger" 
                                            @click="deleteActivity(activity.id)"
                                            :disabled="loading">
                                            <i class="fas fa-trash"></i> 刪除
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- 無資料顯示 -->
                        <div v-if="filteredActivities.length === 0" class="text-center py-5">
                            <i class="fas fa-calendar-times fa-3x text-muted mb-3"></i>
                            <h5 class="text-muted">暫無活動資料</h5>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- 新增/編輯活動 Modal -->
        <div class="modal fade" id="activityModal" tabindex="-1" aria-labelledby="activityModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-xl">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="activityModalLabel">
                            {{ isEditMode ? '編輯活動' : '新增活動' }}
                        </h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <!-- 活動表單 -->
                        <form @submit.prevent="submitForm">
                            <div class="row">
                                <!-- 基本資訊 -->
                                <div class="col-md-6">
                                    <h6 class="text-primary mb-3">基本資訊</h6>
                                    
                                    <!-- 活動名稱 -->
                                    <div class="mb-3">
                                        <label for="activityName" class="form-label">活動名稱 <span class="text-danger">*</span></label>
                                        <input 
                                            type="text" 
                                            class="form-control" 
                                            id="activityName"
                                            v-model="form.name"
                                            required>
                                    </div>

                                    <!-- 活動類別 -->
                                    <div class="mb-3">
                                        <label for="activityCategory" class="form-label">活動類別 <span class="text-danger">*</span></label>
                                        <select class="form-select" id="activityCategory" v-model="form.category" required>
                                            <option value="">請選擇類別</option>
                                            <option value="手作">手作</option>
                                            <option value="音樂">音樂</option>
                                            <option value="運動">運動</option>
                                            <option value="烹飪">烹飪</option>
                                            <option value="展覽">展覽</option>
                                        </select>
                                    </div>

                                    <!-- 報名人數限制 -->
                                    <div class="row">
                                        <div class="col-6">
                                            <div class="mb-3">
                                                <label for="activityLimit" class="form-label">報名限制 <span class="text-danger">*</span></label>
                                                <input 
                                                    type="number" 
                                                    class="form-control" 
                                                    id="activityLimit"
                                                    v-model.number="form.limit"
                                                    min="1"
                                                    required>
                                            </div>
                                        </div>
                                        <div class="col-6">
                                            <div class="mb-3">
                                                <label for="activityCurrent" class="form-label">目前報名人數</label>
                                                <input 
                                                    type="number" 
                                                    class="form-control" 
                                                    id="activityCurrent"
                                                    v-model.number="form.current"
                                                    min="0">
                                            </div>
                                        </div>
                                    </div>

                                    <!-- 講師 -->
                                    <div class="mb-3">
                                        <label for="activityInstructor" class="form-label">講師</label>
                                        <input 
                                            type="text" 
                                            class="form-control" 
                                            id="activityInstructor"
                                            v-model="form.instructor">
                                    </div>

                                    <!-- 活動狀態 -->
                                    <div class="mb-3">
                                        <label class="form-label">活動狀態</label>
                                        <div class="form-check form-switch">
                                            <input 
                                                class="form-check-input" 
                                                type="checkbox" 
                                                id="activityStatus"
                                                v-model="form.status">
                                            <label class="form-check-label" for="activityStatus">
                                                {{ form.status ? '報名中' : '過去活動' }}
                                            </label>
                                        </div>
                                    </div>
                                </div>

                                <!-- 時間地點資訊 -->
                                <div class="col-md-6">
                                    <h6 class="text-primary mb-3">時間地點資訊</h6>
                                    
                                    <!-- 活動日期 -->
                                    <div class="row">
                                        <div class="col-6">
                                            <div class="mb-3">
                                                <label for="activityDate" class="form-label">活動開始日期 <span class="text-danger">*</span></label>
                                                <input 
                                                    type="date" 
                                                    class="form-control" 
                                                    id="activityDate"
                                                    v-model="form.date"
                                                    required>
                                            </div>
                                        </div>
                                        <div class="col-6">
                                            <div class="mb-3">
                                                <label for="activityEnd" class="form-label">活動結束日期</label>
                                                <input 
                                                    type="date" 
                                                    class="form-control" 
                                                    id="activityEnd"
                                                    v-model="form.end">
                                            </div>
                                        </div>
                                    </div>

                                    <!-- 活動時間 -->
                                    <div class="mb-3">
                                        <label for="activityTime" class="form-label">活動時間</label>
                                        <input 
                                            type="text" 
                                            class="form-control" 
                                            id="activityTime"
                                            v-model="form.time"
                                            placeholder="例：09:00-17:00">
                                    </div>

                                    <!-- 報名期間 -->
                                    <div class="row">
                                        <div class="col-6">
                                            <div class="mb-3">
                                                <label for="registrationStart" class="form-label">報名開始日期</label>
                                                <input 
                                                    type="date" 
                                                    class="form-control" 
                                                    id="registrationStart"
                                                    v-model="form.registrationStart">
                                            </div>
                                        </div>
                                        <div class="col-6">
                                            <div class="mb-3">
                                                <label for="registrationEnd" class="form-label">報名結束日期</label>
                                                <input 
                                                    type="date" 
                                                    class="form-control" 
                                                    id="registrationEnd"
                                                    v-model="form.registrationEnd">
                                            </div>
                                        </div>
                                    </div>

                                    <!-- 活動地點 -->
                                    <div class="mb-3">
                                        <label for="activityLocation" class="form-label">活動地點</label>
                                        <input 
                                            type="text" 
                                            class="form-control" 
                                            id="activityLocation"
                                            v-model="form.location">
                                    </div>

                                    <!-- 座標 (可選) -->
                                    <div class="row">
                                        <div class="col-6">
                                            <div class="mb-3">
                                                <label for="activityLatitude" class="form-label">緯度</label>
                                                <input 
                                                    type="number" 
                                                    step="any"
                                                    class="form-control" 
                                                    id="activityLatitude"
                                                    v-model.number="form.latitude">
                                            </div>
                                        </div>
                                        <div class="col-6">
                                            <div class="mb-3">
                                                <label for="activityLongitude" class="form-label">經度</label>
                                                <input 
                                                    type="number" 
                                                    step="any"
                                                    class="form-control" 
                                                    id="activityLongitude"
                                                    v-model.number="form.longitude">
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <!-- 完整寬度區域 -->
                                <div class="col-12">
                                    <!-- 活動描述 -->
                                    <div class="mb-3">
                                        <label for="activityDescription" class="form-label">活動描述</label>
                                        <textarea 
                                            class="form-control" 
                                            id="activityDescription"
                                            rows="4"
                                            v-model="form.description"
                                            placeholder="請輸入活動的詳細描述..."></textarea>
                                    </div>

                                    <!-- 活動圖片 -->
                                    <div class="mb-3">
                                        <label for="activityImage" class="form-label">活動圖片 URL</label>
                                        <input 
                                            type="url" 
                                            class="form-control" 
                                            id="activityImage"
                                            v-model="form.image"
                                            placeholder="https://example.com/image.jpg">
                                    </div>
                                </div>
                            </div>
                        </form>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">取消</button>
                        <button 
                            type="button" 
                            class="btn btn-primary" 
                            @click="submitForm"
                            :disabled="loading">
                            <span v-if="loading" class="spinner-border spinner-border-sm me-2" role="status"></span>
                            {{ isEditMode ? '更新活動' : '新增活動' }}
                        </button>
                    </div>
                </div>
            </div>
        </div>

        <!-- 查看活動詳情 Modal -->
        <div class="modal fade" id="viewActivityModal" tabindex="-1" aria-labelledby="viewActivityModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-lg">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="viewActivityModalLabel">活動詳情</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body" v-if="selectedActivity">
                        <div class="row">
                            <div class="col-md-6">
                                <!-- 活動圖片 -->
                                <img :src="selectedActivity.image || '/default-activity.jpg'" 
                                     class="img-fluid rounded mb-3" 
                                     :alt="selectedActivity.name">
                                
                                <!-- 基本資訊 -->
                                <h6 class="text-primary">基本資訊</h6>
                                <table class="table table-borderless table-sm">
                                  <tbody>
                                    <tr>
                                      <td class="text-muted">活動名稱：</td>
                                      <td>{{ selectedActivity.name }}</td>
                                    </tr>
                                    <tr>
                                      <td class="text-muted">活動類別：</td>
                                      <td>{{ selectedActivity.category }}</td>
                                    </tr>
                                    <tr>
                                      <td class="text-muted">報名人數：</td>
                                      <td>{{ selectedActivity.current }}/{{ selectedActivity.limit }}</td>
                                    </tr>
                                    <tr>
                                      <td class="text-muted">講師：</td>
                                      <td>{{ selectedActivity.instructor }}</td>
                                    </tr>
                                    <tr>
                                      <td class="text-muted">狀態：</td>
                                      <td>
                                        <span class="badge" :class="selectedActivity.status ? 'bg-success' : 'bg-danger'">
                                          {{ selectedActivity.status ? '報名中' : '過去活動' }}
                                        </span>
                                      </td>
                                    </tr>
                                  </tbody>
                                </table>
                            </div>
                            <div class="col-md-6">
                                <!-- 時間地點資訊 -->
                                <h6 class="text-primary">時間地點資訊</h6>
                                <table class="table table-borderless table-sm">
                                  <tbody>
                                    <tr>
                                      <td class="text-muted">活動日期：</td>
                                      <td>{{ formatDate(selectedActivity.date) }} - {{ formatDate(selectedActivity.end) }}</td>
                                    </tr>
                                    <tr>
                                      <td class="text-muted">活動時間：</td>
                                      <td>{{ selectedActivity.time }}</td>
                                    </tr>
                                    <tr>
                                      <td class="text-muted">報名期間：</td>
                                      <td>{{ formatDate(selectedActivity.registrationStart) }} ~ {{ formatDate(selectedActivity.registrationEnd) }}</td>
                                    </tr>
                                    <tr>
                                      <td class="text-muted">活動地點：</td>
                                      <td>{{ selectedActivity.location }}</td>
                                    </tr>
                                    <tr v-if="selectedActivity.latitude && selectedActivity.longitude">
                                      <td class="text-muted">座標：</td>
                                      <td>{{ selectedActivity.latitude }}, {{ selectedActivity.longitude }}</td>
                                    </tr>
                                  </tbody>
                                </table>
                                
                                <!-- 活動描述 -->
                                <div class="mt-3">
                                    <h6 class="text-primary">活動描述</h6>
                                    <p class="text-muted">{{ selectedActivity.description || '暫無描述' }}</p>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">關閉</button>
                        <button type="button" class="btn btn-warning" @click="editFromView">
                            <i class="fas fa-edit"></i> 編輯此活動
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </div>
</template>

<script>
import Breadcrumb from '@/components/breadcrumb/Breadcrumb.vue';
import { useActivity } from '@/composables/useActivity';
import { ref, computed, onMounted, reactive, nextTick } from 'vue';
import { useRouter } from 'vue-router';
import { useToast } from '@/composables/useToast'; // 引入 toast 元件

export default {
    name: "ActivityBlog",
    components: {
        Breadcrumb
    },
    setup() {
        const router = useRouter();
        
        // 使用 Composable 管理活動狀態與操作
        const { 
            activities, 
            loading, 
            error, 
            success,
            loadActivities, 
            addActivity,
            updateActivity,
            removeActivity 
        } = useActivity();
        
        // 篩選條件
        const searchText = ref('');
        const filterCategory = ref('');
        const filterStatus = ref('');
        const { showToast } = useToast(); // 使用 Toast 通知功能
        // Modal 狀態管理
        const isEditMode = ref(false);
        const selectedActivity = ref(null);
        
        // 表單資料 - 響應式物件
        const form = reactive({
            name: '',
            category: '',
            limit: 0,
            current: 0,
            date: '',
            end: '',
            time: '',
            registrationStart: '',
            registrationEnd: '',
            location: '',
            latitude: null,
            longitude: null,
            instructor: '',
            status: true,
            description: '',
            image: ''
        });

        // 篩選後的活動列表
        const filteredActivities = computed(() => {
            return activities.value.filter(activity => {
                const matchesSearch = !searchText.value || 
                    activity.name.toLowerCase().includes(searchText.value.toLowerCase());
                const matchesCategory = !filterCategory.value || 
                    activity.category === filterCategory.value;
                const matchesStatus = filterStatus.value === '' || 
                    activity.status.toString() === filterStatus.value;
                
                return matchesSearch && matchesCategory && matchesStatus;
            });
        });

        // 格式化日期為繁體中文格式
        const formatDate = (dateString) => {
            if (!dateString) return '';
            return new Date(dateString).toLocaleDateString('zh-TW');
        };

        // 截斷描述文字，避免卡片過長
        const truncateDescription = (description, maxLength = 50) => {
            if (!description) return '';
            return description.length > maxLength ? 
                description.substring(0, maxLength) + '...' : description;
        };

        // 重置表單資料
        const resetForm = () => {
            Object.assign(form, {
                name: '',
                category: '',
                limit: 0,
                current: 0,
                date: '',
                end: '',
                time: '',
                registrationStart: '',
                registrationEnd: '',
                location: '',
                latitude: null,
                longitude: null,
                instructor: '',
                status: true,
                description: '',
                image: ''
            });
        };

        // 開啟新增 Modal
        const openAddModal = () => {
            isEditMode.value = false;
            resetForm();
            const modal = new bootstrap.Modal(document.getElementById('activityModal'));
            modal.show();
        };

        // 開啟編輯 Modal
        const openEditModal = (activity) => {
            isEditMode.value = true;
            // 將活動資料填入表單
            Object.assign(form, {
                id: activity.id,
                name: activity.name,
                category: activity.category,
                limit: activity.limit,
                current: activity.current,
                date: activity.date,
                end: activity.end,
                time: activity.time,
                registrationStart: activity.registrationStart,
                registrationEnd: activity.registrationEnd,
                location: activity.location,
                latitude: activity.latitude,
                longitude: activity.longitude,
                instructor: activity.instructor,
                status: activity.status,
                description: activity.description,
                image: activity.image
            });
            const modal = new bootstrap.Modal(document.getElementById('activityModal'));
            modal.show();
        };

        // 提交表單 - 新增或更新
        const submitForm = async () => {
            try {
                let result;
                if (isEditMode.value) {
                    // 更新活動
                    result = await updateActivity(form.id, form);
                    // 顯示成功通知
                    showToast({
                    title: '更新成功',
                    message: `更新活動: ${form.name}`,
                    type: 'success'
                    });
                    const modal = bootstrap.Modal.getInstance(document.getElementById('activityModal'));
                    modal.hide();
                } else {
                    // 新增活動
                    result = await addActivity(form);
                    showToast({
                    title: '新增成功',
                    message: `新增活動: ${form.name}`,
                    type: 'success'
                    });
                    const modal = bootstrap.Modal.getInstance(document.getElementById('activityModal'));
                    modal.hide();
                }
            } catch (err) {
                    showToast({
                    title: '更新失敗 !',
                    message: err.message,
                    type: 'error'
                    });
            }
        };

        // 查看活動詳情
        const viewActivity = (activity) => {
            selectedActivity.value = activity;
            const modal = new bootstrap.Modal(document.getElementById('viewActivityModal'));
            modal.show();
        };

        // 從查看模式轉到編輯模式
        const editFromView = () => {
            // 關閉查看 Modal
            const viewModal = bootstrap.Modal.getInstance(document.getElementById('viewActivityModal'));
            viewModal.hide();
            
            // 等待 Modal 關閉後開啟編輯 Modal
            setTimeout(() => {
                openEditModal(selectedActivity.value);
            }, 300);
        };

        // 刪除活動 - 確認後執行刪除操作
        const deleteActivity = async (activityId) => {
            if (confirm('確定要刪除此活動嗎？此操作無法復原。')) {
                try {
                    const result = await removeActivity(activityId);
                    showToast({
                    title: '刪除成功',
                    message: `刪除活動ID: ${activityId}`,
                    type: 'success'
                    });
                } catch (error) {
                    showToast({
                    title: '刪除失敗 !',
                    message:error.message,
                    type: 'error'
                    });
                }
            }
        };

        // 組件掛載時載入活動資料
        onMounted(() => {
            loadActivities();
        });

        return {
            // 響應式狀態
            activities,
            loading,
            error,
            success,
            searchText,
            filterCategory,
            filterStatus,
            
            // Modal 狀態
            isEditMode,
            selectedActivity,
            form,
            
            // 計算屬性
            filteredActivities,
            
            // 操作方法
            formatDate,
            truncateDescription,
            openAddModal,
            openEditModal,
            submitForm,
            viewActivity,
            editFromView,
            deleteActivity
        };
    }
}
</script>

<style scoped>
.activity-card {
    transition: transform 0.2s ease-in-out;
    height: 100%;
}

.activity-card:hover {
    transform: translateY(-2px);
    box-shadow: 0 4px 15px rgba(0,0,0,0.1);
}

.activity-image {
    height: 200px;
    object-fit: cover;
}

.activity-info {
    font-size: 0.9rem;
}

.registration-period {
    border-top: 1px solid #eee;
    padding-top: 0.5rem;
}

.progress-bar {
    background: linear-gradient(45deg, #007bff, #0056b3);
}

/* Modal 樣式調整 */
.modal-xl {
    max-width: 90%;
}

.table-borderless td {
    border: none;
    padding: 0.25rem 0.5rem;
}

.form-label {
    font-weight: 500;
    margin-bottom: 0.25rem;
}

.text-danger {
    color: #dc3545 !important;
}

.text-primary {
    color: #0d6efd !important;
}
</style>