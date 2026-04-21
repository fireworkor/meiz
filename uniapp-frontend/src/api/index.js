import request from '../utils/request'

export const userAPI = {
  login(data) {
    return request.post('/users/login', data)
  },
  register(data) {
    return request.post('/users/register', data)
  }
}

export const employeeAPI = {
  getAll() {
    return request.get('/employees')
  },
  getById(id) {
    return request.get(`/employees/${id}`)
  },
  create(data) {
    return request.post('/employees', data)
  },
  update(id, data) {
    return request.put(`/employees/${id}`, data)
  },
  delete(id) {
    return request.delete(`/employees/${id}`)
  }
}

export const customerAPI = {
  getAll() {
    return request.get('/customers')
  },
  getById(id) {
    return request.get(`/customers/${id}`)
  },
  create(data) {
    return request.post('/customers', data)
  },
  update(id, data) {
    return request.put(`/customers/${id}`, data)
  },
  delete(id) {
    return request.delete(`/customers/${id}`)
  }
}

export const attendanceAPI = {
  checkIn(data) {
    return request.post('/attendances/check-in', data)
  },
  checkOut(data) {
    return request.post('/attendances/check-out', data)
  },
  getByEmployee(employeeId) {
    return request.get(`/attendances/employee/${employeeId}`)
  },
  getToday(employeeId) {
    return request.get(`/attendances/employee/${employeeId}/today`)
  }
}

export const orderAPI = {
  getAll() {
    return request.get('/orders')
  },
  getById(id) {
    return request.get(`/orders/${id}`)
  },
  create(data) {
    return request.post('/orders', data)
  },
  updateStatus(id, status) {
    return request.put(`/orders/${id}/status?status=${status}`)
  }
}

export const reservationAPI = {
  getAll() {
    return request.get('/reservations')
  },
  getById(id) {
    return request.get(`/reservations/${id}`)
  },
  create(data) {
    return request.post('/reservations', data)
  },
  updateStatus(id, status) {
    return request.put(`/reservations/${id}/status?status=${status}`)
  }
}

export const scheduleAPI = {
  getAll() {
    return request.get('/schedules')
  },
  getById(id) {
    return request.get(`/schedules/${id}`)
  },
  create(data) {
    return request.post('/schedules', data)
  },
  update(id, data) {
    return request.put(`/schedules/${id}`, data)
  },
  delete(id) {
    return request.delete(`/schedules/${id}`)
  },
  getByEmployee(employeeId) {
    return request.get(`/schedules/employee/${employeeId}`)
  },
  getByEmployeeAndDateRange(employeeId, startDate, endDate) {
    return request.get(`/schedules/employee/${employeeId}/date-range?startDate=${startDate}&endDate=${endDate}`)
  },
  getByDateRange(startDate, endDate) {
    return request.get(`/schedules/date-range?startDate=${startDate}&endDate=${endDate}`)
  }
}

export const shiftAPI = {
  getAll() {
    return request.get('/shifts')
  },
  getById(id) {
    return request.get(`/shifts/${id}`)
  },
  create(data) {
    return request.post('/shifts', data)
  },
  update(id, data) {
    return request.put(`/shifts/${id}`, data)
  },
  delete(id) {
    return request.delete(`/shifts/${id}`)
  },
  updateStatus(id, status) {
    return request.put(`/shifts/${id}/status?status=${status}`)
  },
  getByEmployee(employeeId) {
    return request.get(`/shifts/employee/${employeeId}`)
  },
  getByStatus(status) {
    return request.get(`/shifts/status/${status}`)
  }
}

export const productAPI = {
  getAll() {
    return request.get('/products')
  },
  getById(id) {
    return request.get(`/products/${id}`)
  },
  create(data) {
    return request.post('/products', data)
  },
  update(id, data) {
    return request.put(`/products/${id}`, data)
  },
  delete(id) {
    return request.delete(`/products/${id}`)
  },
  getByCategory(category) {
    return request.get(`/products/category/${category}`)
  },
  search(name) {
    return request.get(`/products/search?name=${name}`)
  }
}

export const inventoryAPI = {
  getAll() {
    return request.get('/inventory')
  },
  getById(id) {
    return request.get(`/inventory/${id}`)
  },
  create(data) {
    return request.post('/inventory', data)
  },
  update(id, data) {
    return request.put(`/inventory/${id}`, data)
  },
  delete(id) {
    return request.delete(`/inventory/${id}`)
  },
  addStock(data) {
    return request.post('/inventory/add-stock', data)
  },
  reduceStock(data) {
    return request.post('/inventory/reduce-stock', data)
  },
  getLowStock(threshold) {
    return request.get(`/inventory/low-stock?threshold=${threshold || 10}`)
  }
}

export const commissionAPI = {
  getAll() {
    return request.get('/commissions')
  },
  getById(id) {
    return request.get(`/commissions/${id}`)
  },
  create(data) {
    return request.post('/commissions', data)
  },
  update(id, data) {
    return request.put(`/commissions/${id}`, data)
  },
  delete(id) {
    return request.delete(`/commissions/${id}`)
  },
  getByEmployee(employeeId) {
    return request.get(`/commissions/employee/${employeeId}`)
  },
  getByStatus(status) {
    return request.get(`/commissions/status/${status}`)
  },
  updateStatus(id, status) {
    return request.put(`/commissions/${id}/status?status=${status}`)
  }
}

export const dashboardAPI = {
  getData() {
    return request.get('/dashboard/data')
  },
  getEmployeePerformance() {
    return request.get('/dashboard/employee-performance')
  }
}

export const roomAPI = {
  getAll() {
    return request.get('/rooms')
  },
  getById(id) {
    return request.get(`/rooms/${id}`)
  },
  create(data) {
    return request.post('/rooms', data)
  },
  update(id, data) {
    return request.put(`/rooms/${id}`, data)
  },
  delete(id) {
    return request.delete(`/rooms/${id}`)
  },
  getByStatus(status) {
    return request.get(`/rooms/status/${status}`)
  },
  updateStatus(id, status) {
    return request.put(`/rooms/${id}/status?status=${status}`)
  }
}

export const membershipCardAPI = {
  getAll() {
    return request.get('/membership-cards')
  },
  getById(id) {
    return request.get(`/membership-cards/${id}`)
  },
  create(data) {
    return request.post('/membership-cards', data)
  },
  update(id, data) {
    return request.put(`/membership-cards/${id}`, data)
  },
  delete(id) {
    return request.delete(`/membership-cards/${id}`)
  },
  recharge(id, amount) {
    return request.post(`/membership-cards/${id}/recharge?amount=${amount}`)
  },
  consume(id, amount) {
    return request.post(`/membership-cards/${id}/consume?amount=${amount}`)
  },
  getByCustomer(customerId) {
    return request.get(`/membership-cards/customer/${customerId}`)
  }
}

export const cardTypeAPI = {
  getAll() {
    return request.get('/card-types')
  },
  getById(id) {
    return request.get(`/card-types/${id}`)
  },
  create(data) {
    return request.post('/card-types', data)
  },
  update(id, data) {
    return request.put(`/card-types/${id}`, data)
  },
  delete(id) {
    return request.delete(`/card-types/${id}`)
  },
  getByStatus(status) {
    return request.get(`/card-types/status/${status}`)
  }
}

export const couponAPI = {
  getAll() {
    return request.get('/coupons')
  },
  getById(id) {
    return request.get(`/coupons/${id}`)
  },
  create(data) {
    return request.post('/coupons', data)
  },
  update(id, data) {
    return request.put(`/coupons/${id}`, data)
  },
  delete(id) {
    return request.delete(`/coupons/${id}`)
  },
  use(id) {
    return request.post(`/coupons/${id}/use`)
  },
  getByCustomer(customerId) {
    return request.get(`/coupons/customer/${customerId}`)
  }
}

export const marketingActivityAPI = {
  getAll() {
    return request.get('/marketing-activities')
  },
  getById(id) {
    return request.get(`/marketing-activities/${id}`)
  },
  create(data) {
    return request.post('/marketing-activities', data)
  },
  update(id, data) {
    return request.put(`/marketing-activities/${id}`, data)
  },
  delete(id) {
    return request.delete(`/marketing-activities/${id}`)
  },
  getByStatus(status) {
    return request.get(`/marketing-activities/status/${status}`)
  }
}