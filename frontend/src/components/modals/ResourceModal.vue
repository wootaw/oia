<template>
  <div class="modal fade modal-full" id="comments-modal" tabindex="-1" role="dialog" v-modal="setParams">
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
                  <div class="wrapper-md">
                    <div class="m-b b-l m-l-md streamline">
                      <slot></slot>
                      <comment v-for="comment of comments" :key="comment.id" :comment="comment"></comment>
                    </div>
                    <reply-panel :resourceid="resource_id" @commentcreated="commentCreated"></reply-panel>
                  </div>
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
import ResourceNav from 'COMPONENT/navs/ResourceNav'
import ResourceView from 'COMPONENT/sidebars/ResourceView'
import Comment from 'COMPONENT/comments/Comment'
import ReplyPanel from 'COMPONENT/comments/ReplyPanel'
export default {
  // props: ['method', 'summary', 'path'],

  data () {
    return {
      resource_view_dent: true,
      resource_id: null,
      tab: null,
      comments: []
    }
  },

  components: { 
    'resource-view': ResourceView,
    'resource-nav': ResourceNav,
    'comment': Comment,
    'reply-panel': ReplyPanel
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

          binding.value($(el).data('resource_id'), parts[3]);
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
    },

    commentCreated(comment) {
      this.comments.push(comment);
    }
  }
}
</script>