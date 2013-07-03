import processing.opengl.*;
import de.bezier.guido.*;

NuiSkeletonData skeleton;

Slider slider;
Button button;
float rotY = 0;

void setup ()
{
    size( 500, 500, P3D );
    
    Interactive.make(this);
    button = new Button(0,height-10,10,10);
    slider = new Slider(10,height-10,width-10, 10);
    
    String[] lines = loadStrings("FusedSkeletonData_Unsmoothed_MappedTo30FPS_Jonathan.txt");
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
    
    frameRate( 30 );
}

void draw ()
{
    background( 0 );
    
    pushMatrix();
    fill( 255 );
    noStroke();
    translate( width/2, height/2, 0 );
    pushMatrix();
    rotateX( PI );
    rotateY( PI-rotY );
    scale( 200 );
    translate( -skeleton.hipCenter().x, -skeleton.hipCenter().y, -skeleton.hipCenter().z );
    if ( button.on )
    {
        skeleton.next();
        slider.setValue( map(skeleton.currentFrame, 0, skeleton.frame.length, 0, 1) );
    }
    skeleton.draw();
    popMatrix();
    popMatrix();
}

void mouseDragged ()
{
    if ( mouseY < height-10 ) 
    {
        rotY = map( mouseX, 0, width, -HALF_PI/2, HALF_PI/2);
    }
}
