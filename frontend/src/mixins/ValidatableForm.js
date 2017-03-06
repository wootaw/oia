import { Validator } from 'vee-validate';
import signService from 'SERVICE/SignService';

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
      return this.alert || this.formFields().reduce((r, cf, idx) => {
        return r || this.errors.has(cf);
      }, false);
    },

    formData() {
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
      return Object.keys(this.__fields);
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
      signService.sign(form.attr('action'), form.serialize()).then((resp) => {
        this.loading = false;
        switch(resp.code) {
          case 200:
            location.reload();
            break;
          case 401:
            this.alert = true;
            this.msg = resp.data.msg;
            break;
        }
      });
    },

    initVars(init=null) {
      return this.formFields().reduce(function(r, p) {
        r[p] = init;
        return r;
      }, {});
    }
  },

  watch: {
    formData(nv, ov) {
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
    return {
      alert: false,
      msg: '',
      errors: null,
      loading: false,
      form: this.initVars(''),
      errors_changed: this.initVars()
    };
  }
}