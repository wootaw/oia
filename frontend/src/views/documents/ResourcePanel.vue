<template>
  <div :id="resource.slug" class="panel panel-res">
    <div class="panel-heading bg-green dk" v-sticky="{ offset_top: 50, container: '#scroll-container' }">
      <div class="clearfix">
        <div class="clear">
          <div class="h3 m-t-xs m-b-sm">
            <span>{{document.summary}}</span>
            <span class="sep">/</span>
            <span>{{resource.summary}}</span>
            <i class="fa fa-circle text-success pull-right text-xs m-t-sm"></i>
          </div>
          <span :class="methodClasses">{{resource.method}}</span>
          <span class="label pull-left">{{resource.path}}</span>
        </div>
      </div>
    </div>
    <div class="panel-body no-padder">
      <div class="wrapper bg-light">{{resource.md_description}}</div>
    </div>
  </div>
</template>

<script>
// import ResourceItem from 'COMPONENT/sidebars/ResourceItem'
export default {
  props: ['resource', 'document'],

  // components: { ResourceItem },

  computed: {
    methodClasses () {
      let r = ['label', 'pull-left', 'm-r-sm'];
      r.push({
        'GET':    'label-success', 
        'POST':   'label-warning', 
        'PUT':    'label-primary', 
        'DELETE': 'label-danger' 
      }[this.resource.method]);
      return r;
    }
  },
}
</script>