<template>
  <div class="panel panel-default bg-dark panel-resps">
    <div class="panel-heading dker">
      <h4>Responses</h4>
    </div>
    <table class="table table-striped m-b-none">
      <tbody>
        <tr v-for="resp of responses" :key="resp.id" :class="level(resp.ancestor)">
          <td><i class="fa fa-lv"></i><span>{{resp.name}}</span></td>
          <td>
            <b>{{resp.summary}}</b><br/>
            <span v-html="resp.md_description"></span>
          </td>
          <td>{{resp.data_type}}<span v-if="resp.array">[]</span></td>
        </tr>
      </tbody>
    </table>
  </div>
</template>

<script>
export default {
  props: ['responses'],

  methods: {
    level (ancestor) {
      let lv = ancestor == null ? 0 : ancestor.split('.').length;
      return [`resp-lv${lv}`];
    }
  },

  data () {
    return {};
  }
}
</script>