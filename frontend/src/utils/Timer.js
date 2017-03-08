const timer = class Timer {

  constructor(later) {
    this.later = later;
    this._ticking = false;
    this._go = true;
    this._defer = null;
    this._id = 0;
  }

  restart() {
    this._go = false;
    this._defer = $.Deferred();
    this._createTick();
    return this._defer.promise();
  }

  _createTick() {
    if (!this._ticking) {
      this._go = true;
      this._ticking = true;
      setTimeout(() => {
        if (this._go) {
          this._defer.resolve({ id: this._id });
          this._id += 1;
          this._ticking = false;
        } else {
          this._ticking = false;
          this._createTick();
        }
        
      }, this.later);
    }
  }

};

export default timer