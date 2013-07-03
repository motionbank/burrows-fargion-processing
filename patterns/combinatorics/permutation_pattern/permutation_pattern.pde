import de.bezier.math.combinatorics.*;

void setup () 
{
    colorMode( HSB );
    
    int s = 160;
    int b = 200;
    int g = 20;
    int t = 5;
    
    color colors[] = new color[t];
    for ( int i = 0; i < colors.length; i++ )
    {
        colors[i] = color( (255/t)*i, s, b );
    }
    
    Permutation permutation = new Permutation( colors.length );
    
    size( g*colors.length, g*permutation.totalAsInt() );
    noStroke();
    
    int r = 0;
    while ( permutation.hasMore() )
    {
        int[] p = permutation.next();
        for ( int j = 0; j < p.length; j++ )
        {
            fill( colors[p[j]] );
            rect( j*g, r*g, g, g );
        }
        r++;
    }
    
    saveFrame( "permutation_"+colors.length+"_"+permutation.totalAsInt()+".png" );
}
