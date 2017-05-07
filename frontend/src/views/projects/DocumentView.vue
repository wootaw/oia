<template>
  <div class="panel-doc">
    <slot></slot>
  </div>
</template>

<script>
export default {
  props: ['current'],

  data () {
    return {
      active: null
    };
  },

  computed: {
    selected () {
      return this.active || this.current;
    }
  },

  // watch: {
  //   current (nv, ov) {
  //     console.log(nv);
  //   }
  // },

  directives: {
    init: {
      inserted(el, binding) {
        $(el).find('li').click(function() {
          binding.value[1]('active', $(this).data('id'));
          return false;
        }).each((i, elm) => {
          if ($(elm).data('id') == binding.value[0]) {
            $(elm).addClass('active');
          }
        });
      },

      componentUpdated(el, binding) {
        $(el).find('li').each((i, elm) => {
          if ($(elm).data('id') == binding.value[0]) {
            $(elm).addClass('active');
          } else {
            $(elm).removeClass('active');
          }
        });
      },
    },

  },

  methods: {

    setProps (prop, value) {
      this[prop] = value;
    }
  }
}
</script>