
void cube ( float s )
{
    pushMatrix();
    scale( s );

    beginShape(QUADS);

    vertex(-1, 1, 1);
    vertex( 1, 1, 1);
    vertex( 1, -1, 1);
    vertex(-1, -1, 1);

    vertex( 1, 1, 1);
    vertex( 1, 1, -1);
    vertex( 1, -1, -1);
    vertex( 1, -1, 1);

    vertex( 1, 1, -1);
    vertex(-1, 1, -1);
    vertex(-1, -1, -1);
    vertex( 1, -1, -1);

    vertex(-1, 1, -1);
    vertex(-1, 1, 1);
    vertex(-1, -1, 1);
    vertex(-1, -1, -1);

    vertex(-1, 1, -1);
    vertex( 1, 1, -1);
    vertex( 1, 1, 1);
    vertex(-1, 1, 1);

    vertex(-1, -1, -1);
    vertex( 1, -1, -1);
    vertex( 1, -1, 1);
    vertex(-1, -1, 1);

    endShape();

    popMatrix();
}

void rekt ( float x, float y, float w, float h )
{
    beginShape();
        vertex( x, y );
        vertex( x+w, y );
        vertex( x+w, y+h );
        vertex( x, y+h );
    endShape( CLOSE );
}

void circle ( float x, float y, float radius )
{
    pushMatrix();
    translate( x, y );
    beginShape();
        for ( int i = 0, a = 0; i < 360; i += 12 )
        {   
            a = radians( i );
            vertex( cos(a) * radius, sin(a) * radius );
        }
    endShape(CLOSE);
    popMatrix();
}
