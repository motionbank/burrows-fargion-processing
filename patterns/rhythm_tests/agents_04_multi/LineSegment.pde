class LineGroup {
    
    ArrayList<LineSegment> lineSegments = new ArrayList<LineSegment>();
    int frames = 0;
    
    
    LineGroup ( int _frames ) {
        this.frames = _frames;
    }
    
    void add( LineSegment _ls ) {
        this.lineSegments.add( _ls );
    }
    
    int size() {
       return lineSegments.size(); 
    }
    
    LineSegment get(int _i) {
        return lineSegments.get(_i);
    }
    
    float getAvgLength () {
        
        float l = 0;
        for (int i=0; i<this.lineSegments.size(); i++) {
            LineSegment ls0 = this.lineSegments.get(i);
            l += ls0.length;
        }
        return l/this.lineSegments.size();
    }
    
    LineSegment getStart() {
        
        LineSegment ls = this.lineSegments.get(0);
        
        for (int i=1; i<this.lineSegments.size(); i++) {
            LineSegment ls0 = this.lineSegments.get(i);
            
            if ( ls0.startDist < ls.startDist ) ls = ls0;
        }
        return ls;
    }
    
    float getMaxLength () {
        
        float l = lineSegments.get(0).length ;
        
        for (int i=1; i<this.lineSegments.size(); i++) {
            LineSegment ls0 = this.lineSegments.get(i);
            
            if ( ls0.length > l ) l = ls0.length;
        }
        return l;
    }
    
//    LineSegment getEnd() {
//        
//    }
    
    void draw() {
        
        //println(this.lineSegments.size());
        
        LineSegment sls = getStart();
        
        pushMatrix();
        translate(w/2,h);
        
        
       for (int i=0; i<this.lineSegments.size(); i++) { 
           
           LineSegment ls = this.lineSegments.get(i);
           
            float x0 = map(this.frames, 0, framesGlobal, 0, w/3) + abs(ls.startDist - sls.startDist);
            //println(ls.startDist - sls.startDist);
            float x1 = x0 + abs(ls.endDist - ls.startDist);
            
            float y = -sls.startDist;// - this.getAvgLength() / 2;
            
            if (drawStrokes) {
                noFill();
                stroke(255,0,0,60);
                strokeWeight(2);
                line(x0, y, x1, y);
            }  
            fill(255,0,0,30);
            noStroke();
            ellipse(x0, y, eRad,eRad);
            ellipse(x1, y, eRad,eRad);
       }
        popMatrix();
    }
}


class LineSegment {
    
    PVector start = new PVector();
    PVector end = new PVector();
    float startDist = 0;
    float endDist = 0;
    float length = 0;
    int frames = 0;
    float speed0 = 0;
    float speed1 = 0;
    
    LineSegment(float x0, float y0, float x1, float y1, int _frames) {
        start = new PVector(x0,y0);
        end = new PVector(x1,y1);
        this.frames = _frames;
        this.init();
    }
    
    LineSegment(Agent a0, Agent a1, int _frames) {
        PVector p0 = a0.position;
        PVector p1 = a1.position;
        
        speed0 = a0.currentSpeed();
        speed1 = a1.currentSpeed();
        
        if ( p0.dist(center) < p1.dist(center) ) {
            start = new PVector(p0.x, p0.y);
            end = new PVector(p1.x, p1.y);
        }
        else {
            start = new PVector(p1.x, p1.y);
            end = new PVector(p0.x, p0.y);
        }
        this.frames = _frames;
        this.init();
    }
    
    void init() {
        this.endDist = center.dist(end);
        this.startDist = center.dist(start);
        this.length = start.dist(end);
    }
    
    void draw() {
        if (drawStrokes) {
            noFill();
            stroke(255,0,0,60);
            strokeWeight(2);
            line(start.x, start.y, end.x, end.y);
        }
        fill(255,0,0,30);
        noStroke();
        ellipse(start.x, start.y, eRad,eRad);
        ellipse(end.x, end.y, eRad,eRad);
        
        pushMatrix();
        translate(w/2,h);
        
//            float x = map(this.frames, 0, framesGlobal, 0, w/2);
//            float y0 = -this.startDist;
//            float y1 = -this.endDist;
//            
//            noFill();
//            stroke(255,0,0,60);
//            strokeWeight(2);
//            line(x, y0, x, y1);
//       
//            fill(255,0,0,30);
//            noStroke();
//            ellipse(x, y0, gridStep/2,gridStep/2);
//            ellipse(x, y1, gridStep/2,gridStep/2);     
           
           
//            float x0 = map(this.frames, 0, framesGlobal, 0, w/3);
//            float x1 = x0 + abs(this.endDist - this.startDist);
//            
//            float y = -this.startDist;
//            
//            noFill();
//            stroke(255,0,0,60);
//            strokeWeight(2);
//            line(x0, y, x1, y);
//       
//            fill(255,0,0,30);
//            noStroke();
//            ellipse(x0, y, gridStep/2,gridStep/2);
//            ellipse(x1, y, gridStep/2,gridStep/2);  
        
        popMatrix();
        
        pushMatrix();
        translate(w/2,h/2);
        
//            float x = map(this.frames, 0, framesGlobal, 0, w/2);
//            float y0 = -this.startDist;
//            float y1 = -this.endDist;
//            
//            noFill();
//            stroke(255,0,0,60);
//            strokeWeight(2);
//            line(x, y0, x, y1);
//       
//            fill(255,0,0,30);
//            noStroke();
//            ellipse(x, y0, gridStep/2,gridStep/2);
//            ellipse(x, y1, gridStep/2,gridStep/2);     
           
           

            
//            noFill();
//            stroke(255,0,0,60);
//            strokeWeight(2);
//            line(x0, y, x1, y);
       


//            fill(255,0,0,30);
//            noStroke();
//            ellipse(x0, y, gridStep/2,gridStep/2);
//            ellipse(x1, y, gridStep/2,gridStep/2);
            
            
            float x = map(this.frames, 0, framesGlobal, 0, w/3);
            float y0 = -this.startDist;
            float y1 = -this.endDist;
            
            if (drawStrokes) {
                noFill();
                stroke(255,0,0,60);
                strokeWeight(2);
                line(x, y0, x, y1);
            }
       
            fill(255,0,0,30);
            noStroke();
            ellipse(x, y0, eRad,eRad);
            ellipse(x, y1, eRad,eRad);
        
        popMatrix();
    }
}
