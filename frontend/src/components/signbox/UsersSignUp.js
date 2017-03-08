import Vue from 'vue';
import signService from 'SERVICE/SignService';
import { Validator } from 'vee-validate';
import ValidatableForm from 'MIXIN/ValidatableForm'
import Timer from 'UTIL/Timer';

Validator.extend('exists', {
  getMessage: (field) => `${field} already exists, or is reserved word.`,
  validate: (value, type) => new Promise(resolve => {
    if (this.timers == undefined) {
      this.timers = {};
    }
    if (this.timers[type[0]] == undefined) {
      this.timers[type[0]] = new Timer(800);
    }

    this.timers[type[0]].restart().then((d) => {
      signService.exists(value, type[0]).then(resp => {
        resolve({ valid: !resp.data.exists });
      });
    });
  })
});

const UsersSignUp = Vue.component('users-sign_up', (resolve, reject) => {

  signService.getSignUpForm().then(d => {
    resolve({
      mixins: [ValidatableForm],

      template: d.data,

      methods: {
        service: () => signService.sign,

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
        }
      },

      beforeCreate() {
        this.__fields = {
          username: 'required|alpha_dash|exists:username',
          email: 'required|email|exists:email',
          password: 'required|min:6'
        };
      },

    });
  });
});

export default UsersSignUp