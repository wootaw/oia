<template>
  <div :class="viewClasses">
    <div class="vbox">
      <div class="row-row">
        <div class="cell">
          <div class="cell-inner">
            <div class="wrapper-md">
              This is the scrollable content
              <p>&nbsp;</p><p>&nbsp;</p><p>&nbsp;</p><p>&nbsp;</p><p>&nbsp;</p><p>&nbsp;</p><p>&nbsp;</p><p>&nbsp;</p><p>监听当前实例上的自定义事件。事件可以由vm.$emit触发。回调函数会接收所有传入事件触发函数的额外参数。</p><p>&nbsp;</p><p>&nbsp;</p><p>&nbsp;</p><p>&nbsp;</p><p>&nbsp;</p><p>&nbsp;</p><p>&nbsp;</p><p>&nbsp;</p><p>&nbsp;</p><p>&nbsp;</p><p>&nbsp;</p><p>&nbsp;</p><p>&nbsp;</p><p>&nbsp;</p><p>&nbsp;</p><p>&nbsp;</p><p>&nbsp;</p><p>&nbsp;</p><p>&nbsp;</p><p>&nbsp;</p><p>&nbsp;</p><p>&nbsp;</p><p>&nbsp;</p><p>&nbsp;</p><p>&nbsp;</p><p>&nbsp;</p><p>&nbsp;</p>
              You got the bottom
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  props: ['dedent'],

  data () {
    return {
      'w': true
    };
  },

  computed: {
    viewClasses () {
      return {
        'col': true,
        'w-40': this.w,
        'w-1x': !this.w,
        'bounce-in-left': this.dedent,
        'slide-out-left': !this.dedent
      };
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
    level (ancestor) {
      let lv = ancestor == null ? 0 : ancestor.split('.').length;
      return [`resp-lv${lv}`];
    }
  }
}
</script>