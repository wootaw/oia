<template>
  <div class="clearfix m-b-lg">
    <a class="pull-left thumb-sm avatar">
      <img src="/uploads/user/xs_gk8cafay6-bzt3p34hz-l4p1da4ky-ccddpza4z-kidttqup6.png" alt="...">
    </a>
    <div class="m-l-xxxl panel b-a bg-dark dk panel-reply">
      <div class="panel-heading pos-rlt b-light no-padder">
        <span class="arrow left"></span>
        <ul class="nav nav-tabs nav-sm m-t-sm">
          <li :class="writeTabClasses">
            <a href="#" @click.stop.prevent="toggleTab('write')">Write</a>
          </li>
          <li :class="previewTabClasses">
            <a href="#" @click.stop.prevent="toggleTab('preview')">Preview</a>
          </li>
          <li class="pull-right dropdown">
            <button class="btn btn-xs m-r-sm m-t-n-sm dropdown-toggle" data-toggle="dropdown" v-dropdown>
              <i class="fa fa-code"></i><span class="caret"></span>
            </button>
            <ul class="dropdown-menu dropup pull-left m-r-sm">
              <li v-for="(value, key) in languages">
                <a href="#" v-html="value" @click.stop.prevent="appendCode(key)"></a>
              </li>
            </ul>
          </li>
        </ul>
      </div>
      <div class="panel-body">
        <textarea 
          class="w-full form-control" 
          rows="4" 
          v-show="tab=='write'" 
          @keydown.tab.stop.prevent="insertion='  '" 
          v-editor="[getInsertion, setInsertion, setContent, insertion]"
        ></textarea>
        <div class="preview-area b-b" v-show="tab=='preview'">
          <div :class="previewAreaClasses" v-html="preview"></div>
        </div>
        <button class="btn m-t w-xs btn-success pull-right" @click="setContent('ok')">Comment</button>
      </div>
    </div>
    <!-- <div class="editor-shadow"></div> -->
  </div>
</template>

<script>
import commentsService from 'SERVICE/CommentsService';
import 'VENDOR/jquery.autogrow-textarea'
export default {
  // props: ['responses'],

  data () {
    return {
      content: '',
      preview: '',
      insertion: null,
      changed: false,
      loading: false,
      tab: 'write',
      languages: {
        'ruby':   'Ruby',
        'erb':    'HTML / ERB',
        'scss':   'CSS / SCSS',
        'js':     'JavaScript',
        'yml':    'YAML',
        'coffee': 'CoffeeScript',
        'conf':   'Nginx / Redis <i>(.conf)</i>',
        'python': 'Python',
        'php':    'PHP',
        'java':   'Java',
        'erlang': 'Erlang',
        'shell':  'Shell / Bash'
      }
    };
  },

  computed: {
    writeTabClasses () {
      return {
        'm-l': true,
        'active': this.tab == 'write'
      };
    },

    previewTabClasses () {
      return {
        'active': this.tab == 'preview'
      };
    },

    previewAreaClasses () {
      return {
        'bg-loading': this.loading,
        'x-c-y-c': this.loading,
        'h-xxs': this.loading
      }
    }
  },

  directives: {
    dropdown: {
      bind(el, binding) {
        $(el).dropdown();
      }
    },

    editor: {
      bind(el, binding) {
        $(document).on('shown.bs.modal', (e) => {
          $(el).autogrow();
        });

        $(el).blur((e) => {
          binding.value[2]($(el).val());
        });
      },

      update(el, binding) {
        let str = binding.value[0]();
        if (str != null) {
          let start = el.selectionStart;
          let end   = el.selectionEnd;

          $(el).val(`${$(el).val().substring(0, start)}${str}${$(el).val().substring(end)}`);
          el.selectionStart = el.selectionEnd = start + str.length;
          $(el).focus();

          binding.value[1](null);
        }
      }
    }
  },

  methods: {
    toggleTab (tab) {
      this.tab = tab;

      switch(tab) {
        case 'preview':
          if (this.changed) {
            this.loading = true;
            this.preview = '';
            commentsService.preview(this.content).then(d => {
              this.changed = false;
              this.loading = false;
              this.preview = d.data.body;
            });
          }
          break;
      }
    },

    appendCode(lang) {
      console.log(lang);
    },

    getInsertion() {
      return this.insertion;
    },

    setInsertion(val) {
      this.insertion = val;
    },

    setContent(str) {
      this.content = str;
    }
  },

  watch: {
    content(nv, ov) {
      if (nv != ov) {
        this.changed = true;
      }
    }
  }
  
}
</script>

<style>
/*.editor-shadow {
  position: absolute;
  top: -10000;
  left: -10000;
  resize: none;
}*/
</style>