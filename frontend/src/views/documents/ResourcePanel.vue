<template>
  <div :id="resource.slug" class="panel panel-res">
    <div class="panel-heading bg-green dk">
      <div class="clearfix">
        <div class="clear">
          <div class="h3 m-t-xs m-b-sm">
            <span>{{document.summary}}</span>
            <span class="sep">/</span>
            <span>{{resource.summary}}</span>
            <button class="btn m-b-xs btn-xs btn-warning pull-right" v-showmodal="{id: '#comments-modal', data: {slug: resource.slug, tab: 'comments'}}">
              <i class="fa fa-comments m-r-xs"></i>25
            </button>
          </div>
          <span :class="methodClasses">{{resource.method}}</span>
          <span class="label pull-left" v-html="colourPath"></span>
        </div>
      </div>
    </div>
    <div class="panel-body no-padder">
      <div class="wrapper bg-light" v-html="resource.md_description"></div>
      <parameter-panel :parameters="resource.parameters"></parameter-panel>
      <response-panel :responses="resource.responses"></response-panel>
    </div>
  </div>
</template>

<script>
import 'UTIL/sticky-kit'
import ParameterPanel from 'VIEW/documents/ParameterPanel'
import ResponsePanel from 'VIEW/documents/ResponsePanel'
export default {
  props: ['resource', 'document'],

  components: {
    'parameter-panel': ParameterPanel,
    'response-panel': ResponsePanel
  },

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
    },

    colourPath () {
      let path = this.resource.path;
      this.resource.parameters.reduce((r, c) => {
        if (c.location == 'path') {
          r.push(c.name);
        }
        return r;
      }, []).forEach((n) => {
        path = path.replace(new RegExp(`(:${n})`), '<span class="text-danger">$1</span>');
      });
      return path;
    }
  },

  directives: {

  },
}
</script>