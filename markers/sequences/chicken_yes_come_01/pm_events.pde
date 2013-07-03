
void pmReady ( PieceMakerApi piecemaker, boolean l )
{
    pm = piecemaker;
    pm.loadVideo(61, pm.createCallback(this, "videoLoaded"));
    runningLocally = l;
}

void videoLoaded ( Video v )
{
    video = v;
    video.recorded_at = new Date( video.recorded_at );
    videoElement = loadVideo( self, video.s3_url );
}

void videoFileLoaded ( Object videoElement )
{
    pm.loadEventsForVideo( video.id, pm.createCallback( this, "videoEventsLoaded" ) );
}

void videoEventsLoaded ( Events data )
{
    Object events = new ArrayList();
    events.addAll( data.events );
    for ( Object e : events )
    {
        addEventToLists(e);
    }
}

void pmError ( Object err )
{
    console.log( err );
    alert( "An error occured: \"" + err.statusText + " (" + err.status + ")" );
}

void pmDataAvailable ( int dataType, ArrayList data )
{
    switch ( dataType )
    {
    case PieceMakerApi.PIECES:
        piece = data.get(0);
        pm.loadVideosForPiece( piece.id );
        break;
    case PieceMakerApi.VIDEOS:
        videos = data;
        break;
    case PieceMakerApi.VIDEO:
//        video = data;
//        video.recorded_at = new Date( video.recorded_at );
//        videoElement = loadVideo( this, video.s3_url );
        break;
    case 99:
//        pm.loadEventsForVideo( video.id );
        break;
    case PieceMakerApi.EVENTS:
//        Object events = new ArrayList();
//        events.addAll( data.events );
//        for ( Object e : events )
//        {
//            addEventToLists(e);
//        }
        break;
    case PieceMakerApi.EVENT:
        Object event = data.event;
        String action = data.action;
        if ( action.equals("create") || action.equals("load") )
        {
            Object eList = addEventToLists( event );
            if ( eList != null )
            {
                Collections.sort( eList, new Comparator(){
                    public int compare ( Object o1, Object o2 ) {
                        return o1.videoTimeNormalized - o2.videoTimeNormalized;
                    }
                });
            }
        }
        else if ( action.equals("delete") && event.event_type.equals("scene") )
        {
            ArrayList eList = event.performers.indexOf("jburrows") >= 0 ? jbEvents : mfEvents;
            for ( Object e : eList )
            {
                if ( e.id == event.id )
                {
                    eList.remove(e);
                    break;
                }
            }
        }
    }
}

void addEventToLists ( Object e )
{
    if ( !(e.event_type.equals("scene")) ) return null;
    if ( e.performers.indexOf("jburrows") >= 0 )
    {
        if ( jbEvents == null ) jbEvents = new ArrayList();
        fixAndPrecalcEventVideoTime( e, video );
        jbEvents.add( e );
        return jbEvents;
    }
    if ( e.performers.indexOf("mfargion") >= 0 )
    {
        if ( mfEvents == null ) mfEvents = new ArrayList();
        fixAndPrecalcEventVideoTime( e, video );
        mfEvents.add( e );
        return mfEvents;
    }
}

void fixAndPrecalcEventVideoTime ( Object event, Object video ) 
{
    event.happened_at = new Date( event.happened_at_float );
    event.videoTime = new Date( event.happened_at - video.recorded_at );
    event.videoTimeNormalized = map( event.videoTime.getTime(), 0, videoElement.duration * 1000.0, 0, 1 );
}
