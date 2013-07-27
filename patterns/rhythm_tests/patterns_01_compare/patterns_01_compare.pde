import java.util.Map.Entry;

import java.util.*;
import java.io.*;

String dataSrc = "data/pattern.csv";

float w = 1600;
float h = 800;

boolean stop = false;

int framesGlobal = 0;

//LineGroupList groupList = new LineGroupList();
ArrayList<LineGroupList> groupLists = new ArrayList<LineGroupList>();

PVector center = new PVector(w/4,h/2);

void setup() {
    
    size(1600+40,800+40);
    
    noLoop();
    
    groupLists.add( loadData("data/pattern_1_9.csv") );
    groupLists.add( loadData("data/pattern_prim.csv") );
    groupLists.add( loadData("data/pattern_fib.csv") );
    groupLists.add( loadData("data/pattern_1_2_23.csv") );
    groupLists.add( loadData("data/pattern_1_111.csv") );
    groupLists.add( loadData("data/pattern_1_11.csv") );
    groupLists.add( loadData("data/pattern_123_cage.csv") );
    groupLists.add( loadData("data/pattern_123_cage2.csv") );
    groupLists.add( loadData("data/pattern_123_cage3.csv") );
    groupLists.add( loadData("data/pattern_123_cage4.csv") );
    groupLists.add( loadData("data/pattern_123_1221.csv") );
}



void update() {
    
    framesGlobal++;
    
    for ( int i=0; i< groupLists.size(); i++) {
        groupLists.get(i).update();
    }
}


void draw() {
    
    if (!stop) update();
    
    background(255);
    
    pushMatrix();
    translate(20,20);
    
    for ( int i=0; i< groupLists.size(); i++) {
        float yy =  (h)/groupLists.size()*(i+1);
        float hh =  (h)/groupLists.size();
        groupLists.get(i).draw( yy - hh/2);
    }
    
    popMatrix();
    

}

LineGroupList loadData( String _src) {
    
    LineGroupList lgl = new LineGroupList( _src );
    
  Table  table = loadTable(_src, "header");

  println(table.getRowCount() + " total rows in table"); 

  for (TableRow row : table.rows()) {
    
    int time = row.getInt("time");
    int length = row.getInt("length");
    int intersections = row.getInt("intersections");
    int height = row.getInt("height");
    
    LineGroup lg = new LineGroup( time, length, intersections, height ); 
    
    try {
        lg.speeds = row.getString("speeds");

    } catch(Exception e) {
        
    }
    
    lgl.add( lg );
    
    
  }
    
    return lgl;
}

void saveData() {
   
//   Table table = new Table();
//  
//   table.addColumn("time");
//   table.addColumn("length");
//   table.addColumn("intersections");
//   table.addColumn("height");
//   
//   for (int i=0; i<agentList.groups.size(); i++) {
//       LineGroup lg = agentList.groups.get(i);
//       TableRow newRow = table.addRow();
//       newRow.setInt("time", lg.frames);
//       newRow.setInt("length", round(lg.getMaxLength()));
//       newRow.setInt("intersections", lg.size());
//       newRow.setInt("height", round(lg.getStart().startDist));
//   }
//  
//   saveTable(table, "data/pattern.csv");
}
