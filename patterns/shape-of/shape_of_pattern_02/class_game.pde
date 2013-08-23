class PatternGame
{
    int bpm;
    float bpms;
    long lastTs = -1;
    
    PatternTrack[] tracks;
    
    PatternGame () 
    {
        reset();
    }
    
    void reset () 
    {
        bpm = int( 80 + random(100) );
        bpms = (60 * 1000.0) / bpm;
        
        tracks = new PatternTrack[5];
        
        tracks[0] = new PatternTrack( new boolean[]{ 1,0 } );
        tracks[1] = new PatternTrack( new boolean[]{ 1,0,0 } );
        tracks[2] = new PatternTrack( new boolean[]{ 1,0,0,0 } );
        tracks[3] = new PatternTrack( new boolean[]{ 1,0,0,1,0 } );
        tracks[4] = new PatternTrack( new boolean[]{ 1,0,0,0,0,0,0,
                                                     1,0,0,0,0,0,
                                                     1,0,0,0,0,0,0,0,0,0,0,0,0,0,
                                                     1,0,0,0,0,0,0,0,0,0,0,0,0,0,
                                                     1,0,0,0,0,0,0 } );
        
        lastTs = new Date().getTime();
    }
    
    void tick ()
    {
        long nowTs = new Date().getTime();
        if ( nowTs - lastTs >= bpms ) 
        {
            lastTs = nowTs;
            
            for ( PatternTrack pt : tracks ) 
            {
                pt.step();
            }
        }
    }
    
    void draw ( float x, float y, float w, float h )
    {
        fill( 100 );
        noStroke();
        rect( x, y, w, h );
        
        float trackHeight = h / tracks.length;
        for ( int i = 0; i < tracks.length; i++ ) {
            if ( tracks[i].now() ) {
                fill( 255 );
                rect( x, y + i * trackHeight, w, trackHeight );
            }
        }
    }
}

class PatternTrack
{
    boolean[] pattern;
    int current = 0;
    
    PatternTrack ( boolean[] patt )
    {
        pattern = patt;
    }
    
    void step ()
    {
        current++;
        current %= pattern.length;
    }
    
    boolean now ()
    {
        return pattern[current];
    }
}
