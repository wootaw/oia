import xhr from './xhr/'

class ProjectsService {

  getListByOwner(path, query) {
    return xhr({
      url: path,
      body: query,
      prefix: 'page',
      dt: 'json'
    });
  }

  getNewForm() {
    return xhr({
      url: '/projects/new',
      prefix: 'page'
    });
  }

  getTemplate(type) {
    return xhr({
      url: '/projects/templates',
      body: { t: type },
      prefix: 'page'
    });
  }

  create(path, query) {
    return xhr({
      url: '/projects',
      body: query,
      method: 'post',
      prefix: 'page'
    });
  }

}

export default new ProjectsService()