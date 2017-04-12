<template>
  <div :id="document.name" class="wrapper-md panel-doc" v-recalc-sticky="dir" v-sticky="{ offset_top: 50, container: '#scroll-container' }">
    <h2>{{document.summary}}</h2>
    <div class="wrapper" v-html="document.md_description"></div>
    <resource-panel
      v-for="res of document.resources"
      :document="document"
      :resource="res"
      :key="res.id"
    ></resource-panel>
  </div>
</template>

<script>
import ResourcePanel from 'VIEW/documents/ResourcePanel'
import smoothscroll from 'smoothscroll'
export default {
  props: ['document', 'dir'],

  components: {
    'resource-panel': ResourcePanel
  },

  data () {
    return {
      doing: false,
    }
  },

  directives: {
    sticky: {
      inserted(el, binding) {
        $('.panel-body .panel-res > .panel-heading', el).stick_in_parent(binding.value);
      }
    },

    recalcSticky: {
      inserted(el, binding) {
        let lc = '.panel-body .panel-res:last-child';
        let ct = el;
        if (binding.value == 'bottom') {
          ct = $(el).prev();
        }

        smoothscroll($(lc, ct)[0], 0, function() {
          $(document.body).trigger("sticky_kit:recalc");
        }, $('#scroll-container')[0]);
      }
    }
  }
}
</script>