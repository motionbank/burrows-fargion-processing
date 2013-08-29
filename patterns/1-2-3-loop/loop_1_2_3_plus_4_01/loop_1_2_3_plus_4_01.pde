import de.bezier.math.combinatorics.*;

Permutation perm;

int[] permRow;
int permVal = 0;

float[][] shape;

int shapeDim = 4;
float[][] shapeVertices;

Permutation shapePerm;
int[] shapePermRow;

float[] pos;
int edgeSize = 20;

float xMin = Float.MAX_VALUE, xMax = Float.MIN_VALUE, 
      yMin = Float.MAX_VALUE, yMax = Float.MIN_VALUE;

void setup () 
{
    size( 700, 700, JAVA2D );
    
    shapeVertices = new float[shapeDim][0];
    for ( float i = 0, k = TWO_PI / shapeDim, a = 0; i < shapeDim; i++ )
    {
        a = -HALF_PI + (i * k);
        shapeVertices[(int)i] = new float[]{
            cos( a ), sin( a )
        };
    }
    
    pos = new float[]{ width/2, height/2 };
    
    background( 255 );
    fill( 0 );
    
    perm = new Permutation( shapeDim );
    shapePerm = new Permutation( shapeDim );
    shapePermRow = shapePerm.next();
    shape = new float[0][0];
    
    frameRate( 1 );
}

void draw ()
{
    if ( permVal == shapeDim || permRow == null )
    {
        if ( perm.hasMore() )
        {
            permRow = perm.next();
            permVal = 0;
            // move on once per block
            if ( shape.length > 0 )
            {
                pos = shape[shape.length-1];
                float[] next = shapeVertices[permRow[permVal]];
                pos = new float[]{ pos[0] - next[0]*edgeSize, pos[1] - next[1]*edgeSize };
                permVal++;
            }
        }
        else
        {
            perm.rewind();
            
            if ( !shapePerm.hasMore() )
            {
                println( "done" );
                noLoop();
            }
            else
            {
                println( "next" );
                shapePermRow = shapePerm.next();
            }

            return;
        }
    }
    
    float[] next = shapeVertices[ shapePermRow[ permRow[permVal] ] ];
    //next = shapeVertices[ permRow[permVal] ];
    next = new float[]{ pos[0] + next[0]*edgeSize, pos[1] + next[1]*edgeSize };
    permVal++;
    
    xMin = min( xMin, next[0] );
    xMax = max( xMax, next[0] );
    yMin = min( yMin, next[1] );
    yMax = max( yMax, next[1] );
    float xScale = 1;
    float yScale = 1;
    
    if ( xMin != xMax && yMin != yMax ) {
       xScale = width / (xMax - xMin);
       yScale = height / (yMax - yMin);
    }
    
    shape = (float[][])append( shape, next );
    
//    pos = next;
    
    background( 255 );
    
    stroke( 0 );
    noFill();
    
    pushMatrix();
    
    scale( min(xScale, yScale) * 0.5 );
    translate( -xMin, -yMin );
    
    beginShape();
    for ( float[] p : shape )
    {
        vertex( p[0], p[1] );
    }
    endShape();
    
    stroke( 255, 0, 0 );
    ellipse( next[0], next[1], 5, 5 );
    
    popMatrix();
}
