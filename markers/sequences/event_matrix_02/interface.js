
var getSketchWidth = function ()
{
    return jQuery('canvas').width();
}

var getSketchHeight = function ()
{
    return jQuery('canvas').height();
}

var videoElement;

var setVideoTime = function ( t ) {
    if ( !videoElement ) {
        videoElement = jQuery('#video-player video').get(0);
    }
    videoElement.currentTime = t;
}
