<!-- <template>
  <div class="padder-xl" v-html="content"></div>
</template> -->

<script>
import Vue from 'vue'
export default {
  props: ['content', 'form', 'type'],

  beforeUpdate() {
    // let res = Vue.compile(this.content)
    // this.render = res.render
    // this.staticRenderFns = res.staticRenderFns
    if (this[this.type] == null) {
      console.log('first')
      this[this.type] = 1
    }
  },

  render: function (h) {
    // return createElement(
    //   'h' + this.level,   // tag name 标签名称
    //   this.$slots.default // 子组件中的阵列
    // )

    // console.log(h)
    // return Vue.compile(this.content).render()
    // return h('div', {
    //   attrs: {
    //     class: 'padder-xl',
    //     'v-html': 'content'
    //   }
    // })
    // console.log(this.form)
    // console.log(this.form())
    // console.log(this.form().render)
    // console.log(this.content)
    // console.log(this.type)
    // if (this[this.type] == null) {
    //   console.log('first')
    //   let SignIn = Vue.component('sign-in', {
    //     template: this.content
    //   })

    //   this[this.type] = SignIn
    // }
    Vue.component('sign-in', {
        template: this.content
      })
    return h('div', { attrs: {class: 'padder-xl'} }, 
      [
        h('sign-in'),
      ]
    )
  },

  data() {
    return {
      sign_in: null,
      sign_up: null
    }
  }

  // staticRenderFns: function() {
  //   return this.form().staticRenderFns()
  // }
}
</script>