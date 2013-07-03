/* + + + + + + + + + + + + + + + + + + + + + + + +
 +
 +   functions called from plain js (outside)
 +
 + + + + + + + + + + + + + + + + + + + + + + + + */
 
 /**
  *    pass the App object to the sketch to be able to call out
  */
 void setApp ( App a )
 {
     app = a;
 }
 
 /**
  *    pass in video file to load
  */
 void setVideoFile ( String path )
 {
     console.log( path );
     movie = new Movie( this, path /*, path.replace(".mp4",".ogv"), path.replace(".mp4",".webm")*/ );
 }
