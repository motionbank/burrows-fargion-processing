
var loadVideo = function ( listener, src ) {

    var video = document.getElementById('video-player') || document.createElement('video');
    var codecs = ['mp4','ogv','webm'];
    for ( var c in codecs ) {
        var source = document.createElement('source');
        source.setAttribute('src',src.replace('mp4',codecs[c]));
        video.appendChild(source);
    }
    video.removeAttribute('controls');
    
    video.addEventListener('mouseover',function(){
        video.setAttribute('controls','controls');
    });
    video.addEventListener('mouseenter',function(){
        video.setAttribute('controls','controls');
    });
    
    video.addEventListener('mouseout',function(){
        video.removeAttribute('controls');
    });
    video.addEventListener('mouseleave',function(){
        video.removeAttribute('controls');
    });
    
    //video.style.display = 'none';
    if ( !video.parentNode ) document.body.appendChild(video);
    
    // events:
    // https://developer.mozilla.org/en-US/docs/DOM/Media_events
    
    
    video.addEventListener('loadedmetadata',function(r){
        listener.videoFileLoaded( video );
    });
    
    video.addEventListener('canplay',function(r){
        //video.play();
        startPolling();
    });
    
    var pollTs = -1, lastTime = -1;
    var startPolling = function () {
        function pollVideo () {
            var currentTime = video.currentTime;
            if ( lastTime != currentTime )
            {
                lastTime = currentTime;
                listener.timeChanged( currentTime, video.duration );
            }
            pollTs = setTimeout(pollVideo, 1000/25.0);
        }
        pollVideo();
    }
    var stopPolling = function () {
        clearTimeout( pollTs );
    }
    
//    video.addEventListener('timeupdate',function(r){
//        listener.timeChanged( video.currentTime, video.duration );
//    });

//    video.addEventListener('play',function () {
//    });

//    setTimeout( function () {
//        $.ajax({
//            url: 'http://localhost:3000/api/event/1490/save',
//            type: 'POST',
//            dataType: 'json',
//            data: {
//                title: 'test 123'
//            },
//            xhrFields: {
//                withCredentials: true
//            },
//            success: function (resp) {
//                console.log(resp);
//            },
//            error: function (err) {
//                console.log(err);
//            }
//        });
//    }, 1000);

    return video;
}
