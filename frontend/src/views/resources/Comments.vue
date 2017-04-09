<template>
  <div class="wrapper-md">
    <div class="m-b b-l m-l-md streamline">
      <slot></slot>
      <comment v-for="comment of comments" :key="comment.id" :comment="comment"></comment>
    </div>
    <reply-panel :resourceid="resourceid" @commentcreated="commentCreated"></reply-panel>
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
      comments: []
    }
  },

  components: { 
    'comment': Comment,
    'reply-panel': ReplyPanel
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
    }
  },

  methods: {
    loadComments() {
      this.loading = true;
      commentsService.fetchList(this.resourceid).then(d => {
        this.loading = false;
        switch(d.code) {
          case 200:
            this.comments = d.data.comments;
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
    }
  }
}
</script>