import xhr from './xhr/'

class SignService {
  getPage (path, query) {
    return xhr({
      url: path,
      body: query,
      prefix: 'page'
    })
  }

  sign(path, query) {
    return xhr({
      url: path,
      body: query,
      method: 'post',
      prefix: 'page'
    })
  }
}

export default new SignService()