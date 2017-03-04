import Vue from 'vue';
import signService from 'SERVICE/SignService';
import { Validator } from 'vee-validate';
import isEmail from 'validator/lib/isEmail'

Validator.extend('account', {
    getMessage: field => 'The account must be an email or username you registered with.',
    validate: value => /^[a-zA-Z0-9_-]*$/.test(value) || isEmail(String(value))
});

const elements = {
  account: null,
  password: null
};

const UsersSignIn = Vue.component('users-sign_in', (resolve, reject) => {

  signService.getPage('/users/sign_in').then(d => {
    resolve({
      template: d.data,

      validator: null,

      computed: {
        disabledSubmit() {
          return this.alert || this.errors.has('account') || this.errors.has('password');
        }
      },

      methods: {
        setPath(p) {
          this.$emit('gopage', p);
        },

        trySignIn(e) {
          this.validator.validateAll({
            account: this.account,
            password: this.password
          }).then(success => {
            if (success) {
              let form = $(e.target)
              signService.signIn(form.attr('action'), form.serialize()).then((resp) => {
                switch(resp.code) {
                  case 200:
                    location.reload();
                    break;
                  case 401:
                    this.alert = true;
                    this.msg = resp.data.msg;
                    break;
                }
              });
            }
          });
        },

        initElements(field) {
          if(elements[field] == null) {
            elements[field] = $(`#user_${field}`).parent('.input-group');
          }
        },

        clearAlert() {
          if (this.alert) {
            this.alert = false;
          }
        }
      },

      watch: {
        account(value) {
          this.clearAlert();
          let ov = this.errors.has('account');
          if(this.validator.validate('account', value)) {
            this.account_error_changed = ov ? 'hide' : null;
          } else {
            this.account_error_changed = ov ? null : 'show';
          }
        },

        password(value) {
          this.clearAlert();
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
          password: 'required|min:6'
        });
        this.$set(this, 'errors', this.validator.errorBag);
      },

      updated() {
        if (this.account_error_changed != null) {
          this.initElements('account');
          elements.account.tooltip(this.account_error_changed);
          this.account_error_changed = null;
        }
        if (this.password_error_changed != null) {
          this.initElements('password');
          elements.password.tooltip(this.password_error_changed);
          this.password_error_changed = null;
        }
      },

      data() {
        return {
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