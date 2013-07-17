class AgentList {
    
    ArrayList<Agent> agents = new ArrayList<Agent>();
    ArrayList<LineSegment> lines = new ArrayList<LineSegment>();
    
    boolean afterFirstRound = false;
    float[] anglePairs;
    
    
    
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
        anglePairs = new float[numPairs];
        
        for( int i=0; i<anglePairs.length; i++) {
            anglePairs[i] = PI*4;
        }
    }
    
    void update() {
        
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
                    
                    float lastAngle = anglePairs[idx];
                    float newAngle = a0.rotation - a1.rotation;
                    
                    // check if the agends passed each other
                    if ( lastAngle != PI*4 && abs(newAngle) < PI/300 ) {
                        
                        if (lastAngle > 0 && newAngle < 0 || lastAngle < 0 && newAngle > 0 ){
                            lines.add( new LineSegment( a0.position, a1.position ) );
                            a0.triggerIntersection();
                            a1.triggerIntersection();
                        }
                    }
                    
                    anglePairs[idx] = newAngle;
                    idx++;
                }
            }
        }
        
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
        
        // agent connections
//        for( int i=0; i<agents.size()-1; i++) {
//            Agent a0 = agents.get(i);
//            
//            for( int j=i+1; j<agents.size(); j++) {
//                Agent a1 = agents.get(j);
//                
//                stroke(0,150);
//                strokeWeight(1);
//                line(a0.position.x, a0.position.y, a1.position.x, a1.position.y);
//            }
//        }
        
        if (showAgents) {
            for( int i=0; i<agents.size(); i++) {
                
                if (i<agents.size()-1) {
                    Agent a0 = agents.get(i);
                    Agent a1 = agents.get(i+1);
                    stroke(0,150);
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
    PVector center = new PVector(width/2,height/2);
    float speed = 0.01;
    float rotation = 0;
    float distance = gridStep;
    float inc = gridStep;
    color fillColor = 0;
    boolean hasIntersection = false;
    
    int activeFrames = 5;
    int activeTimer  = 0;
    
    int completeCycles = 0;
    
    Agent( float _speed ) {
        this.speed = _speed;
    }
    
    void update() {
        
        hasIntersection = false;
        
        rotation += speed;
        float x = cos(rotation-PI/2) * distance + center.x;
        float y = sin(rotation-PI/2) * distance + center.y;
        position.set(x,y);
        
        if ( rotation > TWO_PI ) {
            
            completeCycles++;
            //this.distance = (completeCycles + 1)*inc;
            rotation -= TWO_PI;
            println("cycle" + completeCycles + " " + distance);
        }
        
        if (activeTimer > 0) {
            activeTimer--;
        }
        
    }
    
    void triggerIntersection() {
        this.hasIntersection = true;
        activeTimer = activeFrames;
        completeCycles++;
        this.distance = (completeCycles + 1)*inc;
    }
    
    void draw() {
        
        pushMatrix();
        
        translate(position.x, position.y);
        rotate(rotation-PI/2);
        
        noFill();
        stroke(0,30);
        if (activeTimer > 0) stroke(255,0,0);
        line(0,0,width,0);
        
        fill(fillColor);
        if (activeTimer > 0) fill(255,0,0);
        noStroke();
        ellipse(0,0,gridStep/2,gridStep/2);
        
        popMatrix();
    }
}
