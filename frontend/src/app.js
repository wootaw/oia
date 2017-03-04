import 'es6-shim'
import 'jquery-ujs'
import 'ASSET/scss/app.scss'
import 'VENDOR/font-awesome/css/font-awesome.min.css'

// // import router from 'ROUTE/'
// import App from 'COMPONENT/App'
import Vue from 'vue'
// import Vuelidate from 'vuelidate'
// import VeeValidate from 'vee-validate'
// import { Validator } from 'vee-validate';
// import signService from 'SERVICE/SignService'
import UsersSignIn from 'COMPONENT/signbox/UsersSignIn'
import UsersSignUp from 'COMPONENT/signbox/UsersSignUp'
// require('COMPONENT/signbox/UsersSignIn')

// require('./jquery')

$(function() {
  // Vue.use(VeeValidate);
  // console.log(Vuelidate);
  // Vue.use(window.vuelidate.default);
  // const signPanels = [{
  //   name: 'users-sign_in',
  //   validator: new Validator({
  //     login: 'required',
  //     password: 'required|min:6'
  //   })
  // }, {
  //   name: 'users-sign_up',
  //   validator: null
  // }, {
  //   name: 'users-password-new',
  //   validator: null
  // }]

  // signPanels.forEach((panel) => {
  //   let path = panel.name.replace(/\-/g, '/')

    
  // })

  if($('#sign-modal').length > 0) {
    let signVue = new Vue({
      el: '#sign-modal',

      methods: {
        openPage(path) {
          this.type = path.replace(/^\//, '').replace(/\//g, '-')
        },

        // fuckIt(resp) {
        //   console.log('fucking...')
        //   console.log(resp)
        // }
      },
      // created() {
      //         this.$watch('errors', (errors) => {
      //             // this.errors.clear();
      //             // errors.forEach(e => {
      //             //     this.errors.add(e.field, e.msg, e.rule, e.scope);
      //             // });
      //             console.log(errors)
      //         })
      //     },
      data: {
        type: 0,
      }
    })

    $('.btn-sign').click((e) => {
      signVue.openPage($(e.target).attr('data-path'))
    })
  } else {

  }
});

// router.start(App, '#app')
