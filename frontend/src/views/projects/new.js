import Vue from 'vue';
import projectsService from 'SERVICE/ProjectsService';
import ValidatableForm from 'MIXIN/ValidatableForm'

const New = Vue.component('projects-new', (resolve, reject) => {

  projectsService.getNewForm().then(d => {
    resolve({
      mixins: [ValidatableForm],

      template: d.data,

      directives: {
        dropdown: {
          bind(el, binding) {
            $(el).dropdown();
          }
        },

        modal: {
          update(el, binding) {
            if (binding.value != binding.oldValue) {
              $(el).parents('.modal').modal('hide')
            }
          }
        }
      },

      methods: {
        service: () => projectsService.create,

        processResponse(resp) {
          switch(resp.code) {
          // case 204:
          case 200:
            if (resp.data.code == 201) {
              this.success += 1;
            } else {
              this.alert = true;
              this.msgs = resp.data.msgs;
            }
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
          name: 'required|alpha_dash|min:2',
          // summary: 'required'
        };
      },

      data() {
        let dvd = this.defaultValidateData();
        dvd.success = 0;
        return dvd
      }

    });
  });
});

export default New