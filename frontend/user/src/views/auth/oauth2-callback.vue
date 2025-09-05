<template>
  <div
    class="min-h-screen flex items-center justify-center bg-gray-50 dark:bg-gray-900"
  >
    <div class="max-w-md w-full space-y-8 p-8">
      <div class="text-center">
        <div v-if="isProcessing" class="space-y-4">
          <!-- [重點] 載入動畫 -->
          <div
            class="animate-spin rounded-full h-12 w-12 border-b-2 border-primary mx-auto"
          ></div>
          <h2 class="text-xl font-semibold text-title dark:text-white">
            正在處理登入資訊...
          </h2>
          <p class="text-gray-600 dark:text-gray-400">
            請稍候，系統正在驗證您的身份
          </p>
        </div>

        <div v-else-if="hasError" class="space-y-4">
          <!-- [重點] 錯誤顯示 -->
          <div class="text-red-500 text-4xl">⚠️</div>
          <h2 class="text-xl font-semibold text-red-600">登入失敗</h2>
          <p class="text-gray-600 dark:text-gray-400">
            {{ errorMessage }}
          </p>
          <button
            @click="redirectToHome"
            class="px-6 py-3 bg-primary text-white rounded-lg hover:bg-primary-dark transition-colors"
          >
            返回首頁
          </button>
        </div>

        <div v-else class="space-y-4">
          <!-- [重點] 成功提示 -->
          <div class="text-green-500 text-4xl">✅</div>
          <h2 class="text-xl font-semibold text-green-600">登入成功！</h2>
          <p class="text-gray-600 dark:text-gray-400">
            正在跳轉回原畫面，請耐心等候😊...
          </p>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, nextTick } from "vue";
import { useRouter, useRoute } from "vue-router";
import { memberService } from "@/service/memberService";

// [重點] Vue Router 相關
const router = useRouter();
const route = useRoute();

// [重點] 頁面狀態
const isProcessing = ref(true);
const hasError = ref(false);
const errorMessage = ref("");

/**
 * [重點] 處理 OAuth 回調的主要函式
 */
async function handleOAuthCallback() {
  try {
    // [重點] 1. 從 URL 參數中取得 token
    const token = route.query.token;

    if (!token) {
      throw new Error("未收到登入授權碼，請重新登入");
    }

    console.log("收到 token:", token);

    // [重點] 2. 先將 token 儲存到 localStorage
    localStorage.setItem("authToken", token);

    // [重點] 3. 等待下一個 tick 確保所有元件都已初始化
    await nextTick();

    // [重點] 4. 嘗試取得使用者資料來驗證 token
    try {
      const userData = await memberService.getCurrentMember();
      console.log("取得使用者資料:", userData);

      // [重點] 5. 延遲引入並使用 authStore
      await nextTick();

      // [重點] 動態引入 authStore 並設置資料
      const { useAuthStore } = await import("@/stores/authStore");
      const authStore = useAuthStore();

      if (authStore) {
        authStore.setToken(token);
        authStore.setUser(userData);
        console.log("已設置 authStore 資料");
      }
    } catch (apiError) {
      console.error("驗證 token 失敗:", apiError);
      throw new Error("登入驗證失敗，請重新登入");
    }

    // [重點] 6. 短暫顯示成功訊息後跳轉
    isProcessing.value = false;

    setTimeout(() => {
      redirectAfterLogin();
    }, 1500);
  } catch (error) {
    console.error("OAuth 回調處理失敗:", error);

    // [重點] 顯示錯誤訊息
    isProcessing.value = false;
    hasError.value = true;
    errorMessage.value = error.message || "登入過程中發生未知錯誤";

    // [重點] 清理可能的無效 token
    localStorage.removeItem("authToken");
    localStorage.removeItem("redirectAfterLogin");
  }
}

/**
 * [重點] 登入成功後的跳轉邏輯
 */
function redirectAfterLogin() {
  // [重點] 1. 優先檢查是否有儲存的跳轉路徑
  const savedRedirectPath = localStorage.getItem("redirectAfterLogin");

  if (savedRedirectPath && savedRedirectPath !== "/auth/callback") {
    // [重點] 清除儲存的路徑並跳轉
    localStorage.removeItem("redirectAfterLogin");
    router.push(savedRedirectPath);
    return;
  }

  // [重點] 2. 預設跳轉到會員中心
  router.push("/my-account");
}

/**
 * [重點] 返回首頁
 */
function redirectToHome() {
  router.push("/");
}

// [重點] 頁面載入時執行回調處理
onMounted(async () => {
  // [重點] 等待一個 tick 確保所有依賴都已載入
  await nextTick();
  handleOAuthCallback();
});
</script>

<style scoped>
/* [重點] 載入動畫 */
@keyframes spin {
  to {
    transform: rotate(360deg);
  }
}

.animate-spin {
  animation: spin 1s linear infinite;
}
</style>
