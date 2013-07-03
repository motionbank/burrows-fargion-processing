
import org.piecemaker.api.*;
import de.bezier.guido.*;

PieceMakerApi pm;
ArrayList events;
ArrayList jbEvents, mfEvents;
Object video, videoElement, selectedEvent, draggedEvent, selectedEventList;
MultiSlider slider;
PImage videoFrame;
float playHead = 0;
boolean runningLocally = false;
long pressedMillis;

PApplet self;

void setup ()
{
    size( 800, 150 );
    
    self = this;
    
    Interactive.make( this );
    slider = new MultiSlider( 10, height-20, width-20, 10 );
    Interactive.add( slider );
    Interactive.setActive( slider, true );
}

void draw ()
{
    background( 255 );
    
    if ( video != null )
    {
        fill( 0 );
        text( video.title, 10, 20 );
    }
    
    if ( videoElement != null && !videoElement.paused )
    {
        setSliderToPlayhead();
    }
    
    if ( jbEvents != null && mfEvents != null )
    {
        noStroke();
        fill( 0 );
        rectMode( CORNER );

        for ( Object e : jbEvents )
        {
            drawEvent( e, height/2-20, 20 );
        }

        for ( Object e : mfEvents )
        {
            drawEvent( e, height/2, 20 );
        }
        
        drawPlayhead();
        
        stroke( 0 );
        line ( 0, height/2, width, height/2 );
    }
}

void setSliderToPlayhead ()
{
    slider.setValue( 2, playHead );
}

void drawPlayhead () 
{
   if ( playHead >= slider.values[0] && playHead <= slider.values[1] )
   {
       stroke( 255, 0, 0 );
       float x = map( playHead, slider.values[0], slider.values[1], 10, width-10 );
       line( x, height/2-40, x, height/2+40 );
   } 
}

void drawEvent ( Object e, float y, float height )
{
    if ( e.videoTimeNormalized >= slider.values[0] && e.videoTimeNormalized <= slider.values[1] )
    {
        float x = map( e.videoTimeNormalized, slider.values[0], slider.values[1], 10, width-10 );
        float w = max( 2, 5/(slider.values[1]-slider.values[0]) );
        if ( w > 2 )
            drawGradient( x, y, w, 20, color(200), color(255) );
        else
        {
            fill( 200 );
            rect( x, y, w, 20 );
        }
        
        e.selected = e == selectedEvent || 
                     (abs(mouseX - x) < 5 && mouseY > y && mouseY < y+height);
        
        stroke( e.selected ? color(0,0,255) : 0 );
        line( x, y, x, y+height );
        
        fill( e.selected ? color(0,0,255) : 0 );
        text( e.title, x+3, y+height*0.66 );
    }
}

void drawGradient ( float x, float y, float w, float h, color c1, color c2 )
{
    int[] colors = new int[int(ceil(w))];
    float step = 1.0/colors.length;
    float s = 0;
    for ( int i = 0; i < colors.length; i++, s+=step )
    {
        colors[i] = lerpColor( c1, c2, s );
    }
    
    noFill();
    for ( ix = 0; ix < colors.length; ix++ )
    {
        stroke( colors[ix] );
        line( x+ix, y, x+ix, y+h );
    }
}

