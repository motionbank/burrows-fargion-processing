class Sequence
{
    private int[] frames;
    private int length;
    private String filePath;
    
    Sequence ( String _filePath, int[] _frames )
    {
        if ( _frames != null )
        {
            frames = new int[ _frames.length ];
            System.arraycopy( _frames, 0, frames, 0, frames.length );
            
            int[] framesSorted = getFrames();
            java.util.Arrays.sort( framesSorted );
            length = framesSorted[frames.length-1] - framesSorted[0];
        }
    }
    
    String getFilePath ()
    {
        return filePath;
    }
    
    int[] getFrames ()
    {
        return java.util.Arrays.copyOf( frames, frames.length );
    }
    
    int getLength ()
    {
        return length;
    }
}
