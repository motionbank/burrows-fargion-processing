import processing.opengl.*;

NuiSkeletonData skeleton;

void setup ()
{
    size( 500, 500, P3D );
    
    String[] lines = loadStrings("2012_07_19 ExportedSkeletonData.txt");
    String[] linesClean = new String[lines.length];
    int linesTotal = 0;
    for ( String l : lines )
    {
        if ( l.indexOf('#') == -1 ) 
        {
            linesClean[linesTotal] = l;
            linesTotal++;
        }
    }
    skeleton = new NuiSkeletonData(0,linesTotal);
    for ( int i = 0; i < linesTotal; i++ )
    {
        skeleton.addFrame( linesClean[i] );
    }
    skeleton.currentFrame = 0;
}

void draw ()
{
    background( 0 );
    fill( 255 );
    noStroke();
    translate( width/2, height/2, 0 );
    pushMatrix();
    rotateX( PI );
    rotateY( -HALF_PI/2 );
    scale( 200 );
    translate( -skeleton.hipCenter().x, -skeleton.hipCenter().y, -skeleton.hipCenter().z );
    skeleton.next();
    skeleton.draw();
    popMatrix();
}
