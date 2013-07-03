
void pmReady ( PieceMakerApi p, boolean l )
{
    pm = p;
    pm.loadVideo( 94 );
    onLocalhost = l;
}

void pmDataAvailable ( int dataType, ArrayList data )
{
    switch ( dataType )
    {
    case PieceMakerApi.VIDEO:
        video = data;
        //
        //    THIS IS OUR ABSOLUTE ZERO TIME:
        //    all others are in relation to recorded_at
        //
        video.recorded_at = new Date( video.recorded_at_float );
        pm.loadEventsForVideo( video.id );
        break;
    case PieceMakerApi.EVENTS:
        Object events = new ArrayList();
        events.addAll( data.events );
        for ( Object e : events )
        {
            if ( e.performers.length > 0 && e.performers[0] == "mfargion" )
            {
                if ( e.event_type == "data" ) 
                {
                    e.happened_at = new Date( e.happened_at_float );
                    int d = e.happened_at - video.recorded_at;
                    timeline.addListener( new TimelineListenerFPS(d, 30, "updateSkeleton") );
                    
                    matteo = new Skeleton();
                    
                    Object eventData = jsonDecode( e.description );
                    String[] lines = loadStrings( eventData.file );
                    for ( String l : lines )
                    {
                        if ( l.startsWith("#") ) continue;
                        String[] dataRaw = l.split(",");
                        Object data = new float[dataRaw.length-1];
                        for ( int d = 0, k = dataRaw.length; d < k-1; d++ )
                        {
                            if ( d < 4 )
                                data[d] = float( dataRaw[d].trim() );
                            else
                            {
                                data[d] = float( dataRaw[d].replace("(","").replace(")","").trim().split(" ") );
                            }
                        }
                        matteo.addPose( data );
                    }
                }
                else if ( e.event_type == "scene" && e.created_by == "FlorianJenett2" )
                {
                    e.happened_at = new Date( e.happened_at_float );
                    e.happened_at_frame = Math.ceil( ((e.happened_at - video.recorded_at) / 1000) * 25 ); // TODO: check ceil or floor?
                    
                    if ( e.duration == null )
                        e.duration = e.dur ? e.dur : 2;
                    
                    if ( matteoEvents == null )
                    {
                        matteoEvents = new ArrayList();
                    }
                    matteoEvents.add( e );
                }
            }
        }
        timeline.addListener( new TimelineListenerFPS(video.duration, 25, "updateEvent") );
        loaded = true;
        timeline.goto( 8900 * 40 );
        break;
    case PieceMakerApi.EVENT:

    }
}

