/**
 *    Motion Bank research, http://motionbank.org
 *
 *    Shape of pattern
 *    Processing 2.0
 *    fjenett
 */
 
 import de.bezier.guido.*;
 
 BeatShape[] shapes;
 BeatShape bs;
 BeatRecorderShape rs;
 
 void setup ()
 {
     size( 400, 400 );
     
     Interactive.make( this );
     Interactive.on( this, "keypressed:space",  this, "keyPressedSpace" );
     
     initGame( this );
     
     background( 0 );
 }
 
 void draw ()
 {
     noStroke();
     fill( 0, 15 );
     rect( 0, 0, width, height );
     
     for ( BeatShape s : shapes ) 
     {
         s.tick();
     
         noFill();
         stroke( 255 );
         
         pushMatrix();
         translate( width/2, height/2 );
         s.draw();
         popMatrix();
     }
 }
 
 void initGame ( PApplet p )
 {
     int edges = int( 3 + random(6) );
     int bpm = int( 90 + random( 50 ) );
     
     bs = new BeatShape( 1, edges, bpm );
     rs = new BeatRecorderShape( 1, edges, bpm );
     
     shapes = new BeatShape[]{
         bs, rs
     };
     
     Interactive.on( bs, "tick:next", p, "ticked" );
 }
 
 void keyPressedSpace ()
 {
     rs.pressed();
 }
 
 void ticked ()
 {
     fill( 255 );
     pushMatrix();
     translate( width/2, height/2 );
     bs.drawFull();
     popMatrix();
 }
 
 void tickDone ()
 {
     //println( bs.timeStamp - rs.timeStamp );
     if ( rs.verticesToDraw == bs.verticesToDraw )
     {
         rs.timeStamp = bs.timeStamp;
     }
 }
 
 
