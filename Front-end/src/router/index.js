/*
 * @Descripttion:
 * @version:
 * @Author: 王远昭
 * @Date: 2023-01-15 10:34:27
 * @LastEditors: 王远昭
 * @LastEditTime: 2023-01-17 15:15:29
 */
import { createRouter, createWebHashHistory } from "vue-router";
const routes = [
  {
    path: "/",
    redirect: "Home",
  },
  {
    path:"/Home",
    name:"Home",
    component:() => import('../Views/Index.vue')
  },
  {
    path:"/Admin",
    name:"Admin",
    component:() => import('../Views/Admin.vue')
  },
  {
    path:"/Login",
    name:"Login",
    component:() => import('../Views/Login.vue')
  },
  {
    path:"/User",
    name:"User",
    meta: {
      title: '用户信息',
      requiresAuth: true, // 路由拦截，未登录不能使用
    },
    component:() => import('../Views/User.vue'),
    children: [
      {
        path: 'info',
        component: () => import('../components/user/My.vue')
      },
      {
        path: 'cart',
        component: () => import('../components/user/Cart.vue')
      },
      {
        path: 'order',
        component: () => import('../components/user/Order.vue')
      }
    ]
  }
];


const router = createRouter({
  history: createWebHashHistory(),
  routes, // `routes: routes` 的缩写
});

// 路由拦截，判断是否需要登录
router.beforeEach((to, from, next) => {
  if (to.meta.title) {
    //判断是否有标题
    document.title = to.meta.title;
  }
  // console.log("title",document.title)
  // 通过requiresAuth判断当前路由导航是否需要登录
  if (to.matched.some(record => record.meta.requiresAuth)) {
    let token = sessionStorage.getItem('username')
    // console.log("token",token)
    // 若需要登录访问，检查是否为登录状态
    if (!token) {
      next({
        path: '/login',
        query: { redirect: to.fullPath }
      })
    } else {
      next()
    }
  } else {
    next() // 确保一定要调用 next()
  }
})
export default router;
