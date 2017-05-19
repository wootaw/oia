import Vue from 'vue';
import signService from 'SERVICE/SignService';
import { Validator } from 'vee-validate';
import ValidatableForm from 'MIXIN/ValidatableForm'
import Timer from 'UTIL/Timer';
import 'DIRECTIVE/groupfocus';

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

  let inits = $('#sign-modal').data();
  inits = Object.keys(inits).reduce((r, c) => {
    if (typeof inits[c] != 'object') {
      r[c] = inits[c];
    }
    return r;
  }, {});

  signService.getSignUpForm(inits).then(d => {
    resolve({
      mixins: [ValidatableForm],

      template: d.data,

      methods: {
        service: () => signService.sign,

        processResponse(resp) {
          switch(resp.code) {
          case 200:
            location.href = resp.data.redirect;
            break;
          case 401:
            this.alert = true;
            this.msgs = resp.data.msgs;
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

      created () {
        Object.keys(this.form).forEach((item, idx) => {
          if (inits[item] != null) {
            this.form[item] = inits[item];
          }
        });
      }

    });
  });
});

export default UsersSignUp