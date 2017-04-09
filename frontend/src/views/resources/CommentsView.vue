<template>
  <div class="wrapper-md">
    <div class="m-b b-l m-l-md streamline">
      <slot></slot>
      <comment v-for="comment of comments" :key="comment.id" :comment="comment"></comment>
    </div>
    <reply-panel :resourceid="resourceid" @commentcreated="commentCreated" :panel="tab"></reply-panel>
  </div>
</template>

<script>
import Comment from 'VIEW/resources/Comment'
import ReplyPanel from 'VIEW/resources/ReplyPanel'
import commentsService from 'SERVICE/CommentsService';
export default {
  props: ['resourceid', 'tab'],

  data () {
    return {
      loading: false,
      meta: null,
      comments: []
    }
  },

  components: { 
    'comment': Comment,
    'reply-panel': ReplyPanel
  },

  computed: {
    total() {
      if (this.meta == null) {
        return 0;
      } else {
        return this.meta.total;
      }
    }
  },

  watch: {
    resourceid(nv, ov) {
      if (nv != ov) {
        this.loadComments();
      }
    },

    tab(nv, ov) {
      if (nv != ov && nv == 'comments') {
        this.loadComments();
      }
    },

    total(nv, ov) {
      if (nv != null) {
        this.$emit('totalchanged', nv);
      }
    }
  },

  methods: {
    loadComments() {
      this.meta = null;
      this.comments = [];
      this.loading = true;
      commentsService.fetchList(this.resourceid).then(d => {
        this.loading = false;
        switch(d.code) {
          case 200:
            this.comments = d.data.comments;
            this.meta = d.data.meta;
            break;
          case 401:
            this.alert = true;
            this.msg = resp.msg;
            break;
        }
      });
    },

    commentCreated(comment) {
      comment.new = true;
      this.comments.push(comment);
      if (this.meta == null) {
        this.meta = { total: 0 };
      }
      this.meta.total += 1;
    }
  }
}
</script>