import Vue from 'vue'

Vue.directive('scaleout', {
  bind(el, binding) {
    $('.loading-logo', el).addClass('scale-out-center');
    setTimeout(() => {
      $(el).css('display', 'none');
    }, 800);
  }
})
