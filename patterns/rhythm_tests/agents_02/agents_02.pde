import java.util.Map.Entry;

import java.util.*;
import java.io.*;


// 1,1,2,3,5,8,13,21

AgentList agentList = new AgentList();
float[] fib     = {1,2,3,5,8,13};
float[] cage    = {6,7,14,14,7};
float[] cyc     = {1,2,3};
float[] rdm     = {3,5,7,11,13};
float[] rdm2    = {11,2,3,4,8,15,1};
float[] rdm3    = {1,2,3,4,5,6,7,8,9};

float[] sp = rdm;

float base = 0.0005;

float gridStep = 10;

boolean showAgents = true;

void setup() {

    size(800,800);
//    agentList.add(new Agent(base));
//    agentList.add(new Agent(base));
//    agentList.add(new Agent(base*2));
//    agentList.add(new Agent(base*3));
//    agentList.add(new Agent(base*5));
//    agentList.add(new Agent(base*8));
//    agentList.add(new Agent(base*13));
//    agentList.add(new Agent(base*21));
//    agentList.add(new Agent(base*34));

    for (int i=0; i<sp.length; i++) {
        agentList.add( new Agent(base * sp[i]) );
    }
    
//    for (int i=0; i<20; i++) {
//        agentList.add( new Agent(random(0.02)) );
//    }
}

void update() {
    
    agentList.update();
}

void draw() {
    
    update();
    
    pushMatrix();
//    translate(0, height);
//    rotate(-PI/2);
    
    
    background(255);
    
    // circle grid
    for( int i=1; i<40; i++) {
        stroke(230);
        strokeWeight(1);
        noFill();
        ellipse(width/2,height/2,i*gridStep*2,i*gridStep*2);
    }
    
    agentList.draw();
    
    popMatrix();
}
