<template>
  <div class="no-padder">
    <div class="wrapper-md b-b">
      <div class="row">
        <div class="col-sm-12 col-xs-12">
          <span :class="methodClasses">{{resource.method}}</span>
          <span class="label no-padder" v-html="locationHref" v-raw:href="setVal"></span><span class="label no-padder" v-html="locationSearch" v-raw:search="setVal"></span>
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
        <li :class="{'active': tab=='body'}" v-show="resource.method!='GET'">
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
      <div class="panel b-a bg-paper h-xxl" v-show="tab == 'body'">
        <div class="panel-body no-padder" style="height: 360px;" v-jsoneditor:input="[setVal, {mode: 'code', onError: bodyError, onChange: bodyChanged}, resource]"></div>
        <div class="clearfix panel-footer b-t no-padder">
          <pre class="no-border no-bg" v-html="errorMsg"></pre>
        </div>
      </div>
      <div class="no-padder pull-right h-xxxs">
        <div class="pull-left h-xxxs w-xxs bg-loading" v-show="loading"></div>
        <div class="btn-group dropdown">
          <button class="btn btn-success" @click="callResource" :disabled="loading">Request Resource</button>
          <button class="btn btn-success" data-toggle="dropdown"><span class="caret"></span></button>
          <ul class="dropdown-menu">
            <li><a href>Action</a></li>
            <li><a href>Another action</a></li>
            <li><a href>Something else here</a></li>
            <li class="divider"></li>
            <li><a href>Separated link</a></li>
          </ul>
        </div>
      </div>
      <div class="clearfix m-b"></div>
      <div class="panel b-a bg-paper h-xxl" v-show="resultData != null">
        <div class="panel-body no-padder" style="height: 360px;" v-jsoneditor:result="[setVal, {mode: 'view'}, resource]"></div>
        <div class="clearfix panel-footer b-t no-padder">
          <pre class="no-border no-bg" v-html="errorMsg"></pre>
        </div>
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
    if (this.resource.params == null) {
      this.resource.params = this.resource.parameters.reduce((r, c) => {
        r.push({ name: c.name, value: c.default, checked: c.required, custom: false, origin: c });
        return r;
      }, []);
    }

    if (this.resource.bodyJSON == null) {
      this.resource.bodyJSON = this.resource.parameters.reduce((r, c) => {
        if (c.location == "body") {
          this.initBody(r, c);
        }
        return r;
      }, {});
    }

    return {
      tab: 'parameter',
      input: null,
      result: null,
      resultData: null,
      errorMsg: null,
      loading: false,
      href: this.resource.path,
      search: '',
      params: this.resource.params
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

    locationHref () {
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
        if (c.origin.location == 'query' && c.name != null && c.value != null && c.checked) {
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
        const editor = new JSONEditor(el, binding.value[1]);
        binding.value[0](binding.arg, editor);      // call setVal
        if (binding.arg == 'input') {
          editor.set(binding.value[2].bodyJSON);
        }
      },
    },

    raw: {
      componentUpdated (el, binding) {
        binding.value(binding.arg, $(el).text());   // call setVal
      }
    }
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
    partParams (part) {
      return this.params.reduce((r, c) => {
        if (c.origin.location == part && c.name != null && c.value != null && c.checked) {
          r[c.name] = c.value;
        }
        return r;
      }, {});
    },

    callResource () {
      this.loading = true;
      const options = {
        type: this.resource.method,
        url: `https://api.yunlu6.com${this.href}${this.search}`,
        data: this.partParams('form'),
        crossDomain: true,
      };
      const headers = this.partParams('header');
      if (headers.length > 0) {
        options.headers = headers;
      }

      $.ajax(options).done((data, textStatus, jqxhr) => {
        this.loading = false;
        this.resultData = data;
        this.result.set(data);
      }).fail((jqXHR, textStatus, errorThrown) => {
        this.loading = false;
      });
    },

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

    initBody (obj, param) {
      if (param.ancestor == null) {
        let value = { 'String': "null", 'Boolean': true, 'Number': 0, 'Object': {} }[param.data_type];
        if (param.array) {
          value = [value];
        }
        obj[param.name] = value;
        return true;
      } else {
        const parts = param.ancestor.split('.');
        const name  = parts.shift();
        let parent  = obj[name];

        if (parent == null) {
          return false;
        } else {
          if (Array.isArray(parent)) {
            parent = parent[0];
          }

          if (typeof parent == "object") {
            const subparam = (({ data_type, array, name }) => ({ data_type, array, name }))(param);
            subparam.ancestor = parts.length == 0 ? null : parts.join('.');
            return this.initBody(parent, subparam);
          } else {
            return true;
          }
        }
      }
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
      if (this.editor != null) {
        this.resource.bodyJSON = this.editor.get();
      }
    },

    setVal (part, value) {
      this[part] = value;
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