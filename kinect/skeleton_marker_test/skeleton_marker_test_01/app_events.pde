void mouseDragged ()
{
    if ( mouseY < height-10 ) 
    {
        rotY = map( mouseX, 0, width, -HALF_PI/2, HALF_PI/2);
    }
}

void keyPressed ()
{
    switch ( key )
    {
        case 'b':
            findRandomAndGoto("brush");
            break;
        case 's':
            findRandomAndGoto("small petals");
            break;
        case 'p':
            findRandomAndGoto("petals");
            break;
    }
}

void findRandomAndGoto ( String title )
{
    Event e = null;
    while (  e == null )
    {
        int r = int( random( matteoEvents.size() ) );
        Event er = matteoEvents.get( r );
        if ( er.title.equals( title ) )
        {
            timeline.goto( er.happened_at_frame * 40 );
            timeline.select( er.happened_at_frame * 40, er.happened_at_frame * 40 + er.duration * 1000 );
            return;
        }
    }
}
