RhythmList rhythmList = new RhythmList();
int minNumBeats = 0;
float step = 0;

void setup() {
    
    size(1600,600);
    
    rhythmList.add(new Rhythm("cage",  "6,7,14,14,7"));
    rhythmList.add(new Rhythm("cyc",   "3,3,3,3,3,3"));
    rhythmList.add(new Rhythm("three", "3,4,5"));
//    rhythmList.add(new Rhythm("fib",   "1,1,2,3,5,8"));
//    rhythmList.add(new Rhythm("fib",   "1,2,2,1,2,1,1,2"));
    rhythmList.add(new Rhythm("fib",   "12,4"));
    rhythmList.add(new Rhythm("abcde",   "5,7"));
    
    minNumBeats = rhythmList.getLowestCommon();
    println("min length " + minNumBeats + " beats");
    
    step = (width-150)/(float)minNumBeats;
    println("step " + step);
    
    noLoop();
}

void draw() {
    
    int[] accu = new int[minNumBeats+1];
    
    background(255);
    
    pushMatrix();
    
    translate(75,50);
    
    float x = 0;
    float y = 0;
    float h = 25.0;
    
    for (int i=0; i<minNumBeats+1; i++) {
        
        stroke(240);
        if (i%4 == 0) stroke(220);
        line(i*step,0,i*step,height-100);
    }
    
    for (int i=0; i<rhythmList.length(); i++) {
        
        Rhythm rhythm = rhythmList.get(i);
        
        fill(255,0,0);
        text(rhythm.title, -45,y+17);
        
        int numCycles = minNumBeats/rhythm.getNumBeatsTotal();
        println(rhythm.title + " numCycles " + numCycles);
        
        curveTightness(1);
        beginShape();
        
        curveVertex(x-0.5*step,y+h);

        
//        curveVertex(x-1*step,y+h/2);
        
        for (int j=0; j<numCycles; j++) {
            
            for (int k=0; k<rhythm.getNumSequences(); k++) {
                
                float l = rhythm.getSequence(k) * step;
                
                accu[ round(x/step) ] ++;
                       
                noStroke();
                if(k == 0) fill(0);
                else fill(150);
                rect(x,y,1, h);
                
                stroke(255,0,0,80);
                noFill();
                
                //curve(x1, y1, x2, y2, x3, y3, x4, y4)
                
                curveVertex(x-0.5*step,y+h);

                curveVertex(x,y);

                curveVertex(x+0.5*step,y+h);
                
//                curveVertex(x-1*step,y+h/2);
//                curveVertex(x,y);
//                curveVertex(x+1*step,y+h/2);
                
                x += l;
            }
        }
        
        curveVertex(x-0.5*step,y+h);


        curveVertex(x+0.5*step,y+h);

//        curveVertex(x-1*step,y+h/2);
//        curveVertex(x,y);
//        curveVertex(x+1*step,y+h/2);
        
        curveVertex(x+0.5*step,y+h);
//        curveVertex(x+1*step,y+h/2);
        
        endShape();
            
        noStroke();
        fill(0);
        rect(x,y,1, h);
        
        x = 0;
        y += 60;
    }
    
    accu[accu.length-1] += rhythmList.length();
    
    println(accu);
    
    int[] adjs = new int[accu.length];
    
    for (int i=0; i<accu.length; i++) {
        
        if ( accu[i] > 0) {
            int adj = 0;
            if ( i>0 )             adj += accu[i-1];
    //        if ( i>1 )             adj += accu[i-2];
            if ( i<accu.length-1 ) adj += accu[i+1];
    //        if ( i<accu.length-2 ) adj += accu[i+2];
            adjs[i] = adj;
        }
    }
    
    x = 0;
    y += 60;
    
    int max = rhythmList.length();
    int v = max - accu[0];
    
    
    pushMatrix();
    
    translate(0,y + max * h);
    
    stroke(0);
    line(0,0,width-150,0);
    
    
    
    beginShape();
    
    curveTightness(1);
    
    
    v = accu[0];
    
    curveVertex(0,0);
    curveVertex(0,0);
    
    curveVertex(0,-v*h);

    for (int i=0; i<accu.length; i++) {
        
        v = accu[i];
        x = i*step;

        
        if (v > 0 || true) {
            fill(255,0,0);
            stroke(255,0,0,150);
            strokeWeight(1);
            noStroke();

            curveVertex(x,-v*h);

        }
        if (v > 0 && adjs[i] > 0) {
            fill(255 - adjs[i]*50);
            noStroke();
            //ellipse(x,-v*h,20,20);
            
            rect(x-0.5*step,50,step,20);
        }
    }
    
    v = accu[accu.length-1];
    x = (accu.length-1)*step;
    
    curveVertex(x,-v*h);
    curveVertex(x,-v*h);
    
    curveVertex(x,0);
    curveVertex(x,0);
    
    endShape(CLOSE);
    
   blendMode(MULTIPLY);
    
    beginShape();
    
    curveTightness(1);
    
    
    v = adjs[0];
    
    curveVertex(0,0);
    curveVertex(0,0);
    curveVertex(0,-v*h);

    for (int i=0; i<accu.length; i++) {
        
        v = adjs[i];
        x = i*step;

        
        if (v > 0 || true) {
            fill(0,0,255,30);
            strokeWeight(1);
            stroke(0,0,255,150);
            noStroke();
            curveVertex(x,-v*h);

        }
    }
    
    v = adjs[adjs.length-1];
    x = (adjs.length-1)*step;
    
    curveVertex(x,-v*h);
    curveVertex(x,-v*h);
    
    endShape(CLOSE);
     
    
    popMatrix();
    
    popMatrix();
    
}
