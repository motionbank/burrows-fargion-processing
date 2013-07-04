
void pmReady ( PieceMakerApi p, boolean l )
{
    api = new PieceMakerApi( this, 
                             "a79c66c0bb4864c06bc44c0233ebd2d2b1100fbe", 
                             onLocalhost ? "http://localhost:3000" : "http://counterpoint.herokuapp.com" );
                             
    api.loadVideo( 94, api.createCallback( "videoLoaded" ) );
    onLocalhost = l;
}

void videoLoaded ( Video v )
{
    video = v;
    //
    //    THIS IS OUR ABSOLUTE ZERO TIME:
    //    all others are in relation to recorded_at
    //
    video.recorded_at = new Date( video.recorded_at_float );
    api.loadEventsForVideo( video.id, api.createCallback( "videoEventsLoaded" ) );
}

void videoEventsLoaded ( Events evts )
{
    Object events = new ArrayList();
    events.addAll( evts.events );
    
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
                //console.log( "Loading file from:", eventData.file );
                String[] lines = loadStrings( kinectDataRoot + "/" + video.id + "/" + eventData.file );
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
}

