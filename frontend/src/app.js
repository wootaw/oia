import 'es6-shim'
import 'ASSET/scss/app.scss'
import 'VENDOR/font-awesome/css/font-awesome.min.css'

// // import router from 'ROUTE/'
// import App from 'COMPONENT/App'
import Vue from 'vue'
import signService from 'SERVICE/SignService'
// import SignForm from 'COMPONENT/signbox/SignForm'


$(function() {
  let v = new Vue({
    el: '#sign-modal',
    // components: { SignForm },

    mounted () {
      // this.fetchList()
    },

    methods: {
      // fetchList () {
      //   documentsService.fetchList().then(function(d) {
      //     this.documents = d.docs
      //   }.bind(this))
      // }
      setPath(path) {
        this.path = path
        signService.getPage(path).then(function(d) {
          this.content = d
        }.bind(this))
      }
    },
    // props: ['path'],
    // data() {
    //   return {
    //     path: '/users/sign_in'
    //   }
    // }

    data: {
      content: ''
    }
  })

  $('#yyyy').click(function() {
    // v.data.path = 'uuuuuuuu'
    // console.log(v)
    // Vue.set(v, 'path', '99999999')
    v.setPath('/users/sign_in')
    // Vue.set()
  })

  $('#zzzz').click(function() {
    // v.data.path = 'uuuuuuuu'
    // console.log(v)
    // Vue.set(v, 'path', '99999999')
    v.setPath('/users/sign_up')
    // Vue.set()
  })
});

// router.start(App, '#app')
