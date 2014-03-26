
boolean inDragDrop = false;
int dragX, dragY;

void dragEnter ()
{
    inDragDrop = true;
}

void dragOver ( int dx, int dy )
{
    dragX = dx;
    dragY = dy;
}

void dragDrop ( Object data, int dx, int dy )
{
//    String[] dataElements = data.split("-");
    
//    kinectDataKey = dataElements[2];
//    kinectDataStart = int(dataElements[3]);
//    kinectDataFrame = kinectDataStart;
//    kinectDataEnd = int(dataElements[4]);

    Object dataElements = getKinectData( data );
    
    tInterface.appendItem( dataElements[0], dataElements[1], dataElements[2], dataElements[3] );
    
    inDragDrop = false;
}

void dragLeave () 
{
    inDragDrop = false;
}

void mouseDragged ()
{
    if ( !inDragDrop && mouseY < height-10 ) 
    {
        rotY -= (pmouseX-mouseX) * radians(0.75);
    }
}

void keyPressed ()
{
    switch ( key )
    {
        case 'r':
            tInterface.reset();
            break;
    }
}
