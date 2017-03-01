// 此处配置后端 API 根路径 以及 全局错误处理
// 更多配置请根据业务逻辑自行实现

// 后端 API 根路径
// export const rootPath = '/api'
// export const rootPath = '/api/v1'
export const rootPaths = { api: '/api/v1', page: '' }
// export const rootPath = '/mocks'

// XHR 错误处理
export const errHandler = (e) => {
  // $.toast({
  //   heading: '请求 API 失败',
  //   icon: 'error',
  //   stack: false
  // })
  // console.log('000000000')
  console.warn(e)
}
