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
import DocumentPanel from 'VIEW/documents/DocumentPanel'
import 'VIEW/projects/new'
// import 'VIEW/projects/jquery.waypoints'
import 'UTIL/sticky-kit'
import 'UTIL/distance'
import smoothscroll from 'smoothscroll'
import Sign from 'MIXIN/Sign'
import documentsService from 'SERVICE/DocumentsService';
// import ProjectsList from 'VIEW/owners/ProjectsList'

$(function() {
  let app = new Vue({
    el: '#app',

    mixins: [Sign],

    components: { 
      'border-loading': BorderLoading,
      'document-panel': DocumentPanel
    },

    directives: {
      scrollspy: {
        bind(el, binding) {
          $(el).scrollspy(binding.value);
        },
      },

      calch: {
        inserted(el, binding) {
          let fnode = $('.panel-doc:first .panel-res:first > .panel-heading', el);
          // console.log(fnode.distanceTop('#scroll-container'));
        },
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
          // $(el).stick_in_parent(binding.value);
          let opts = binding.value;
          // opts.spacer = '.sticky-spacer';
          $('.panel-body .panel-res > .panel-heading', el).stick_in_parent(opts);
        }
      },

    },

    methods: {
      scrolledTo(scroll, max) {
        this.scroll = scroll;
        this.max = max;
      },

      documentLoaded(doc, location) {
        switch(location) {
          case 'top':
            this.topdocs.splice(0, 0, doc);
            break;
          case 'bottom':
            this.bottomdocs.push(doc);
            break;
        }
      }
    },

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
      scroll: null,
      max: null,
      topdocs: [],
      bottomdocs: []
    }
  });
});
