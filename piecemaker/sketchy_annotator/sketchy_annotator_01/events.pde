
void keyPressed ()
{
    switch ( key )
    {
        case ' ':
            if ( movie != null ) movie.isPlaying() ? movie.pause() : movie.play();
            break;
        case 'd':
            drawingMode = !drawingMode;
            break;
    }
    switch ( keyCode )
    {
        case RIGHT:
            movie.jump( movie.time() + secsOneFrame );
            break;
        case LEFT:
            movie.jump( movie.time() - secsOneFrame );
            break;
    }
}

boolean movieWasPlaying = false;
DrawingFrame currentDrawing;

void mousePressed ()
{
    if ( movie != null && !drawingMode )
    {
        movieWasPlaying = movie.isPlaying();
        movie.pause();
    }
    if ( drawingMode )
    {
        currentDrawing = drawings.getFrameAt( movie.time() );
        if ( currentDrawing == null )
        {
            currentDrawing = drawings.newFrameAt( movie.time() );
        }
        
        currentDrawing.addSegment();
        currentDrawing.add( mouseX, mouseY );
    }
}

void mouseDragged ()
{
    if ( movie != null && !drawingMode )
    {
        float sec = map( mouseX, 0, width, 0, movie.duration() );
        movie.jump( sec );
    }
    if ( drawingMode )
    {
        currentDrawing.add( mouseX, mouseY );
    }
}

void mouseReleased ()
{
    if ( movie != null && !drawingMode && movieWasPlaying )
    {
        movie.play();
    }
}
