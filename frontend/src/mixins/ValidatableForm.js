import { Validator } from 'vee-validate';

export default {
  validator: null,
  
  computed: {
    disabledSubmit() {
      return this.alert || Object.keys(this.form).reduce(function(r, cf, idx) {
        return r || this.errors.has(cf);
      }.bind(this), false);
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
        this.clearAlert();

        if (this._old_form != null) {
          Object.keys(value).forEach(function(k) {
            if (this._old_form[k] != value[k]) {
              this.validator.validate(k, value[k]);
            }
          }.bind(this));
        }

        this._old_form = Object.keys(value).reduce(function(r, p) {
          r[p] = value[p];
          return r;
        }, {});
      }
    },

    errors: {
      deep: true,
      handler: function(value) {
        Object.keys(this.__fields).forEach(function(k) {
          if (value.has(k)) {
            this._errors_changed[k] = this._old_errors.indexOf(k) >= 0 ? null : 'show';
          } else {
            this._errors_changed[k] = this._old_errors.indexOf(k) >= 0 ? 'hide' : null;
          }
        }.bind(this));

        this._old_errors = Object.keys(this.__fields).reduce(function(r, c) {
          if (value.has(c)) {
            r.push(c);
          }
          return r;
        }, []);
      }
    }

  },

  created() {
    this.validator = new Validator(this.__fields);
    this.$set(this, 'errors', this.validator.errorBag);
    this._elements = this.initVars();
    this._errors_changed = this.initVars();
    this._old_form = null;
    this._old_errors = [];
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
