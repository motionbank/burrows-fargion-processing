
import org.piecemaker.api.*;
import de.bezier.guido.*;

PieceMakerApi pm;
boolean onLocalhost = false, sliderPressed = false;
boolean showDuration = false;

Object video, selectedEvent;
ArrayList events, eventPerformers;
HashMap eventsByPerformer;

float playHead;
MultiSlider slider;

void setup ()
{
    size( 1200, 200 );
    
    Interactive.make( this );
    slider = new MultiSlider( 25, height-15, width-30, 10 );
    Interactive.add( slider );
    Interactive.setActive( slider, false );
}

void draw ()
{
    background( 255 );
    
    if ( video != null )
    {
        if ( events != null )
        {
            drawThereIsMoreGradient();
            
            int performers = eventsByPerformer.size();
            float h = height / performers;
            
            strokeWeight( 1 );
            stroke( 170 );
            line( 15, 0, 15, height );
            
            stroke( 0, 255, 0 );
            float px = map( playHead, slider.getValue(slider.LEFT), slider.getValue(slider.RIGHT), 20, width );
            if ( px > 20 )
                line( px, 0, px, height );
            
//            if ( selectedEvent != null )
//                drawEvent( selectedEvent, 0, h, true );
            
            int i = 0;
            for ( String key : eventPerformers )
            {
                ArrayList eventList = eventsByPerformer.get(key);
                
                pushMatrix();
                fill( 0 );
                textAlign( RIGHT );
                translate( 10, i*h );
                rotate( -HALF_PI );
                text( key, -3, 0 );
                popMatrix();
                
                if ( i > 0 )
                {
                    strokeWeight( 1 );
                    stroke( 170 );
                    line( 0, i*h, width, i*h );
                }
                
                for ( Object e : eventList )
                {
                    drawEvent( e, i, h, e == selectedEvent );
                }
                
                i++;
            } // iterator
        }
        else
        {
            fill( 0 );
            textAlign( CENTER );
            text( "Loading events ...", width/2, height/2 );
        }
    }
    else
    {
        fill( 0 );
        textAlign( CENTER );
        text( "( Select a video to start loading events ... )", width/2, height/2 );
    }
}

void drawEvent ( Object e, int i, float h, boolean selected )
{
    if ( e.videoTimeNormalized >= slider.getValue( slider.LEFT ) &&
         e.videoTimeNormalized <= slider.getValue( slider.RIGHT ) )
    {
        float x = map( e.videoTimeNormalized, slider.getValue(slider.LEFT), slider.getValue(slider.RIGHT), 20, width );
        float w = map( e.videoTimeNormalized + e.videoDurationNormalized, slider.getValue(slider.LEFT), slider.getValue(slider.RIGHT), 20, width ) - x;
        
        if ( showDuration )
        {
            fill( 0, 30 );
            noStroke();
            rect( x, i*h, w, h );
        }
        
        strokeWeight( 1 );
        stroke( 0 );
        
        if ( selected )
        {
            strokeWeight( 2 );
            stroke( 200, 50, 50 );
//            for ( int n = 0; n < 10; n++ )
//            {
//                stroke( 200 + (n*(55/10)) );
//                line( x+n, i*h, x+n, i*h+h );
//                line( x-n, i*h, x-n, i*h+h );
//            }
        }
        
        line( x, i*h, x, i*h+h );
    }
}

void drawThereIsMoreGradient ()
{
    if ( slider.getValue(slider.LEFT) > 0 )
    {
        for ( int i = 0; i < 10; i++ )
        {
            stroke( 200 + (i*(55/10)) );
            line( 15+i, 0, 15+i, height );
        }
    }
    if ( slider.getValue(slider.RIGHT) < 1 )
    {
        for ( int i = 0; i < 10; i++ )
        {
            stroke( 200 + (i*(55/10)) );
            line( width-i, 0, width-i, height );
        }
    }
}
