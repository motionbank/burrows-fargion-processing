void keyPressed ()
{
    if ( key != CODED )
    {
        if ( key == ' ' || key == 'l' )
            Interactive.send( "event:hit" );
    } 
    else 
    {
        if ( keyCode == UP )
            game.trackUp();
        else
        if ( keyCode == DOWN )
            game.trackDown();
    }
}
