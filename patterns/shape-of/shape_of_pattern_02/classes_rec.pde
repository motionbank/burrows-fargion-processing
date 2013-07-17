class BeatRecorderShape
extends BeatShape
{
    int fired = 0;
    
    float [][] xy2;
    
    BeatRecorderShape ( int sb, int ppb, float bpm )
    {
        super( sb, ppb, bpm );
        
        xy2 = new float[xy.length][2];
        
        for ( int i = 0; i < xy.length; i++ )
        {
            xy2[i] = new float[]{
                xy[i][0], xy[i][1]
            };
        }
        
        timeStamp = (new Date().getTime());
    }
    
    void tick ()
    {
    }
    
    void pressed ()
    {
        float hit = int( (new Date().getTime()) - timeStamp );
        hit = hit / beatsPerMillis;
        
        //println( "You are off by", nf((1-hit)*100,3,2), beatsPerMillis );
        
        timeStamp = (new Date().getTime());
        
        trigger();
        
        if ( verticesToDraw > 0 )
        {
            xy2[verticesToDraw][0] = xy2[verticesToDraw-1][0] + hit * (xy[verticesToDraw][0] - xy2[verticesToDraw-1][0]);
            xy2[verticesToDraw][1] = xy2[verticesToDraw-1][1] + hit * (xy[verticesToDraw][1] - xy2[verticesToDraw-1][1]);
        }
    }
    
    void draw ()
    {
//        stroke( 50, 0, 0 );
//        
//        beginShape();
//        for ( int i = 0; i < (verticesToDraw+1) && i < xy.length; i++ )
//        {
//            vertex( xy[i][0] * 100, xy[i][1] * 100 );
//        }
//        endShape();
        
        stroke( 255, 0, 0 );
        
        beginShape();
        for ( int i = 0; i < (verticesToDraw+1) && i < xy2.length; i++ )
        {
            vertex( xy2[i][0] * 100, xy2[i][1] * 100 );
        }
        endShape();
        
        stroke( 100, 0, 0 );
        
        beginShape();
        for ( int i = verticesToDraw+1; i < xy2.length; i++ )
        {
            vertex( xy2[i][0] * 100, xy2[i][1] * 100 );
        }
        endShape();
    }
    
    void reset ()
    {
        super.reset();
        
        xy2 = new float[xy.length][2];
        
        for ( int i = 0; i < xy.length; i++ )
        {
            xy2[i] = new float[]{
                xy[i][0], xy[i][1]
            };
        }
    }
}
