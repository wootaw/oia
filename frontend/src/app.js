import 'es6-shim'
import 'jquery-ujs'
import 'ASSET/scss/app.scss'
import 'VENDOR/font-awesome/css/font-awesome.min.css'

import 'COMPONENT/signbox/UsersSignIn'
import 'COMPONENT/signbox/UsersSignUp'
import Vue from 'vue'

$(function() {
  if($('#sign-modal').length > 0) {
    let signVue = new Vue({
      el: '#sign-modal',

      methods: {
        openPage(path) {
          this.type = path.replace(/^\//, '').replace(/\//g, '-')
        },
      },

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
