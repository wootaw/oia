import xhr from './xhr/'

class SignService {

  getSignInForm () {
    return xhr({
      url: '/users/sign_in',
      prefix: 'page'
    });
  }

  getSignUpForm () {
    return xhr({
      url: '/users/sign_up',
      prefix: 'page'
    });
  }

  sign(path, query) {
    return xhr({
      url: path,
      body: query,
      method: 'post',
      prefix: 'page'
    });
  }

  exists (value, type) {
    return xhr({
      url: '/users/exists',
      body: { type: type, value: value },
      prefix: 'page'
    });
  }
}

export default new SignService()