import java.util.Map.Entry;

import java.util.*;
import java.io.*;
import processing.video.*;

Movie movie0;
Movie movie1;

String dataSrc = "data/pattern.csv";

float w = 1600;
float h = 800;

boolean stop = false;

int framesGlobal = 0;

//LineGroupList groupList = new LineGroupList();
ArrayList<LineGroupList> groupLists = new ArrayList<LineGroupList>();

PVector center = new PVector(w/2,h/2);

void setup() {
    
    size(1600+40,800+40);
    
    frameRate(600);
    
    groupLists.add( loadData("data/pattern_123_cage4.csv") );
    
    movie0 = new Movie(this, "/Users/mbaer/Downloads/Sequenz 02_9.mov");
    movie0.loop();
    
    //movie1 = new Movie(this, "/Users/mbaer/Documents/_Gestaltung/OpenFrameworks/of_v0072_osx_release/examples/addons/opencvExample/bin/data/fingers.mov");
    movie1 = new Movie(this, "/Users/mbaer/Downloads/Sequenz 02_9.mov");
    movie1.loop();
}



void update() {
    
    framesGlobal++;
    
    for ( int i=0; i< groupLists.size(); i++) {
        groupLists.get(i).update();
    }
}


void draw() {
    
    if (!stop) update();
    
    //background(255);
    
    pushMatrix();
    translate(20,20);
    
//    for ( int i=0; i< groupLists.size(); i++) {
//        float yy =  (h)/groupLists.size()*(i+1);
//        float hh =  (h)/groupLists.size();
//        groupLists.get(i).draw( yy - hh/2);
//    }
    
    image(movie0,0,0);
    image(movie1,movie0.width,0,movie0.width,movie0.height);


    for ( int i=0; i< groupLists.size(); i++) {
        LineGroupList lgl = groupLists.get(i);
        
        if ( lgl.hasFrame( framesGlobal ) ) {
            LineGroup lg = lgl.getByFrame( framesGlobal );
            
//            fill(255,0,0);
//            ellipse( w/4, center.y, lg.speeds[0] * 10, lg.speeds[0] * 10);
//            
//            fill(255,0,0);
//            ellipse( w/4*3, center.y, lg.speeds[1] * 10, lg.speeds[1] * 10);
                
              movie0.jump( movie0.duration() * lg.speeds[0]/3 );
              movie1.jump( movie1.duration() * lg.speeds[1]/14 );
        }
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
    String speeds = row.getString("speeds");
    
    LineGroup lg = new LineGroup( time, length, intersections, height, speeds ); 

    
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

void movieEvent(Movie m) {
  m.read();
}
