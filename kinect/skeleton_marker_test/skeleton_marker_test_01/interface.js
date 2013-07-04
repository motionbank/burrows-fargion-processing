window.addEventListener( "load", function(evt) {
    var checkReady = function () {
        var sketch = Processing.getInstanceById( getProcessingSketchId() );
        if ( !sketch ) return setTimeout( checkReady, 100 );
        sketchLoaded( sketch );
    }
    checkReady();
});

function sketchLoaded ( sketch ) {
    onLocalhost = window.location.href.match(/^http:\/\/127\.0\.0\.1.*/) || 
                  window.location.href.match(/^http:\/\/localhost.*/);
    
    var pm = new PieceMakerApi({
        listener: sketch,
        api_key: "a79c66c0bb4864c06bc44c0233ebd2d2b1100fbe",
        baseUrl: ( onLocalhost ? "http://localhost:3000" : "http://counterpoint.herokuapp.com" )
    });
    
    sketch.pmReady( pm, onLocalhost );
}

function jsonDecode ( json_str ) {
    return eval( '(' + json_str + ');' );
}
