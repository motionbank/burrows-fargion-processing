import processing.opengl.*;
import de.bezier.guido.*;

NuiSkeletonData skeletonJ, skeletonM;

Slider slider;
Button button;
float rotY = 0;
boolean loaded;

void setup ()
{
    size( 500, 500, P3D );
    
    Interactive.make(this);
    button = new Button(0,height-10,10,10);
    slider = new Slider(10,height-10,width-10, 10);
    
    new Thread(){
        public void run () {
            loadSkeletons();
            loaded = true;
        }
    }.start();
    
    frameRate( 30 );
}

void draw ()
{
    background( 0 );
    
    if ( loaded )
    {
        pushMatrix();
        fill( 255 );
        noStroke();
        translate( width/2, height/2, 0 );
        pushMatrix();
        rotateX( PI );
        rotateY( rotY + PI );
        scale( 200 );
        pushMatrix();
        translate( 0.5, 0, 0 );
        translate( -skeletonJ.hipCenter().x, -skeletonJ.hipCenter().y, -skeletonJ.hipCenter().z );
        if ( button.on )
        {
            skeletonJ.next();
            slider.setValue( map(skeletonJ.currentFrame, 0, skeletonJ.frame.length, 0, 1) );
        }
        skeletonJ.draw();
        popMatrix();
        pushMatrix();
        translate( -0.5, 0, 0 );
        translate( -skeletonM.hipCenter().x, -skeletonM.hipCenter().y, -skeletonM.hipCenter().z );
        if ( button.on )
        {
            skeletonM.next();
            slider.setValue( map(skeletonM.currentFrame, 0, skeletonM.frame.length, 0, 1) );
        }
        skeletonM.draw();
        popMatrix();
        popMatrix();
        popMatrix();
    }
    else
    {
        fill( 255 );
        text( "loading", width/2, height/2 );
    }
}

void mouseDragged ()
{
    if ( mouseY < height-10 ) 
    {
        rotY = map( mouseX, 0, width, -HALF_PI/2, HALF_PI/2);
    }
}

void loadSkeletons ()
{
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
    skeletonJ = new NuiSkeletonData(0,linesTotal);
    for ( int i = 0; i < linesTotal; i++ )
    {
        skeletonJ.addFrame( linesClean[i] );
    }
    skeletonJ.currentFrame = 0;
    
    lines = loadStrings("FusedSkeletonData_Unsmoothed_MappedTo30FPS_Matteo.txt");
    linesClean = new String[lines.length];
    linesTotal = 0;
    for ( String l : lines )
    {
        if ( l.indexOf('#') == -1 ) 
        {
            linesClean[linesTotal] = l;
            linesTotal++;
        }
    }
    skeletonM = new NuiSkeletonData(0,linesTotal);
    for ( int i = 0; i < linesTotal; i++ )
    {
        skeletonM.addFrame( linesClean[i] );
    }
    skeletonM.currentFrame = 0;
    
    println( skeletonJ.frame.length + " " + skeletonM.frame.length );
}
