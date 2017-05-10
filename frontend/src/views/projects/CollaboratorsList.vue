<template>
  <div class="m-t m-b collaborators-list">
    <a href="#" class="pull-left thumb-xs collaborator-item">
      <img class="avatar" src="/uploads/user/sm_cztvmqtbd-acujcs5uu-9sgonxmk8-rs5m7gawq-nagnwult3.png" alt="...">
    </a>
    <a href="#" class="pull-left thumb-xs collaborator-item">
      <img class="avatar" src="/uploads/user/sm_iune12pxp-mimoaqfvv-jodiwb0sc-bdm0reu0d.png" alt="...">
    </a>
    <a href="#" class="pull-left thumb-xs collaborator-item">
      <img class="avatar" src="/uploads/user/sm_ae2tw5i88-rkbwt9npa-lyieltlc3-ek4a0pba0-bn6o3zgcu.png" alt="...">
    </a>
    <a href="#" class="pull-left thumb-xs collaborator-item">
      <img class="avatar" src="/uploads/user/sm_ae2tw5i88-rkbwt9npa-lyieltlc3-ek4a0pba0-bn6o3zgcu.png" alt="...">
    </a>
    <a href="#" class="pull-left thumb-xs collaborator-item">
      <img class="avatar" src="/uploads/user/sm_ae2tw5i88-rkbwt9npa-lyieltlc3-ek4a0pba0-bn6o3zgcu.png" alt="...">
    </a>
    <a href="#" class="pull-left thumb-xs collaborator-item">
      <img class="avatar" src="/uploads/user/sm_ae2tw5i88-rkbwt9npa-lyieltlc3-ek4a0pba0-bn6o3zgcu.png" alt="...">
    </a>
    <button class="btn btn-rounded btn-icon btn-new pull-right" data-toggle="modal" data-target="#normal-modal"><i class="fa fa-plus"></i></button>
    <div class="clearfix"></div>
  </div>
</template>

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

/*@import "variables.scss";*/
.collaborators-list {
  padding-left: 12px;
}
.collaborators-list .collaborator-item {
  width: 36px;
  height: 36px;
  margin-left: -12px;
}
.collaborators-list .collaborator-item:hover {
  /*padding-left: 5px;*/
  /*padding-right: 54px;*/
  -webkit-animation: scale-crush-right 200ms cubic-bezier(0.390, 0.575, 0.565, 1.000) both;
  -moz-animation: scale-crush-right 200ms cubic-bezier(0.390, 0.575, 0.565, 1.000) both;
  animation: scale-crush-right 200ms cubic-bezier(0.390, 0.575, 0.565, 1.000) both;
}
.collaborators-list .avatar {
  width: 36px;
  background-color: #bbb;
  /*background-image: url("../images/black_paper.jpg");*/
  border: 1px solid #fff;
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