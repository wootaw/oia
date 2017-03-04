import Vue from 'vue';
import signService from 'SERVICE/SignService';
import { Validator } from 'vee-validate';
import isEmail from 'validator/lib/isEmail'
// import { Validator } from 'vee-validate'
// import Rules from 'vee-validate/rules';
// import isEmail from 'validator/lib/isEmail';

// console.log(Validator);
Validator.extend('account', {
    getMessage: field => 'The account must be an email or username you registered with.',
    validate: value => /^[a-zA-Z0-9_-]*$/.test(value) || isEmail(String(value))
});

const elements = {
  account: null,
  password: null
};

const UsersSignIn = Vue.component('users-sign_in', (resolve, reject) => {

  signService.getPage('/users/sign_in').then((d) => {
    resolve({
      template: d.data,

      validator: null,

      methods: {
        setPath(p) {
          this.$emit('gopage', p);
        },

        trySignIn(e) {
          let form = $(e.target)
          signService.signIn(form.attr('action'), form.serialize()).then((resp) => {
            switch(resp.code) {
              case 401:
                this.alert = true;
                this.msg = resp.data.msg;
                break;
            }
          })
        },

        initElements() {
          if(elements.account == null || elements.password == null) {
            elements.account = $('#user_account').parent('.input-group');
            elements.password = $('#user_password').parent('.input-group');
          }
        }
      },

      watch: {
        account(value) {
          // this.initElements();
          let ov = this.errors.has('account');
          if(this.validator.validate('account', value)) {
            this.account_error_changed = ov ? 'hide' : null;
          } else {
            this.account_error_changed = ov ? null : 'show';
          }
        },
        password(value) {
          // this.initElements();
          let ov = this.errors.has('password');
          if(this.validator.validate('password', value)) {
            this.password_error_changed = ov ? 'hide' : null;
          } else {
            this.password_error_changed = ov ? null : 'show';
          }
        }
      },

      created() {
        this.validator = new Validator({
          account: 'required|account',
          // login: "{ rules: ['alpha_dash', 'email'] }",
          password: 'required|min:6'
        });
        this.$set(this, 'errors', this.validator.errorBag);
      },

      updated() {
        if (this.account_error_changed != null) {
          this.initElements();
          elements.account.tooltip(this.account_error_changed);
          this.account_error_changed = null;
        }
        if (this.password_error_changed != null) {
          this.initElements();
          elements.password.tooltip(this.password_error_changed);
          this.password_error_changed = null;
        }
      },

      data() {
        return {
          test: 0,
          alert: false,
          msg: '',
          errors: null,
          account_error_changed: null,
          password_error_changed: null,
          account: '',
          password: ''
        }
      },
      
    })
  })
})

export default UsersSignIn