<template>
  <div class="m-t m-b collaborators-list">
    <a href="#" class="pull-left thumb-xs collaborator-item" v-for="collaborator of collaborators" :key="collaborator.id">
      <span v-if="collaborator.members.avatar_url == null" class="avatar">{{headerChar(collaborator.members.email)}}</span>
      <img v-else class="avatar" :src="collaborator.members.avatar_url" alt="collaborator.members.username">
    </a>
    <button class="btn btn-rounded btn-icon btn-new pull-right" data-toggle="modal" data-target="#normal-modal"><i class="fa fa-plus"></i></button>
    <div class="clearfix"></div>
  </div>
</template>

<script>
import collaboratorsService from 'SERVICE/CollaboratorsService';
export default {
  data () {
    return {
      loading: false,
      emails: [],
      collaborators: []
    };
  },

  computed: {

    // disabledSubmit () {
    //   return this.emails.length == 0;
    // }
  },

  // components: { 
  //   'tags-editor': TagsEditor,
  // },

  methods: {
    headerChar (email) {
      return email.substr(0, 1).toUpperCase();
    }
  },

  mounted() {
    const parts = location.pathname.split('/').slice(1, 3);

    this.loading = true;
    collaboratorsService.fetchList(parts[0], parts[1]).then(d => {
      this.loading = false;
      this.collaborators = d.data.collaborators;
    });
  }
}
</script>

<style>
@-webkit-keyframes scale-crush-right {
  0% {
    padding-right: 0;
  }
  100% {
    padding-right: 54px;
  }
}
@keyframes scale-crush-right {
  0% {
    padding-right: 0;
  }
  100% {
    padding-right: 54px;
  }
}

@-webkit-keyframes scale-crush-left {
  0% {
    padding-right: 54px;
  }
  100% {
    padding-right: 0;
  }
}
@keyframes scale-crush-left {
  0% {
    padding-right: 54px;
  }
  100% {
    padding-right: 0;
  }
}

/*@import "variables.scss";*/
.collaborators-list {
  padding-left: 12px;
}
.collaborators-list .collaborator-item {
  display: inline-block;
  width: 36px;
  height: 36px;
  margin-left: -12px;
  -webkit-animation: scale-crush-left 200ms cubic-bezier(0.390, 0.575, 0.565, 1.000) both;
  -moz-animation: scale-crush-left 200ms cubic-bezier(0.390, 0.575, 0.565, 1.000) both;
  animation: scale-crush-left 200ms cubic-bezier(0.390, 0.575, 0.565, 1.000) both;
}
.collaborators-list .collaborator-item:hover {
  /*padding-left: 5px;*/
  /*padding-right: 54px;*/
  -webkit-animation: scale-crush-right 200ms cubic-bezier(0.390, 0.575, 0.565, 1.000) both;
  -moz-animation: scale-crush-right 200ms cubic-bezier(0.390, 0.575, 0.565, 1.000) both;
  animation: scale-crush-right 200ms cubic-bezier(0.390, 0.575, 0.565, 1.000) both;
}
.collaborators-list a {
  text-decoration: none;
}
.collaborators-list .avatar {
  width: 36px;
  height: 36px;
  background-color: #bbb;
  /*background-image: url("../images/black_paper.jpg");*/
  border: 1px solid #fff;
}
.collaborators-list span.avatar {
  color: #fff;
  background-color: #27a102;
  font-size: 23px;
  line-height: 36px;
  text-align: center;
  font-weight: bold;
}
.collaborators-list .btn-new {
  width: 36px;
  height: 36px;
  background-color: transparent;
  /*margin-left: 5px;*/
  border: 1px solid #27a102;
}
.collaborators-list .btn-new i {
  font-size: 16px;
  color: #27a102;
  margin-top: 1px;
}
.collaborators-list .btn-new:hover {
  background-color: #27a102;
  border: 1px solid #27a102;
}
.collaborators-list .btn-new:hover i {
  color: #fff;
}
</style>