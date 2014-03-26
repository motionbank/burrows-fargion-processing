var getCanvasWidth = function () {
    return jQuery('canvas').width();
}
var getCanvasHeight = function () {
    return jQuery('canvas').height();
}
var getKinectData = function ( id ) {
    var item = jQuery('#'+id);
    return [
        item.data('key'),
        item.text(),
        parseInt( item.data('start') ),
        parseInt( item.data('end') )
    ];
}
