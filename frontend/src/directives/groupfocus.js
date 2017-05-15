import Vue from 'vue'

Vue.directive('groupfocus', {
  bind(el, binding) {
    $(el).focus(() => {
      $(el).parents(binding.value).addClass('group-focus');
    }).blur(() => {
      $(el).parents(binding.value).removeClass('group-focus');
    });
  }
})