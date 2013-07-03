/**
 *    Motion Bank research, http://motionbank.org/
 *
 *    Comparing the timings inside of one pattern in "Both Sitting Duet".
 *
 *    Processing 2.0.x
 *    fjenett 20130703
 */

import java.util.*;

final static int KINECT_FPS = 30;
final static String KINECT_DATA_ROOT = "/Users/fjenett/Desktop/documents-export-2013-07-03/";

List<Sequence> sequences;

float seqHeight, seqMaxLength, seqMaxFrameLengthsTotal;
float[] seqMaxFrameLengths;
int viewMode = 1;

void setup ()
{
    size( 800, 800 );
    
    initSequences();
    initHelperValues();
}

void draw ()
{
    background( 60 );
    
    if ( viewMode == 1 )
    {
        float h = 20;
        
        fill( 255 );
        float vf = map( seqMaxLength, 0, seqMaxFrameLengthsTotal, 0, width-2 );
        text( seqMaxLength * (1/30.0) , vf, 20-5 );
        stroke( 100 );
        line( vf, 20, vf, height-1 );
        
        for ( Sequence s : sequences )
        {
            fill( 255 );
            noStroke();
            
            int[] seqValues = s.getFrames();
            float x = 1;
            
            colorMode( HSB );
            
            for ( int v = 0; v < seqValues.length-1; v++ )
            {
                fill( map( v, 0, seqValues.length-1, 0, 255 ), 150, 230 );
                float w = map( seqValues[v+1]-seqValues[v], 0, seqMaxFrameLengthsTotal, 0, width-2 );
                rect( x, h, w - 1, seqHeight-1 );
                x += w;
            }
            
            colorMode( RGB );
            
            h += seqHeight;
        }
    }
    else if ( viewMode == 2 )
    {
        float h = 20;
        
        float xf = 1, vf = 0;
        fill( 255 );
        for ( float xs : seqMaxFrameLengths )
        {
            vf = (xs * (1/30.0));
            text( vf, xf, 20-5 );
            xf += map( xs, 0, seqMaxFrameLengthsTotal, 0, width-2 );
        }
        
        for ( Sequence s : sequences )
        {
            fill( 255 );
            noStroke();
            
            int[] seqValues = s.getFrames();
            float x = 1;
            
            colorMode( HSB );
            
            for ( int v = 0; v < seqValues.length-1; v++ )
            {
                fill( map( v, 0, seqValues.length-1, 0, 255 ), 150, 230 );
                float w = map( seqValues[v+1]-seqValues[v], 0, seqMaxFrameLengthsTotal, 0, width-2 );
                rect( x, h, w - 1, seqHeight-1 );
                x += map( seqMaxFrameLengths[v], 0, seqMaxFrameLengthsTotal, 0, width-2 );
            }
            
            colorMode( RGB );
            
            h += seqHeight;
        }
    }
}
