void keyPressed ()
{
    if ( key != CODED )
    {
        if ( key == ' ' || key == 'l' )
            Interactive.send( "key-hit" );
        else if ( key == 'r' )
            game.reset();
        else if ( key == '-' )
        {
            game.slower();
            game.reset();
        }
        else if ( key == '+' )
        {
            game.faster();
            game.reset();
        }
    } 
    else 
    {
        if ( keyCode == UP )
        {
            Interactive.send( "key-hit" );
            game.trackUp();
        }
        else if ( keyCode == DOWN )
        {
            Interactive.send( "key-hit" );
            game.trackDown();
        }
    }
}

