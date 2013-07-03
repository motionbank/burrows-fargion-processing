
public class MultiSlider
{
    float x, y, width, height;
    float pressedX, pressedLeftX, pressedRightX;
    boolean on = false;
    
    SliderHandle left, right, activeHandle;
    int LEFT = 0, RIGHT = 1, CENTER = 2;
    
    float values[];
    
    MultiSlider ( float xx, float yy, float ww, float hh )
    {
        this.x = xx; this.y = yy; this.width = ww; this.height = hh;
        
        left  = new SliderHandle( x, y, height, height );
        right = new SliderHandle( x+width-height, y, height, height );
        
        values = new float[]{ 0, 1 };
    }
    
    void reset ()
    {
        setValue( 0, 0 );
        setValue( 1, 1 );
    }
    
    void setValue ( int which, float val )
    {
        val = val < 0 ? 0 : val;
        val = val > 1 ? 1 : val;
        
        if ( which >= 0 && which < values.length )
        {
            values[which] = val;
        }
        if ( which == 0 )
        {
            left.x  = map( val, 0, 1, x, x+width-left.width );
        } 
        else if ( which == 1 )
        {
            right.x = map( val, 0, 1, x, x+width-right.width );
        }
        else
        {
            float c = values[0] + (values[1] - values[0]) / 2;
            float d = val - c;
            
            float v1 = getValue(0)+d;
            float v2 = getValue(1)+d;
            if ( v1 >= 0 && v1 < v2 && v2 <= 1 )
            {
                setValue( 0, v1 );
                setValue( 1, v2 );
            }
        }
    }
    
    float getValue ( int which )
    {
        if ( which >= 0 && which < values.length )
        {
            return values[which];
        }
        else
        {
            return values[0] + ( values[1] - values[0] ) / 2;
        }
    }
    
    void mouseEntered ()
    {
        on = true;
    }
    
    void mouseExited ()
    {
        on = false;
    }
    
    void mousePressed ( float mx, float my )
    {
        if ( left.isInside( mx, my ) ) 
            activeHandle = left;
        else if ( right.isInside( mx, my ) ) 
            activeHandle = right;
        else if ( Interactive.insideRect( x, y, width, height, mx, my ) )
        {
            activeHandle = this;
            pressedX = mx;
            pressedLeftX  = left.x;
            pressedRightX = right.x;
        }
    }
    
    void mouseDragged ( float mx, float my )
    {
        if ( activeHandle == null ) return;
        
        float vx = mx - activeHandle.width/2;
        vx = constrain( vx, x, x+width-activeHandle.width );
        
        if ( activeHandle == left )
        {
            if ( vx > right.x - activeHandle.width ) 
                vx = right.x - activeHandle.width;
            values[0] = map( vx, x, x+width-activeHandle.width, 0, 1 );
            activeHandle.x = vx;
        }
        else if ( activeHandle == right )
        {
            if ( vx < left.x + activeHandle.width ) 
                vx = left.x + activeHandle.width;
            values[1] = map( vx, x, x+width-activeHandle.width, 0, 1 );
            activeHandle.x = vx;
        }
        else
        {
            float xd = mx - pressedX;
            if ( pressedLeftX + xd > x && pressedRightX + right.width + xd < x + width ) 
            {
                left.x  = pressedLeftX  + xd;
                right.x = pressedRightX + xd;
                values[0] = map( left.x,  x, x+width-left.width,  0, 1 );
                values[1] = map( right.x, x, x+width-right.width, 0, 1 );
            }
        }
    }
    
    void draw ()
    {
        rectMode( CORNER );
        noStroke();
        fill( 120 );
        rect( x, y, width, height );
        fill( on ? 200 : 150 );
        rect( left.x, left.y, right.x-left.x+right.width, right.height );
    }
    
    public boolean isInside ( float mx, float my )
    {
        return left.isInside(mx,my) || right.isInside(mx,my) || Interactive.insideRect( x, y, width, height, mx, my );
    }
}

class SliderHandle
{
    float x,y,width,height;
    
    SliderHandle ( float xx, float yy, float ww, float hh )
    {
        this.x = xx; this.y = yy; this.width = ww; this.height = hh;
    }
    
    void draw ()
    {
        rectMode( CORNER );
        rect( x, y, width, height );
    }
    
    public boolean isInside ( float mx, float my )
    {
        return Interactive.insideRect( x, y, width, height, mx, my );
    }
}
