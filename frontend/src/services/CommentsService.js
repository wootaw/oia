import xhr from './xhr/'

class CommentsService {
  fetchList (resource_id) {
    return xhr({
      url: '/comments',
      body: { resource_id: resource_id },
      prefix: 'page',
      dt: 'json'
    });
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