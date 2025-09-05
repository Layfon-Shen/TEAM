<template>
  <div class="dashboard-main-body">
    <!-- 引入照服員表格元件 -->
    <CaregiverTable
      :careWorkers="caregivers"
      :loading="isLoading"
      :error="error"
      @view="viewCaregiver"
      @edit="editCaregiver"
      @delete="deleteCaregiver"
    />
  </div>
</template>

<script>
import Breadcrumb from "@/components/breadcrumb/Breadcrumb.vue";
import CaregiverTable from "@/components/Caregiver/CaregiverTable.vue";
import { useCaregivers } from "@/composables/useCaregivers.js";
import { useRouter } from "vue-router";
import { useToast } from "@/composables/useToast";
import { useConfirmDialog } from "@/composables/useConfirmDialog";

export default {
  name: "CaregiverList",
  components: {
    Breadcrumb,
    CaregiverTable,
  },
  setup() {
    // 使用照服員資料 composable
    const {
      caregivers,
      loading: isLoading,
      error,
      loadCaregivers,
      searchCaregivers,
      deleteCaregiver: apiDeleteCaregiver,
    } = useCaregivers({ autoLoad: true });

    // 使用路由
    const router = useRouter();

    // 使用 Toast 和確認對話框
    const { showToast } = useToast();
    const { showConfirmDialog } = useConfirmDialog();

    /**
     * 查看照服員詳情
     * @param {Object} caregiver 照服員資料
     */
    const viewCaregiver = (caregiver) => {
      // 導航到照服員詳情頁面
      router.push(`/care-worker/${caregiver.id}`);
    };

    /**
     * 編輯照服員資料
     * @param {Object} caregiver 照服員資料
     */
    const editCaregiver = (caregiver) => {
      // 導航到編輯頁面
      router.push(`/care-worker/edit/${caregiver.id}`);
    };

    /**
     * 刪除照服員
     * @param {Object} caregiver 照服員資料
     */
    const deleteCaregiver = async (caregiver) => {
      // **重點註解：改用 useConfirmDialog 提供一致的使用者體驗**
      try {
        const confirmed = await showConfirmDialog({
          title: "刪除照服員",
          message: `確定要刪除照服員「${caregiver.chineseName}」的資料嗎？\n\n此操作無法復原。`,
          type: "warning",
          confirmText: "確定刪除",
          cancelText: "取消",
          confirmButtonClass: "btn-danger",
          icon: "heroicons:trash",
        });

        // **重點註解：只有在使用者確認後才執行刪除**
        if (confirmed) {
          try {
            await apiDeleteCaregiver(caregiver.id);
            // 刪除後重新載入資料
            await loadCaregivers(true);

            // **重點註解：刪除成功後顯示成功訊息**
            showToast({
              title: "刪除成功",
              message: `照服員「${caregiver.chineseName}」已成功刪除`,
              type: "success",
            });
          } catch (deleteErr) {
            // **重點註解：僅在實際刪除 API 失敗時顯示錯誤訊息**
            showToast({
              title: "刪除失敗",
              message: deleteErr.message || "刪除照服員時發生錯誤",
              type: "error",
            });
          }
        }
        // **重點註解：如果使用者取消，不做任何處理，避免顯示錯誤訊息**
      } catch (err) {
        // **重點註解：這裡只處理 showConfirmDialog 本身的錯誤（通常是使用者取消），不顯示錯誤訊息**
        console.log("使用者取消刪除操作");
      }
    };

    return {
      // 狀態
      caregivers,
      isLoading,
      error,

      // 方法
      viewCaregiver,
      editCaregiver,
      deleteCaregiver,
    };
  },
};
</script>
