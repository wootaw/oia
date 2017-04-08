<template>
  <div class="modal fade modal-full" id="comments-modal" tabindex="-1" role="dialog" v-modal>
    <button class="btn btn-rounded btn-lg btn-icon btn-default btn-close" data-dismiss="modal">
      <i class="fa fa-times"></i>
    </button>
    <div class="grid-over h-full">
      <div class="hbox hbox-auto-xs">
        <resource-view :dedent="resource_view_dent"></resource-view>
        <div class="col w-auto b-l">
          <div class="vbox bg-dark dker">
            <resource-nav v-on:resviewdent="resourceViewDent"></resource-nav>
            <slot></slot>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import ResourceNav from 'COMPONENT/navs/ResourceNav'
import ResourceView from 'COMPONENT/sidebars/ResourceView'
export default {
  // props: ['method', 'summary', 'path'],

  data () {
    return {
      resource_view_dent: true,
    }
  },

  components: { 
    'resource-view': ResourceView,
    'resource-nav': ResourceNav,
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

          window.history.pushState("", "Comments", `/${parts.join('/')}`);
        }).on('hidden.bs.modal', function (e) {
          let parts = location.pathname.split('/').slice(1, 4);
          window.history.pushState("", "", `/${parts.join('/')}`);
        });
      }
    }
  },

  methods: {
    resourceViewDent(dent) {
      this.resource_view_dent = dent;
    }
  }
}
</script>