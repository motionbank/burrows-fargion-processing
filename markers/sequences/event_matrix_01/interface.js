
var onLocalhost;
var videoElement;
var sketch;

window.onload = function () {
    var neededJs = ['PieceMakerApi', 'Processing', 'jQuery'];
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

function sketchLoaded ( s ) {
    
    sketch = s;
    
    onLocalhost = window.location.href.match(/^http:\/\/127\.0\.0\.1.*/);
    
    var pm = new PieceMakerApi({
        listener: sketch,
        api_key: "a79c66c0bb4864c06bc44c0233ebd2d2b1100fbe",
        baseUrl: ( onLocalhost && false ? 'http://localhost:3000' : 'http://counterpoint.herokuapp.com' )
    });
    
    sketch.pmReady( pm, onLocalhost );
    var canvas = jQuery(sketch.externals.canvas);
    canvas.bind('mouseover',function(){
        sketch.mouseOver();
    });
    canvas.bind('mouseout',function(){
        sketch.mouseOut();
    });
    
    pm.loadPieces(function(piecesCollection){
        var pieces = piecesCollection.pieces;
        if ( pieces.length > 1 ) {
            var form = jQuery('<form id="select-piece">');
            var sel = jQuery('<select>');
            sel.appendTo( form );
            for ( var p in pieces ) {
                var piece = pieces[p];
                var opt = jQuery('<option>');
                opt.text(piece.title);
                opt.attr('value',piece.id);
                sel.append(opt);
            }
            form.submit(function(evt){
                var pieceId = sel.val();
                pm.loadPiece( pieceId, pieceLoaded );
            });
            form.append('<input type="submit" value="Load">');
            jQuery('#interfaces').append(form);
        }
        else if ( pieces.length == 1 )
        {
            pm.loadPiece( pieces[0].id, pieceLoaded );
        }
    });
    
    var pieceLoaded = function (piece) {
        pm.loadVideosForPiece( piece.id, function(videoCollection){
            var videos = videoCollection.videos;
            var form = jQuery('<form id="select-video">');
            var sel = jQuery('<select>');
            form.append(sel);
            for ( var v in videos ) {
                var video = videos[v];
                var opt = jQuery('<option>');
                opt.text(video.title);
                opt.attr('value',video.id);
                sel.append(opt);
            }
            form.append('<input type="submit" value="Load">');
            form.submit(function(evt){
                evt.preventDefault();
                var videoId = sel.val();
                pm.loadVideo( videoId, function(video){
                    video.recorded_at = new Date( video.recorded_at );
                    sketch.setVideo( video );
                    pm.loadEventsForVideo( video.id, function(data){
                        sketch.setEvents(data.events);
                    });
                });
                return false;
            });
            jQuery('#interfaces').append(form);
        });
    }
}

var showVideo = function ( url )
{    
    // create html elements
    var videoContainer = jQuery('#video-player');
    videoContainer.empty();
    var video = jQuery('<video>');
    videoElement = video.get(0);
    videoContainer.append(video);
    var codecs = ['mp4','ogv','webm'];
    for ( var c in codecs ) {
        var src = jQuery('<source>');
        src.attr( 'src', url.replace('mp4', codecs[c] ) );
        video.append(src);
    }
    // polling
    var vMillis = -1, pollingTs = -1;
    var startPolling = function(){
        var doPoll = function(){
            var now = videoElement.currentTime;
            if ( now != vMillis ) {
                
                sketch.videoTimeChanged( now );
                vMillis = now;
            }
            pollingTs = setTimeout( doPoll, 1000/25.0 );
        }
        doPoll();
    }
    var stopPolling = function(){
        clearTimeout( pollingTs );
    }
    // events
    video.bind('mouseover', function(){
        video.attr('controls',1);
    });
    video.bind('mouseout', function(){
        video.removeAttr('controls');
    });
    video.bind('timeupdate', function(){
        if ( videoElement.paused ){
            sketch.videoTimeChanged( videoElement.currentTime );
        }
    });
    video.bind('loadedmetadata', function(){
    });
    video.bind('canplay', function(){
    });
    video.bind('play', function(){
        startPolling();
    });
    video.bind('pause', function(){
        stopPolling();
    });
}

var videoSeekTo = function ( t ) {
    if ( videoElement )
        videoElement.currentTime = t;
}
