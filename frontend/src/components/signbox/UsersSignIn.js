import Vue from 'vue';
import signService from 'SERVICE/SignService';
import { Validator } from 'vee-validate';
import isEmail from 'validator/lib/isEmail'
import ValidatableForm from 'MIXIN/ValidatableForm'
import 'DIRECTIVE/groupfocus';

Validator.extend('account', {
  getMessage: field => 'The account must be an email or username you registered with.',
  validate: value => /^[a-zA-Z0-9_-]*$/.test(value) || isEmail(String(value))
});

const UsersSignIn = Vue.component('users-sign_in', (resolve, reject) => {

  signService.getSignInForm().then(d => {
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
            this.msgs = resp.data.msgs;
            break;
          }
        }
      },

      beforeCreate() {
        this.__fields = {
          account: 'required|account',
          password: 'required|min:6'
        };
      },

    });
  });
});

export default UsersSignIn