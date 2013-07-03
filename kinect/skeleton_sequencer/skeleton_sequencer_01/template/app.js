jQuery(function(){
	new App(SketchConfig).start(window, document);
}); // jQuery.ready

var App = (function(){

	// - - - - - - - - - - - - - -
	//  private vars
	// - - - - - - - - - - - - - -

	/* see PieceMakerLib.js */
	var pm;  
	var video;

	var app;
	var canvas;
	var sketch; /* see Processing.js */
	var config;
	var onLocalhost = false;
	var videoId = 94;

	// - - - - - - - - - - - - - -
	//  App class
	// - - - - - - - - - - - - - -

	var App = function ( confs ) {
		app = this;
		config = confs;
	}
	App.prototype = {
		start: function (window, document) {
			
			onLocalhost = window.location.href.match(/^http:\/\/127\.0\.0\.1.*/) || 
                  		     window.location.href.match(/^http:\/\/localhost.*/);
			pm = new PieceMakerApi({
        		api_key: "a79c66c0bb4864c06bc44c0233ebd2d2b1100fbe",
        		baseUrl: ( onLocalhost ? 'http://localhost:3000' : 'http://counterpoint.herokuapp.com' )
    		});

			loadSketch();
		},
		getCanvasWidth : function () {
			return canvas.width();
		},
		getCanvasHeight : function () {
			return canvas.height();
		}
	}

	// - - - - - - - - - - - - - -
	//  private functs
	// - - - - - - - - - - - - - -

	var videoLoaded = function (t, video) {
		video = video.video;
		video.recorded_at = new Date( video.recorded_at_float);
		pm.loadEventsForVideo( video.id, eventsLoaded );

		setLoadingStatus("Loading events ...");
	};

	var eventsLoaded = function (t, data) {

		setLoadingStatus("Sequencing events ...");

		if ( data.total <= 0 ) {
			console.log( data );
			alert( "No events for video ... something's wrong" );
		} else {
			var events = data.events;
			for ( var i = 0, k = data.total; i < k; i++ ) {
				events[i].happened_at = new Date( events[i].happened_at_float );
				if ( events[i].event_type == 'data' && 
				     events[i].description && events[i].description.match(/^[\s]*{/) ) {
					events[i].data = jsonParse( events[i].description );
					events[i].description = null;
				}
			}

			sequenceEvents( events );
		}
	}

	var sequenceEvents = function ( events ) {

		var dataEvents = [];
		var data = [];
		var dataLoaded = 0;
		var sceneEvents = [];
		var scenes = [];

		var fps30 = 1000 / 30.0;
		var fps25 = 1000 / 25.0;

		var sequences = jQuery('#sequences');

		var processData = function () {
			
			var sequencesBlock = jQuery('#sequences');
			var itemTemplate = sequencesBlock.html().replace(/^[\s]*|[\s]*$/g,"");
			sequencesBlock.empty();

			sceneEvents.sort(function(s1,s2){
				return s1.title == s2.title ? 0 : (s1.title < s2.title ? -1 : 1);
			});

			for ( var i = 0, k = sceneEvents.length; i < k; i++ ) {
				var sceneEvent = sceneEvents[i];
				for ( var ii = 0, kk = sceneEvent.performers.length; ii < kk; ii++ ) {
					var key = sceneEvent.performers[ii];
					var dataEvent = dataEvents[key];
					if ( dataEvent ) {
						var tDiff = sceneEvent.happened_at - dataEvent.happened_at;
						if ( tDiff >= 0 ) {
							var startFrame = parseInt( tDiff / fps30 );
							var endFrame = startFrame + Math.ceil( (sceneEvent.duration * 1000) / fps30 );
							var link = jQuery( itemTemplate.
													replace('start',startFrame).
													replace('end', endFrame).
													replace('key', key).
													replace('title', sceneEvent.title) ).removeClass('template');
							link.data( 'start', startFrame );
							link.data( 'end', endFrame );
							link.data( 'key', key );
							link.get(0).addEventListener('dragstart', function (e) {
								e.dataTransfer.effectAllowed = 'copy';
								var message = this.id;
								e.dataTransfer.setData( 'text/plain', message );
								return false;
							});

							sequences.append( link );
						}
					}
				}
			}

			prepareCanvas();
		}

		var processBigData = function ( raw ) {
			var rows = [];
			var lines = raw.split("\n");
			for ( var l = "", i = 0, m = lines.length; i < m; i++ )
		    {
		    	l = lines[i];
		        if ( l[0] == '#' ) continue;

		        var dataRaw = l.split(",");
		        var data = [];
		        for ( var d = 0, k = dataRaw.length; d < k-1; d++ )
		        {
		            if ( d < 4 )
		                data[d] = parseFloat( dataRaw[d].trim() );
		            else
		            {
		            	var dataXYZ = dataRaw[d].replace("(","").replace(")","").trim().split(" ");
		                data[d] = [];
		                for ( var n = 0, r = dataXYZ.length; n < r; n++ ) {
		                	data[d].push( parseFloat( dataXYZ[n] ) );
		                }
		            }
		        }
		        rows[data[0]] = data;
		    }
		    return rows;
		}

		var loadData = function ( key, file ) {
			jQuery.get(file,function(d){
				data[key] = processBigData( d );
				dataLoaded++;
				if ( dataLoaded == 2 ) {
					sketch.setData(data);
					processData();
				}
			});
		}

		for ( var i = 0, k = events.length; i < k; i++ ) {
			if ( !(events[i].event_type == 'scene' || events[i].event_type == 'data') ) continue;
			if ( events[i].created_by != 'FlorianJenett2' ) continue;
			if ( !events[i].performers || events[i].performers.length == 0 ) continue;

			if ( events[i].event_type == 'scene' ) {
				if ( events[i].title != null && 
					 events[i].title != '' && 
					 scenes.indexOf(events[i].title) == -1 ) {
					scenes.push(events[i].title);
				}
				sceneEvents.push( events[i] );
			} else {
				dataEvents[events[i].performers[0]] = events[i];
				loadData( events[i].performers[0], events[i].data.file );
				setLoadingStatus("Loading big data ...");
			}
		}
	} // sequenceEvents(), is rather lengthy

	var prepareCanvas = function () {
		var canvasElement = canvas.get(0);
		var canvasPosition = getElementPosition(canvasElement);

		canvasElement.addEventListener( 'dragenter', function (e) {
			if (e.preventDefault) e.preventDefault();
			sketch.dragEnter();
			return false;
		});

		canvasElement.addEventListener( 'dragover', function (e) {
			if (e.preventDefault) e.preventDefault();
			e.dataTransfer.dropEffect = 'copy';
			sketch.dragOver( e.pageX-canvasPosition.x, 
							 e.pageY-canvasPosition.y );
			return false;
		});

		canvasElement.addEventListener( 'dragleave', function () {
			sketch.dragLeave();
		});

		canvasElement.addEventListener( 'drop', function (e) {
			if (e.stopPropagation) e.stopPropagation();
			if (e.preventDefault) e.preventDefault();
			sketch.dragDrop( e.dataTransfer.getData('text/plain'), 
							 e.pageX-canvasPosition.x, 
							 e.pageY-canvasPosition.y );
			return false;
		});
	}

	var loadSketch = function () {
		canvas = jQuery('canvas');
		canvas.css('width','970px');
		canvas.css('height','500px');

		jQuery.get( config.name+'.pde', function(sketchCode){
    		new Processing( canvas.get(0), sketchCode );
    	});

    	isSketchLoaded( config.id, sketchLoaded );
	};

	var isSketchLoaded = function ( id, callback ) {
		var s = Processing.getInstanceById(id);
		if ( !s ) {
			return setTimeout( function(){isSketchLoaded(id,callback)}, 100 );
		}
		callback(s);
	}

	var sketchLoaded = function ( s ) {

		sketch = s;
		sketch.setApp( app );

		jQuery('#loading').hide();
		canvas.parent().show();

		pm.loadVideo( videoId, videoLoaded );

		setLoadingStatus("Loading video ...");
	};

	var setLoadingStatus = function ( msg ) {
		isSketchLoaded(config.id,function(s){s.setLoadingStatus(msg)});
	}

	var jsonParse = function ( json ) {
		return eval( '(' + json + ');' );
	}

	var getElementPosition = function ( obj ) {
	    var curleft = curtop = 0;
	    if (obj.offsetParent) {
	        do {
	            curleft += obj.offsetLeft;
	            curtop  += obj.offsetTop;
	        } while (obj = obj.offsetParent);
	        return {x:curleft,y:curtop};
	    }
	    return undefined;
	}

	return App;
})();