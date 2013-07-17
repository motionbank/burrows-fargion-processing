/**
 *    Motion Bank research, http://motionbank.org
 *
 *    Shape of pattern
 *    Processing 2.0
 *    fjenett
 */
 
 import java.util.*;
 import de.bezier.guido.*;
 
 PatternGame game;
 
 void setup ()
 {
     size( 400, 400 );
     
     Interactive.make( this );
     
     game = new PatternGame();
     
     new Thread () {
         public void run () {
             while ( true ) {
                 game.tick();
             }
         }
     }.start();
 }
 
 void draw ()
 {
     background( 0 );
     
     game.draw( 10, 10, width-20, height-20 );
 }

