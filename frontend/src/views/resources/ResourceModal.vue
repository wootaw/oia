<template>
  <div class="modal fade modal-full" id="resource-modal" tabindex="-1" role="dialog" v-modal="[setProps]">
    <button class="btn btn-rounded btn-lg btn-icon btn-default btn-close" data-dismiss="modal">
      <i class="fa fa-times"></i>
    </button>
    <div class="grid-over h-full modal-dialog">
      <div class="hbox hbox-auto-xs">
        <resource-view :dedent="resource_view_dent" :resource="resource" :document="document"></resource-view>
        <div class="col w-auto b-l">
          <div class="vbox bg-dark dker">
            <resource-nav 
              @resviewdent="resourceViewDent" 
              @tabchanged="setProps" 
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
import documentsService from 'SERVICE/DocumentsService';
export default {
  props: ['document'],

  data () {
    return {
      resource_view_dent: true,
      comments_total: null,
      tab: null,
      loading: false,
      resource_slug: null,
      document_name: null
    }
  },

  components: { 
    'resource-view': ResourceView,
    'resource-nav':  ResourceNav,
    'comments-view': CommentsView,
    'console-view':  ConsoleView,
  },

  computed: {
    resourceId () {
      return this.resource == null ? null : this.resource.id;
    },

    resource () {
      if (this.withoutResource()) {
        return null;
      } else {
        let result = null;
        this.document.resources.some((res, idx, ress) => {
          if (res.slug == this.resource_slug) {
            result = res;
            return true;
          }
        });
        return result;
      }
    }
  },

  directives: {

    modal: {
      bind(el, binding) {
        let parts = null;
        $(el).on('show.bs.modal', function (e) {
          parts = location.pathname.split('/').slice(1, 3);
          parts.push($(el).data('slug'));
          parts.push($(el).data('tab'));

          binding.value[0]('document_name', $(el).data('document_name'));
          binding.value[0]('resource_slug', parts[2]);    // call setProps
          window.history.pushState('', 'Comments', `/${parts.join('/')}`);
        }).on('shown.bs.modal', function (e) {
          binding.value[0]('tab', parts[3]);              // call setProps
        }).on('hide.bs.modal', function (e) {
        }).on('hidden.bs.modal', function (e) {
          window.history.pushState("", "", `/${parts.slice(0, 3).join('/')}`);
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

    withoutResource () {
      return this.document == null || this.resource_slug == null;
    },

    setProps (prop, value) {
      this[prop] = value;
      if (prop == 'resource_slug') {
        if (this.withoutResource()) {
          this.$emit('needdocument', this.document_name);
        }
      }
    },

    updateCommentsTotal(total) {
      this.comments_total = total;
    }
  }
}
</script>