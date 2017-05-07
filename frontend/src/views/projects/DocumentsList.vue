<template>
  <ul :class="navClasses" v-init="[selected, setProps]" v-affix="[setProps]">
    <slot></slot>
  </ul>
</template>

<script>
import documentsService from 'SERVICE/DocumentsService';
export default {
  props: ['documentid', 'documentname'],

  data () {
    return {
      active: null,
      slug: null,
      loading: false,
      affix: null,
      documents: []
    };
  },

  computed: {
    selected () {
      return this.active || this.documentid;
    },

    navClasses () {
      return {
        'nav': true,
        'nav-cata': true,
        'affix': this.affix == 'affix',
        'affix-top': this.affix == 'affix-top',
        'affix-bottom': this.affix == 'affix-bottom',
        'loading': this.loading
      };
    }
  },

  watch: {
    documentname (nv, ov) {
      if (nv != ov && nv != null) {
        this.setProps('slug', nv);
      }
    }
  },

  directives: {
    init: {
      inserted(el, binding) {
        $(el).find('li a.doc-item').click(function() {
          if ($(this).parents('.nav-cata').hasClass('loading')) {
            return false;
          }
          binding.value[1]('active', $(this).parents().data('id'));
          binding.value[1]('slug', $(this).attr('href'));
          return false;
        }).each((i, elm) => {
          if ($(elm).parents().data('id') == binding.value[0]) {      // binding.value[0] == selected
            $(elm).parents().addClass('active');
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

    affix: {
      bind(el, binding) {
        $(el).affix({
          offset: {
            top: 20,
            bottom: 20
          }
        }).on('affixed.bs.affix', function (e) {
          binding.value[0]('affix', 'affix');
        }).on('affixed-top.bs.affix', function (e) {
          binding.value[0]('affix', 'affix-top');
        }).on('affixed-bottom.bs.affix', function (e) {
          binding.value[0]('affix', 'affix-bottom');
        });
      }
    }
  },

  methods: {

    setProps (prop, value) {
      this[prop] = value;

      if (prop == 'slug') {
        this.findDocument(value);
      }
    },

    findDocument (slug) {
      let current = null
      this.documents.some((doc, idx, docs) => {
        if (doc.name == slug) {
          current = doc;
          return true;
        }
      });

      if (current == null) {
        this.loading = true;
        const parts = location.pathname.split('/').slice(1, 3);

        documentsService.getOne(slug, {
          'owner_name': parts[0],
          'project_name': parts[1],
          // 'version': resel.data('version'),
          'location': 'current'
        }).then(d => {
          this.loading = false;
          current = d.data.documents
          this.documents.push(current);
          this.$emit('documentchanged', current);
        });
      } else {
        this.$emit('documentchanged', current);
      }
    }
  }
}
</script>