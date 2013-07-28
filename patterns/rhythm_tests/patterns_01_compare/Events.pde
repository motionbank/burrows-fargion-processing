void keyPressed() 
{
    if ( key != CODED )
    {
        switch ( key ) {
        case 's':
            saveFrame("output/" + timestamp() + ".png");
            break;
            
        case 'x':
            saveData();
            break;
            
        case 'l':
            
            break;
            
        case 'g':

            break;
            
        case ' ':
//            if (stop) loop();
//            else noLoop();
            stop = !stop;
            break;
            
        case 'a':

        }
    } 
    else {
        switch ( keyCode )
        {
        case UP:
            
            break;
        case DOWN:
            
            break;
        default:
            println( "Key pressed, code: " + keyCode );
        }
    }
}

String timestamp() {
    return String.format("%1$ty%1$tm%1$td_%1$tH%1$tM%1$tS", Calendar.getInstance());
}

String getTitle(float[] _ar) {
    String st = "";
    for( int i=0; i<_ar.length; i++) {
        st += "_" + int(_ar[i]);
    }
    return st;
}
