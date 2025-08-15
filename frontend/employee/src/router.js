import { createRouter, createWebHistory } from "vue-router";
import { useAuthStore } from "@/stores/authStore"; // 引入 Auth Store

// ===== 頁面元件導入 =====

// 首頁
import Ai from './pages/dashboard/ai.vue'

// error
import Error from "./pages/error/error.vue";
import BadRequest from "./pages/error/bad-request.vue";
import ServiceUnavailable from "./pages/error/service-unavailable.vue";
import InternalServer from "./pages/error/internal-server.vue";
import Forbidden from "./pages/error/forbidden.vue";

// Employee
import EmpList from "./pages/employee/empList.vue";
import EmpRole from "./pages/employee/empRole.vue";
import EmpAdmin from "./pages/employee/empAdmin.vue";
import ViewProfile from "./pages/employee/view-profile.vue";
// authentication
import SignIn from "./pages/authentication/sign-in.vue";
import ForgotPassword from "./pages/authentication/forgot-password.vue";

// Rehabus
import RehabusList from "./pages/rehabus/rehabus-list.vue";
import RehabusAdd from "./pages/rehabus/rehabus-add.vue";
import RehabusEdit from "./pages/rehabus/rehabus-edit.vue";

// Rehabus (FareZone)
import FareZoneList from "./pages/rehabus/farezone-list.vue";
import FareZoneAdd from "./pages/rehabus/farezone-add.vue";
import FareZoneEdit from "./pages/rehabus/farezone-edit.vue";

//RoomType
import RoomAdd from "./pages/roomType/RoomAdd.vue";
import RoomEdit from "./pages/roomType/RoomEdit.vue";
import RoomList from "./pages/roomType/RoomList.vue";
import RoomPreview from "./pages/roomType/RoomPreview.vue";

// device 輔具管理相關頁面
import DeviceList from "./pages/device/device.vue";
import DeviceCategory from "./pages/device/category.vue";
import DeviceImport from "./pages/device/import.vue";

// Activity - 活動管理模組
import ActivityBlog from "./pages/activity/activityblog.vue";

// Caregiver
import CaregiverList from "./pages/caregiver/CaregiverList.vue";
import AddCareWorker from "./components/Caregiver/AddCareWorker.vue";
import EditCareWorker from "./pages/caregiver/EditCareWorker.vue";
import ViewCareWorker from "./pages/caregiver/ViewCareWorker.vue";

/**
 * 檢查使用者認證狀態的輔助函數
 * 使用 Pinia Auth Store 進行認證檢查
 * @returns {boolean} 是否已通過認證
 */
function isAuthenticated() {
  try {
    // 使用 Pinia Auth Store 檢查認證狀態
    const authStore = useAuthStore();

    // 首先嘗試從 store 檢查
    if (authStore.isAuthenticated) {
      return true;
    }

    // 如果 store 中沒有認證資訊，嘗試初始化
    authStore.initializeAuth();
    return authStore.isAuthenticated;
  } catch (error) {
    console.error("Router: 檢查認證狀態時發生錯誤:", error);
    return false;
  }
}

// ===== 路由定義 =====
const routes = [
  // 首頁
  {
    path: "/",
    component: Ai,
    meta: {
      requiresAuth: true,
      title: "首頁",
    },
  },
  // 員工列表頁面 Employee
  {
    path: "/employee/list",
    component: EmpList,
    meta: {
      requiresAuth: true,
      title: "員工列表",
    },
  },
  {
    path: "/employee/role",
    component: EmpRole,
    meta: {
      requiresAuth: true,
      title: "員工角色管理",
    },
  },
  {
    path: "/employee/admin",
    component: EmpAdmin,
    meta: {
      requiresAuth: true,
      title: "員工管理",
    },
  },
  {
    path: "/view-profile",
    component: ViewProfile,
    meta: {
      requiresAuth: true,
      title: "檢視個人資料",
    },
  },

  // Rehabus (復康巴士管理) - 需要認證
  {
    path: "/rehabus/list",
    component: RehabusList,
    meta: {
      requiresAuth: true,
      title: "復康巴士列表",
    },
  },
  {
    path: "/rehabus/add",
    component: RehabusAdd,
    meta: {
      requiresAuth: true,
      title: "新增復康巴士",
    },
  },
  {
    path: "/rehabus/edit/:id",
    component: RehabusEdit,
    meta: {
      requiresAuth: true,
      title: "編輯復康巴士",
    },
  },

  // FareZone (行政區管理) - 需要認證
  {
    path: "/farezone/list",
    component: FareZoneList,
    meta: {
      requiresAuth: true,
      title: "行政區列表",
    },
  },
  {
    path: "/farezone/add",
    component: FareZoneAdd,
    meta: {
      requiresAuth: true,
      title: "新增行政區",
    },
  },
  {
    path: "/farezone/edit/:id",
    component: FareZoneEdit,
    meta: {
      requiresAuth: true,
      title: "編輯行政區",
    },
  },

  // RoomType 房型模組 - 需要認證
  {
    path: "/roomType/RoomList",
    component: RoomList,
    meta: {
      requiresAuth: true,
      title: "房型列表",
    },
  },
  {
    path: "/roomType/RoomPreview/:id",
    component: RoomPreview,
    meta: {
      requiresAuth: true,
      title: "房型簡介",
    },
  },
  {
    path: "/roomType/RoomEdit/:id",
    component: RoomEdit,
    meta: {
      requiresAuth: true,
      title: "編輯房型",
    },
  },
  {
    path: "/roomType/RoomAdd",
    component: RoomAdd,
    meta: {
      requiresAuth: true,
      title: "新增房型",
    },
  },

  // device 輔具管理相關路由 - 需要認證
  {
    path: "/device/list",
    component: DeviceList,
    meta: {
      requiresAuth: true,
      title: "輔具列表",
    },
  },
  {
    path: "/device/category",
    component: DeviceCategory,
    meta: {
      requiresAuth: true,
      title: "輔具分類",
    },
  },
  {
    path: "/device/import",
    component: DeviceImport,
    meta: {
      requiresAuth: true,
      title: "輔具批次匯入",
    },
  },

  // Activity - 活動管理路由 - 需要認證
  {
    path: "/activity/list",
    component: ActivityBlog,
    meta: {
      requiresAuth: true,
      title: "活動管理",
    },
  },

  // caregiver - 需要認證
  {
    path: "/caregiver/list",
    name: "CaregiverList",
    component: CaregiverList,
    meta: {
      requiresAuth: true,
      title: "照服員列表",
    },
  },
  {
    path: "/add-care-worker",
    name: "AddCareWorker",
    component: AddCareWorker,
    meta: {
      requiresAuth: true,
      title: "新增照服員",
    },
  },
  {
    path: "/care-worker/edit/:id",
    name: "EditCareWorker",
    component: EditCareWorker,
    props: true,
    meta: {
      requiresAuth: true,
      title: "編輯照服員",
    },
  },
  {
    path: "/care-worker/edit",
    name: "EditCareWorkerRedirect",
    redirect: "/caregiver/list",
    meta: {
      requiresAuth: true,
    },
  },
  {
    path: "/care-worker/:id",
    name: "ViewCareWorker",
    component: ViewCareWorker,
    props: true,
    meta: {
      requiresAuth: true,
      title: "照服員詳細資料",
    },
  },
  {
    path: "/care-worker",
    name: "ViewCareWorkerRedirect",
    redirect: "/caregiver/list",
    meta: {
      requiresAuth: true,
    },
  },

  // Authentication - 登入頁面
  {
    path: "/sign-in",
    component: SignIn,
    meta: {
      layout: false,
      requiresAuth: false,
      title: "員工登入",
    },
  },
  {
    path: "/forgot-password",
    component: ForgotPassword,
    meta: {
      layout: false,
      requiresAuth: false,
      title: "忘記密碼",
    },
  },

  // error - status code pages
  {
    path: "/error",
    component: Error,
    meta: {
      requiresAuth: false,
      title: "頁面不存在 (404)",
    },
  },
  {
    path: "/bad-request",
    component: BadRequest,
    meta: {
      requiresAuth: false,
      title: "請求參數錯誤 (400)",
    },
  },
  {
    path: "/service-unavailable",
    component: ServiceUnavailable,
    meta: {
      requiresAuth: false,
      title: "服務無法使用 (503)",
    },
  },
  {
    path: "/internal-server",
    component: InternalServer,
    meta: {
      requiresAuth: false,
      title: "伺服器錯誤 (500)",
    },
  },
  {
    path: "/forbidden",
    component: Forbidden,
    meta: {
      requiresAuth: false,
      title: "權限不足 (403)",
    },
  },
  // 404 頁面處理
  {
    path: "/:pathMatch(.*)*",
    redirect: "/error",
    meta: {
      requiresAuth: false,
    },
  },
];

// ===== 建立路由實例 =====
const router = createRouter({
  history: createWebHistory(),
  routes,
});

// ===== 全域路由守衛 =====

/**
 * 全域前置守衛 - 在每次路由跳轉前檢查認證狀態
 */
router.beforeEach((to, from, next) => {
  console.log(`Router: 路由跳轉 ${from.path} -> ${to.path}`);

  // 檢查目標路由是否需要認證（預設需要認證，除非明確設定為 false）
  const requiresAuth = to.meta.requiresAuth !== false;

  if (requiresAuth) {
    // 需要認證的路由
    if (isAuthenticated()) {
      next();
    } else {
      // 如果當前不是在登入頁面，則重導向到登入頁面
      if (to.path !== "/sign-in") {
        next("/sign-in");
      } else {
        next();
      }
    }
  } else {
    // 不需要認證的頁面

    // 如果已經登入且嘗試訪問登入頁面，重導向到首頁
    if (to.path === "/sign-in" && isAuthenticated()) {
      next("/");
    } else {
      next();
    }
  }
});

/**
 * 全域後置守衛 - 設定頁面標題
 */
router.afterEach((to) => {
  // 設定頁面標題
  const title = to.meta.title || "員工管理系統";
  document.title = title;
});

export default router;
