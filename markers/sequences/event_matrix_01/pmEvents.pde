
void pmReady ( PieceMakerApi p, boolean l )
{
    pm = p;
    onLocalhost = l;
}

void pmDataAvailable ( int type, Object data )
{
    switch ( type )
    {
        case PieceMakerApi.VIDEO:
            video = data;
            video.recorded_at = new Date( video.recorded_at );
            events = null;
            pm.loadEventsForVideo(video.id);
            showVideo( this, video.s3_url );
            break;
        case PieceMakerApi.EVENTS:
            events = new ArrayList();
            events.addAll( data.events );
            eventsByPerformer = new HashMap();
            for ( Object e : events )
            {
                e.happened_at = new Date( e.happened_at_float );
                e.videoTime = new Date( e.happened_at - video.recorded_at ).getTime();
                e.videoTimeNormalized = map( e.videoTime, 0, video.duration * 1000.0, 0, 1 );
                e.videoDurationNormalized = map( e.duration * 1000.0, 0, video.duration * 1000.0, 0, 1 );
                
                if ( e.performers.length == 0 )
                {
                    e.performers[0] = "<none>";
                }
                for ( Object p : e.performers )
                {
                    ArrayList performerList = eventsByPerformer.get(p);
                    if ( performerList == null )
                    {
                        performerList = new ArrayList();
                        eventsByPerformer.put( p, performerList );
                    }
                    performerList.add( e );
                }
            }
            eventPerformers = new ArrayList();
            eventPerformers.addAll( eventsByPerformer.keySet().toArray() );
            Collections.sort( eventPerformers );
            break;
    }
}
