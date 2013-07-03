
void mouseOver ()
{
    Interactive.setActive( slider, true );
}

void mouseOut ()
{
    Interactive.setActive( slider, false );
}

void mousePressed ()
{
    sliderPressed = slider.isInside(mouseX, mouseY);
}

void mouseMoved ()
{
    selectedEvent = null;
    if ( events != null )
    {
        for ( Object e : events )
        {
            if ( e.dimensions )
            {
                if ( mouseY >= e.dimensions.y && mouseY-1 <= e.dimensions.y + e.dimensions.height+ 1 )
                {
                    int ex = map( e.videoTimeNormalized, slider.getValue(slider.LEFT), slider.getValue(slider.RIGHT), 20, width );
                    if ( abs( ex - mouseX ) < 5 )
                    {
                        selectedEvent = e;
                        return;
                    }
                }
            }
        }
    }
}

void videoTimeChanged ( float ms )
{
    playHead = ms / video.duration;
    
    var ms1 = ms * 1000.0;
    for ( Object e : events )
    {
        if ( abs(e.videoTime-ms1) < 100 ) {
            //console.log( e.title + " " + abs(e.videoTime-ms1) );
            selectedEvent = e;
            break;
        }
    }
}

void mouseDragged ()
{
    if ( video && !sliderPressed && !slider.isInside(mouseX, mouseY) ) 
    {
        playHead = map( mouseX, 20, width, slider.getValue(slider.LEFT), slider.getValue(slider.RIGHT) );
        videoSeekTo( video.duration * playHead );
    }
}

void keyPressed ()
{
    switch ( key )
    {
        case 'd':
            showDuration = !showDuration;
            break;
    }
}
