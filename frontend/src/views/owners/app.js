import 'es6-shim'
import 'ASSET/scss/app.scss'
import 'VENDOR/font-awesome/css/font-awesome.min.css'

import Vue from 'vue'
import 'COMPONENT/signbox/UsersSignIn'
import 'COMPONENT/signbox/UsersSignUp'
import 'VIEW/projects/new'
import Sign from 'MIXIN/Sign'
import ProjectsList from 'VIEW/owners/ProjectsList'
// import signService from 'SERVICE/SignService';

$(function() {
  new Vue({
    el: '#app',

    mixins: [Sign],

    components: {
      'projects-list':  ProjectsList
    },

    data: {
      sign: 0,
      modal: 0
    }
  });

});
