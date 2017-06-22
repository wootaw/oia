import 'bootstrap/dist/css/bootstrap.css'
import 'ASSET/scss/app.scss'
import 'VENDOR/font-awesome/css/font-awesome.min.css'

import 'UTIL/bootjs'
import 'es6-shim'
import Vue from 'vue'
import Sign from 'MIXIN/Sign'
import 'DIRECTIVE/scaleout';
import 'COMPONENT/signbox/UsersSignIn'
import 'COMPONENT/signbox/UsersSignUp'

// import { Realtime, TextMessage } from 'leancloud-realtime'

$(function() {
  let app = new Vue({
    el: '#app',

    data: {
      sign: 0,
      modal: 0,
      email: null
    },

    mixins: [Sign],

  });
});
