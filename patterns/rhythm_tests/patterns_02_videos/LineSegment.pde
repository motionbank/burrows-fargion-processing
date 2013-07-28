class LineGroupList {
    
    ArrayList<LineGroup> groups = new ArrayList<LineGroup>();
    String src = "";
    
    LineGroupList( String _src ) {
        this.src = _src;
    }
    
    void add ( LineGroup _lg ) {
        groups.add( _lg );
    }
    
    void update() {
        
    }
    
    boolean hasFrame( int _f ) {
        boolean b = false;
        
        for (int i=0; i<this.groups.size(); i++ ) {
                
            if (this.groups.get(i).time == _f) {
                b = true;
                println(true);
                break;
            }
        }
        return b;
    }
    
    LineGroup getByFrame( int _f ) {
        LineGroup b = null;
        
        for (int i=0; i<this.groups.size(); i++ ) {
            
            if (this.groups.get(i).time == _f) {
                b = this.groups.get(i);
                break;
            }
        }
        return b;
    }
    
    void draw( float _y ) {
        
        for (int i=0; i<groups.size()-1; i++){
            LineGroup lg = groups.get(i);
            float x = map(lg.time, 0, this.last().time, 0, w);
            fill(255,0,0,200);
            noStroke();
            ellipse(x,_y,lg.intersections*5,lg.intersections*5);
            
            textSize(9);
            
            try {
                pushMatrix();
                translate(x-5,_y+10);
                rotate(PI/2);
                fill(0);
                text(lg.speeds[0] + "/" + lg.speeds[1], 0,0);
                popMatrix();
            } catch(Exception e) {
        
            }
            
        }
        
        fill(0);
        text(this.src, 0, _y-20);

    }
    
    LineGroup last() {
        return groups.get(groups.size()-1);
    }
}

class LineGroup {
    
    int time = 0;
    int length = 0;
    int intersections = 0;
    int height = 0;
    String speedsString = "";
    float[] speeds;
    float speed0 = 0;
    float speed1 = 0;
    
    LineGroup ( int _time, int _length, int _intersections, int _height, String _ss ) {
        this.time = _time;
        this.length = _length;
        this.intersections = _intersections;
        this.height = _height;
        this.speedsString = _ss;
        this.speeds = parseFloat(_ss.split("/"));
        println(time);
    }
    
    
    
    void update(){
       
    } 
    
    void draw() {      

    }
}


//class LineSegment {
//    
//    PVector start = new PVector();
//    PVector end = new PVector();
//    float startDist = 0;
//    float endDist = 0;
//    float length = 0;
//    int frames = 0;
//    
//    LineSegment(float x0, float y0, float x1, float y1, int _frames) {
//        start = new PVector(x0,y0);
//        end = new PVector(x1,y1);
//        this.frames = _frames;
//        this.init();
//    }
//    
//    LineSegment(PVector p0, PVector p1, int _frames) {
//        if ( p0.dist(center) < p1.dist(center) ) {
//            start = new PVector(p0.x, p0.y);
//            end = new PVector(p1.x, p1.y);
//        }
//        else {
//            start = new PVector(p1.x, p1.y);
//            end = new PVector(p0.x, p0.y);
//        }
//        this.frames = _frames;
//        this.init();
//    }
//    
//    void init() {
//        this.endDist = center.dist(end);
//        this.startDist = center.dist(start);
//        this.length = start.dist(end);
//    }
//    
//    void draw() {
//        
//        pushMatrix();
//
//        popMatrix();
//    }
//}
