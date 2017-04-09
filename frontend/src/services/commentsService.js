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

  create(resource_id, content) {
    let data = { body: content, resource_id: resource_id };
    data[$('meta[name=csrf-param]').attr('content')] = $('meta[name=csrf-token]').attr('content');
    return xhr({
      url: '/comments',
      body: data,
      method: 'post',
      prefix: 'page',
      dt: 'json'
    });
  }
}

export default new CommentsService()