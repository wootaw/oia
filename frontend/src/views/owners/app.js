import 'bootstrap/dist/css/bootstrap.css'
import 'ASSET/scss/app.scss'
import 'VENDOR/icons/iconfont.css'

import 'UTIL/bootjs'
import 'es6-shim'
import Vue from 'vue'
import Sign from 'MIXIN/Sign'
import 'DIRECTIVE/scaleout';
import 'COMPONENT/signbox/UsersSignIn'
import 'COMPONENT/signbox/UsersSignUp'
import 'VIEW/projects/new'
import ProjectsList from 'VIEW/owners/ProjectsList'

// import { Realtime, TextMessage } from 'leancloud-realtime'

$(function() {
  let app = new Vue({
    el: '#app',

    mixins: [Sign],

    components: {
      'projects-list':  ProjectsList
    },

    methods: {
      projectCreated(project) {
        this.lastest = project;
      }
    },

    data: {
      sign: 0,
      modal: 0,
      lastest: null
    }
  });
});
