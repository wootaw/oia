import Vue from 'vue';
import projectsService from 'SERVICE/ProjectsService';

const ProjectPanel = Vue.component('project-panel', (resolve, reject) => {

  projectsService.getTemplate('panel').then(d => {
    resolve({

      props: ['project'],

      template: d.data,

    });
  });
});

export default ProjectPanel