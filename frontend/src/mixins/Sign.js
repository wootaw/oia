import signService from 'SERVICE/SignService';

export default {
  methods: {
    openPage(path, is) {
      this[is] = path.replace(/^\//, '').replace(/\//g, '-');
    },

    csrf: part => $(`meta[name=csrf-${part}]`).attr('content'),

    signOut(path) {
      let body = { '_method': 'delete' };
      body[this.csrf('param')] = this.csrf('token');
      signService.signOut(path, body).then((resp) => {
        switch(resp.code) {
          case 204:
            location.reload();
            break;
          case 401:
            break;
        }
      });
    }
  }
}