<template>
  <div class="modal fade modal-full" id="normal-modal" tabindex="-1" role="dialog">
    <button class="btn btn-rounded btn-lg btn-icon btn-default btn-close" data-dismiss="modal">
      <i class="fa fa-times"></i>
    </button>
    <div class="grid-over h-full">
      <div class="dp-table w-half h-full item m-center">
        <div class="cell v-middle wrapper-md">
          <div class="modal-dialog" role="document">
            <h3 class="txt-center text-primary-lter">Add collaborators to your project</h3>
            <div class="bg-dark no-bg">
              <tags-editor @tagschanged="tagsChanged"></tags-editor>
              <div class="m-t m-b txt-center">
                <span class="divider-txt">
                  <span><b>Note:</b> emails have to be comma separated when pasted in</span>
                </span>
              </div>
              <div class="m-b">
                <button :class="{'btn-lg': true, 'btn-success': !loading && !disabledSubmit, disabled: disabledSubmit, 'w-full': true, 'bg-loading': loading, 'x-md-y-c': true }" :disabled="disabledSubmit" @click="invite">Invite</button>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import TagsEditor from 'COMPONENT/TagsEditor'
export default {
  data () {
    return {
      loading: false,
      emails: [],
    };
  },

  computed: {

    disabledSubmit () {
      return this.emails.length == 0;
    }
  },

  components: { 
    'tags-editor': TagsEditor,
  },

  methods: {

    setProps (prop, value) {
      this[prop] = value;
    },

    tagsChanged (tags) {
      if (tags != null) {
        this.emails = tags;
      }
    },

    invite () {
      this.loading = true;
    }
  }
}
</script>