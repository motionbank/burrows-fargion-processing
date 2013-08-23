/**
 *    Motion Bank research, http://motionbank.org
 *
 *    Shape of pattern
 *    Processing 2.0
 *    fjenett
 */
 
 import de.bezier.guido.*;
 
 PatternGame game;
 
 void setup ()
 {
     size( 400, 400 );
     
     Interactive.make( this );
     
     game = new PatternGame();
     
     background( 0 );
 }
 
 void draw ()
 {
     game.tick();
     game.draw( 10, 10, width-20, height-20 );
 }

