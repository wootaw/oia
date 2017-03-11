import { Validator } from 'vee-validate';

export default {
  validator: null,
  
  directives: {
    toggleTooltip: {
      update(el, binding) {
        if (binding.value != binding.oldValue && binding.value != null) {
          $(el).tooltip(binding.value);
        }
      }
    }
  },

  computed: {
    disabledSubmit() {
      return this.alert || this.loading || this.formFields().reduce((r, cf, idx) => {
        return r || this.errors.has(cf);
      }, false);
    },

    validateValues() {
      return this.formFields().reduce((r, c) => {
        r.push(this.form[c]);
        return r;
      }, []);
    },

    errorFields() {
      return this.errors == null ? [] : this.formFields().reduce((r, c) => {
        if (this.errors.has(c)) {
          r.push(c);
        }
        return r;
      }, []);
    }
  },

  methods: {
    formFields() {
      if (this._cache_fields == undefined) {
        this._cache_fields = Object.keys(this.__fields);
      }
      return this._cache_fields;
    },

    setPath(p) {
      this.$emit('gopage', p);
    },

    clearAlert() {
      if (this.alert) {
        this.alert = false;
      }
    },

    trySubmit(e) {
      let form = $(e.target)
      this.loading = true;
      this.service()(form.attr('action'), form.serialize()).then((resp) => {
        this.loading = false;
        this.processResponse(resp);
      });
    },

    initVars(init=null) {
      return this.formFields().reduce(function(r, p) {
        r[p] = init;
        return r;
      }, {});
    },

    defaultValidateData() {
      return {
        alert: false,
        msg: '',
        errors: null,
        loading: false,
        form: this.initVars(''),
        errors_changed: this.initVars()
      };
    }
  },

  watch: {
    validateValues(nv, ov) {
      this.clearAlert();
      nv.forEach((v, idx) => {
        if (v != ov[idx]) {
          this.validator.validate(this.formFields()[idx], v);
        }
      });
    },

    errorFields(nv, ov) {
      this.formFields().forEach((k) => {
        if (nv.indexOf(k) < 0) {
          this.errors_changed[k] = ov.indexOf(k) < 0 ? null : 'hide';
        } else {
          this.errors_changed[k] = ov.indexOf(k) < 0 ? 'show' : null;
        }
      });
    },
  },

  created() {
    this.validator = new Validator(this.__fields);
    this.$set(this, 'errors', this.validator.errorBag);
  },

  data() {
    return this.defaultValidateData();
  }
}
