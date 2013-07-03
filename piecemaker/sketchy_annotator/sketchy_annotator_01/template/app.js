
jQuery(function(){
	new App(AppConfig);
});

var App = (function(){

	// --------------------------
	//	private variables
	// --------------------------
	
	var app = null;
	var pm = null;

	var conf;

	var sketch, video, canvas;

	// --------------------------
	//	private functions
	// --------------------------

	var init = function () {
		pm = new PieceMakerApi({
    		api_key: conf.pieceMaker.apiKey,
    		baseUrl: conf.onLocalhost ? 'http://localhost:3000' : conf.pieceMaker.remoteLocation
		});

		loadSketch( conf.sketch.id, conf.sketch.name+'.pde' );
	}

	var loadSketch = function ( id, file ) {
		canvas = jQuery( '#'+id );
		canvas.css('width',conf.sketch.width);
		canvas.css('height',conf.sketch.height);

		jQuery.get(
			file,
			function(code){
				new Processing( canvas.get(0), code );
				isSketchLoaded( id, sketchLoaded );
			}
		);
	}

	var isSketchLoaded = function ( id, callback ) {
		var s = Processing.getInstanceById(id);
		if (!s) {
			return setTimeout( function(){isSketchLoaded(id,callback)}, 100 );
		}
		callback(s);
	}

	var sketchLoaded = function ( s ) {
		sketch = s;
		sketch.setApp(app);

		pm.loadVideo( 96, videoLoaded );
	}

	var videoLoaded = function (t, video) {
		sketch.setVideoFile( //conf.onLocalhost ? 'http://piecemaker.local/video/full/' + video.s3_url.split('/').pop() : 
			video.s3_url );
	}

	// --------------------------
	//	class App
	// --------------------------
	
	var App = function ( appConf ) {
		app = this;
		conf = appConf;

		init();
	}
	App.prototype = {

	}
	return App;
})();