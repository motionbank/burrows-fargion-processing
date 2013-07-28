import java.util.Map.Entry;

import java.util.*;
import java.io.*;


// 1,1,2,3,5,8,13,21

AgentList agentList = new AgentList();
float[] fib     = {1,2,3,5,8,13};
float[] cage    = {6,7,14,14,7};
float[] cyc     = {1,2,3};
float[] rdm     = {2,3,5,7,11,13};
float[] rdm2    = {1,2,23};
float[] rdm3    = {1,2,3,4,5,6,7,8,9};
float[] rdm4    = {1, 2, 3, 7, 111};

float[][] rtm0 = { {1,2,3}, {1,3,2}, {2,3,1}, {2,1,3}, {3,1,2}, {3,2,1} };
float[][] rtm1 = { {1,2,3, 1,3,2, 2,3,1, 2,1,3, 3,1,2, 3,2,1}, {6,7,14,14,7} };
float[][] rtm2 = { {1,2,3, 1,3,2, 2,3,1, 2,1,3, 3,1,2, 3,2,1}, {1,2,2,1, 2,1,1,2} };

float[][] sp = rtm2;

float base = 0.00005;

float gridStep = 8;
float gridRes = 0;

boolean showAgents = true;
boolean stop = false;
boolean drawStrokes = true;
boolean drawGrid = true;

float eRad = gridStep*0.8;

float w = 1600;
float h = 800;

int framesGlobal = 0;

PVector center = new PVector(w/4,h/2);

void setup() {
    
    size(1600+40,800+40);
    base = 0.02;
    //frameRate(120);

    for (int i=0; i<sp.length; i++) {
        agentList.add( new Agent(base, sp[i]) );
    }
    
    gridRes = floor(h/2 / gridStep);
    
    new Thread() {
        public void run () {
            while (true) {
                if (!stop) update();
            }
        }
    }.start();
}


void update() {
    
    agentList.update();
    
    framesGlobal++;
}


void draw() {
    
    //if (!stop) update();
    
    pushMatrix();
    translate(20,20);
//    translate(0, height);
//    rotate(-PI/2);
    
    
    background(255);
    
    if (drawGrid) {
    
        // circle grid
        for( int i=1; i<gridRes; i++) {
            stroke(230);
            strokeWeight(1);
            noFill();
            ellipse(w/4, h/2, i*gridStep*2, i*gridStep*2);
        }
        
        for( int i=1; i<gridRes*2; i++) {
            stroke(230);
            strokeWeight(1);
            noFill();
            float y = h-i*gridStep;
            line(w/2,y, w, y);
        }
    }
    
    agentList.draw();
    
    popMatrix();
    
    
    String st = "";
    
    for (int i=0; i<sp.length; i++) {
        st += sp[i] + "  ";
    }
    
    fill(0);
    text(st,20,20);
}

void saveData() {
//   String[] st = new String[agentList.groups.size()];
//   for (int i=0; i<agentList.groups.size(); i++) {
//       LineGroup lg = agentList.groups.get(i);
//       st[i] = lg.frames + " " + round(lg.getMaxLength()) + " " + lg.size() + " " + round(lg.getStart().startDist);
//   }
//   saveStrings("pattern.txt", st);
   
   
   Table table = new Table();
  
   table.addColumn("time");
   table.addColumn("length");
   table.addColumn("intersections");
   table.addColumn("height");
   table.addColumn("speeds");
   
   for (int i=0; i<agentList.groups.size(); i++) {
       LineGroup lg = agentList.groups.get(i);
       TableRow newRow = table.addRow();
       newRow.setInt("time", lg.frames);
       newRow.setInt("length", round(lg.getMaxLength()));
       newRow.setInt("intersections", lg.size());
       newRow.setInt("height", round(lg.getStart().startDist));
       
       String st = "";
       
       for (int ii=0; ii<lg.size(); ii++){
           st += lg.get(ii).speed0 + "/" + lg.get(ii).speed1;
       }
       
       newRow.setString("speeds", st);
   }
  
   saveTable(table, "data/" + timestamp() + "_pattern.csv");
}
