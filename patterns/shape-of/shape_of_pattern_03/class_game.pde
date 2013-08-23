class PatternGame
{
    int bpm;
    float bpms;
    long lastTs = -1;

    boolean[][] board;

    PatternTrack[] tracks;

    PatternGame () 
    {
        reset();
    }

    void reset () 
    {
        bpm = int( 80 + random(100) );
        bpms = (60 * 1000.0) / bpm;

        tracks = new PatternTrack[5];

        tracks[0] = new PatternTrack( new boolean[] { 
            true, false
        } 
        );
        tracks[1] = new PatternTrack( new boolean[] { 
            true, false, false
        } 
        );
        tracks[2] = new PatternTrack( new boolean[] { 
            true, false, false, false
        } 
        );
        tracks[3] = new PatternTrack( new boolean[] { 
            true, false, false, true, false
        } 
        );
        tracks[4] = new PatternTrack( new boolean[] { 
            true, false, false, false, false, false, false, 
            true, false, false, false, false, false, 
            true, false, false, false, false, false, false, false, false, false, false, false, false, false, 
            true, false, false, false, false, false, false, false, false, false, false, false, false, false, 
            true, false, false, false, false, false, false
        } 
        );

        board = new boolean[tracks.length][25];

        lastTs = new Date().getTime();
    }

    void tick ()
    {
        long nowTs = new Date().getTime();
        if ( nowTs - lastTs >= bpms ) 
        {
            lastTs = nowTs;

            for ( int i = 0; i < tracks.length; i++ ) 
            {
                PatternTrack pt = tracks[i];
                pt.step();

                boolean[] tmp = new boolean[ board[i].length ];
                System.arraycopy( board[i], 1, tmp, 0, board[i].length-1 );
                tmp[tmp.length-1] = pt.now();
                board[i] = tmp;
            }
        }
    }

    void draw ( float x, float y, float w, float h )
    {
        fill( 100 );
        noStroke();
        rect( x, y, w, h );

        float cellHeight = h / board.length;
        float cellWidth = w / board[0].length;

        for ( int i = 0; i < board.length; i++ ) {
            for ( int n = 0; n < board[i].length; n++ ) {
                if ( board[i][n] ) {
                    fill( 255 );
                    stroke( 0 );
                    rect( x + n * cellWidth, y + i * cellHeight, cellWidth, cellHeight );
                }
            }
        }
    }
}

class PatternTrack
{
    boolean[] pattern;
    int current = 0;

    PatternTrack ( boolean[] patt )
    {
        pattern = patt;
    }

    void step ()
    {
        current++;
        current %= pattern.length;
    }

    boolean now ()
    {
        return pattern[current];
    }
}

