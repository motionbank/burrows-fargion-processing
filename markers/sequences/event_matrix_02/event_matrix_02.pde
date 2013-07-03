
import de.bezier.guido.*;

boolean sliderPressed = false;
boolean showDuration = false;

Object video, selectedEvent;

ArrayList events;
HashMap performers;

ArrayList filterPerformers = new ArrayList(), filterType = new ArrayList(), 
          filterUser = new ArrayList(), filterTitle = new ArrayList();

float playHead;
MultiSlider slider;

void setup ()
{
    size( getSketchWidth(), getSketchHeight() );
    
    Interactive.make( this );
    slider = new MultiSlider( 25, height-15, width-30, 10 );
    Interactive.add( slider );
    Interactive.setActive( slider, false );
}

void draw ()
{
    background( 255 );
    
    if ( events != null )
    {
        float h = height / (performers.size() - filterPerformers.size());
        
        strokeWeight( 1 );
        stroke( 120 );
        line( 15, 0, 15, height );
        
        stroke( 0, 255, 0 );
        float px = map( playHead, slider.getValue(slider.LEFT), slider.getValue(slider.RIGHT), 20, width );
        if ( px > 20 )
        {
            line( px, 0, px, height );
        }
        
        int i = 0;
        String keys = performers.keySet().toArray();
        Arrays.sort( keys );

        for ( String k : keys )
        {
            Performer p = performers.get(k);
            
            if ( filterPerformers.indexOf(p.name) != -1 ) continue;
            
            pushMatrix();
            fill( 0 );
            textAlign( RIGHT );
            translate( 10, i*h );
            rotate( -HALF_PI );
            text( p.name, -3, 0 );
            popMatrix();
            
            if ( i > 0 )
            {
                strokeWeight( 1 );
                stroke( 120 );
                line( 0, i*h, width, i*h );
            }
            
            String[] eventKeys = p.eventsByTitle.keySet().toArray();
            String[] eventKeysFiltered = new String[0];
            
            for ( String eKey : eventKeys )
            {
                if ( filterTitle.indexOf(eKey) == -1 )
                    eventKeysFiltered.push( eKey );
            }
            Arrays.sort( eventKeysFiltered );

            float hh = h / eventKeysFiltered.length;
            int ii = 0;
            float yy;
            
            for ( String eKey : eventKeysFiltered )
            {
                yy = i*h + ii*hh;
                
                if ( ii > 0 )
                {
                    strokeWeight( 1 );
                    stroke( 170 );
                    line( 15, yy, width, yy );
                }
                fill( 170 );
                textAlign( LEFT );
                text( eKey, 18, yy+12 );
                
                ArrayList pEvents = p.eventsByTitle.get(eKey);
                for ( Event e : pEvents )
                {
                    drawEvent( e, yy, hh, e == selectedEvent );
                }
                
                ii++;
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

void drawEvent ( Object e, int yy, float h, boolean selected )
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
            rect( x, yy, w, h );
        }
        
        strokeWeight( 1 );
        stroke( 0 );
        
        if ( selected )
        {
            strokeWeight( 2 );
            stroke( 200, 50, 50 );
        }
        
        line( x, yy, x, yy+h );
    }
}
