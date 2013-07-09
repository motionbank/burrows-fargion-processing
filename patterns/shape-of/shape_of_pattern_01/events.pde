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
