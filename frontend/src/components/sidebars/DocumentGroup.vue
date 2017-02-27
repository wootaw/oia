<template>
  <div class="panel panel-doc list m-b-none no-radius">
    <div class="panel-heading">{{summary}}</div>
    <ul class="list-group alt">
      <li v-for="res in resources" class="list-group-item">
        <resource-item :method="res.method" :path="res.path" :summary="res.summary"></resource-item>
      </li>
    </ul>
  </div>
</template>

<script>
import ResourceItem from 'COMPONENT/sidebars/ResourceItem'
export default {
  props: ['summary', 'resources'],

  components: { ResourceItem }
}
</script>