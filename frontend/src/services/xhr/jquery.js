import { rootPaths, errHandler } from './config'

const xhr = ({ method = 'get', url, body = null, prefix = 'api' }) => {
  const defer = $.Deferred()

  $.ajax({
    type: method,
    url: rootPaths[prefix] + url,
    data: body
    // crossDomain: true, // 跨域
    // xhrFields: { withCredentials: true } // 跨域允许带上 cookie
  })
  .done((data, success, jqxhr) => {
    // if (!success) return $.toast({
    //   heading: '操作失败',
    //   text: errMsg,
    //   icon: 'warning',
    //   stack: false
    // })
    // if (!success) console.warn(errMsg)
    defer.resolve(data)
  })
  .fail(errHandler)

  return defer.promise()
}

export default xhr
