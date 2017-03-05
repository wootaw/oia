import { Validator } from 'vee-validate';

export default {
  validator: null,
  
  computed: {
    disabledSubmit() {
      return this.alert || Object.keys(this.form).reduce(function(pf, cf, idx) {
        return (idx == 1 ? this.errors.has(pf) : pf) || this.errors.has(cf);
      }.bind(this));
    }
  },

  methods: {
    setPath(p) {
      this.$emit('gopage', p);
    },

    initElements(field) {
      if(this._elements[field] == null) {
        this._elements[field] = $(`#user_${field}`).parent('.input-group');
      }
    },

    clearAlert() {
      if (this.alert) {
        this.alert = false;
      }
    },

    trySubmit(e) {
      let form = $(e.target)
      signService.sign(form.attr('action'), form.serialize()).then((resp) => {
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

    doValidate(field, value) {
      this.clearAlert();
      let ov = this.errors.has(field);
      if(this.validator.validate(field, value)) {
        this._errors_changed[field] = ov ? 'hide' : null;
      } else {
        this._errors_changed[field] = ov ? null : 'show';
      }
    },

    initVars(init=null) {
      return Object.keys(this.__fields).reduce(function(r, p) {
        r[p] = init;
        return r;
      }, {});
    }

  },

  watch: {
    form: {
      deep: true,
      handler: function(value) {
        Object.keys(value).forEach(function(k) {
          this.doValidate(k, value[k]);
        }.bind(this));
      }
    }
  },

  created() {
    this.validator = new Validator(this.__fields);
    this.$set(this, 'errors', this.validator.errorBag);
    this._errors_changed = this.initVars();
    this._elements = this.initVars();
  },

  updated() {
    Object.keys(this._errors_changed).forEach(function(key) {
      if (key != null) {
        this.initElements(key);
        this._elements[key].tooltip(this._errors_changed[key]);
        this._errors_changed[key] = null;
      }
    }.bind(this));
  },

  data() {
    return {
      alert: false,
      msg: '',
      errors: null,
      form: this.initVars(''),
    };
  },
}
