import request from '../utils/request'

export const userAPI = {
  login(data) {
    return request.post('/api/users/login', data)
  },
  register(data) {
    return request.post('/api/users/register', data)
  }
}

export const employeeAPI = {
  getAll() {
    return request.get('/api/employees')
  },
  getById(id) {
    return request.get(`/api/employees/${id}`)
  },
  create(data) {
    return request.post('/api/employees', data)
  },
  update(id, data) {
    return request.put(`/api/employees/${id}`, data)
  },
  delete(id) {
    return request.delete(`/api/employees/${id}`)
  }
}

export const customerAPI = {
  getAll() {
    return request.get('/api/customers')
  },
  getById(id) {
    return request.get(`/api/customers/${id}`)
  },
  create(data) {
    return request.post('/api/customers', data)
  },
  update(id, data) {
    return request.put(`/api/customers/${id}`, data)
  },
  delete(id) {
    return request.delete(`/api/customers/${id}`)
  }
}

export const attendanceAPI = {
  checkIn(data) {
    return request.post('/api/attendances/check-in', data)
  },
  checkOut(data) {
    return request.post('/api/attendances/check-out', data)
  },
  getByEmployee(employeeId) {
    return request.get(`/api/attendances/employee/${employeeId}`)
  },
  getByDateRange(employeeId, startDate, endDate) {
    return request.get(`/api/attendances/employee/${employeeId}/date-range?startDate=${startDate}&endDate=${endDate}`)
  },
  getToday(employeeId) {
    return request.get(`/api/attendances/employee/${employeeId}/today`)
  }
}

export const orderAPI = {
  getAll() {
    return request.get('/api/orders')
  },
  getById(id) {
    return request.get(`/api/orders/${id}`)
  },
  getByCustomer(customerId) {
    return request.get(`/api/orders/customer/${customerId}`)
  },
  getByStatus(status) {
    return request.get(`/api/orders/status/${status}`)
  },
  create(data) {
    return request.post('/api/orders', data)
  },
  checkout(data) {
    return request.post('/api/orders/checkout', data)
  },
  updateStatus(id, status) {
    return request.put(`/api/orders/${id}/status?status=${status}`)
  },
  pay(id, paymentMethod) {
    return request.put(`/api/orders/${id}/pay?paymentMethod=${paymentMethod}`)
  },
  delete(id) {
    return request.delete(`/api/orders/${id}`)
  }
}

export const serviceAPI = {
  getAll() {
    return request.get('/api/services')
  },
  getById(id) {
    return request.get(`/api/services/${id}`)
  },
  getByCategory(category) {
    return request.get(`/api/services/category/${category}`)
  },
  getByStatus(status) {
    return request.get(`/api/services/status/${status}`)
  },
  search(name) {
    return request.get(`/api/services/search?name=${name}`)
  },
  create(data) {
    return request.post('/api/services', data)
  },
  update(id, data) {
    return request.put(`/api/services/${id}`, data)
  },
  delete(id) {
    return request.delete(`/api/services/${id}`)
  },
  updateStatus(id, status) {
    return request.put(`/api/services/${id}/status?status=${status}`)
  }
}

export const salaryAPI = {
  getAll() {
    return request.get('/api/salaries')
  },
  getById(id) {
    return request.get(`/api/salaries/${id}`)
  },
  getByEmployee(employeeId) {
    return request.get(`/api/salaries/employee/${employeeId}`)
  },
  getByYearMonth(year, month) {
    return request.get(`/api/salaries/year-month?year=${year}&month=${month}`)
  },
  getByStatus(status) {
    return request.get(`/api/salaries/status/${status}`)
  },
  calculate(employeeId, year, month) {
    return request.post(`/api/salaries/calculate?employeeId=${employeeId}&year=${year}&month=${month}`)
  },
  calculateAll(year, month) {
    return request.post(`/api/salaries/calculate-all?year=${year}&month=${month}`)
  },
  pay(id) {
    return request.post(`/api/salaries/${id}/pay`)
  },
  batchPay(salaryIds) {
    return request.post('/api/salaries/batch-pay', salaryIds)
  },
  create(data) {
    return request.post('/api/salaries', data)
  },
  update(id, data) {
    return request.put(`/api/salaries/${id}`, data)
  },
  delete(id) {
    return request.delete(`/api/salaries/${id}`)
  }
}

export const reservationAPI = {
  getAll() {
    return request.get('/api/reservations')
  },
  getById(id) {
    return request.get(`/api/reservations/${id}`)
  },
  create(data) {
    return request.post('/api/reservations', data)
  },
  updateStatus(id, status) {
    return request.put(`/api/reservations/${id}/status?status=${status}`)
  }
}

export const scheduleAPI = {
  getAll() {
    return request.get('/api/schedules')
  },
  getById(id) {
    return request.get(`/api/schedules/${id}`)
  },
  create(data) {
    return request.post('/api/schedules', data)
  },
  update(id, data) {
    return request.put(`/api/schedules/${id}`, data)
  },
  delete(id) {
    return request.delete(`/api/schedules/${id}`)
  },
  getByEmployee(employeeId) {
    return request.get(`/api/schedules/employee/${employeeId}`)
  },
  getByEmployeeAndDateRange(employeeId, startDate, endDate) {
    return request.get(`/api/schedules/employee/${employeeId}/date-range?startDate=${startDate}&endDate=${endDate}`)
  },
  getByDateRange(startDate, endDate) {
    return request.get(`/api/schedules/date-range?startDate=${startDate}&endDate=${endDate}`)
  }
}

export const shiftAPI = {
  getAll() {
    return request.get('/api/shifts')
  },
  getById(id) {
    return request.get(`/api/shifts/${id}`)
  },
  create(data) {
    return request.post('/api/shifts', data)
  },
  update(id, data) {
    return request.put(`/api/shifts/${id}`, data)
  },
  delete(id) {
    return request.delete(`/api/shifts/${id}`)
  },
  updateStatus(id, status) {
    return request.put(`/api/shifts/${id}/status?status=${status}`)
  },
  getByEmployee(employeeId) {
    return request.get(`/api/shifts/employee/${employeeId}`)
  },
  getByStatus(status) {
    return request.get(`/api/shifts/status/${status}`)
  }
}

export const productAPI = {
  getAll() {
    return request.get('/api/products')
  },
  getById(id) {
    return request.get(`/api/products/${id}`)
  },
  create(data) {
    return request.post('/api/products', data)
  },
  update(id, data) {
    return request.put(`/api/products/${id}`, data)
  },
  delete(id) {
    return request.delete(`/api/products/${id}`)
  },
  getByCategory(category) {
    return request.get(`/api/products/category/${category}`)
  },
  search(name) {
    return request.get(`/api/products/search?name=${name}`)
  }
}

export const inventoryAPI = {
  getAll() {
    return request.get('/api/inventory')
  },
  getById(id) {
    return request.get(`/api/inventory/${id}`)
  },
  create(data) {
    return request.post('/api/inventory', data)
  },
  update(id, data) {
    return request.put(`/api/inventory/${id}`, data)
  },
  delete(id) {
    return request.delete(`/api/inventory/${id}`)
  },
  addStock(data) {
    return request.post('/api/inventory/add-stock', data)
  },
  reduceStock(data) {
    return request.post('/api/inventory/reduce-stock', data)
  },
  getLowStock(threshold) {
    return request.get(`/api/inventory/low-stock?threshold=${threshold || 10}`)
  }
}

export const commissionAPI = {
  getAll() {
    return request.get('/api/commissions')
  },
  getById(id) {
    return request.get(`/api/commissions/${id}`)
  },
  create(data) {
    return request.post('/api/commissions', data)
  },
  update(id, data) {
    return request.put(`/api/commissions/${id}`, data)
  },
  delete(id) {
    return request.delete(`/api/commissions/${id}`)
  },
  getByEmployee(employeeId) {
    return request.get(`/api/commissions/employee/${employeeId}`)
  },
  getByStatus(status) {
    return request.get(`/api/commissions/status/${status}`)
  },
  updateStatus(id, status) {
    return request.put(`/api/commissions/${id}/status?status=${status}`)
  }
}

export const dashboardAPI = {
  getData() {
    return request.get('/api/dashboard/data')
  },
  getEmployeePerformance() {
    return request.get('/api/dashboard/employee-performance')
  }
}

export const roomAPI = {
  getAll() {
    return request.get('/api/rooms')
  },
  getById(id) {
    return request.get(`/api/rooms/${id}`)
  },
  create(data) {
    return request.post('/api/rooms', data)
  },
  update(id, data) {
    return request.put(`/api/rooms/${id}`, data)
  },
  delete(id) {
    return request.delete(`/api/rooms/${id}`)
  },
  search(keyword, status, type) {
    const params = new URLSearchParams()
    if (keyword) params.append('keyword', keyword)
    if (status) params.append('status', status)
    if (type) params.append('type', type)
    return request.get(`/api/rooms/search?${params.toString()}`)
  },
  getByStatus(status) {
    return request.get(`/api/rooms/status/${status}`)
  },
  updateStatus(id, status) {
    return request.put(`/api/rooms/${id}/status?status=${status}`)
  },
  batchDelete(ids) {
    return request.delete('/api/rooms/batch', ids)
  }
}

export const membershipCardAPI = {
  getAll() {
    return request.get('/api/membership-cards')
  },
  getById(id) {
    return request.get(`/api/membership-cards/${id}`)
  },
  create(data) {
    return request.post('/api/membership-cards', data)
  },
  update(id, data) {
    return request.put(`/api/membership-cards/${id}`, data)
  },
  delete(id) {
    return request.delete(`/api/membership-cards/${id}`)
  },
  recharge(id, amount) {
    return request.post(`/api/membership-cards/${id}/recharge?amount=${amount}`)
  },
  consume(id, amount) {
    return request.post(`/api/membership-cards/${id}/consume?amount=${amount}`)
  },
  getByCustomer(customerId) {
    return request.get(`/api/membership-cards/customer/${customerId}`)
  }
}

export const cardTypeAPI = {
  getAll() {
    return request.get('/api/card-types')
  },
  getById(id) {
    return request.get(`/api/card-types/${id}`)
  },
  create(data) {
    return request.post('/api/card-types', data)
  },
  update(id, data) {
    return request.put(`/api/card-types/${id}`, data)
  },
  delete(id) {
    return request.delete(`/api/card-types/${id}`)
  },
  getByStatus(status) {
    return request.get(`/api/card-types/status/${status}`)
  }
}

export const couponAPI = {
  getAll() {
    return request.get('/api/coupons')
  },
  getById(id) {
    return request.get(`/api/coupons/${id}`)
  },
  create(data) {
    return request.post('/api/coupons', data)
  },
  update(id, data) {
    return request.put(`/api/coupons/${id}`, data)
  },
  delete(id) {
    return request.delete(`/api/coupons/${id}`)
  },
  use(id) {
    return request.post(`/api/coupons/${id}/use`)
  },
  getByCustomer(customerId) {
    return request.get(`/api/coupons/customer/${customerId}`)
  }
}

export const marketingActivityAPI = {
  getAll() {
    return request.get('/api/marketing-activities')
  },
  getById(id) {
    return request.get(`/api/marketing-activities/${id}`)
  },
  create(data) {
    return request.post('/api/marketing-activities', data)
  },
  update(id, data) {
    return request.put(`/api/marketing-activities/${id}`, data)
  },
  delete(id) {
    return request.delete(`/api/marketing-activities/${id}`)
  },
  getByStatus(status) {
    return request.get(`/api/marketing-activities/status/${status}`)
  }
}

export const verificationAPI = {
  getAll() {
    return request.get('/api/verifications')
  },
  getById(id) {
    return request.get(`/api/verifications/${id}`)
  },
  getByCode(code) {
    return request.get(`/api/verifications/code/${code}`)
  },
  getByCustomer(customerId) {
    return request.get(`/api/verifications/customer/${customerId}`)
  },
  getByStatus(status) {
    return request.get(`/api/verifications/status/${status}`)
  },
  getByType(type) {
    return request.get(`/api/verifications/type/${type}`)
  },
  getStats() {
    return request.get('/api/verifications/stats')
  },
  createCoupon(data) {
    return request.post('/api/verifications/coupon', data)
  },
  createPoints(data) {
    return request.post('/api/verifications/points', data)
  },
  createProduct(data) {
    return request.post('/api/verifications/product', data)
  },
  verify(data) {
    return request.post('/api/verifications/verify', data)
  },
  cancel(id) {
    return request.post(`/api/verifications/${id}/cancel`)
  },
  delete(id) {
    return request.delete(`/api/verifications/${id}`)
  }
}

export const groupPurchaseAPI = {
  getAll() {
    return request.get('/api/group-purchases')
  },
  getById(id) {
    return request.get(`/api/group-purchases/${id}`)
  },
  getActive() {
    return request.get('/api/group-purchases/active')
  },
  getAvailable() {
    return request.get('/api/group-purchases/available')
  },
  getByCategory(category) {
    return request.get(`/api/group-purchases/category/${category}`)
  },
  create(data) {
    return request.post('/api/group-purchases', data)
  },
  update(id, data) {
    return request.put(`/api/group-purchases/${id}`, data)
  },
  delete(id) {
    return request.delete(`/api/group-purchases/${id}`)
  },
  join(id, data) {
    return request.post(`/api/group-purchases/${id}/join`, data)
  }
}

export const paymentAPI = {
  create(data) {
    return request.post('/api/payments/create', data)
  },
  queryStatus(paymentNo) {
    return request.get(`/api/payments/status/${paymentNo}`)
  },
  sandboxSuccess(paymentNo) {
    return request.post(`/api/payments/sandbox/${paymentNo}/success`)
  }
}