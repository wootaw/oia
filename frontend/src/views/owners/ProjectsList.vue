<template>
  <div class="row">
    <div class="col-md-12 bg-loading h-xxs x-c-y-c m-b" v-if="loading"></div>
    <div class="col-md-3 col-xs-12 col-sm-4" v-for="project in projects">
      <project-panel :project="project"></project-panel>
    </div>
  </div>
</template>

<script>
import projectsService from 'SERVICE/ProjectsService';
import ProjectPanel from 'VIEW/owners/ProjectPanel'
export default {

  props: ['lastest'],

  components: { ProjectPanel },

  watch: {
    lastest(nv, ov) {
      this.projects.splice(0, 0, nv);
    }
  },

  created() {
    let path = `${location.pathname}.json${location.search}`;
    this.loading = true;
    projectsService.getListByOwner(path).then((resp) => {
      switch(resp.code) {
        case 200:
          this.projects = resp.data.projects;
          this.loading = false;
          break;
        case 401:
          break;
      }
    });
  },

  data() {
    return {
      projects: [],
      loading: false
    }
  }
}
</script>