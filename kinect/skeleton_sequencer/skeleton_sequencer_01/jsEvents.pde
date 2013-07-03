
void setApp ( App a )
{
    app = a;
}

void setData ( Object d )
{
    kinectData = d;
    
    kinectDataListener = new TimelineListenerFPS(0,30,"kinectDataAnimation");
    timeline.addListener( kinectDataListener );
    
    loaded = true;
}

void setLoadingStatus ( String msg )
{
    loadingStatusMsg = msg;
}

