<template>
  <div class="clearfix m-b-lg">
    <a class="pull-left thumb-sm avatar"><img src="/uploads/user/xs_gk8cafay6-bzt3p34hz-l4p1da4ky-ccddpza4z-kidttqup6.png" alt="..."></a>
    <div class="m-l-xxxl panel b-a bg-dark dk panel-reply">
      <div class="panel-heading pos-rlt b-light no-padder">
        <span class="arrow left"></span>
        <ul class="nav nav-tabs nav-sm m-t-sm">
          <li :class="writeClasses">
            <a href="#" @click.stop.prevent="toggleTab('write')">Write</a>
          </li>
          <li :class="previewClasses">
            <a href="#" @click.stop.prevent="toggleTab('preview')">Preview</a>
          </li>
        </ul>
      </div>
      <div class="panel-body">
        <textarea class="w-full form-control" rows="4" v-show="this.tab=='write'"></textarea>
        <div class="preview-area b-b" v-show="this.tab=='preview'">
          <div>
            This is the scrollable content
            <p>&nbsp;</p><p>&nbsp;</p><p>&nbsp;</p><p>&nbsp;</p><p>&nbsp;</p><p>&nbsp;</p><p>&nbsp;</p><p>&nbsp;</p><p>监听当前实例上的自定义事件。事件可以由vm.$emit触发。回调函数会接收所有传入事件触发函数的额外参数。</p><p>&nbsp;</p><p>&nbsp;</p><p>&nbsp;</p><p>&nbsp;</p><p>&nbsp;</p><p>&nbsp;</p><p>&nbsp;</p><p>&nbsp;</p><p>&nbsp;</p><p>&nbsp;</p><p>&nbsp;</p><p>&nbsp;</p><p>&nbsp;</p><p>&nbsp;</p><p>&nbsp;</p><p>&nbsp;</p><p>&nbsp;</p><p>&nbsp;</p><p>&nbsp;</p><p>&nbsp;</p><p>&nbsp;</p><p>&nbsp;</p><p>&nbsp;</p><p>&nbsp;</p><p>&nbsp;</p><p>&nbsp;</p><p>&nbsp;</p>
            You got the bottom
          </div>
        </div>
        <button class="btn m-t w-xs btn-success pull-right">Comment</button>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  props: ['responses'],

  data () {
    return {
      dedent: true,
      tab: 'write'
    };
  },

  computed: {
    writeClasses () {
      return {
        'm-l': true,
        'active': this.tab == 'write'
      };
    },

    previewClasses () {
      return {
        'active': this.tab == 'preview'
      };
    },
  },

  methods: {
    toggleTab (tab) {
      this.tab = tab;
    }
  },
  
}
</script>