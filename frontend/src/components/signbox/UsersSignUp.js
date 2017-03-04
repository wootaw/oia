// let Vue = require('vue')
import Vue from 'vue'
// let signService = require('SERVICE/SignService')
// errors.has('user[login]')
import signService from 'SERVICE/SignService'

const UsersSignUp = Vue.component('users-sign_up', (resolve, reject) => {

  signService.getPage('/users/sign_up').then((d) => {
    resolve({
      // mixins: [required],
      template: d.data,

      validator: null,

      methods: {
        setPath(p) {
          this.$emit('gopage', p)
        },

        trySignIn(e) {
          let form = $(e.target)
          signService.signIn(form.attr('action'), form.serialize()).then((resp) => {
            switch(resp.code) {
              case 401:
                this.alert = true
                this.msg = resp.data.msg
                break
            }
          })
        }
      },

      data() {
        return {
          test: 0,
          alert: false,
          msg: '',
          sign_in: {
            login: true,
            password: true
          }
        }
      },
      // watch: {
      //   errors(nv, ov) {
      //     console.log(nv)
      //   }
      // },
      // created() {
      //   this.$watch(() => this.errors.errors, (errors) => {
      //     // bus.$emit('errors-changed', value);
      //     // console.log(value)
      //     // console.log(value.field)
      //     if (errors.length > 0) {
      //       // console.log(name)
      //       let type = panel.name.replace(/users\-/, '').replace(/\-/, '')
      //       let eids = errors.map(x => x.field.replace(/user\[/, '').replace(/\]/, ''))

      //       errors.forEach((error) => {
      //         let field = error.field.replace(/user\[/, '').replace(/\]/, '')
      //         // let eid = error.field.replace(/\[/, '_').replace(/\]/, '')
      //         // $(`#pp_${eid}`).tooltip('show')
      //         // console.log($(`#pp_${eid}`))
      //       })
      //     }
      //   });
      // },
      
      
      
      // validations() {
      //   return {
      //     signin: {
      //       login: {
      //         required
      //       }
      //     }
      //   }
      // }
    })
  })
})

export default UsersSignUp