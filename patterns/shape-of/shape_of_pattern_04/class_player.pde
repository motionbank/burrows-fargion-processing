class Player
implements PatternTrack
{
    long[] hitTimes;
    
    Player ( )
    {
        hitTimes = new long[0];
        
        Interactive.on( "key-hit", this, "checkHit" );
    }
    
    void checkHit ()
    {
        long hitTs = new Date().getTime();
        
        hitTimes = (long[])append( hitTimes, hitTs );
    }
    
    double[] patternBetween ( long from, long to )
    {
        double[] r = new double[0];
        
        for ( long l : hitTimes ) 
        {
            if ( l >= from && l <= to ) r = (double[])append( r, l );
        }
        
        return r;
    }
}
