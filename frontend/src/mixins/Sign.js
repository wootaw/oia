import signService from 'SERVICE/SignService';

export default {
  methods: {
    openPage(path, is, data) {
      if (data != null) {
        Object.keys(data).forEach((item, idx) => {
          $('#sign-modal').data(item, data[item]);
        });
      }
      this[is] = path.replace(/^\//, '').replace(/\//g, '-');
    },

    csrf: part => $(`meta[name=csrf-${part}]`).attr('content'),

    signOut(path) {
      let body = { '_method': 'delete' };
      body[this.csrf('param')] = this.csrf('token');
      signService.signOut(path, body).then((resp) => {
        switch(resp.code) {
          case 200:
            location.reload();
            break;
          case 401:
            break;
        }
      });
    }
  }
}