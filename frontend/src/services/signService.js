import xhr from './xhr/'

class SignService {
  getPage (path, query) {
    return xhr({
      url: path,
      body: query,
      prefix: 'page'
    })
  }
}

export default new SignService()