import xhr from './xhr/'

class ProjectsService {

  getNewForm() {
    return xhr({
      url: '/projects/new',
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