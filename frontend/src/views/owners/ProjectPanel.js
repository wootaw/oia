import Vue from 'vue';
import projectsService from 'SERVICE/ProjectsService';

const ProjectPanel = Vue.component('project-panel', (resolve, reject) => {

  projectsService.getTemplate('panel').then(d => {
    resolve({

      props: ['project', 'owner'],

      template: d.data,

      computed: {
        detailUrl() {
          return `/${this.owner}/${this.project.name}`;
        }
      }

    });
  });
});

export default ProjectPanel