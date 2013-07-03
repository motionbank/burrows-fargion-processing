void updateSkeleton ( int currentFrame )
{
    if ( loaded ) matteo.setPose(currentFrame);
}

void updateEvent ( int currentFrame )
{
    Event lastSelectedEvent = selectedEvent;
    selectedEvent = null;
    
    for ( Event e : matteoEvents )
    {
        if ( e.happened_at_frame < currentFrame )
        {
            selectedEvent = e;
        }
    }
    
    if ( selectedEvent != lastSelectedEvent )
    {
        eventChanged();
    }
}

void eventChanged ()
{
    if ( stopAtNextEvent )
    {
        timeline.stop();
    }
}
