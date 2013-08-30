function Head ( _el ) {
  
  this.isRunning = false;
  this.el = $(_el);
  this.posUp = { x: 0, y: -this.el.parent().height()};
  //this.el.css({"top":this.pos.y + "px"});
  
  this.run = function( _d ) {
    
    var that = this;
    this.isRunning = true;
    
    var t = {
      up: Math.floor(_d*2/5),
      wait: Math.floor(_d*1/5),
      down: Math.floor(_d*2/5)
    }
    
    this.el
      // up
      .animate(
        {top: this.posUp.y},
        t.up, 
        "easeOutQuart",
        // ==================================================== show random graphic
        function() { that.el.find(">*").removeClass("show").random().addClass("show"); }
      )
      // wait
      .delay( t.wait )
      // down
      .animate(
        {top: 0 }, 
        t.down, 
        "easeOutQuart",
        function() {
          
          that.isRunning = false;

          if ( $("#head img.show").data("change-face") === true ) {
            $("#face img").removeClass("show").random().addClass("show");
          }
        }
      );
  };
  
};


function Arms ( _el ) {
  
  this.isRunning = false;
  this.el = $(_el);
  this.posUp = { x: 0, y: -this.el.parent().height()};
  //this.el.css({"top":this.pos.y + "px"});
  
  this.run = function( _d ) {
    
    var that = this;
    this.isRunning = true;
    
    var t = {
      up: Math.floor(_d*2/5),
      wait: Math.floor(_d*1/5),
      down: Math.floor(_d*2/5)
    }
    
    this.el
      // up
      .animate(
        {top: this.posUp.y},
        t.up, 
        "easeOutQuart"
      )
      // wait
      .delay( t.wait )
      // down
      .animate(
        {top: 0 }, 
        t.down, 
        "easeOutQuart",
        function() { that.isRunning = false; }
      );
  };
  
};
