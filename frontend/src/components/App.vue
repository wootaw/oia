<template>
  <div class="panel panel-doc list m-b-none no-radius">
    <div class="panel-heading">{{fff}}</div>
    <resources></resources>
  </div>
</template>

<script>
import Resources from 'COMPONENT/sidebars/Resources'

export default {
  // 路由会自动将该组件挂载到 #app 上
  // el: () => '#app',
  
  components: { Resources },

  // 注意：顶级变量必须设置默认值方能引入 observer
  data: () => ({
    // console.log('-------');
    fff: 'Personal',
    userData: null
  })
}
</script>