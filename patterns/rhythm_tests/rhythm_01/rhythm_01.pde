RhythmList rhythmList = new RhythmList();
int minNumBeats = 0;
float step = 0;

void setup() {
    
    size(1000,400);
    
    rhythmList.add(new Rhythm("cage",  "6,7,14,14,7"));
    rhythmList.add(new Rhythm("cyc",   "3,3,3,3,3,3"));
    rhythmList.add(new Rhythm("three", "3,4,5,6"));
    rhythmList.add(new Rhythm("fib",   "1,1,2,3,5"));
    
    minNumBeats = rhythmList.getLowestCommonDenominator();
    println("min length " + minNumBeats + " beats");
    
    step = (width-150)/(float)minNumBeats;
    println("step " + step);
    
    noLoop();
}

void draw() {
    
    background(255);
    
    pushMatrix();
    
    translate(75,50);
    
    float x = 0;
    float y = 0;
    
    for (int i=0; i<rhythmList.length(); i++) {
        
        Rhythm rhythm = rhythmList.get(i);
        
        fill(255,0,0);
        text(rhythm.title, -45,y+17);
        
        int numCycles = minNumBeats/rhythm.getNumBeatsTotal();
        println(rhythm.title + " numCycles " + numCycles);
        
        for (int j=0; j<numCycles; j++) {
            
            for (int k=0; k<rhythm.getNumSequences(); k++) {
                
                float l = rhythm.getSequence(k) * step;
                
                pushMatrix();
                translate(x,y);
                
                noStroke();
                if(k == 0) fill(0);
                else fill(150);
                rect(0,0,1, 25);
                popMatrix();
                
                x += l;
            }
        }
        
        pushMatrix();
        translate(x,y);
            
        noStroke();
        fill(0);
        rect(0,0,1, 25);
        popMatrix();
        
        x = 0;
        y += 30;
    }
    
    popMatrix();
    
}
