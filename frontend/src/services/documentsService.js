import xhr from './xhr/'

class DocumentsService {
  fetchList (query) {
    return xhr({
      url: '/documents',
      // url: '/docs.json',
      body: query
    })
  }

  getPrev(slug, query) {
    return xhr({
      url: `/documents/${slug}.json`,
      body: query,
      prefix: 'page'
    });
  }
}

export default new DocumentsService()