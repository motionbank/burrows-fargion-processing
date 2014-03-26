/**
 *    2012-09-19 18:15:04 - fjenett
 */

import de.bezier.guido.*;

App app;
Object kinectData;

KinectRenderer drawer = new KinectRenderer();
String kinectDataKey;
int kinectDataStart, kinectDataEnd, kinectDataFrame;
TimelineListener kinectDataListener;

TimelineInterface tInterface;
Timeline timeline;

boolean loaded = false;
TimelineListener loadingAniListener;
String loadingStatusMsg = "Loading ...";
int loadingFrame = 0;

float rotY = HALF_PI/2;

void setup ()
{
    size( getCanvasWidth(), getCanvasHeight(), P3D );

    //Interactive.make( this );

    timeline = new Timeline();
    
    loadingAniListener = new TimelineListenerFPS(0, 5, "loadingAnimation");
    timeline.addListener( loadingAniListener );
    
    tInterface = new TimelineInterface( 10, 10, width-20, 10 );
    timeline.addListener( tInterface );
    
    //textFont( createFont( "Arial", 20 ) );
    
    background( 255 );
}

void draw ()
{
    background( 255 );
    
    if ( !loaded )
    {
        drawLoading();
    }
    else
    {
        drawKinectData();
    
        tInterface.draw( 10, 10, width-20, 10 );
    }
    
    timeline.update();
}

void drawLoading ()
{
    noStroke();
    
    pushMatrix();
    translate( width/2, height/2 );
    
    fill( 0 );
    textAlign( CENTER );
    text( loadingStatusMsg, 0, 45 );
    
    rotateZ( radians(loadingFrame * 10) ); // see loadingAnimation()
    for ( int i = 0; i < 360; i+=20 )
    {
        float v = i/360.0;
        
        fill( 255 - (v * 255) );
        pushMatrix();
        rotateZ( radians(i) );
        translate( 20, 20 );
        beginShape();
        vertex( -2.5, -2.5 );
        vertex(  2.5, -2.5 );
        vertex(  2.5,  2.5 );
        vertex( -2.5,  2.5 );
        endShape();
        popMatrix();
    }
    popMatrix();
}

void drawKinectData ()
{
    background( 50 );

    if ( kinectDataKey != null )
    {
        pushMatrix();
        fill( 255 );
        noStroke();
        translate( width/2, height/2, 0 );
        pushMatrix();
        rotateX( PI );
        rotateY( -rotY );
        scale( 200 );
        int[] hipcenter = drawer.getHipCenter( kinectData[kinectDataKey][100] );
        translate( -hipcenter[0], -hipcenter[1], -hipcenter[2] );
        drawer.draw( kinectData[kinectDataKey][kinectDataFrame] );
        popMatrix();
        popMatrix();
    }
    else
    {
        fill( 255 );
        textAlign( CENTER );
        text( "Drag one of the poses below into this window", width/2, height/2 );
    }
    
    if ( inDragDrop )
    {
        stroke( 255 );
        noFill();
        circle( dragX, dragY, 40 );
    }
    
    text( " ", -10, -20 );
}

