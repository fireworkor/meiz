// 通用提示工具
const toast = {
  show(options) {
    if (typeof alert !== 'undefined') {
      alert(options.title)
    } else {
      console.log('Toast:', options.title)
    }
  }
}

// 通用确认对话框
const modal = {
  show(options) {
    if (typeof confirm !== 'undefined') {
      const result = confirm(options.content)
      if (options.success) {
        options.success({ confirm: result })
      }
    } else {
      console.log('Modal:', options.content)
    }
  }
}

// 通用导航
const navigate = {
  back() {
    if (typeof window !== 'undefined' && window.history) {
      window.history.back()
    }
  },
  to(url) {
    if (typeof window !== 'undefined' && window.location) {
      window.location.href = url
    }
  }
}

// 通用加载提示
const loading = {
  show(options) {
    console.log('Loading:', options?.title || '加载中...')
  },
  hide() {
    console.log('Loading hidden')
  }
}

// 通用剪贴板操作
const clipboard = {
  setData(options) {
    if (typeof navigator !== 'undefined' && navigator.clipboard) {
      navigator.clipboard.writeText(options.data).then(() => {
        if (options.success) {
          options.success()
        }
      }).catch(err => {
        console.error('复制失败:', err)
      })
    } else {
      console.log('Clipboard not supported')
    }
  }
}

export { toast, modal, navigate, loading, clipboard }