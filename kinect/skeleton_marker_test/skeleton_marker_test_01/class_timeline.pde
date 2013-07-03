class Timeline
{
    long currentTime;
    long offset = 0;
    ArrayList<TimelineListener> listeners;
    
    boolean running = true, hasSelection = false;
    int selectionFrom, selectionTo;
    
    void run ()
    {
        running = true;
    }
    
    void stop ()
    {
        running = false;
    }
    
    void addListener ( TimelineListener l )
    {
        if ( listeners == null ) listeners = new ArrayList();
        listeners.add( l );
    }
    
    void update ()
    {
        if ( !running ) return;
        
        currentTime = millis() + offset;
        
        if ( hasSelection )
        {
            if ( currentTime <= selectionFrom || currentTime >= selectionTo ) return;
        }
        
        trigger();
    }
    
    void trigger ()
    {
        if ( listeners != null )
        {
            for ( TimelineListener l : listeners )
            {
                l.check( currentTime );
            }
        }
    }
    
    void goto ( int ts )
    {
        offset = ts-millis();
        update();
    }
    
    void select ( int from, int to )
    {
        selectionFrom = from;
        selectionTo = to;
        hasSelection = true;
    }
    
    void deselect ()
    {
        hasSelection = false;
    }
}

class TimelineListener
{
    void check ( long t ) {
    }
}

class TimelineListenerFPS
{
    long timeStart;
    long currentFrame = 0;
    long duration;
    Object handler;
    
    TimelineListenerFPS ( long ts, int fps, String func )
    {
        timeStart = ts;
        duration = 1000/fps;
        handler = eval( func );
    }
    
    void check ( long t )
    {
        int f = Math.floor( Math.abs(t - timeStart) / duration );
        if ( f != currentFrame )
        {
            currentFrame = f;
            handler( currentFrame );
        }
    }
}
