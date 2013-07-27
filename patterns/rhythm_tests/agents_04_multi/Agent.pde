class AgentList {
    
    ArrayList<Agent> agents = new ArrayList<Agent>();
    ArrayList<LineSegment> lines = new ArrayList<LineSegment>();
    ArrayList<LineGroup> groups = new ArrayList<LineGroup>();
    
    boolean afterFirstRound = false;
    double[] anglePairs;
    
    
    
    AgentList() {
        
    }
    
    void add( Agent _a ) {
        agents.add(_a);
        
        int numPairs = 0;
        
        for( int i=0; i<agents.size()-1; i++) {
            
            for( int j=i+1; j<agents.size(); j++) {
                numPairs++;
            }
        }
        anglePairs = new double[numPairs];
        
        for( int i=0; i<anglePairs.length; i++) {
            anglePairs[i] = PI*4;
        }
    }
    
    void update() {
        
        int numInter = 0;
        boolean groupCreated = false;
        LineGroup lg = new LineGroup(framesGlobal);

        for( int i=0; i<agents.size(); i++) {
            agents.get(i).update();
        }
        
        if (afterFirstRound) {
            
            // check if same rotation
            int idx = 0;
            
            for( int i=0; i<agents.size()-1; i++) {
                Agent a0 = agents.get(i);
                
                for( int j=i+1; j<agents.size(); j++) {
                    Agent a1 = agents.get(j);
                    
                    double lastAngle = anglePairs[idx];
                    double newAngle = a0.rotation - a1.rotation;
                    
//                    if (newAngle < 0) newAngle *= -1.0d;
                    
                    // check if the agends passed each other
                    if ( lastAngle != PI*4 && abs( (float) newAngle ) < PI/300 ) {
                        
                        if (lastAngle > 0 && newAngle < 0 || lastAngle < 0 && newAngle > 0 ){
                            
                            if ( !groupCreated ) {
                                groups.add(lg);
                                groupCreated = true;
                            }
                            
                            LineSegment ls = new LineSegment( a0, a1, framesGlobal );
                            
                            lines.add( ls );
                            lg.add( ls );
                            
                            a0.triggerIntersection();
                            a1.triggerIntersection();
                        }
                    }
                    
                    anglePairs[idx] = newAngle;
                    idx++;
                }
            }
            
            
            for( int i=0; i<agents.size(); i++) {
                agents.get(i).checkIntersection( framesGlobal );
            }
        }
        
        boolean finish = true;
        for (int i=0; i<agents.size(); i++) {
            if (!agents.get(i).complete()) finish = false;
        }
        if (finish) stop = true;
        
        
        for( int i=0; i<agents.size(); i++) {
            if (!afterFirstRound && agents.get(i).completeCycles > 0) {
                afterFirstRound = true;
                break;
            }
        }
    }
    
    void draw() {
        
        // same rotation marker
        for( int i=0; i<lines.size(); i++) {
            lines.get(i).draw();
        }
        
        for( int i=0; i<groups.size(); i++) {
            groups.get(i).draw();
        }
        
        if (showAgents) {
            for( int i=0; i<agents.size(); i++) {
                
                if (i<agents.size()-1) {
                    Agent a0 = agents.get(i);
                    Agent a1 = agents.get(i+1);
                    stroke(0,150);
                    //stroke(0,2);
                    strokeWeight(1);
                    line(a0.position.x, a0.position.y, a1.position.x, a1.position.y);
                }
            }
            
            // draw agents
            for( int i=0; i<agents.size(); i++) {
                agents.get(i).draw();
            }
        }
    }
}


class Agent {
    
    PVector position = new PVector(0,0);
    ArrayList<PVector> timeline = new ArrayList<PVector>();
    float[] speed;
    int speedIdx = -1;
    int rounds = 0;
    double rotation = 0;
    float distance = gridStep;
    float inc = gridStep;
    color fillColor = 0;
    boolean hasIntersection = false;
    
    int activeFrames = 5;
    int activeTimer  = 0;
    
    int completeCycles = 0;
    int level = 1;
    
    Agent( float _base, float[] _speed ) {
        
        this.speed = new float[_speed.length];
        for (int i=0; i<speed.length; i++) {
            speed[i] = _base * _speed[i];
            this.rounds += _speed[i];
        }
        this.rounds = 200;
    }
    
    boolean update() {
        
        speedIdx++;
        speedIdx %= speed.length;
        
        hasIntersection = false;
        boolean comp = false;
        
        rotation += speed[speedIdx];
        position = calculatePosition();
        
        if ( rotation > TWO_PI ) {
            
            completeCycles++;
            //this.distance = (completeCycles + 1)*inc;
            rotation -= TWO_PI;
            //println("cycle" + completeCycles + " " + distance);
            comp = true;
            println(completeCycles);
        }
        
        if (activeTimer > 0) {
            activeTimer--;
        }
        
        
        
        return comp;
    }
    
    float currentSpeed() {
        return speed[speedIdx] / base;
    }
    
    void triggerIntersection() {
        this.hasIntersection = true;
        activeTimer = activeFrames;
        level++;
    }
    
    void checkIntersection( int _frames ) {
       if (this.hasIntersection) {
           timeline.add( new PVector( _frames, center.dist(this.position) ) );
           this.distance = (level)*inc;
           this.position = calculatePosition();
           
       } 
    }
    
    PVector calculatePosition() {
        float x = cos((float) rotation-PI/2) * distance + center.x;
        float y = sin((float) rotation-PI/2) * distance + center.y;
        return new PVector(x,y);
    }
    
    boolean complete() {
        boolean t = false;
        if (this.completeCycles >= this.rounds) t = true;
        return t;
    }
    
    void draw() {
        
        pushMatrix();
        
        translate(position.x, position.y);
        rotate((float) rotation-PI/2);
        
        noFill();
        stroke(0,30);
        if (activeTimer > 0 && !stop) stroke(255,0,0);
        line(-this.distance+gridStep,0,gridStep*gridRes-gridStep - this.distance,0);
        
        fill(fillColor);
        if (activeTimer > 0 && !stop) fill(255,0,0);
        noStroke();
        ellipse(0,0,gridStep/2,gridStep/2);
        
        popMatrix();
        
        pushMatrix();
        translate(w/2,h/2);
        
                // agent timeline
            
            beginShape();
            
            stroke(0,100);
            strokeWeight(1);
            noFill();
            
            for( int i=0; i<this.timeline.size(); i++) {
                PVector p = this.timeline.get(i);
                float x = map(p.x, 0, framesGlobal, 0, w/3);
                float y = -p.y;
                vertex(x,y);
            }
            
            endShape();
        
        popMatrix();
    }
}
