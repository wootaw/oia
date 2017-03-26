<template>
  <div :class="classes" v-if="more">
    <i class="ball left"></i>
    <i class="ball center"></i>
    <i class="ball right"></i>
  </div>
</template>

<script>
import documentsService from 'SERVICE/DocumentsService';
export default {
  props: ['owner', 'project', 'version', 'location', 'slug'],

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

  watch: {
    slug(nv, ov) {
      if (this.doing) { return; }

      this.doing = true;
      documentsService.getPrev(nv, {
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
  }
}
</script>