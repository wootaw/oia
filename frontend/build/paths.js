var path = require('path');

String.prototype.join = function (target) {
  return path.join(this.toString(), target);
};

var ROOT = path.resolve(__dirname, '..');

module.exports = {
  ROOT:   ROOT,                                
  BUILD:  ROOT.join('./build'),
  DIST:   ROOT.join('../public/assets'),
  SRC:    ROOT.join('./src'),
  VENDOR: ROOT.join('./vendor')
};
