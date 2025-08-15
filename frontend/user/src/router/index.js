import { createRouter, createWebHistory } from "vue-router";
import IndexThree from "@/views/index/main-index.vue";
// Member
import LoginPage from '@/views/member/login-page.vue' 
                     
const routes = [
  {
    path: "/",
    name: "Home",
    component: IndexThree,
  },
  {
    path: "/index-v3",
    name: "IndexThree",
    component: IndexThree,
  },
  {
    path: "/login",
    name: "Login",
    component: LoginPage,
  }
];

const router = createRouter({
  history: createWebHistory(process.env.BASE_URL),
  routes,
});

export default router;
