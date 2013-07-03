
window.onload = function () {
    var neededJs = ['PieceMakerApi', 'Processing', 'Interactive', 'jQuery'];
    var checkNeeded = function () {
        for ( var n in neededJs ) {
            if ( !( neededJs[n] in window ) ) {
                return setTimeout( checkNeeded, 200 );
            }
        }
        if ( 'Processing' in window ) {
            var sketch = Processing.getInstanceById( getProcessingSketchId() );
            if ( !sketch ) {
                return setTimeout( checkNeeded, 200 );
            }
            sketchLoaded( sketch );
        }
    }
    checkNeeded();
}

var onLocalhost;

function sketchLoaded ( sketch ) {
    
    onLocalhost = window.location.href.match(/^http:\/\/127\.0\.0\.1.*/);
    
    var pm = new PieceMakerApi({
        listener: sketch,
        api_key: "a79c66c0bb4864c06bc44c0233ebd2d2b1100fbe",
        baseUrl: ( onLocalhost && false ? 'http://localhost:3000' : 'http://counterpoint.herokuapp.com' )
    });
    
    sketch.pmReady( pm, onLocalhost );
}
