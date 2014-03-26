
jQuery(function () {
	
	// just checking where we are
	var onLocalhost = window.location.href.match(/^http:\/\/127\.0\.0\.1.*/);

	var sketch, video, videoElement, poller;

	// setting up PM
	var pm = new PieceMakerApi({
        api_key: "a79c66c0bb4864c06bc44c0233ebd2d2b1100fbe",
        baseUrl: ( onLocalhost && false ? 'http://localhost:3000' : 'http://counterpoint.herokuapp.com' )
    });

    // load pieces from PM
	pm.loadPieces(function(data){
	    var pieces = data.pieces;
	    // TODO: make an interface for choosing the a piece
	    //if ( pieces.length > 1 ) {
	    	// make an interface for it later?
	    //} else if ( pieces.length == 1 ) {
	    	for ( var p in pieces ) {
	        	if ( pieces[p].is_active ) {
	        		pm.loadPiece( pieces[p].id, pieceLoaded );
	        		return;
	        	}
	    	}
	    //}
	});

	// create popup menu
	var pieceLoaded = function ( piece ) {
        pm.loadVideosForPiece( piece.id, function(data){
            var videos = data.videos;
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
                pm.loadVideo(videoId, videoLoaded);
                return false;
            });
            jQuery('#interfaces').html(form);
        });
    };

    // initialize video element, load events
    var videoLoaded = function (v) {

    	// fixes ms-detail date
    	v.recorded_at = new Date( v.recorded_at_float );
    	video = v;

    	// clean up video, sketch, canvas, filters
    	if ( sketch ) {
    		sketch.videoChanged();
    	}
    	jQuery('video').each(function(i,e){
    		e.pause();
    		jQuery(e).empty().removeAttr('src','');
    	});
    	if ( poller ) {
    		poller.stop();
    	}
    	jQuery('#filters .column').empty();

    	var videoObject = jQuery('#video-player video');

    	jQuery(['mp4','ogv','webm']).each(function(i,e){
    		videoObject.append('<source src="'+(video.s3_url.replace('.mp4','.'+e))+'"/>');
    	});

    	videoElement = videoObject.get(0);
    	videoElement.addEventListener('loadedmetadata',function(){
    		videoObject.attr('width',videoElement.videoWidth);
    		videoObject.attr('height',videoElement.videoHeight);
    		//console.log( videoElement.duration );
    		videoFileLoaded( videoObject );
    	});

    	pm.loadEventsForVideo( video.id, eventsLoaded );
    }

	var isSketchLoaded = function (callback) {
		var sketch = Processing.getInstanceById( SketchConfig.id );
		if ( !sketch ) {
			return setTimeout( function(){isSketchLoaded(callback)}, 100 );
		}
		callback( sketch );
	}

    // load sketch
    var videoFileLoaded = function ( videoObject ) {

    	videoObject.removeAttr('poster');

    	if ( !sketch ) {
    	
    		var canvas = jQuery('canvas');
    		canvas.css('width','100%');
    		canvas.css('height','300px');
	    	
	    	jQuery.get(SketchConfig.name+".pde",function(resp){
	    		new Processing( canvas.get(0), resp );
	    	});
    	}

    	isSketchLoaded( sketchLoaded );
    }

    var sketchLoaded = function ( s ) {

    	sketch = s;
    	
    	sketch.setVideo( video );

    	poller = new VideoPoller(videoElement, function(t){
    		sketch.timeChanged(t);
    	});
    	videoElement.addEventListener('play',function(){
    		poller.start();
    	});
    	videoElement.addEventListener('pause',function(){
    		poller.stop();
    	})
    }

    var eventsLoaded = function ( data ) {
    	if ( data.total > 0 ) {
    		var events = [];
    		var performers = [];
    		var titles = [];
    		var types = [];
    		var users = [];
    		for ( var i = 0; i < data.total; i++ ) {
    			var e = data.events[i];
    			// fixes ms-detail date
				e.happened_at = new Date( e.happened_at_float );
        		e.videoTime = new Date( e.happened_at - video.recorded_at ).getTime();
        		e.videoTimeNormalized = e.videoTime / (video.duration * 1000.0);
        		e.videoDurationNormalized = (e.duration * 1000.0) / (video.duration * 1000.0);
        		// add to filters
        		if ( e.title && titles.indexOf(e.title) == -1 ) {
        			titles.push( e.title );
        		}
        		if ( e.event_type && types.indexOf(e.event_type) == -1 ) {
        			types.push( e.event_type );
        		}
        		if ( e.performers && e.performers.length && e.performers.length > 0 ) {
        			for ( var ip = 0, kip = e.performers.length; ip < kip; ip++ ) {
        				if ( performers.indexOf(e.performers[ip]) == -1 ) {
        					performers.push(e.performers[ip]);
        				}
        			}
        		}
        		if ( e.created_by && users.indexOf(e.created_by) == -1 ) {
        			users.push(e.created_by);
        		}
        		events.push( e );
    		}
    		//console.log(titles,types,performers, users);
    		buildFilters({
    			title:titles,
    			type: types, 
    			performer: performers, 
    			user: users
    		});
    		isSketchLoaded(function(s){
    			s.setEvents( events );
    		});
    	} else {
    		console.log( 'No events' );
    	}
    }

	var buildFilters = function ( filterBy ) {
		for ( var f in filterBy ) {
			if ( !filterBy.hasOwnProperty(f) || typeof f != 'string' ) continue;
			var element = jQuery('#'+f+'-filter');
			for ( var i = 0, k = filterBy[f].length; i < k; i++ ) {
				var inp = jQuery( '<input type="checkbox" checked="checked" '+
								   'data-filter-type="'+f+'" data-filter-value="'+escape(filterBy[f][i])+'" />');
				inp.change(function(evt){
					var elm = jQuery(this);
					sketch.filterEvents( elm.data('filter-type'), 
										 unescape(elm.data('filter-value')), 
										 elm.attr('checked') != 'checked' );
					return false;
				});
				var lab = jQuery('<label></label>');
				lab.append(inp);
				lab.append(filterBy[f][i]);
				element.append(lab);
				element.append('<br/>');
			}
		}
	}

	// just prep'in the video to show/hide controls when hover'd

	jQuery('video').hover(function(){
		if ( this.readyState == 4 )
			jQuery(this).attr('controls','controls')
	},function(){
		jQuery(this).removeAttr('controls')
	});

}); // jQuery()

var PiceMakerListener = (function () {
	var PieceMakerListener = function () {};
	PieceMakerListener.prototype.pmDataAvailable = function () {
	};
	return PieceMakerListener;
})();

var VideoPoller = (function(){
	var videoElement, callback;
	var vMillis = -1, pollingTs = -1;
	var startPolling = function(){
		var doPoll = function(){
			if ( !videoElement ) {
				console.log( "VideoPoller: video is null, stopping." );
				return;
			}
			var now = videoElement.currentTime;
			if ( now != vMillis ) {
				callback( now );
				vMillis = now;
			}
			pollingTs = setTimeout( doPoll, 1000/25.0 );
		}
		doPoll();
	}
	var stopPolling = function(){
		clearTimeout( pollingTs );
	}
	var VideoPoller = function () {
		videoElement = arguments[0];
		callback = arguments[1] || function(){};
	}
	VideoPoller.prototype.start = startPolling;
	VideoPoller.prototype.stop = stopPolling;
	return VideoPoller;
})();