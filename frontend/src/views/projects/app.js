import 'bootstrap/dist/css/bootstrap.css'
import 'bootstrap/dist/js/bootstrap'
import 'es6-shim'
import 'ASSET/scss/app.scss'
import 'VENDOR/font-awesome/css/font-awesome.min.css'

import Vue from 'vue'
import 'COMPONENT/signbox/UsersSignIn'
import 'COMPONENT/signbox/UsersSignUp'
import 'VIEW/projects/new'
import 'UTIL/sticky-kit'
import smoothscroll from 'smoothscroll'
import Sign from 'MIXIN/Sign'
// import ProjectsList from 'VIEW/owners/ProjectsList'

$(function() {
  let app = new Vue({
    el: '#app',

    mixins: [Sign],

    directives: {
      scrollspy: {
        bind(el, binding) {
          $(el).scrollspy(binding.value);
        }
      },

      smoothscroll: {
        bind(el, binding) {
          $(el).on('click', function(e) {
            e.preventDefault();
            smoothscroll($($(this).attr('href'))[0], 500, undefined, $(binding.value)[0]);
          })
        }
      },

      sticky: {
        inserted(el, binding) {
          $(el).stick_in_parent(binding.value);
        }
      }
    },
    // components: {
    //   'projects-list':  ProjectsList
    // },

    methods: {
      // projectCreated(project) {
      //   this.lastest = project;
      // }
    },

    data: {
      sign: 0,
      modal: 0,
      lastest: null
    }
  });
});
