class BeatShape
{
    int shapeBeats = 1; // takes that much beats to complete
    int partsPerBeat = 3; // three is a triangle
    float beatsPerMillis = (80.0 / 60.0) * 1000;
    
    float [][] xy;
    
    long timeStamp = 0;
    int verticesToDraw = 0;
    
    BeatShape ( int sb, int ppb, float bpm )
    {
        shapeBeats = sb;
        partsPerBeat = ppb;
        beatsPerMillis = (bpm / 60.0) * 1000.0;
        
        float angle = TWO_PI / ppb;
        float sa = 0;
        xy = new float[sb * (ppb+1)][0];
        for ( int i = 0; i < xy.length; i++ )
        {
            xy[i] = new float[]{ cos( sa ), sin( sa ) };
            sa += angle;
        }
    }
    
    void tick ()
    {
        if ( (new Date().getTime()) - timeStamp > beatsPerMillis )
        {
            timeStamp = (new Date().getTime());
            
            trigger();
        }
    }
    
    void trigger ()
    {
        verticesToDraw++;
        verticesToDraw %= xy.length;
        if ( verticesToDraw == 0 ) 
        {
            verticesToDraw = 1;
        }
        
        Interactive.send( this, "tick:next" );
        
        if ( verticesToDraw == xy.length-1 )
        {
            Interactive.send( this, "tick:done" );
        }
    }
    
    void draw ()
    {
        beginShape();
        for ( int i = 0; i < (verticesToDraw+1) && i < xy.length; i++ )
        {
            vertex( xy[i][0] * 100, xy[i][1] * 100 );
        }
        endShape();
    }
    
    void drawFull ()
    {
        beginShape();
        for ( int i = 0; i < xy.length; i++ )
        {
            vertex( xy[i][0] * 100, xy[i][1] * 100 );
        }
        endShape();
    }
    
    void reset ()
    {
        verticesToDraw = 0;
        timeStamp = (new Date().getTime());
    }
}
