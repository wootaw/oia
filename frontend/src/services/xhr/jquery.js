const rootPaths = { api: '/api/v1', page: '' }
const xhr = ({ method='get', url, body=null, prefix='api', dt='html' }) => {
  const defer = $.Deferred()

  $.ajax({
    type: method,
    url: rootPaths[prefix] + url,
    data: body,
    dataType: dt
    // crossDomain: true, // 跨域
    // xhrFields: { withCredentials: true } // 跨域允许带上 cookie
  })
  .always((data, textStatus, jqxhr) => {
    if (/^(nocontent|success)$/.test(textStatus)) {
      defer.resolve({ data: data, code: jqxhr.status })
    } else {
      defer.resolve({ data: JSON.parse(data.responseJSON), code: data.status })
    }
  });

  return defer.promise()
}

export default xhr
