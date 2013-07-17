class PatternGame
{
    int bpm;
    double bpms;
    
    int boardWidth = 25;
    boolean[][] board;
    
    int currentTrack;

    PatternTrack[] tracks;

    PatternGame () 
    {
        reset();
        
        Interactive.on( "event:hit", this, "hit" );
    }

    void reset () 
    {
        bpm = int( 80 + random(100) );
        bpms = (60 * (double)1000.0) / bpm;
        
        long nowTs = new Date().getTime();
        
        tracks = new PatternTrack[5];

        tracks[0] = new PatternTrack( nowTs, new double[] { 
            bpms
        });
        tracks[1] = new PatternTrack( nowTs, new double[] { 
            bpms * 2
        });
        tracks[2] = new PatternTrack( nowTs, new double[] { 
            bpms * 3
        });
        tracks[3] = new PatternTrack( nowTs, new double[] { 
            bpms * 2, bpms * 3, bpms * 4
        });
        tracks[4] = new PatternTrack( nowTs, new double[] { 
            bpms * 7,
            bpms * 6,
            bpms * 14,
            bpms * 14,
            bpms * 7
        });

        board = new boolean[tracks.length][boardWidth];
    }

    void tick ()
    {
        long ts = new Date().getTime();
        
        for ( PatternTrack pt : tracks )
        {
            pt.tick(ts);
        }
    }
    
    void hit ()
    {
        long hitTs = new Date().getTime();
        double hitOffset = tracks[currentTrack].hitOffset( hitTs );
        
        if ( hitOffset < 200 )
        {
            println( "hit " + nf( (float)hitOffset, 3, 2 ) );
        }
        else 
        {
            println( nf( (float)hitOffset, 3, 2 ) );
        }
    }
    
    void trackUp ()
    {
        currentTrack--;
        if ( currentTrack < 0 ) currentTrack = 0;
    }
    
    void trackDown ()
    {
        currentTrack++;
        if ( currentTrack >= tracks.length ) currentTrack = tracks.length-1;
    }

    void draw ( float x, float y, float w, float h )
    {
        fill( 100 );
        noStroke();
        rect( x, y, w, h );
        
        long nowTs = new Date().getTime();
        double from = 0, to = 20*bpms;

        float trackHeight = h / tracks.length;
        
        fill( 100, 80, 80 );
        rect( x, y + currentTrack * trackHeight, w, trackHeight );
        
        for ( int i = 0; i < tracks.length; i++ )
        {
            double[] values = tracks[i].fromTo( nowTs, from, to );
            for ( int v = 0; v < values.length; v++ )
            {
                fill( 255 );
                rect( x + map( (float)values[v], (float)from, (float)to, 0, w ), y + i * trackHeight, 2, trackHeight - 2 );
            }
        }
    }
}

class PatternTrack
{
    long lastTs;
    double head = 0;
    
    double[] pattern;
    int current = 0;

    PatternTrack ( long nowTs, double[] patt )
    {
        pattern = patt;
        lastTs = nowTs;
    }
    
    void tick ( long nowTs )
    {
        if ( nowTs - lastTs >= pattern[current] ) 
        {
            lastTs = nowTs - (long)((nowTs - lastTs) - pattern[current]);
            step();
        }
    }

    void step ()
    {
        if ( current == 0 ) head = 0;
        
        head += pattern[current];
        
        current++;
        current %= pattern.length;
    }
    
    double hitOffset ( long nowTs )
    {
        double hitOffset = nowTs - lastTs;
        if ( hitOffset > pattern[current] / 2 )
        {
            hitOffset = pattern[current] - hitOffset;
        }
        
        return Math.abs(hitOffset);
    }
    
    double[] fromTo ( long nowTs, double from, double to )
    {
        int i = 0;
        double h = head + (nowTs - lastTs);
        double t = -h;
        int d = from >= t ? 1 : -1;
        while ( (t - from) * d < 0 ) 
        {
            t += pattern[i] * d;
            i += d;
            if ( i < 0 ) i = pattern.length-1;
            else if ( i >= pattern.length ) i = 0;
        }
        double[] r = new double[0];
        while ( t < to )
        {
            r = (double[])append( r, t );
            t += pattern[i];
            i++;
            i %= pattern.length;
        }
        return r;
    }
}

