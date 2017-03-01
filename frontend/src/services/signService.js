import xhr from './xhr/'

class SignService {
  getPage (path, query) {
    return xhr({
      url: path,
      // url: '/docs.json',
      body: query
    })
  }
}

export default new SignService()