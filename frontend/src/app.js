import 'es6-shim'
import 'ASSET/scss/app.scss'
import 'VENDOR/font-awesome/css/font-awesome.min.css'

// // import router from 'ROUTE/'
// import App from 'COMPONENT/App'
import Vue from 'vue'
import signService from 'SERVICE/SignService'

$(function() {
  ['users-sign_in', 'users-sign_up', 'users-password-new'].forEach((name) => {
    let path = name.replace(/\-/g, '/')
    Vue.component(name, function (resolve, reject) {

      signService.getPage(`/${path}`).then((d) => {
        resolve({

          methods: {
            setPath(p) {
              this.$emit('gopage', p)
            }
          },

          template: d
        })
      })

    })
  })

  let signVue = new Vue({
    el: '#sign-modal',

    methods: {
      openPage(path) {
        this.type = path.replace(/^\//, '').replace(/\//g, '-')
      }
    },

    data: {
      type: 0,
    }
  })

  $('.btn-sign').click((e) => {
    signVue.openPage($(e.target).attr('data-path'))
  })
});

// router.start(App, '#app')
