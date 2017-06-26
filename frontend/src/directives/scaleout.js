import Vue from 'vue'

Vue.directive('scaleout', {
  bind(el, binding) {
    $('.navbar-brand', el).removeClass('loading');

    $('div', el).removeClass('rotate-down');
    $('.navbar-collapse', el).removeClass('loading').addClass('fixed-to-top');

    setTimeout(() => {
      $(el).removeClass('loading');
    }, 800);
  }
})
