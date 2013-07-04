/**
 * 2012-09-06 17:13:00 - fjenett
 */

import org.piecemaker.api.*;
import de.bezier.guido.*;

PieceMakerApi api;
Video video;
Skeleton matteo;

Event selectedEvent;
ArrayList<Event> matteoEvents;

Timeline timeline;
boolean stopAtNextEvent = false;

boolean onLocalhost = true;
boolean loaded = false;

float rotY = HALF_PI/2;

String kinectDataRoot = "http://motionbank-media.s3.amazonaws.com/jbmf/data/2012-05/kinect";

void setup ()
{
    size( 400, 600, P3D );

    Interactive.make( this );

    timeline = new Timeline();
    
    //textFont( createFont( "Arial", 20 ) );
}

void draw ()
{
    if ( loaded )
    {
        background( 0 );

        pushMatrix();
        fill( 255 );
        noStroke();
        translate( width/2, height/2, 0 );
        pushMatrix();
        rotateX( PI );
        rotateY( -rotY );
        scale( 200 );
        translate( -matteo.pose(100).hipCenter.x, -matteo.pose(100).hipCenter.y, -matteo.pose(100).hipCenter.z );
        matteo.draw();
        popMatrix();
        popMatrix();
        if ( selectedEvent != null )
        {
            fill( 255 );
            text( selectedEvent.title.toUpperCase(), 10, 20 );
        }
    }
    else
    {
        background( 200 );
    }
    
    timeline.update();
}

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

