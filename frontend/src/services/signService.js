import xhr from './xhr/'

class SignService {

  getSignInForm() {
    return xhr({
      url: '/users/sign_in',
      prefix: 'page'
    });
  }

  getSignUpForm(data) {
    const options = {
      url: '/users/sign_up',
      prefix: 'page'
    };

    if (data != null) {
      options.body = data;
    }

    return xhr(options);
  }

  sign(path, query) {
    return xhr({
      url: path,
      body: query,
      method: 'post',
      prefix: 'page',
      dt: 'json'
    });
  }

  exists(value, type) {
    return xhr({
      url: '/users/exists',
      body: { type: type, value: value },
      prefix: 'page'
    });
  }

  signOut(path, body) {
    return xhr({
      url: path,
      body: body,
      method: 'post',
      prefix: 'page'
    })
  }
}

export default new SignService()