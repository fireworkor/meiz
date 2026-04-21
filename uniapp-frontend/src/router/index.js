import Vue from 'vue'
import VueRouter from 'vue-router'
import Login from '../pages/login/Login.vue'
import AdminDashboard from '../pages/admin/dashboard/Dashboard.vue'
import StaffDashboard from '../pages/staff/dashboard/Dashboard.vue'
import CustomerDashboard from '../pages/customer/dashboard/Dashboard.vue'
import EmployeeList from '../pages/admin/employee/List.vue'
import EmployeeAdd from '../pages/admin/employee/Add.vue'
import EmployeeEdit from '../pages/admin/employee/Edit.vue'
import CustomerList from '../pages/admin/customer/List.vue'
import CustomerAdd from '../pages/admin/customer/Add.vue'
import CustomerEdit from '../pages/admin/customer/Edit.vue'
import Checkout from '../pages/admin/checkout/Index.vue'
import ReservationList from '../pages/admin/reservation/List.vue'
import ReservationAdd from '../pages/admin/reservation/Add.vue'
import ScheduleList from '../pages/admin/schedule/List.vue'
import ScheduleAdd from '../pages/admin/schedule/Add.vue'
import ScheduleEdit from '../pages/admin/schedule/Edit.vue'
import ShiftList from '../pages/admin/shift/List.vue'
import ShiftAdd from '../pages/admin/shift/Add.vue'
import InventoryList from '../pages/admin/inventory/List.vue'
import InventoryAdd from '../pages/admin/inventory/Add.vue'
import CommissionList from '../pages/admin/commission/List.vue'
import CommissionAdd from '../pages/admin/commission/Add.vue'
import DashboardData from '../pages/admin/dashboard/Data.vue'
import ServiceRecords from '../pages/admin/service/Records.vue'
import RoomList from '../pages/admin/room/List.vue'
import MemberList from '../pages/admin/member/List.vue'
import MemberAdd from '../pages/admin/member/Add.vue'
import CouponList from '../pages/admin/coupon/List.vue'
import CouponAdd from '../pages/admin/coupon/Add.vue'
import MarketingList from '../pages/admin/marketing/List.vue'
import MarketingAdd from '../pages/admin/marketing/Add.vue'
import AdminAttendance from '../pages/admin/attendance/Index.vue'
import AdminSalary from '../pages/admin/salary/Index.vue'
import AdminVerification from '../pages/admin/verification/Index.vue'
import AdminGroupPurchase from '../pages/admin/grouppurchase/Index.vue'
import StaffAttendance from '../pages/staff/attendance/Index.vue'
import TodayReservation from '../pages/staff/reservation/Today.vue'
import StaffPerformance from '../pages/staff/performance/Index.vue'
import StaffMarketing from '../pages/staff/marketing/Index.vue'
import StaffCheckout from '../pages/staff/checkout/Index.vue'
import StaffShiftApply from '../pages/staff/shift/Apply.vue'
import StaffNotifications from '../pages/staff/notifications/Index.vue'
import CustomerProfile from '../pages/customer/profile/Index.vue'
import CustomerMall from '../pages/customer/mall/Index.vue'
import ProductDetail from '../pages/customer/mall/ProductDetail.vue'
import CustomerCart from '../pages/customer/cart/Index.vue'
import OrderConfirm from '../pages/customer/order/Confirm.vue'
import OrderList from '../pages/customer/order/List.vue'
import CustomerPoints from '../pages/customer/points/Index.vue'
import CustomerActivities from '../pages/customer/activities/Index.vue'
import CustomerEvaluation from '../pages/customer/evaluation/Index.vue'
import CustomerNotifications from '../pages/customer/notifications/Index.vue'
import CustomerPromoter from '../pages/customer/promoter/Index.vue'
import CustomerReservationCreate from '../pages/customer/reservation/Create.vue'
import CustomerReservationList from '../pages/customer/reservation/List.vue'
import CustomerConsumption from '../pages/customer/Consumption.vue'
import CustomerVerification from '../pages/customer/verification/Index.vue'
import CustomerGroupPurchase from '../pages/customer/grouppurchase/Index.vue'

Vue.use(VueRouter)

const routes = [
  {
    path: '/',
    redirect: '/login'
  },
  {
    path: '/login',
    name: 'Login',
    component: Login
  },
  {
    path: '/admin/dashboard',
    name: 'AdminDashboard',
    component: AdminDashboard
  },
  {
    path: '/staff/dashboard',
    name: 'StaffDashboard',
    component: StaffDashboard
  },
  {
    path: '/customer/dashboard',
    name: 'CustomerDashboard',
    component: CustomerDashboard
  },
  {
    path: '/admin/employee/list',
    name: 'EmployeeList',
    component: EmployeeList
  },
  {
    path: '/admin/employee/add',
    name: 'EmployeeAdd',
    component: EmployeeAdd
  },
  {
    path: '/admin/employee/edit',
    name: 'EmployeeEdit',
    component: EmployeeEdit
  },
  {
    path: '/admin/customer/list',
    name: 'CustomerList',
    component: CustomerList
  },
  {
    path: '/admin/customer/add',
    name: 'CustomerAdd',
    component: CustomerAdd
  },
  {
    path: '/admin/customer/edit',
    name: 'CustomerEdit',
    component: CustomerEdit
  },
  {
    path: '/admin/checkout',
    name: 'Checkout',
    component: Checkout
  },
  {
    path: '/admin/reservation/list',
    name: 'ReservationList',
    component: ReservationList
  },
  {
    path: '/admin/reservation/add',
    name: 'ReservationAdd',
    component: ReservationAdd
  },
  {
    path: '/admin/schedule/list',
    name: 'ScheduleList',
    component: ScheduleList
  },
  {
    path: '/admin/schedule/add',
    name: 'ScheduleAdd',
    component: ScheduleAdd
  },
  {
    path: '/admin/schedule/edit',
    name: 'ScheduleEdit',
    component: ScheduleEdit
  },
  {
    path: '/admin/shift/list',
    name: 'ShiftList',
    component: ShiftList
  },
  {
    path: '/admin/shift/add',
    name: 'ShiftAdd',
    component: ShiftAdd
  },
  {
    path: '/admin/inventory/list',
    name: 'InventoryList',
    component: InventoryList
  },
  {
    path: '/admin/inventory/add',
    name: 'InventoryAdd',
    component: InventoryAdd
  },
  {
    path: '/admin/commission/list',
    name: 'CommissionList',
    component: CommissionList
  },
  {
    path: '/admin/commission/add',
    name: 'CommissionAdd',
    component: CommissionAdd
  },
  {
    path: '/admin/dashboard/data',
    name: 'DashboardData',
    component: DashboardData
  },
  {
    path: '/admin/service/records',
    name: 'ServiceRecords',
    component: ServiceRecords
  },
  {
    path: '/admin/room/list',
    name: 'RoomList',
    component: RoomList
  },
  {
    path: '/admin/member/list',
    name: 'MemberList',
    component: MemberList
  },
  {
    path: '/admin/member/add',
    name: 'MemberAdd',
    component: MemberAdd
  },
  {
    path: '/admin/coupon/list',
    name: 'CouponList',
    component: CouponList
  },
  {
    path: '/admin/coupon/add',
    name: 'CouponAdd',
    component: CouponAdd
  },
  {
    path: '/admin/marketing/list',
    name: 'MarketingList',
    component: MarketingList
  },
  {
    path: '/admin/marketing/add',
    name: 'MarketingAdd',
    component: MarketingAdd
  },
  {
    path: '/admin/marketing/edit/:id',
    name: 'MarketingEdit',
    component: MarketingAdd
  },
  {
    path: '/admin/attendance',
    name: 'AdminAttendance',
    component: AdminAttendance
  },
  {
    path: '/admin/salary',
    name: 'AdminSalary',
    component: AdminSalary
  },
  {
    path: '/admin/verification',
    name: 'AdminVerification',
    component: AdminVerification
  },
  {
    path: '/admin/grouppurchase',
    name: 'AdminGroupPurchase',
    component: AdminGroupPurchase
  },
  {
    path: '/staff/attendance',
    name: 'StaffAttendance',
    component: StaffAttendance
  },
  {
    path: '/staff/reservation/today',
    name: 'TodayReservation',
    component: TodayReservation
  },
  {
    path: '/staff/performance',
    name: 'StaffPerformance',
    component: StaffPerformance
  },
  {
    path: '/staff/marketing',
    name: 'StaffMarketing',
    component: StaffMarketing
  },
  {
    path: '/staff/checkout',
    name: 'StaffCheckout',
    component: StaffCheckout
  },
  {
    path: '/staff/shift/apply',
    name: 'StaffShiftApply',
    component: StaffShiftApply
  },
  {
    path: '/staff/notifications',
    name: 'StaffNotifications',
    component: StaffNotifications
  },
  {
    path: '/customer/profile',
    name: 'CustomerProfile',
    component: CustomerProfile
  },
  {
    path: '/customer/mall',
    name: 'CustomerMall',
    component: CustomerMall
  },
  {
    path: '/customer/mall/product',
    name: 'ProductDetail',
    component: ProductDetail
  },
  {
    path: '/customer/cart',
    name: 'CustomerCart',
    component: CustomerCart
  },
  {
    path: '/customer/order/confirm',
    name: 'OrderConfirm',
    component: OrderConfirm
  },
  {
    path: '/customer/order/list',
    name: 'OrderList',
    component: OrderList
  },
  {
    path: '/customer/points',
    name: 'CustomerPoints',
    component: CustomerPoints
  },
  {
    path: '/customer/activities',
    name: 'CustomerActivities',
    component: CustomerActivities
  },
  {
    path: '/customer/evaluation',
    name: 'CustomerEvaluation',
    component: CustomerEvaluation
  },
  {
    path: '/customer/notifications',
    name: 'CustomerNotifications',
    component: CustomerNotifications
  },
  {
    path: '/customer/promoter',
    name: 'CustomerPromoter',
    component: CustomerPromoter
  },
  {
    path: '/customer/reservation/create',
    name: 'CustomerReservationCreate',
    component: CustomerReservationCreate
  },
  {
    path: '/customer/reservation/list',
    name: 'CustomerReservationList',
    component: CustomerReservationList
  },
  {
    path: '/customer/consumption',
    name: 'CustomerConsumption',
    component: CustomerConsumption
  },
  {
    path: '/customer/verification',
    name: 'CustomerVerification',
    component: CustomerVerification
  },
  {
    path: '/customer/grouppurchase',
    name: 'CustomerGroupPurchase',
    component: CustomerGroupPurchase
  }
]

const router = new VueRouter({
  mode: 'history',
  routes
})

export default router