public class RhythmList {
    
    ArrayList<Rhythm> rhythms = new ArrayList<Rhythm>();
    
    RhythmList () {
        
    }
    
    void add( Rhythm r) {
        this.rhythms.add( r );
    }
    
    Rhythm get(int _i) {
        return this.rhythms.get(_i);
    }
    
    int length() {
        return rhythms.size();
    }
    
    int getLowestCommonDenominator() {
        
        int sl = 0;
        float maxLength = 1;
        
        for (int i=0; i<rhythms.size(); i++) {
            maxLength *= rhythms.get(i).getNumBeatsTotal();
        }
        
        for (int i=0; i<maxLength; i++) {
            int isZero = 0;
            sl++;
            
            for ( int j=0; j<rhythms.size(); j++) {
                float v = sl % (float) rhythms.get(j).getNumBeatsTotal();
                println(v);
                if ( v == 0 ) isZero++;
            }
            
            if (isZero == rhythms.size()) break;
        }
        
        return sl;
    }
}

public class Rhythm {
    
    String title = "";
    int[] sequences;
    int numBeatsTotal = 0;
    //int numSequences = 0;
    
    Rhythm (String _title, String _seq) {
        title = _title;
        
        String[] s = _seq.split(",");
        
        sequences = new int[s.length];
        
        for (int i=0; i<s.length; i++) {
            sequences[i] = parseInt(s[i]);
        }
        
    }
    
    int getSequence(int _i) {
        return sequences[_i];
    }
    
    int getNumBeatsTotal() {
        if (numBeatsTotal == 0) {
            for (int i=0; i<sequences.length; i++) {
                numBeatsTotal += sequences[i];
            }
        }
        return this.numBeatsTotal;
    }
    
    int getNumSequences() {
        return this.sequences.length;
    }
    
    
}
