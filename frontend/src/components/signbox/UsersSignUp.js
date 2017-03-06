import Vue from 'vue';
import signService from 'SERVICE/SignService';
import { Validator } from 'vee-validate';
import ValidatableForm from 'MIXIN/ValidatableForm'

Validator.extend('exists', {
  getMessage: (field) => `${field} already exists.`,
  validate: (value, type) => new Promise(resolve => {
    setTimeout(() => {
      signService.exists(value, type[0]).then(resp => {
        resolve({ valid: !resp.data.exists });
      });
    }, 500);
  })
});

const UsersSignUp = Vue.component('users-sign_up', (resolve, reject) => {

  signService.getSignUpForm().then(d => {
    resolve({
      mixins: [ValidatableForm],

      template: d.data,

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