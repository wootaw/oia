<template>
  <div :id="document.name" class="panel panel-doc m-b-none no-radius" v-recalc-sticky>
    <div class="panel-heading"><h2>{{document.summary}}</h2></div>
    <div class="panel-body">
      <div class="wrapper">{{document.md_description}}</div>
      <resource-panel
        v-for="res of document.resources"
        :document="document"
        :resource="res"
        :key="res.id"
      >
      </resource-panel>
    </div>
  </div>
</template>

<script>
import ResourcePanel from 'VIEW/documents/ResourcePanel'
import smoothscroll from 'smoothscroll'
export default {
  props: ['document'],

  components: {
    'resource-panel': ResourcePanel
  },

  data () {
    return {
      doing: false,
    }
  },

  directives: {
    recalcSticky: {
      inserted(el, binding) {
        $(document.body).trigger("sticky_kit:recalc");
        smoothscroll($('.panel-body .panel-res:last-child', el)[0], 0, undefined, $('#scroll-container')[0]);
      }
    }
  }
}
</script>