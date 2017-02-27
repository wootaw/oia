import Vue from 'vue'

import documentsService from 'SERVICE/documentsService'
import DocumentGroup from 'COMPONENT/sidebars/DocumentGroup'


$(function() {
  new Vue({
    el: '#app',
    components: { DocumentGroup },

    mounted () {
      this.fetchList()
    },

    methods: {
      fetchList () {
        documentsService.fetchList().then(function(d) {
          this.documents = d.docs
        }.bind(this))
      }
    },

    data() {
      return {
        documents: []
      }
    }
  })
});