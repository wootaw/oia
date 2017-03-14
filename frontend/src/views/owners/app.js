import 'bootstrap/dist/css/bootstrap.css'
import 'bootstrap/dist/js/bootstrap'
import 'es6-shim'
import 'ASSET/scss/app.scss'
import 'VENDOR/font-awesome/css/font-awesome.min.css'

import Vue from 'vue'
import 'COMPONENT/signbox/UsersSignIn'
import 'COMPONENT/signbox/UsersSignUp'
import 'VIEW/projects/new'
import Sign from 'MIXIN/Sign'
import ProjectsList from 'VIEW/owners/ProjectsList'

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
