import xhr from './xhr/'

class DocumentsService {
  fetchList (query) {
    return xhr({
      url: '/documents',
      body: query
    })
  }
}

export default new DocumentsService()