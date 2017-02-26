<template>
  <ul class="list-group alt">
    <li v-for="res in ress" class="list-group-item">
      <div class="media">
        <span class="label label-success pull-left">{{ res.method }}</span>
        <a href="#" class="more pull-right m-t-sm">
          <i class="fa fa-ellipsis-h"></i>
        </a>
        <div class="media-body">
          <a href="#">
            <h5>{{ res.summary }}</h5>
            <small class="text-muted">{{ res.path }}</small>
          </a>
        </div>
      </div>
    </li>
  </ul>
</template>

<script>
export default {
  // computed: {
  //   routes: () => _pickBy(routesMap, route => route.showInNavbar)
  // },
  // filters: {
  //   defaultIcon: icon => icon ? icon : 'fa fa-link'
  // },
  // attached () {
  //   $(this.$el).find('[data-toggle=tooltip]').tooltip({
  //     placement: 'bottom'
  //   })
  // }
  data () {
    return {
      ress: [{method: 'get', summary: "abc", path: '/appa'}]
    }
  }
}
</script>