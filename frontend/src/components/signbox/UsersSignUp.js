import Vue from 'vue';
import signService from 'SERVICE/SignService';
import { Validator } from 'vee-validate';
import ValidatableForm from 'MIXIN/ValidatableForm'

const UsersSignUp = Vue.component('users-sign_up', (resolve, reject) => {

  signService.getPage('/users/sign_up').then(d => {
    resolve({
      mixins: [ValidatableForm],

      template: d.data,

      beforeCreate() {
        this.__fields = {
          username: 'required|alpha_dash',
          email: 'required|email',
          password: 'required|min:6'
        };
      },

    });
  });
});

export default UsersSignUp