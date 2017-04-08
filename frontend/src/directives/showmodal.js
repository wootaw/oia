import Vue from 'vue'

Vue.directive('showmodal', {
  bind(el, binding) {
    $(el).click(() => {
      let modal = $(binding.value.id);
      if (binding.value.data) {
        Object.keys(binding.value.data).forEach((k) => {
          modal.data(k, binding.value.data[k]);
        });
      }

      modal.modal('show');
    });
  }
})