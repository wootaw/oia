<template>
  <div :class="classes" v-if="more" v-scroll="{ scroll: scroll, max: max, location: location, load: loadMore }">
    <i class="ball left"></i>
    <i class="ball center"></i>
    <i class="ball right"></i>
  </div>
</template>

<script>
import documentsService from 'SERVICE/DocumentsService';
export default {
  props: ['owner', 'project', 'version', 'location', 'scroll', 'max'],

  data () {
    return {
      doing: false,
      more: true
    }
  },

  computed: {
    classes () {
      let r = ['border-loading', this.location];
      if (this.doing) {
        r.push('doing');
      }
      return r;
    }
  },

  directives: {
    scroll: {
      inserted(el, binding) {
        $('i.center', el).css({ left: $(el).width() / 2 - 5 });
      },

      update(el, binding) {
        if ($(el).data('init') == undefined) {
          $(el).data('init', true);
        } else {
          switch(binding.value.location) {
            case 'top':
              if (binding.value.scroll <= 150) {
                let top = binding.value.scroll - 50;
                let d = (1 - top / 100) * $(el).width() / 2 - 12;
                $(el).css({ top: top });
                $('i.left', el).css({ left: d });
                $('i.right', el).css({ right: d });
                if (top == 0) {
                  let id = $('.panel-doc:first-child').attr('id');
                  binding.value.load('top', id);
                }
              }
              break;
            case 'bottom':
              if (binding.value.scroll >= binding.value.max - 100) {
                let bottom = binding.value.max - binding.value.scroll;
                let d = (1 - bottom / 100) * $(el).width() / 2 - 12;
                $(el).css({ bottom: -1 * bottom });
                $('i.left', el).css({ left: d });
                $('i.right', el).css({ right: d });
                if (bottom == 0) {
                  let id = $('.panel-doc:last-child').attr('id');
                  binding.value.load('bottom', id);
                }
              }
              break;
          }
        }
      },
    }
  },

  methods: {
    loadMore(v, slug) {
      if (this.doing) { return; }

      this.doing = true;
      documentsService.getPrev(slug, {
        'owner_name': this.owner,
        'project_name': this.project,
        'version': this.version,
        'location': this.location
      }).then(d => {
        this.doing = false;
        let doc = d.data.documents;
        if (doc == undefined) {
          this.more = false;
        } else {
          this.$emit('documentloaded', doc, this.location);
        }
      });
    }
  },

  watch: {

  }
}
</script>