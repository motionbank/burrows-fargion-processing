class Performer
{
    String name;
    
    ArrayList events;
    HashMap eventsByTitle;
    
    Performer ( String n )
    {
        name = n;
    }
    
    void addEvent ( Event e )
    {
        if ( events == null ) events = new ArrayList();
        events.add( e );
        
        if ( eventsByTitle == null )
        {
            eventsByTitle = new HashMap();
        }
        ArrayList tEvents = eventsByTitle.get( e.title );
        if ( tEvents == null )
        {
            tEvents = new ArrayList();
            eventsByTitle.put( e.title, tEvents );
        }
        tEvents.add( e );
    }
}
