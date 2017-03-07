import 'es6-shim'
import 'ASSET/scss/app.scss'
import 'VENDOR/font-awesome/css/font-awesome.min.css'

import Vue from 'vue'
import 'COMPONENT/signbox/UsersSignIn'
import 'COMPONENT/signbox/UsersSignUp'
import signService from 'SERVICE/SignService';

$(function() {
  new Vue({
    el: '#app',

    methods: {
      openPage(path) {
        this.type = path.replace(/^\//, '').replace(/\//g, '-');
      },

      csrfToken: x => $('meta[name=csrf-token]').attr('content'),

      csrfParam: x => $('meta[name=csrf-param]').attr('content'),

      signOut(path) {
        let body = { '_method': 'delete' };
        body[this.csrfParam()] = this.csrfToken();
        signService.signOut(path, body).then((resp) => {
          switch(resp.code) {
            case 204:
              location.reload();
              break;
            case 401:
              break;
          }
        });
      }
    },

    data: {
      type: 0,
    }
  });
});
