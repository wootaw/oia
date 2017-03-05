import Vue from 'vue';
import signService from 'SERVICE/SignService';
import { Validator } from 'vee-validate';
import isEmail from 'validator/lib/isEmail'
import ValidatableForm from 'MIXIN/ValidatableForm'

Validator.extend('account', {
  getMessage: field => 'The account must be an email or username you registered with.',
  validate: value => /^[a-zA-Z0-9_-]*$/.test(value) || isEmail(String(value))
});

const UsersSignIn = Vue.component('users-sign_in', (resolve, reject) => {

  signService.getSignInForm().then(d => {
    resolve({
      mixins: [ValidatableForm],

      template: d.data,

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