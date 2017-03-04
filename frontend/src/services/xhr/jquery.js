const rootPaths = { api: '/api/v1', page: '' }
const xhr = ({ method='get', url, body=null, prefix='api' }) => {
  const defer = $.Deferred()

  $.ajax({
    type: method,
    url: rootPaths[prefix] + url,
    data: body
    // crossDomain: true, // 跨域
    // xhrFields: { withCredentials: true } // 跨域允许带上 cookie
  })
  .always((data, textStatus, jqxhr) => {
    if (textStatus == 'success') {
      defer.resolve({ data: data, code: jqxhr.status })
    } else {
      defer.resolve({ data: data.responseJSON, code: data.status })
    }
  })

  return defer.promise()
}

export default xhr
