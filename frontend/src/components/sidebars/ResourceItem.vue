<template>
  <div class="media">
    <span v-bind:class="[label, labelLeft, labelColor]">{{ methodName }}</span>
    <a href="#" class="more pull-right m-t-sm">
      <i class="fa fa-ellipsis-h"></i>
    </a>
    <div class="media-body">
      <a href="#">
        <h5>{{ summary }}</h5>
        <small class="text-muted">{{ path }}</small>
      </a>
    </div>
  </div>
</template>

<script>
export default {
  props: ['method', 'summary', 'path'],

  computed: {
    methodName () {
      let m = this.method
      if (m == '{delete}') m = m.substr(1, 3)
      return m.toUpperCase()
    }
  },

  data () {
    return {
      label: 'label',
      labelLeft: 'pull-left',
      labelColor: { 
        'get': 'label-success', 
        'post': 'label-warning', 
        'put': 'label-primary', 
        '{delete}': 'label-danger' 
      }[this.method]
    }
  }
}
</script>