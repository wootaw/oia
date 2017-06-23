import 'bootstrap/dist/css/bootstrap.css'
import 'ASSET/scss/app.scss'
import 'VENDOR/icons/iconfont.css'
import 'ASSET/scss/highlight.css'

import 'UTIL/bootjs'
import 'es6-shim'
import Vue from 'vue'
import Sign from 'MIXIN/Sign'
import 'DIRECTIVE/scaleout';
import 'COMPONENT/signbox/UsersSignIn'
import 'COMPONENT/signbox/UsersSignUp'
import DocumentsList from 'VIEW/projects/DocumentsList'
import DocumentPanel from 'VIEW/documents/DocumentPanel'
import ResourceModal from 'VIEW/resources/ResourceModal'
import ResourcesOutline from 'VIEW/projects/ResourcesOutline'
import CollaboratorsList from 'VIEW/projects/CollaboratorsList'
import CollaboratorsModal from 'VIEW/projects/CollaboratorsModal'

import 'DIRECTIVE/showmodal'
// import 'UTIL/sticky-kit'
import smoothscroll from 'smoothscroll'
import documentsService from 'SERVICE/DocumentsService';

$(function() {
  let app = new Vue({
    el: '#app',

    data: {
      sign: 0,
      modal: 0,
      // lastest: null,
      // scroll: null, // resource scroll to
      // max: null,
      current: null,
      document_name: null
      // topdocs: [],
      // bottomdocs: [],
      // documents: [],
      // resource: null,
      // document: null
    },

    mixins: [Sign],

    components: {
      'documents-list':       DocumentsList,
      'document-panel':       DocumentPanel,
      'resource-modal':       ResourceModal,
      'resources-oulline':    ResourcesOutline,
      'collaborators-list':   CollaboratorsList,
      'collaborators-modal':  CollaboratorsModal
    },

    computed: {
      // documentName () {
      //   return this.current == null ? null : this.current.name;
      // },

    },

    directives: {
      scrollspy: {
        bind(el, binding) {
          // $(el).scrollspy(binding.value);
        },
      },

      urlspy: {
        bind(el, binding) {
          $(document).on('activate.bs.scrollspy', function(e) {
            // let item = $(e.target);
            // if (item.hasClass('list-group-item')) { return; }
            // let child = $('.list-group-item.active', item);
            // if (child.length == 0) {
            //   item = $('> a', item);
            // } else {
            //   item = $('a', child);
            // }
            // if (item.length == 0) { return; }

            // let id = item.data('target').substr(1);
            // let parts = location.pathname.split('/');
            // let url = `/${parts[1]}/${parts[2]}/${id}`;
            // if (url != location.pathname) {
            //   if ($(el).data('old') == undefined) {
            //     $(el).data('old', true);
            //   } else {
            //     window.history.replaceState("", "", url);
            //   }
            // }
          });
        }
      },

      // smoothscroll: {
      //   bind(el, binding) {
      //     $(el).on('click', function(e) {
      //       e.preventDefault();
      //       let id = $(this).attr('href').split('/')[1];
      //       let parts = location.pathname.split('/');
      //       // smoothscroll($(`#${id}`)[0], 500, function() {
      //       //   window.history.pushState("", "", `/${parts[1]}/${parts[2]}/${id}`);
      //       // }, $(binding.value)[0]);
      //     });
      //   }
      // },

      // sticky: {
      //   inserted(el, binding) {
      //     // $('.panel-res > .panel-heading', el).stick_in_parent(binding.value);
      //   }
      // },

    },

    methods: {
      // scrolledTo(scroll, max) {
      //   this.scroll = scroll;
      //   this.max = max;
      // },

      // documentLoaded(doc, location) {
      //   switch(location) {
      //     case 'top':
      //       this.topdocs.splice(0, 0, doc);
      //       break;
      //     case 'bottom':
      //       this.bottomdocs.push(doc);
      //       break;
      //   }
      // },

      documentChanged (doc) {
        this.current = doc;
      },

      needDocument (document_name) {
        this.document_name = document_name;
      },

    },

    mounted() {
      let parts = location.pathname.split('/');
      if (parts.length > 3) {
        smoothscroll($(`#${parts[3]}`)[0], 500, undefined, $('#scroll-container')[0]);
      }
    }
  });
});
