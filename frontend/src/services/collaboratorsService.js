import xhr from './xhr/'

class CollaboratorsService {
  fetchList (owner, project) {
    return xhr({
      url: '/collaborators.json',
      body: { owner_name: owner, project_name: project },
      prefix: 'page',
      dt: 'json'
    })
  }

}

export default new CollaboratorsService()