import 'bootstrap/dist/css/bootstrap.css'
// import 'bootstrap/dist/js/bootstrap'
import 'UTIL/bootjs'
import 'es6-shim'
import 'ASSET/scss/app.scss'
import 'ASSET/scss/highlight.css'
import 'VENDOR/font-awesome/css/font-awesome.min.css'

import Vue from 'vue'
import 'COMPONENT/signbox/UsersSignIn'
import 'COMPONENT/signbox/UsersSignUp'
import BorderLoading from 'COMPONENT/loadings/BorderLoading'
import 'VIEW/projects/new'
// import 'VIEW/projects/jquery.waypoints'
import 'UTIL/sticky-kit'
import smoothscroll from 'smoothscroll'
import Sign from 'MIXIN/Sign'
import documentsService from 'SERVICE/DocumentsService';
// import ProjectsList from 'VIEW/owners/ProjectsList'

$(function() {
  let app = new Vue({
    el: '#app',

    mixins: [Sign],

    // props: ['resources'],
    components: { BorderLoading },

    directives: {
      scrollspy: {
        bind(el, binding) {
          $(el).scrollspy(binding.value);
        }
      },

      urlspy: {
        bind(el, binding) {
          $(document).on('activate.bs.scrollspy', function(e) {
            let item = $(e.target);
            if (item.hasClass('list-group-item')) { return; }
            let child = $('.list-group-item.active', item);
            if (child.length == 0) {
              item = $('> a', item);
            } else {
              item = $('a', child);
            }
            if (item.length == 0) { return; }

            let id = item.data('target').substr(1);
            let parts = location.pathname.split('/');
            let url = `/${parts[1]}/${parts[2]}/${id}`;
            if (url != location.pathname) {
              if ($(el).data('old') == undefined) { 
                $(el).data('old', true);
              } else {
                window.history.replaceState("", "", url);
              }
            }
          }).on('top.bs.scrollspy', function(e) {
            // console.log('&&&&')
            binding.value('top', $('.panel-doc:first-child').attr('id'));
            // if ($('.panel-doc:first-child').attr('id') == id) {
            //   binding.value('top');
            // }

            // if ($('.panel-doc:last-child .panel-res:last-child').attr('id') == id) {
            //   binding.value('bottom');
            // }
          });
        }
      },

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

    methods: {

      scrolledTo(v, slug) {
        this.loadTop = slug;
      },

      documentLoaded(doc, location) {
        console.log(doc);
        console.log(location);
      }
    },

    mounted() {
      let parts = location.pathname.split('/');
      if (parts.length > 3) {
        smoothscroll($(`#${parts[3]}`)[0], 500, undefined, $('#scroll-container')[0]);
      }

      // this.$on('documentloaded', this.documentLoaded);
    },

    data: {
      sign: 0,
      modal: 0,
      lastest: null,
      // firstTop: true,
      loadTop: false,
      topdocs: []
      // version: -1
      // resources: {}
    }
  });
});
