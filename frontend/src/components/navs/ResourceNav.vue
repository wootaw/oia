<template>
  <ul class="nav nav-tabs m-t-md">
    <li class="left"><a class="bg-paper" href="#" @click.stop.prevent="toggleDent"><i :class="dentClasses"></i></a></li>
    <li class="active m-l"><a href="#">Comments</a></li>
    <li><a href="#">Console</a></li>
  </ul>
</template>

<script>
export default {
  props: ['responses'],

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

  },

  methods: {
    toggleDent () {
      this.dedent = !this.dedent;
      this.$emit('resviewdent', this.dedent);
    }
  },

  
}
</script>