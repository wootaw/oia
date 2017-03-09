import Vue from 'vue';
import projectsService from 'SERVICE/ProjectsService';
import ValidatableForm from 'MIXIN/ValidatableForm'

const New = Vue.component('projects-new', (resolve, reject) => {

  projectsService.getNewForm().then(d => {
    resolve({
      mixins: [ValidatableForm],

      template: d.data,

      directives: {
        toggleDropdown: {
          update(el, binding) {
            if (binding.value) {
              $(el).dropdown('toggle');
            }
          }
        }
      },

      methods: {
        service: () => projectsService.create,

        processResponse(resp) {
          switch(resp.code) {
          case 200:
            location.reload();
            break;
          case 401:
            this.alert = true;
            this.msg = resp.data.msg;
            break;
          }
        },

      },

      beforeCreate() {
        this.__fields = {
          name: 'required|alpha_dash',
          summary: 'required'
        };
      },

      data() {
        let dvd = this.defaultValidateData();
        dvd.drop = false;
        return dvd
      }

    });
  });
});

export default New