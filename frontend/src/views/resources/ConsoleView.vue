<template>
  <div class="wrapper-md">
    this is console.
  </div>
</template>

<script>
export default {
  props: ['parameters'],

  methods: {
    locationClasses (location) {
      let r = [];
      r.push({
        'header': 'text-muted',
        'path':   'text-danger',
        'query':  'text-info-dker',
        'form':   'text-warning',
        'body':   'text-info',
        'cookie': '',
      }[location]);
      return r;
    }
  },

  data () {
    return {};
  }
}
</script>