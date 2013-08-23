class PatternGame
{
    int bpm;
    double bpms;
    
    boolean nSync = false;
    
    int currentTrack = 0;

    PatternTrack[] tracks;
    Player player;

    PatternGame () 
    {
        bpm = int( 80 + random(100) );
        reset();
    }
    
    void slower ()
    {
        bpm -= 5;
        bpms = (60 * (double)1000.0) / bpm;
    }
    
    void faster ()
    {
        bpm += 5;
        bpms = (60 * (double)1000.0) / bpm;
    }

    void reset () 
    {
        bpms = (60 * (double)1000.0) / bpm;
        
        long nowTs = new Date().getTime();
        
        tracks = new PatternTrack[5];

        tracks[0] = new PatternTrackRepeating( nowTs, new double[] { 
            bpms
        });
        tracks[1] = new PatternTrackRepeating( nowTs, new double[] { 
            bpms * 2
        });
        tracks[2] = new PatternTrackRepeating( nowTs, new double[] { 
            bpms * 3
        });
        tracks[3] = new PatternTrackRepeating( nowTs, new double[] { 
            bpms * 2, bpms * 3, bpms * 4
        });
        tracks[4] = new PatternTrackRepeating( nowTs, new double[] { 
            bpms * 7,
            bpms * 6,
            bpms * 14,
            bpms * 14,
            bpms * 7
        });
        
        player = new Player();
    }

//    void tick ()
//    {
//        long ts = new Date().getTime();
//        
//        for ( PatternTrack pt : tracks )
//        {
//            pt.tick(ts);
//        }
//    }
//    
//    void hit ()
//    {
//        long hitTs = new Date().getTime();
//        double hitOffset = tracks[currentTrack].hitOffset( hitTs );
//        
//        if ( hitOffset < 200 )
//        {
//            println( "hit " + nf( (float)hitOffset, 3, 2 ) );
//        }
//        else 
//        {
//            println( nf( (float)hitOffset, 3, 2 ) );
//        }
//    }
    
    void trackUp ()
    {
        if ( !nSync ) return;
        
        currentTrack--;
        if ( currentTrack < 0 ) currentTrack = 0;
    }
    
    void trackDown ()
    {
        if ( !nSync ) return;
        
        currentTrack++;
        if ( currentTrack >= tracks.length ) currentTrack = tracks.length-1;
    }

    void draw ( float x, float y, float w, float h )
    {
        fill( 100 );
        noStroke();
        rect( x, y, w, h );
        
        long nowTs = new Date().getTime();
        double from = (long)(-20*bpms), to = 0;

        float trackHeight = h / tracks.length;
        
        fill( nSync ? color( 80, 100, 80 ) : color( 100, 80, 80 ) );
        rect( x, y + currentTrack * trackHeight, w, trackHeight );
        
        float th = trackHeight - 2;
        
        double[] currentValues;
        
        for ( int i = 0; i < tracks.length; i++ )
        {
            double[] values = tracks[i].patternBetween( (long)(nowTs + from), (long)(nowTs + to) );
            
            if ( i == currentTrack ) currentValues = values;
            
            if ( values == null ) continue;
            
            for ( int v = 0; v < values.length; v++ )
            {
                if ( tracks[i] == tracks[currentTrack] ) th = trackHeight / 2 - 2;
                else th = trackHeight - 2;
                
                fill( 255 );
                rect( x + map( (float)(values[v] - nowTs), (float)from, (float)to, 0, w ), 
                      y + i * trackHeight, 2, th );
            }
        }
        
        double[] values = player.patternBetween( (long)(nowTs + from), (long)(nowTs + to) );
        th = trackHeight / 2 - 2;
        if ( values != null ) 
        {
            for ( int v = 0; v < values.length; v++ )
            {
                fill( nSync ? color(0, 255, 0) : color(255, 0, 0) );
                rect( x + map( (float)(values[v] - nowTs), (float)from, (float)to, 0, w ), 
                      y + currentTrack * trackHeight + (trackHeight / 2), 2, th );
            }
        }
        
        double totalDiff = -1;
        if ( values.length == currentValues.length ) 
        {
            for ( int v = 0; v < values.length; v++ )
            {
                totalDiff += Math.abs( currentValues[v] - values[v] );
            }        
        }
        nSync = false;
        if ( totalDiff >= 0 && totalDiff < values.length * 200 )
        {
            nSync = true;
        }
    }
}

interface PatternTrack
{
    double[] patternBetween ( long from, long to );
}

class PatternTrackRepeating
implements PatternTrack
{
    long originTime;
    
    boolean repeating = true;
    
    double total = 0;
    double[] pattern;
    int current = 0;

    PatternTrackRepeating ( long orgTs, double[] patt )
    {
        originTime = orgTs;
        pattern = patt;
        for ( double d : pattern ) total += d;
    }
    
//    double hitOffset ( long nowTs )
//    {
//        double hitOffset = nowTs - lastTs;
//        if ( hitOffset > pattern[current] / 2 )
//        {
//            hitOffset = pattern[current] - hitOffset;
//        }
//        
//        return Math.abs(hitOffset);
//    }
    
    double[] patternBetween ( long from, long to )
    {
        if ( pattern == null || pattern.length == 0 ) return null;
        
        long cycles = (long)(Math.floor( (from - originTime) / total ));
        double start = originTime + cycles * total;
        
        //println(String.format( "%s %s %s", (long)(start), from, to ));
        
        int i = 0;
        double[] r = new double[0];
        double next;
        
        while ( start <= to )
        {
            next = start + pattern[i];
            
            if ( next >= from && next <= to ) {
                r = (double[])append(r,next);
            }
            
            start += pattern[i];
            i++;
            i %= pattern.length;
        }
        
        return r;
    }
}

