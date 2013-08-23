function Head ( _el ) {
  
  this.el = $(_el);
  this.pos = { x: 0, y: -this.el.parent().height()};
  this.el.css({"top":this.pos.y + "px"});
  
  this.run = function() {
    
    this.el.find(">*").hide().random().show();
    this.el.animate({top: 0 }, 500, "easeOutQuad").delay(1000).animate({top: this.pos.y }, 500, "easeInQuart");
  };
  
};


function Arms ( _el ) {
  
  this.el = $(_el);
  this.pos = { x: 0, y: -this.el.parent().height()};
  this.el.css({"top":this.pos.y + "px"});
  
  this.run = function() {
    
    this.el.animate({top: 0 }, 500, "easeOutQuad").delay(1000).animate({top: this.pos.y }, 500, "easeInQuart");
  };
  
};
