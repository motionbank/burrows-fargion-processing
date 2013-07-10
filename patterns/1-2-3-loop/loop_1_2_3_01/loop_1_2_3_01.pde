import de.bezier.math.combinatorics.*;

void setup () 
{
    size( 500, 700 );
    
    background( 255 );
    fill( 0 );
    
    char abc[] = new char[]{
        '1', '2', '3'
    };

    Permutation combinations = new Permutation( abc.length );
    
    float h = height / (combinations.totalAsInt()+0.5);
    float y = h * 0.75;
    
    while ( combinations.hasMore() )
    {
        int[] c = combinations.next();
        for ( int i = 0; i < c.length; i++ )
        {
            text( abc[c[i]], 20 + i*24, y );
            if ( i > 0 )
                print( "-" );
            print( abc[c[i]] );
        }
        println(" ");
        y += h;
    }

    noLoop();
}
