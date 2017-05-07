<template>
  <div class="dropdown" v-downitems="[document, setProps]">
    <a href="#" class="btn btn-default btn-xs m-l dropdown-toggle" data-toggle="dropdown">
      <i class="fa fa-list m-r-xs"></i>
      <span class="caret"></span>
    </a>
    <ul class="dropdown-menu pull-right m-l">
      <li v-for="res of resources" :key="res.id">
        <a :href="res.slug" @click.prevent="toResource(res.slug)">
          <i :class="methodClasses(res.method)"></i>
          <span>{{res.summary}}</span>
        </a>
      </li>
    </ul>
  </div>
</template>

<script>
import smoothscroll from 'smoothscroll'
export default {
  props: ['document'],

  data () {
    return {
      outline: []
    };
  },

  computed: {
    resources () {
      return this.document == null ? this.outline : this.document.resources;
    },
  },

  directives: {
    downitems: {
      inserted (el, binding) {
        if (binding.value[0] == null) {
          const ress = [];
          $('.panel-res').each((idx, elm) => {
            ress.push({
              'id': $(elm).data('id'),
              'slug': $(elm).attr('id'),
              'summary': $('span.res-summary', elm).html(),
              'method': $('span.res-method', elm).html()
            })
          });
          binding.value[1]('outline', ress);
        }
      }
    }
  },

  methods: {

    setProps (prop, value) {
      this[prop] = value;
    },

    methodClasses (method) {
      const r = ['fa', 'fa-circle', 'm-l-n-xs', 'text-xs'];
      r.push({
        'GET':    'text-success', 
        'POST':   'text-warning', 
        'PUT':    'text-info', 
        'DELETE': 'text-danger' 
      }[method]);
      return r;
    },

    toResource (slug) {
      const parts = location.pathname.split('/');
      smoothscroll($(`#${slug}`)[0], 500, function() {
        window.history.pushState("", "", `/${parts[1]}/${parts[2]}/${slug}`);
      });
    }
  }
}
</script>