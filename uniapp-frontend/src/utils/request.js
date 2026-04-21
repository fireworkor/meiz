const API_BASE_URL = 'http://localhost:8080/api'

export const request = {
  async post(url, data) {
    try {
      const response = await fetch(`${API_BASE_URL}${url}`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json'
        },
        body: JSON.stringify(data)
      })
      return await response.json()
    } catch (error) {
      console.error('请求失败:', error)
      return { success: false, message: '网络请求失败' }
    }
  },

  async get(url, params) {
    try {
      let queryString = ''
      if (params) {
        queryString = '?' + Object.keys(params).map(key => `${key}=${params[key]}`).join('&')
      }
      const response = await fetch(`${API_BASE_URL}${url}${queryString}`, {
        method: 'GET',
        headers: {
          'Content-Type': 'application/json'
        }
      })
      return await response.json()
    } catch (error) {
      console.error('请求失败:', error)
      return { success: false, message: '网络请求失败' }
    }
  },

  async put(url, data) {
    try {
      const response = await fetch(`${API_BASE_URL}${url}`, {
        method: 'PUT',
        headers: {
          'Content-Type': 'application/json'
        },
        body: JSON.stringify(data)
      })
      return await response.json()
    } catch (error) {
      console.error('请求失败:', error)
      return { success: false, message: '网络请求失败' }
    }
  },

  async delete(url) {
    try {
      const response = await fetch(`${API_BASE_URL}${url}`, {
        method: 'DELETE',
        headers: {
          'Content-Type': 'application/json'
        }
      })
      return await response.json()
    } catch (error) {
      console.error('请求失败:', error)
      return { success: false, message: '网络请求失败' }
    }
  }
}

export default request