
class Drawings
{
    ArrayList frames;
    
    Drawings () {
        frames = new ArrayList();
    }
    
    void addFrame ( DrawingFrame frame )
    {        
        frames.add( frame );
        Collections.sort( frames, new Comparator(){
            public int compare ( DrawingFrame a, DrawingFrame b ) {
                return a.seconds < b.seconds ? -1 : ( a.seconds > b.seconds ? 1 : 0 );
            }
        });
    }
    
    DrawingFrame getFrameAt ( float secs )
    {
        for ( DrawingFrame d : frames )
        {
            if ( d.seconds == secs ) return d;
        }
        return null;
    }
    
    DrawingFrame newFrameAt ( float secs )
    {
        DrawingFrame d = new DrawingFrame( secs );
        addFrame( d );
        
        return d;
    }
}

class DrawingFrame
{
    ArrayList segments;
    DrawingSegment segment;
    
    float seconds;
    
    DrawingFrame ( float ms ) 
    {    
        seconds = ms;
        segments = new ArrayList();
    }
    
    void addSegment ( )
    {
        segment = new DrawingSegment();
        segments.add( segment );
    }
    
    void add ( float xx, float yy )
    {
        segment.add( xx, yy );
    }
    
    void draw ()
    {
        for ( DrawingSegment s : segments )
        {
            s.draw();
        }
    }
}

class DrawingSegment
{
    ArrayList points;
    
    DrawingSegment ()
    {
        points = new ArrayList();
    }
    
    void add ( int xx, int yy )
    {
        points.add( obj( "x", xx, "y", yy ) );
    }
    
    void draw ()
    {
        beginShape();
        for ( Object p : points )
        {
            vertex( p.x, p.y );
        }
        endShape();
    }
}
