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
          <li class="pull-right dropdown dropup">
            <button class="btn btn-xs m-r m-t-n-sm dropdown-toggle" data-toggle="dropdown" v-dropdown>
              <i class="fa fa-code"></i><span class="caret"></span>
            </button>
            <ul class="dropdown-menu pull-left m-r">
              <li v-for="(value, key) in languages">
                <a href="#" v-html="value" @click.prevent="appendCode(key)"></a>
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
          data-autogrow="false"
        ></textarea>
        <div class="preview-area b-b" v-show="tab=='preview'">
          <div :class="previewAreaClasses" v-html="preview"></div>
        </div>
        <button class="btn m-t w-xs btn-success pull-right" @click="addComment()">Comment</button>
      </div>
    </div>
  </div>
</template>

<script>
import commentsService from 'SERVICE/CommentsService';
import 'VENDOR/jquery.autogrow-textarea'
export default {
  props: ['resourceid'],

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
          if (!$(el).data('autogrow')) {
            $(el).autogrow();
            $(el).data('autogrow', true);
          }
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
          let caret = start + str.length;

          $(el).val(`${$(el).val().substring(0, start)}${str}${$(el).val().substring(end)}`);
          if (/`{3}\n/.test(str)) {
            caret -= 5;
          }
          el.selectionStart = el.selectionEnd = caret;
          $(el).focus();

          binding.value[1](null);
        }
      }
    }
  },

  methods: {
    toggleTab (tab) {
      if (this.loading) {
        return;
      }
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

    addComment() {
      if (this.loading) {
        return;
      }

      this.loading = true;
      commentsService.create(this.resourceid, this.content).then(d => {
        this.loading = false;
        switch(d.code) {
          case 200:
            if (d.data.code == 201) {
              this.$emit('commentcreated', d.data.comments);
            } else {
              this.msgs = d.data.msgs;
            }
            break;
          case 401:
            this.alert = true;
            this.msg = resp.msg;
            break;
        }
      });
    },

    appendCode(lang) {
      let prefix_break = '';
      if (this.content.length > 0) {
        prefix_break = '\n';
      }
      this.insertion = `${prefix_break}\`\`\`${lang}\n\n\`\`\`\n`;
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