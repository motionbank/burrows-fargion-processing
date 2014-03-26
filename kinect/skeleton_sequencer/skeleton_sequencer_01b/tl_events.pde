
void loadingAnimation ( int frame )
{
    loadingFrame = frame % 36;
}

void kinectDataAnimation ( int frame )
{
    if ( kinectDataKey != null )
    {
        if ( kinectDataFrame >= kinectDataStart && kinectDataFrame <= kinectDataEnd )
        {
            kinectDataFrame++;
        }
    }
}
