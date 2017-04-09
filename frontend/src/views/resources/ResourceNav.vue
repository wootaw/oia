<template>
  <ul class="nav nav-tabs m-t-md">
    <li class="left"><a class="bg-paper" href="#" @click.stop.prevent="toggleDent"><i :class="dentClasses"></i></a></li>
    <li :class="commentsTabClasses">
      <a href="#" @click.stop.prevent="toggleTab('comments')">Comments
      <span class="badge bg-warning m-l-xs m-t-n-xs" v-show="commentstotal!=0">{{commentstotal}}</span></a>
    </li>
    <li :class="consoleTabClasses"><a href="#" @click.stop.prevent="toggleTab('console')">Console</a></li>
  </ul>
</template>

<script>
export default {
  props: ['responses', 'tab', 'commentstotal'],

  data () {
    return {
      dedent: true
    };
  },

  computed: {
    dentClasses () {
      return {
        'fa': true,
        'fa-fw': true,
        'fa-dedent': this.dedent,
        'fa-indent': !this.dedent
      };
    },

    commentsTabClasses () {
      return {
        'm-l': true,
        'active': this.tab == 'comments'
      };
    },

    consoleTabClasses () {
      return {
        'active': this.tab == 'console'
      };
    },
  },

  methods: {
    toggleDent () {
      this.dedent = !this.dedent;
      this.$emit('resviewdent', this.dedent);
    },

    toggleTab (tab) {
      this.$emit('tabchanged', tab);
    },
  },
  
}
</script>