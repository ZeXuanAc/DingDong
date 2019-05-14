import Vue from 'vue'
import Router from 'vue-router'

Vue.use(Router)

/* Layout */
import Layout from '../layout'

/**
 * constantRoutes
 * a base page that does not have permission requirements
 * all roles can be accessed
 */
export const constantRoutes = [
  {
    path: '/login',
    component: () => import('../views/login/index'),
    hidden: true
  },
  {
    path: '/',
    component: Layout,
    redirect: '/dashboard',
    children: [{
      path: 'dashboard',
      name: 'Dashboard',
      component: () => import('../views/dashboard/index'),
      meta: { title: '首页', icon: 'home', keepAlive: false }
    }]
  },
  {
    path: '/infoManage',
    component: Layout,
    redirect: '/infoManage/building',
    name: 'Nested',
    meta: {
      title: '信息管理',
      icon: 'infoManage'
    },
    children: [
      {
        path: 'building',
        component: () => import('../views/info-manage/building/index'),
        meta: { title: 'building管理', keepAlive: false }
      },
      {
        path: 'storey',
        component: () => import('../views/info-manage/storey/index'),
        meta: { title: 'storey管理', keepAlive: false }
      },
      {
        path: 'equipment',
        component: () => import('../views/info-manage/equipment/index'),
        meta: { title: 'equipment管理', keepAlive: false }
      }
    ]
  },
  {
    path: '/charts',
    component: Layout,
    redirect: 'noRedirect',
    name: 'Charts',
    meta: {
      title: '数据统计',
      icon: 'charts'
    },
    children: [
      {
        path: 'occupancyRate',
        component: () => import('../views/charts/occupancy-rate'),
        name: 'OccupancyRateChart',
        meta: { title: '历史占有率', noCache: true, keepAlive: true }
      },
      {
        path: 'line',
        component: () => import('../views/charts/line'),
        name: 'LineChart',
        meta: { title: 'lineChart', noCache: true, keepAlive: false }
      },
      {
        path: 'mix-chart',
        component: () => import('../views/charts/mix-chart'),
        name: 'MixChart',
        meta: { title: 'mixChart', noCache: true, keepAlive: false }
      }
    ]
  }
]

// 异步挂载的路由
// 动态需要根据权限加载的路由表
export const asyncRoutes = [
  {
    path: '/city',
    component: Layout,
    children: [{
      path: 'index',
      name: 'City',
      component: () => import('../views/city/index'),
      meta: { title: 'city管理', icon: 'international', roles: ['admin'], keepAlive: false }
    }]
  },
  {
    path: '/eq-init',
    component: Layout,
    children: [
      {
        path: 'index',
        name: 'From',
        component: () => import('../views/eq-init/index'),
        meta: { title: '设备初始化', icon: 'init', roles: ['admin'], keepAlive: true }
      }
    ]
  },
  {
    path: '/404',
    component: () => import('../views/404'),
    hidden: true
  },
  // 404 page must be placed at the end !!!
  { path: '*', redirect: '/404', hidden: true }
]

const createRouter = () => new Router({
  // mode: 'history', // require service support
  scrollBehavior: () => ({ y: 0 }),
  routes: constantRoutes
})

const router = createRouter()

// Detail see: https://github.com/vuejs/vue-router/issues/1234#issuecomment-357941465
export function resetRouter() {
  const newRouter = createRouter()
  router.matcher = newRouter.matcher // reset router
}

export default router
