<template>
  <div>
    <a class="pull-left thumb-sm avatar m-l-n-md scale-up-center">
      <img :src="comment.user.avatar_url">
    </a>
    <div :class="panelClasses">
      <div class="panel-heading pos-rlt b-b b-light">
        <span class="arrow left"></span>                    
        <a class="b" href>{{comment.user.username}}</a>
        <label class="label bg-success m-l-xs">User</label>
        <span class="text-muted m-l-sm pull-right">
          <i class="fa fa-clock-o m-r-xs"></i>{{comment.updated}} ago
        </span>
        <span class="text-primary-dker pull-right">#{{comment.position}}</span>
      </div>
      <div class="panel-body" v-html="comment.md_body"></div>
    </div>
  </div>
</template>

<script>
export default {
  props: ['comment'],

  data () {
    return {
    }
  },

  computed: {
    panelClasses () {
      return {
        'm-l-xl': true,
        'panel': true,
        'b-a': true,
        'bg-paper': true,
        'scale-in-tl': this.comment.new
      };
    }
  }
}
</script>