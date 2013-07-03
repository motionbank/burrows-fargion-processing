/**
 *    Sketchy annotator
 *    fjenett 20120921
 */
 
 import processing.video.Movie; // see: processing.video.js
 
 App app;
 Movie movie;
 PImage movieFrame;
 
 Drawings drawings;
 
 int frameNum = 0;
 boolean drawingMode = true;
 
 float secsOneFrame = 1 / 25.0;
 
 void setup ()
 {
     size( getSketchWidth(), getSketchHeight() );
     
     console.log( externals );
     
     drawings = new Drawings();
 }
 
 void draw ()
 {
     if ( movie != null )
     {
         drawMain();
     }
     else
     {
         drawLoading();
     }
 }
 
 void drawMain ()
 {
     background( 255 );
     
     if ( !movie.isPlaying() )
     {
         fill( 0 );
         textAlign( CENTER );
         text( "Press <space> to play/pause video.", width/2, height/2 );
         text( "Click-drag to scrobble video.", width/2, height/2 + 16 );
     }
     
     if ( movie.available() )
     {
         movie.read();
         
         movieFrame = movie.get();
         image( movieFrame, width/2 - movieFrame.width/2, height/2 - movieFrame.height/2 );
     }
     
     if ( drawingMode )
     {
         stroke( 255, 100, 100 );
         noFill();
         strokeWeight( 2 );
         rect( 0,0, width-3,height-3 );
         
         if ( currentDrawing != null )
         {
             float tDist = currentDrawing.seconds - movie.time();
             
             if ( tDist >= 0 && tDist < secsOneFrame/2 )
             {
                 stroke( 0 );
                 noFill();
                 currentDrawing.draw();
             }
         }
     }
 }
 
 void drawLoading ()
 {
     background( 200 );
     
     int f = int( millis() / 40.0 );
     if ( f != frameNum )
     {
         frameNum = f;
         fill( 0 );
         textAlign( CENTER );
         text( "Loading ..", width/2, height/2 );
     }
 }
