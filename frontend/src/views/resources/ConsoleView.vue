<template>
  <div class="no-padder">
    <div class="wrapper-md b-b">
      <div class="row">
        <div class="col-sm-12 col-xs-12">
          <span :class="methodClasses">{{resource.method}}</span>
          <span class="label label-default pull-left">{{resource.path}}</span>
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
      <div class="panel b-a bg-paper">
        <ul class="list-group list-group-lg no-bg auto">
          <li class="list-group-item clearfix flexbox h-xxxs" v-for="param of fields" :key="param.id">
            <label class="i-checks i-checks-sm m-r-sm">
              <input type="checkbox" :disabled="required(param)" :checked="required(param)">
              <i></i>
            </label>
            <input class="inv" type="text" name="" :value="param.name">
            <input class="inv" type="text" name="" :value="param.default" placeholder="null">
          </li>
        </ul>
        <div class="clearfix panel-footer">
          <a class="" href="#">
            <i class="fa fa-plus fa-fw text-muted"></i> 
            Add a new {{tab}}
          </a>
        </div>
      </div>
      <div class="panel b-a bg-paper">
        <div class="panel-body">
          <blockquote>
            <p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer posuere erat a ante.</p>
            <small>Someone famous in <cite title="Source Title">Source Title</cite></small>
          </blockquote>
          <div>Lorem ipsum dolor sit amet, consecteter adipiscing elit...</div>
          <div class="m-t-sm">
            <a href data-toggle="class" class="btn btn-default btn-xs">
              <i class="fa fa-star-o text-muted text"></i>
              <i class="fa fa-star text-danger text-active"></i> 
              Like
            </a>
            <a href class="btn btn-default btn-xs"><i class="fa fa-mail-reply text-muted"></i> Reply</a>
          </div>
        </div>
        <div class="clearfix panel-footer">
          <div class="input-group">
            <input type="text" class="form-control input-sm btn-rounded" placeholder="Search">
            <span class="input-group-btn">
              <button type="submit" class="btn btn-default btn-sm btn-rounded"><i class="fa fa-search"></i></button>
            </span>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  props: ['resource'],

  data () {
    return {
      tab: 'parameter'
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
      return this.resource.parameters.reduce((r, c) => {
        if (c.location == 'header' || c.location == 'body') {
          if (c.location == this.tab) {
            r.push(c);
          }
        } else {
          if (c.location == 'parameter') {
            r.push(c);
          }
        }
        return r;
      }, []);
    }
  },

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
      return parameter.required || parameter.location == 'path';
    },

    toggleParameterTab (tab) {
      this.tab = tab;
    }
  }
}
</script>