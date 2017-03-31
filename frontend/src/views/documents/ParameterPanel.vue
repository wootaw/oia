<template>
  <div class="panel panel-default bg-dark no-radius no-border">
    <div class="panel-heading dker">
      <span class="label bg-danger pull-right m-t-xs">4 left</span>
      <h4>Parameters</h4>
    </div>
    <table class="table table-striped m-b-none">
      <tbody>
        <tr v-for="param of parameters" :key="param.id">
          <td :class="locationClasses(param.location)">
            <i class="fa fa-lv"></i>
            <span>{{param.name}}</span>
          </td>
          <td>
            <b>{{param.summary}}</b><br/>
            <span v-html="param.md_description"></span>
          </td>
          <td>{{param.data_type}}<span v-if="param.array">[]</span></td>
        </tr>
      </tbody>
    </table>
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