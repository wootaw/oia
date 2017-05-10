<template>
  <div :class="editorClasses" v-init="[setProps]">
    <span :class="itemClasses(index)" v-for="(tag, index) in tags" :key="index">
      <span @click="selected = index">{{tag}}</span>
      <i class="fa fa-times" @click="doRemove(index)"></i>
    </span>
    <input type="text" v-model="text" :size="size" @blur="onBlur" @keyup="checkInput" placeholder="Enter multiple emails">
  </div>
</template>

<script>
// import debounce from 'lodash/debounce'
import 'ASSET/scss/variables.scss'
import isEmail from 'validator/lib/isEmail'
export default {
  data () {
    return {
      focus: false,
      text: '',
      size: 20,
      tags: [],
      selected: null
    };
  },

  computed: {

    editorClasses () {
      return {
        'tags-editor': true,
        'form-control': true,
        'h': true,
        'editor-focus': this.focus
      };
    }
  },

  watch: {
    text (nv, ov) {
      this.size = nv.length > 20 ? nv.length + 2 : 20;
    }
  },

  directives: {
    init: {
      bind(el, binding) {
        $(el).click(() => {
          $('input', el).focus();
          binding.value[0]('focus', true);
        });
      }
    }
  },

  methods: {

    setProps (prop, value) {
      this[prop] = value;
    },

    itemClasses (index) {
      return {
        'tag-item': true,
        'selected': this.selected == index
      }
    },

    checkInput (e) {

      // console.log(e)

      if (e.code == "Backspace") {
        if (this.text == '') {
          
          if (this.selected != null) {
            this.remove();
          } else if (this.tags.length > 0) {
            this.selected = this.tags.length - 1;
          }
        }
      }

      if (/(.+,{1})+/.test(this.text) || e.code == 'Enter') {
        this.dig();
      }
    },

    onBlur () {
      this.focus = false;
    },

    dig () {
      this.text = this.text.split(',').reduce((r, c, idx) => {
        if (isEmail(c)) {
          this.tags.push(c);
        } else {
          r.push(c);
        }
        return r;
      }, []).join(',');
    },

    remove () {
      this.tags.splice(this.selected, 1);
      this.selected = null;
    },

    doRemove (index) {
      this.selected = index;
      this.remove();
    }
  }
}
</script>

<style>
.tags-editor {
  cursor: text;
}
.tags-editor:hover, .editor-focus {
  box-shadow: none !important;
  border-color: $white_color_dker;
}
.tags-editor input {
  background-color: transparent;
  border: none;
}
.tags-editor .tag-item {
  cursor: pointer;
  display: inline-block;
  margin: 0 5px 5px 0;
  padding: 2px 4px;
  background-color: #27a102;
  border-radius: 3px;
}
.tags-editor .tag-item.selected {
  background-color: #ab7a4b;
}
/*.tags-editor .tag-item .tag-bg {
  padding: 2px 4px;
  background-color: #27a102;
  border-radius: 3px;
}*/
</style>