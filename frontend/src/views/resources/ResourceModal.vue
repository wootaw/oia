<template>
  <div class="modal fade modal-full" id="resource-modal" tabindex="-1" role="dialog" v-modal="[setParams]">
    <button class="btn btn-rounded btn-lg btn-icon btn-default btn-close" data-dismiss="modal">
      <i class="fa fa-times"></i>
    </button>
    <div class="grid-over h-full">
      <div class="hbox hbox-auto-xs">
        <resource-view :dedent="resource_view_dent"></resource-view>
        <div class="col w-auto b-l">
          <div class="vbox bg-dark dker">
            <resource-nav v-on:resviewdent="resourceViewDent"></resource-nav>
            <div class="row-row bg-dark box-s-l-i">
              <div class="cell">
                <div class="cell-inner">
                  <comments :resourceid="resource_id" :tab="tab">
                    <slot></slot>
                  </comments>
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
import Comments from 'VIEW/resources/Comments'
export default {
  // props: ['method', 'summary', 'path'],

  data () {
    return {
      resource_view_dent: true,
      resource_id: null,
      tab: null,
      loading: false,
    }
  },

  components: { 
    'resource-view': ResourceView,
    'resource-nav': ResourceNav,
    'comments': Comments,
  },

  computed: {
  },

  directives: {

    modal: {
      bind(el, binding) {
        $(el).on('show.bs.modal', function (e) {
          let parts = location.pathname.split('/').slice(1, 3);
          parts.push($(el).data('slug'));
          parts.push($(el).data('tab'));

          binding.value[0]($(el).data('resource_id'), parts[3]);
          window.history.pushState("", "Comments", `/${parts.join('/')}`);
        }).on('hidden.bs.modal', function (e) {
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

    setParams(resource_id, tab) {
      this.resource_id = resource_id;
      this.tab = tab;
    }

  }
}
</script>