void initSequences ()
{
    File seqDir = new File( KINECT_DATA_ROOT );
    if ( seqDir.isDirectory() && seqDir.canRead() )
    {
        File[] files = seqDir.listFiles(new java.io.FilenameFilter(){
            public boolean accept ( File f, String fn ) {
                return fn.contains("-JB-") && fn.endsWith(".txt");
            }
        });
        
        ArrayList _seqs = new ArrayList();
        
        for ( File seqFile : files )
        {
            String[] lines = loadStrings( seqFile.getAbsolutePath() );
            for ( int i = 3; i < lines.length; i++ )
            {
                if ( lines[i].indexOf( "," ) == -1 )
                {
                    String line = lines[i];
                    String[] values = line.split("[\\s]+");
                    int[] valuesInt = int( values );
                    Sequence s = new Sequence( seqFile.getAbsolutePath(), valuesInt );
                    println( s.getLength() );
                    _seqs.add( s );
                }
            }
        }
        
        sequences = java.util.Collections.unmodifiableList( _seqs );
    }
    else
    {
        System.err.println( KINECT_DATA_ROOT + " is not a dir or not readable!" );
        System.exit(-1);
    }
}

void initHelperValues ()
{
    seqHeight = (height - 20.0) / sequences.size();
    
    seqMaxLength = -1;
    seqMaxFrameLengths = new float[ sequences.get(0).getFrames().length-1 ];
    
    for ( Sequence s : sequences ) 
    {
        seqMaxLength = max( seqMaxLength, s.getLength() );
        int[] seqFrames = s.getFrames();
        
        for ( int i = 0; i < seqFrames.length-1; i++ )
        {
            seqMaxFrameLengths[i] = max( seqMaxFrameLengths[i], seqFrames[i+1]-seqFrames[i] );
        }
    }
    
    for ( float f : seqMaxFrameLengths )
    {
        seqMaxFrameLengthsTotal += f;
    }
    
//    for ( String s : PFont.list() )
//    {
//        if ( s.contains( "Open" ) )
//        {
//            println(s);
//        }
//    }
    
    textFont( createFont( "OpenSans-Light", 12 ) );
}
