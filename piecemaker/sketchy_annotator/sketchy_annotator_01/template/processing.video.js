var Movie = function(q, f) {
  var r, i = [], e, h, g, a, n, b, j, k = !1, s = 1, t, o = !1, u = -1, l = -1, m = 25, x = function() {
    var b = "";
    switch(a.networkState) {
      case a.NETWORK_EMPTY:
        b = "Loading did not start yet.";
        break;
      case a.NETWORK_IDLE:
        b = "Loading did not start yet.";
        break;
      case a.NETWORK_LOADING:
        b = "Loading has not finished yet.";
        break;
      case a.NETWORK_NO_SOURCE:
        b = "The source provided is missing. " + a.src;
        break;
      default:
        b = "Not sure what happened ... care to report it to fjenett@gmail.com ?"
    }
    alert(b)
  }, y = function() {
    a.setAttribute("width", a.videoWidth);
    a.setAttribute("height", a.videoHeight);
    e || p()
  }, p = function() {
    h = f.createElement("canvas");
    h.setAttribute("width", a.videoWidth);
    h.setAttribute("height", a.videoHeight);
    g = h.getContext("2d")
  }, z = function() {
    j || n.read();
    !e && !g && p()
  }, A = function() {
    k && r && a.currentTime === a.duration && (a.addEventListener("canplay", function() {
      a.playbackRate = s;
      a.volume = t;
      a.play();
      v()
    }), clearTimeout(l), a.src = a.currentSrc)
  }, v = function() {
    !e && !g && p();
    var b = function() {
      if(3 > a.readyState) {
        o = !1
      }else {
        var w = a.currentTime;
        if(o = u !== w) {
          for(var e = [n], c = 0, f = i.length;c < f;c++) {
            "movieEvent" in i[c] && i[c].movieEvent.apply(i[c], e)
          }
        }
        u = w
      }
      l = setTimeout(b, 1E3 / m)
    };
    b()
  }, c = function() {
    var d = {};
    if(1 == arguments.length && "object" == typeof arguments[0]) {
      d = arguments[0]
    }else {
      if(2 <= arguments.length) {
        var d = Array.prototype.slice.call(arguments), c = d.shift(), d = {sources:d, listener:c}
      }else {
        throw"Wrong number of args passed to Movie()!";
      }
    }
    a = d.element;
    if(!d.element && d.sources) {
      a = f.createElement("video");
      a.setAttribute("crossorigin", "anonymous");
      for(var c = 0, h = d.sources.length;c < h;c++) {
        var g = f.createElement("source");
        g.setAttribute("src", d.sources[c]);
        a.appendChild(g)
      }
      c = f.createElement("div");
      c.style.position = "absolute";
      c.style.left = "-10000px";
      c.style.top = "-10000px";
      c.appendChild(a);
      f.body.appendChild(c)
    }
    k = "loop" in a ? a.loop : !1;
    if("poster" in a && a.poster || d.poster) {
      j = new Image, j.onload = function() {
        a.paused && (e ? (b = new e.PImage, b.fromHTMLImageData(j)) : (b = new Image, b.src = j))
      }, j.src = a.poster
    }
    i = [];
    d.listener && (i.push(d.listener), "Processing" in q && Processing && d.listener instanceof Processing ? (e = d.listener, b = new e.PImage) : b = new Image);
    a.addEventListener("error", x);
    a.addEventListener("loadedmetadata", y);
    a.addEventListener("timeupdate", A);
    a.addEventListener("canplay", z);
    r = 0 <= q.navigator.appVersion.toLowerCase().indexOf("chrome");
    n = this
  };
  c.prototype = {setSourceFrameRate:function(a) {
    m = a
  }, getElement:function() {
    return a
  }, volume:function(b) {
    t = a.volume = b
  }, read:function() {
    if(e) {
      b || (b = new e.PImage);
      try {
        b.fromHTMLImageData(a)
      }catch(d) {
        throw d;
      }
    }else {
      g && (g.drawImage(a, 0, 0), b || (b = new Image), b.src = h.toDataURL("image/png"))
    }
    return b
  }, available:function() {
    return o
  }, play:function() {
    a.play();
    v()
  }, isPlaying:function() {
    return!a.paused
  }, pause:function() {
    a.pause();
    clearTimeout(l)
  }, isPaused:function() {
    return a.paused
  }, stop:function() {
    a.pause();
    clearTimeout(l)
  }, loop:function() {
    k = !0;
    a.setAttribute("loop", "loop")
  }, noLoop:function() {
    k = !1;
    a.removeAttribute("loop")
  }, isLooping:function() {
    return k
  }, jump:function(b) {
    a.currentTime = b
  }, duration:function() {
    return a.duration
  }, time:function() {
    return a.currentTime
  }, speed:function(b) {
    0 !== b ? s = a.playbackRate = b : a.pause()
  }, frameRate:function(a) {
    this.speed(a / m)
  }, getSourceFrameRate:function() {
    return m
  }, goToBeginning:function() {
    this.jump(0)
  }, dispose:function() {
    this.stop();
    f.body.removeChild(a);
    delete a
  }, ready:function() {
    return 2 < a.readyState
  }, newFrame:function() {
    return this.available()
  }, getFilename:function() {
    return a.currentSrc
  }, get:function() {
    return b.get.apply(b, arguments)
  }, set:function() {
    return b.set.apply(b, arguments)
  }, copy:function() {
    return b.copy.apply(b, arguments)
  }, mask:function() {
    return b.mask.apply(b, arguments)
  }, blend:function() {
    return b.blend.apply(b, arguments)
  }, filter:function() {
    return b.filter.apply(b, arguments)
  }, save:function() {
    return b.save.apply(b, arguments)
  }, resize:function() {
    return b.resize.apply(b, arguments)
  }, loadPixels:function() {
    return b.loadPixels.apply(b, arguments)
  }, updatePixels:function() {
    return b.updatePixels.apply(b, arguments)
  }, toImageData:function() {
    return b.toImageData.apply(b, arguments)
  }};
  c.prototype.__defineGetter__("width", function() {
    return b.width
  });
  c.prototype.__defineGetter__("height", function() {
    return b.height
  });
  c.prototype.__defineGetter__("pixels", function() {
    return b.pixels
  });
  c.prototype.__defineGetter__("isRemote", function() {
    return b.isRemote
  });
  c.prototype.__defineSetter__("isRemote", function(a) {
    b.isRemote = a
  });
  c.prototype.__defineGetter__("sourceImg", function() {
    return b.sourceImg
  });
  c.prototype.__defineSetter__("sourceImg", function(a) {
    b.sourceImg = a
  });
  return c
}(window, document);
