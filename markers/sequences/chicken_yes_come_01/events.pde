
void timeChanged ( int secs, int duration )
{
    playHead = secs/(float)duration;
}

void keyPressed ()
{
    if ( keyCode == 127 )
    {
        if ( selectedEvent != null )
        {
            if ( runningLocally && confirm("Delete selected Event?") )
            {
                pm.deleteEvent( selectedEvent.id );
            }
        }
    }
}

void mousePressed ()
{
    float h2 = height/2;
    
    if ( mouseY > h2-20 && mouseY < h2+20 )
    {
        draggedEvent = null;
        selectedEventList = null;
        if ( mouseY < h2 && mouseY > h2-20 )
        {
            selectedEvent = getClickedEventFromList(jbEvents);
            if ( selectedEvent != null )
            {
                selectedEventList = jbEvents;
            }
        }
        else if ( mouseY >= h2 && mouseY < h2+20 )
        {
            selectedEvent = getClickedEventFromList(mfEvents);
            if ( selectedEvent != null )
            {
                selectedEventList = mfEvents;
            }
        }
    }
}

void getClickedEventFromList ( ArrayList eList )
{
    for ( Object e : eList )
    {
        if ( e.videoTimeNormalized >= slider.getValue(0) && e.videoTimeNormalized <= slider.getValue(1) )
        {
            float x = map( e.videoTimeNormalized, slider.getValue(0), slider.getValue(1), 10, width-10 );
            if ( abs(mouseX - x) < 5 )
            {
                return e;
            }
        }
    }
    return null;
}

void mouseDragged ()
{
    if ( mouseY < height/2-20 || (mouseY > height/2+20 && mouseY < slider.y) )
    {
        playHead = map( mouseX, 10, width-10, slider.getValue(0), slider.getValue(1) );
        videoElement.currentTime = playHead * videoElement.duration;
    }
    else if ( selectedEvent != null && mouseY > height/2-20 && mouseY < height/2+20 )
    {
        float v = map( mouseX, 10, width-10, slider.values[0], slider.values[1] );
        selectedEvent.videoTimeNormalized = v;
        Collections.sort(selectedEventList,new Comparator(){
            public int compare ( Object o1, Object o2 ) {
                return o1.videoTimeNormalized - o2.videoTimeNormalized;
            }
        });
        draggedEvent = selectedEvent;
    }
}

void mouseReleased ()
{
    if ( draggedEvent )
    {
        draggedEvent.videoTime = new Date( map( draggedEvent.videoTimeNormalized, 0, 1, 0, video.duration * 1000.0 ) );
        draggedEvent.happened_at = new Date( video.recorded_at.getTime() + draggedEvent.videoTime.getTime() );
        if ( runningLocally )
        {
            pm.saveEvent( draggedEvent.id, object(
                "happened_at_float", draggedEvent.happened_at.getTime() / 1000.0
            ));
        }
        draggedEvent = null;
    }
    else
    {
        long now = millis();
        if ( now - pressedMillis < 300 )
        {
            pressedMillis = -1;
            mouseDoubleClicked();
        }
        else
        {
            pressedMillis = now;
        }
    }
}

void mouseDoubleClicked ()
{
    float v = map( mouseX, 10, width-10, slider.getValue(0), slider.getValue(1) );
    Object d = new Date( video.recorded_at.getTime() + 
                         (new Date( map(v, 0, 1, 0, video.duration * 1000.0) )).getTime() );
                         
    int h2 = height / 2;
    if ( mouseY > h2 - 20 && mouseY < h2 + 20 )
    {
        String performer = mouseY >= h2 ? "mfargion" : "jburrows";
        
        pm.createEvent( object(
            "happened_at_float", d.getTime() / 1000.0,
            "title", "test",
            "event_type", "scene",
            "video_id", video.id,
            "piece_id", 3,
            "performers", "---\n- "+performer+"\n"
        ));
    }
}


void fixAndPrecalcEventVideoTime ( Object event, Object video ) 
{
    event.happened_at = new Date( event.happened_at_float );
    event.videoTime = new Date( event.happened_at - video.recorded_at );
    event.videoTimeNormalized = map( event.videoTime.getTime(), 0, video.duration * 1000.0, 0, 1 );
}
