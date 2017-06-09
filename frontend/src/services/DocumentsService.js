import xhr from './xhr/'

class DocumentsService {
  fetchList (query) {
    return xhr({
      url: '/documents',
      // url: '/docs.json',
      body: query
    })
  }

  getOne(slug, query) {
    return xhr({
      url: `/documents/${slug}.json`,
      body: query,
      prefix: 'page',
      dt: 'json'
    });
  }
}

export default new DocumentsService()