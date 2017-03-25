<template>
  <div :id="document.name" class="panel panel-doc m-b-none no-radius">
    <div class="panel-heading"><h2>{{document.summary}}</h2></div>
    <div class="panel-body">
      <div class="wrapper">{{document.md_description}}</div>
    </div>
  </div>
</template>

<script>
import smoothscroll from 'smoothscroll'
export default {
  props: ['document'],

  data () {
    return {
      doing: false,
    }
  },

  // computed: {
  //   classes () {
  //     let r = ['border-loading', this.location];
  //     if (this.doing) {
  //       r.push('doing');
  //     }
  //     return r;
  //   }
  // },

  // watch: {
  //   slug(nv, ov) {
  //     this.doing = true;
  //     documentsService.getPrev(nv, {
  //       'owner_name': this.owner,
  //       'project_name': this.project,
  //       'version': this.version,
  //       'location': this.location
  //     }).then(d => {
  //       this.doing = false;
  //       this.$emit('documentloaded', d, this.location);
  //     });
  //   }
  // }
}
</script>