
// basic timeline, handles listeners and updates

class Timeline
{
    long currentTime;
    long offset = 0;
    ArrayList<TimelineListener> listeners;
    
    boolean running = true;
    
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
    
    void removeListener ( TimelineListener l )
    {
        if ( listeners != null && listeners.size() > 0 )
        {
            listeners.remove( l );
        }
    }
    
    void update ()
    {
        if ( !running ) return;
        
        currentTime = millis() + offset;
      
        if ( listeners != null )
        {
            for ( TimelineListener l : listeners )
            {
                l.check( currentTime );
            }
        }
    }
}

// base class to inherit from

interface TimelineListener
{
    void check ( long t );
}

// a listener with an undestanding of frames per second,
// only triggers on new frames

class TimelineListenerFPS implements TimelineListener
{
    long timeStart;
    long currentFrame = 0;
    long oneFrame;
    Object handler;
    
    TimelineListenerFPS ( long ts, int fps, String func )
    {
        timeStart = ts;
        oneFrame = 1000/fps;
        handler = eval( func );
    }
    
    void check ( long t )
    {
        int f = Math.floor( Math.abs(t - timeStart) / oneFrame );
        if ( f != currentFrame )
        {
            currentFrame = f;
            handler( currentFrame );
        }
    }
}
