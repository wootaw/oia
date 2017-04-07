import xhr from './xhr/'

class CommentsService {
  fetchList (query) {
    return xhr({
      url: '/documents',
      // url: '/docs.json',
      body: query
    })
  }

  preview(content) {
    let data = { body: content };
    data[$('meta[name=csrf-param]').attr('content')] = $('meta[name=csrf-token]').attr('content');
    return xhr({
      url: '/comments/preview',
      body: data,
      method: 'post',
      prefix: 'page',
      dt: 'json'
    });
  }
}

export default new CommentsService()