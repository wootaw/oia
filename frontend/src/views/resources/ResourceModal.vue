<template>
  <div class="modal fade modal-full" id="resource-modal" tabindex="-1" role="dialog" v-modal="[toggleTab, find]">
    <button class="btn btn-rounded btn-lg btn-icon btn-default btn-close" data-dismiss="modal">
      <i class="fa fa-times"></i>
    </button>
    <div class="grid-over h-full">
      <div class="hbox hbox-auto-xs">
        <resource-view :dedent="resource_view_dent" :resource="resource" :document="document"></resource-view>
        <div class="col w-auto b-l">
          <div class="vbox bg-dark dker">
            <resource-nav 
              @resviewdent="resourceViewDent" 
              @tabchanged="toggleTab" 
              :commentstotal="comments_total" 
              :tab="tab"
            ></resource-nav>
            <div class="row-row bg-dark box-s-l-i">
              <div class="cell">
                <div class="cell-inner">
                  <comments-view 
                    :resourceid="resourceId" 
                    :tab="tab" 
                    @totalchanged="updateCommentsTotal" 
                    v-show="tab=='comments'"
                  ><slot></slot>
                  </comments-view>
                  <console-view 
                    :resource="resource" 
                    :tab="tab" 
                    v-show="tab=='console'" 
                    v-if="resource!=null"
                  ></console-view>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import ResourceNav from 'VIEW/resources/ResourceNav'
import ResourceView from 'VIEW/resources/ResourceView'
import CommentsView from 'VIEW/resources/CommentsView'
import ConsoleView from 'VIEW/resources/ConsoleView'
export default {
  props: ['find', 'resource', 'document'],

  data () {
    return {
      resource_view_dent: true,
      comments_total: null,
      tab: null,
      loading: false,
    }
  },

  components: { 
    'resource-view': ResourceView,
    'resource-nav': ResourceNav,
    'comments-view': CommentsView,
    'console-view': ConsoleView,
  },

  computed: {
    resourceId () {
      return this.resource == null ? null : this.resource.id;
    }
  },

  directives: {

    modal: {
      bind(el, binding) {
        $(el).on('show.bs.modal', function (e) {
          let parts = location.pathname.split('/').slice(1, 3);
          parts.push($(el).data('slug'));
          parts.push($(el).data('tab'));

          binding.value[1]($(el).data('resource_id'), parts[2], 'search');  // call findResource in app
          binding.value[0](parts[3]);            // call toggleTab
          
          window.history.pushState('', 'Comments', `/${parts.join('/')}`);
        }).on('hidden.bs.modal', function (e) {
          binding.value[1](null, null, 'clear');

          let parts = location.pathname.split('/').slice(1, 4);
          window.history.pushState("", "", `/${parts.join('/')}`);
        });
      },

      inserted(el, binding) {
        $('.comment-init', el).removeClass('dp-none');
      }
    }
  },

  methods: {
    resourceViewDent(dent) {
      this.resource_view_dent = dent;
    },

    toggleTab (tab) {
      this.tab = tab;
    },

    updateCommentsTotal(total) {
      this.comments_total = total;
    }
  }
}
</script>