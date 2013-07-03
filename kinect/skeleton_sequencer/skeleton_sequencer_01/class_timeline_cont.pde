
class TimelineInterface implements TimelineListener
{
    float oneFrame = 1000.0 / 30;  // kinect data has 30 fps
    long lastTime = 0;
    
    boolean doLoop = true;
    int frame = 0;
    int totalFrames = 0;
    
    TimelineItem[] items;
    TimelineItem currentItem = null;
    
    float x, y, width, height;
    
    TimelineInterface ( float xx, float yy, float ww, float hh ) 
    {
        x = xx;
        y = yy;
        width = ww;
        height = hh;
        
        lastTime = millis();
        items = new TimelineItem[0];
    }
    
    void reset ()
    {
        lastTime = millis();
        items = new TimelineItem[0];
        totalFrames = 0;
    }

    void check ( long t )
    {
        if ( Math.abs(t - lastTime) >= oneFrame )
        {
            step( 1 );
            lastTime = t;
        }
    }
    
    void step ( int d )
    {
        frame += d;
        
        if ( frame >= totalFrames )
        {
            if ( doLoop )
            {
                frame = 0;
            }
        }
        
        if ( currentItem == null || !currentItem.timeInside(frame) )
        {
            for ( int i = 0, k = items.length; i < k; i++ )
            {
                if ( items[i].timeInside(frame) )
                {
                    currentItem = items[i];
                    break;
                }
            }
        }
        
        if ( currentItem != null )
        {
            currentItem.timeStep(frame);
        }
    }
    
    void draw ()
    {
        for ( int i = 0, k = items.length; i < k; i++ )
        {
            noStroke();
            
            fill( 100 );
            if ( currentItem != null && items[i] == currentItem )
            {
                fill( 130 );
            }
            
            items[i].draw();
        }
        
        stroke( 0 );
        float wf = (frame / totalFrames) * width;
        line( x+wf, y, x+wf, y+height );
    }
    
    void appendItem ( String kk, String kt, int ks, int ke )
    {
        TimelineItem item = new TimelineItem( totalFrames, totalFrames+(ke-ks), kk, kt, ks, ke );
        items.push( item );
        totalFrames += ke-ks;
        updateItemDimensions();
    }
    
    void updateItemDimensions ()
    {
        for ( int i = 0, k = items.length; i < k; i++ )
        {
            float wi = (items[i].frameStart / totalFrames) * width;
            items[i].setDimensions( x + wi, y, ((items[i].frameEnd / totalFrames) * width) - wi - 1, height );
        }
    }
}

class TimelineItem
{
    int frameStart;
    int frameEnd;
    
    String title;
    
    String kinectKey;
    int kinectStart, kinectEnd;
    
    float x, y, width, height;
    
    TimelineItem ( int s, int e, String kk, String kt, int ks, int ke )
    {
        frameStart = s;
        frameEnd = e;
        title = kt;
        
        kinectKey = kk;
        kinectStart = ks;
        kinectEnd = ke;
    }
    
    void setDimensions ( float xx, float yy, float ww, float hh )
    {
        x = xx;
        y = yy;
        width = ww;
        height = hh;
    }
    
    void timeInside ( int frame )
    {
        return frame >= frameStart && frame <= frameEnd;
    }
    
    void timeStep ( int frame )
    {
        kinectDataKey = kinectKey;
        kinectDataFrame = kinectStart + (frame - frameStart);
    }
    
    void draw ()
    {
        rekt( x, y, width, height );
    }
}
