<template>
  <div class="no-padder">
    <div class="wrapper-md b-b">
      <div class="row">
        <div class="col-sm-12 col-xs-12">
          <span :class="methodClasses">{{resource.method}}</span>
          <span class="label no-padder" v-html="locationHerf"></span><span class="label no-padder" v-html="locationSearch"></span>
        </div>
      </div>
    </div>
    <div class="wrapper-md">
      <ul class="nav nav-pills m-b">
        <li :class="{'active': tab=='parameter'}">
          <a href="#" @click.stop.prevent="toggleParameterTab('parameter')">Parameters</a>
        </li>
        <li :class="{'active': tab=='header'}">
          <a href="#" @click.stop.prevent="toggleParameterTab('header')">Headers</a>
        </li>
        <li :class="{'active': tab=='body'}">
          <a href="#" @click.stop.prevent="toggleParameterTab('body')">Body</a>
        </li>
      </ul>
      <div class="panel b-a bg-paper" v-show="tab!='body'">
        <ul class="list-group list-group-lg no-bg auto list-params">
          <li class="list-group-item clearfix flexbox h-xxxs" v-for="param of fields" :key="param.id">
            <label class="i-checks i-checks-sm m-r-sm">
              <input type="checkbox" :disabled="required(param)" v-model="param.checked">
              <i></i>
            </label>
            <input class="inv" type="text" v-model="param.name">
            <input :class="{'inv': true, 'm-r-md': !param.custom}" type="text" v-model="param.value" placeholder="null">
            <button class="btn btn-icon btn-xs" v-if="param.custom" @click="removeParam(param)"><i class="fa fa-times"></i></button>
          </li>
        </ul>
        <div class="clearfix panel-footer">
          <a class="" href="#" @click.stop.prevent="addParam()">
            <i class="fa fa-plus fa-fw text-muted"></i> 
            Add a new {{tab}}
          </a>
        </div>
      </div>
      <div class="panel b-a bg-paper h-xxl" v-show="tab=='body'">
        <div class="panel-body no-padder" style="height: 360px;" v-jsoneditor="{setEditor: setEditor, options: {mode: 'code', onError: bodyError, onChange: bodyChanged}}"></div>
        <div class="clearfix panel-footer b-t no-padder"><pre class="no-border no-bg" v-html="errorMsg"></pre></div>
      </div>
    </div>
  </div>
</template>

<script>
import 'jsoneditor/dist/jsoneditor.css'
import JSONEditor from 'jsoneditor/dist/jsoneditor'

export default {
  props: ['resource'],

  data () {
    return {
      tab: 'parameter',
      editor: null,
      errorMsg: null,
      params: this.resource.parameters.reduce((r, c) => {
        r.push({ name: c.name, value: c.default, checked: c.required, custom: false, origin: c });
        return r;
      }, [])
    };
  },

  computed: {

    methodClasses () {
      let r = ['label', 'pull-left', 'm-r-sm'];
      r.push({
        'GET':    'label-success', 
        'POST':   'label-warning', 
        'PUT':    'label-primary', 
        'DELETE': 'label-danger' 
      }[this.resource.method]);
      return r;
    },

    fields () {
      return this.params.reduce((r, c) => {
        if (c.origin.location == 'header' || c.origin.location == 'body') {
          if (c.origin.location == this.tab) {
            r.push(c);
          }
        } else {
          if (this.tab == 'parameter') {
            r.push(c);
          }
        }
        return r;
      }, []);
    },

    bodyJSON () {
      return this.params.reduce((r, c) => {
        if (!c.custom && c.origin.location == "body") {
          if (c.origin.ancestor == null) {}
        }
        return r;
      }, {});
    },

    locationHerf () {
      let path = this.resource.path;
      this.params.reduce((r, c) => {
        if (c.origin.location == 'path' && c.name != null && c.value != null) {
          r.push([c.name, c.value]);
        }
        return r;
      }, []).forEach((e) => {
        path = path.replace(new RegExp(`(:${e[0]})`), `<span class="text-danger">${encodeURIComponent(e[1])}</span>`);
      });
      return path;
    },

    locationSearch () {
      const parts = this.params.reduce((r, c) => {
        if (c.origin.location == 'query' && c.name != null && c.value != null) {
          r.push(`<span class="text-danger">${encodeURIComponent(c.name)}=${encodeURIComponent(c.value)}</span>`);
        }
        return r;
      }, []);
      return parts.length > 0 ? `?${parts.join('&')}` : '';
    }
  },

  directives: {
    jsoneditor: {
      inserted(el, binding) {
        binding.value.setEditor(new JSONEditor(el, binding.value.options));
      },
    },
  },
  // updated () {
  //   console.log(this.resource == null ? null : this.resource.id);
  // },

  // watch: {
  //   tab (nv, ov) {
  //     console.log(this.resource);
  //   }
  // },

  methods: {
    locationClasses (location) {
      let r = [];
      r.push({
        'header': 'text-muted',
        'path':   'text-danger',
        'query':  'text-info-dker',
        'form':   'text-warning',
        'body':   'text-info',
        'cookie': '',
      }[location]);
      return r;
    },

    required (parameter) {
      return parameter.origin.required || parameter.origin.location == 'path';
    },

    toggleParameterTab (tab) {
      this.tab = tab;
    },

    addParam () {
      let location = this.tab == 'header' ? 'header' : 'query';
      this.params.push({ name: 'New Item', value: null, checked: true, custom: true, origin: { location: location } });
    },

    removeParam (param) {
      this.params.some((e, i, a) => {
        if (e.name == param.name && e.value == param.value && e.custom == true) {
          this.params.splice(i, 1);
          return true;
        } else {
          return false;
        }
      });
    },

    bodyError (msg) {
      this.errorMsg = msg.toString();
    },

    bodyChanged () {
      this.errorMsg = null;
    },

    setEditor (editor) {
      this.editor = editor;
    }
  }
}
</script>

<style>
.list-params .list-group-item button {
  visibility: hidden;
}
.list-params .list-group-item:hover button {
  visibility: visible;
}
</style>