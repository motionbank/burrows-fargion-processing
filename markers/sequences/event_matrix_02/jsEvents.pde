
// called to prepare for receiving new data

void videoChanged ()
{
    events = null;
    performers = null;
    
    filterPerformers = new ArrayList();
    filterType = new ArrayList(); 
    filterUser = new ArrayList(); 
    filterTitle = new ArrayList();
    
    video = null;
    selectedEvent = null;
    
    slider.reset();
    playHead = 0;
}

// called after video item has been loaded from API

void setVideo ( Object newVideo )
{
    video = newVideo;
}

// called after events have been loaded and sugared

void setEvents ( Object newEvents )
{
    events = new ArrayList();
    events.addAll( newEvents );
    
    performers = new HashMap();
    
    for ( Event e : newEvents )
    {
        for ( String s : e.performers )
        {
            Performer p = performers.get( s );
            if ( s != null && !s.equals("") && p == null )
            {
                p = new Performer( s );
                performers.put( s, p );
            }
            p.addEvent( e );
        }
    }
}

// called by video polling mechanism

void timeChanged ( float t )
{
    playHead = t / video.duration;
    
    var ms1 = t * 1000.0;
    for ( Object e : events )
    {
        if ( abs(e.videoTime-ms1) < 100 ) {
            //console.log( e.title + " " + abs(e.videoTime-ms1) );
            selectedEvent = e;
            break;
        }
    }
}


// called by filter interface

void filterEvents ( String type, String value, boolean on )
{
    ArrayList filters = null;
    if ( type == "type" ) filters = filterType;
    else if ( type == "performer" ) filters = filterPerformers;
    else if ( type == "title" ) filters = filterTitle;
    else if ( type == "user" ) filters = filterUser;
    
    // carefull, this has an inverted logic!
    // checked means not in any filter list
    
    if ( on )
    {
        if ( filters.indexOf( value ) == -1 )
        {
            filters.add( value );
        }
    }
    else
    {
        int pos = filters.indexOf( value );
        if ( pos != -1 )
        {
            filters.remove( pos );
        }
    }
    
    //console.log( filters.toArray() );
}
