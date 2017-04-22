<template>
  <div :class="viewClasses">
    <div class="vbox">
      <div class="row-row">
        <div class="cell">
          <div class="cell-inner">
            <div class="wrapper" v-if="resource != null">
              <div class="clearfix m-b">
                <div class="h3 m-t-xs m-b-sm">
                  <span>{{document.summary}}</span>
                  <span class="sep">/</span>
                  <span>{{resource.summary}}</span>
                </div>
                <span :class="methodClasses">{{resource.method}}</span>
                <span class="label pull-left text-muted">{{resource.path}}</span>
              </div>
              <div class="no-padder bg-dark no-bg m-b" v-html="resource.md_description"></div>
              <parameter-panel :parameters="resource.parameters"></parameter-panel>
              <response-panel :responses="resource.responses"></response-panel>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import ResourcePanel from 'VIEW/documents/ResourcePanel'
import ParameterPanel from 'VIEW/documents/ParameterPanel'
import ResponsePanel from 'VIEW/documents/ResponsePanel'
export default {
  props: ['dedent', 'resource', 'document'],

  data () {
    return {
      'w': true
    };
  },

  components: { 
    'resource-panel': ResourcePanel,
    'parameter-panel': ParameterPanel,
    'response-panel': ResponsePanel
  },

  computed: {
    viewClasses () {
      return {
        'col': true,
        'w-40': this.w,
        'w-1x': !this.w,
        'bg-loading': this.resource == null,
        'x-c-y-c': this.resource == null,
        'bounce-in-left': this.dedent && this.resource != null,
        'slide-out-left': !this.dedent
      };
    },

    methodClasses () {
      let r = ['label', 'pull-left', 'm-r-sm'];
      r.push({
        'GET':    'label-success', 
        'POST':   'label-warning', 
        'PUT':    'label-primary', 
        'DELETE': 'label-danger' 
      }[this.resource.method]);
      return r;
    },

  },

  watch: {
    dedent (nv, ov) {
      if (nv) {
        this.w = nv;
      } else {
        setTimeout(() => {
          this.w = nv;
        }, 500);
      }
    }
  },

  methods: {
    // level (ancestor) {
    //   let lv = ancestor == null ? 0 : ancestor.split('.').length;
    //   return [`resp-lv${lv}`];
    // }
  }
}
</script>