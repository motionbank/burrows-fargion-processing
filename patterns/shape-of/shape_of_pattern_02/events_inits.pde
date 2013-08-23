void keyPressed ()
{
    if ( key == ' ' )
    {
        Interactive.send( this, "keypressed:space" );
    }
    if ( key == 'r' )
    {
        initGame( this );
    }
    if ( key == 's' )
    {
        for ( BeatShape s : shapes )
        {
            s.reset();
        }
    }
}

void mousePressed ()
{
    Interactive.send( this, "keypressed:space" );
}

//public void println ( Object...args )
//{
//    String o = "";
//    for ( Object a : args )
//    {
//        o += a.toString() + " ";
//    }
//    println( o );
//}


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
 
 
