// 动态获取API基础URL，支持IPv4和IPv6
const getApiBaseUrl = () => {
  if (typeof window !== 'undefined') {
    const protocol = window.location.protocol || 'http:'
    let hostname = window.location.hostname
    // 如果hostname已经包含方括号（浏览器返回的IPv6格式），则直接使用
    // 如果不包含方括号但包含冒号（纯IPv6地址），则添加方括号
    const formattedHostname = hostname.includes('[') ? hostname : (hostname.includes(':') ? `[${hostname}]` : hostname)
    return `${protocol}//${formattedHostname}:8088`
  }
  return 'http://localhost:8088'
}

const API_BASE_URL = getApiBaseUrl()

export const request = {
  async post(url, data) {
    try {
      const response = await fetch(`${API_BASE_URL}${url}`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json'
        },
        body: JSON.stringify(data),
        credentials: 'include'
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
        },
        credentials: 'include'
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
        body: JSON.stringify(data),
        credentials: 'include'
      })
      return await response.json()
    } catch (error) {
      console.error('请求失败:', error)
      return { success: false, message: '网络请求失败' }
    }
  },

  async delete(url, data) {
    try {
      const response = await fetch(`${API_BASE_URL}${url}`, {
        method: 'DELETE',
        headers: {
          'Content-Type': 'application/json'
        },
        body: data ? JSON.stringify(data) : undefined,
        credentials: 'include'
      })
      return await response.json()
    } catch (error) {
      console.error('请求失败:', error)
      return { success: false, message: '网络请求失败' }
    }
  }
}

export default request