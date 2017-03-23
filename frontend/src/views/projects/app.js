import 'bootstrap/dist/css/bootstrap.css'
import 'bootstrap/dist/js/bootstrap'
import 'es6-shim'
import 'ASSET/scss/app.scss'
import 'ASSET/scss/highlight.css'
import 'VENDOR/font-awesome/css/font-awesome.min.css'

import Vue from 'vue'
import 'COMPONENT/signbox/UsersSignIn'
import 'COMPONENT/signbox/UsersSignUp'
import 'VIEW/projects/new'
// import 'VIEW/projects/jquery.waypoints'
import 'UTIL/sticky-kit'
import smoothscroll from 'smoothscroll'
import Sign from 'MIXIN/Sign'
// import ProjectsList from 'VIEW/owners/ProjectsList'

$(function() {
  let app = new Vue({
    el: '#app',

    mixins: [Sign],

    // props: ['resources'],

    directives: {
      scrollspy: {
        bind(el, binding) {
          $(el).scrollspy(binding.value);
        }
      },

      urlspy: {
        bind(el, binding) {
          $(document).on('activate.bs.scrollspy', function() {
            let item = $('.list-group-item.active a', el);
            if (item.length == 0) {
              item = $('.heading.active > a', el);
            }
            if (item.length == 0) { return; }

            let id = item.attr('href').split('/')[1];
            let parts = location.pathname.split('/');
            let url = `/${parts[1]}/${parts[2]}/${id}`;
            if (url != location.pathname) {
              window.history.replaceState("", "", url);
            }
          });
        }
      },

      // more: {
      //   $(document).on('activate.bs.scrollspy', function() {
      //     let item = $(`${binding.value.target} .list-group-item.active a`);
      //     if (item.length == 0) {
      //       item = $(`${binding.value.target} .heading.active > a`);
      //     }
          
      //     let id = item.attr('href').split('/')[1];
      //     let parts = location.pathname.split('/');
      //     let url = `/${parts[1]}/${parts[2]}/${id}`;
      //     if (url != location.pathname) {
      //       window.history.replaceState("", "", url);
      //     }

      //     // console.log(item.data('target'))
      //     // console.log($('.panel-res:last-child').attr('id'))
      //     if ($('.panel-res:last-child').attr('id') == item.data('target').substr(1)) {
      //       console.log('----->')
      //     }
      //   });
      // },

      smoothscroll: {
        bind(el, binding) {
          $(el).on('click', function(e) {
            e.preventDefault();
            let id = $(this).attr('href').split('/')[1];
            let parts = location.pathname.split('/');
            smoothscroll($(`#${id}`)[0], 500, function() {
              window.history.pushState("", "", `/${parts[1]}/${parts[2]}/${id}`);
            }, $(binding.value)[0]);
          });
        }
      },

      sticky: {
        inserted(el, binding) {
          $(el).stick_in_parent(binding.value);
        }
      },

      // colorpath: {
      //   bind(el, binding) {
      //     // $(el).scrollspy(binding.value);
      //     $(el).html()
      //   }
      // }
    },
    // components: {
    //   'projects-list':  ProjectsList
    // },

    // computed: {
    //   colourPath(id, path) {
    //     return path + id;
    //   }
    // },

    // methods: {
    //   // projectCreated(project) {
    //   //   this.lastest = project;
    //   // }
    //   setResources(id, pname, type) {
    //     // ifresources[id]
    //     if (this.resources[id] == undefined) {
    //       this.resources[id] = {};
    //     }
    //     this.resources[id][pname] = type;
    //   },

    //   colourPath(id, path) {
    //     return path + id;
    //   }
    // },

    mounted() {
      let parts = location.pathname.split('/');
      if (parts.length > 3) {
        smoothscroll($(`#${parts[3]}`)[0], 500, undefined, $('#scroll-container')[0]);
      }
    },

    data: {
      sign: 0,
      modal: 0,
      lastest: null,
      // resources: {}
    }
  });
});
