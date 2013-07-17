class LineSegment {
    
    PVector start = new PVector();
    PVector end = new PVector();
    
    LineSegment(float x0, float y0, float x1, float y1) {
        start = new PVector(x0,y0);
        end = new PVector(x1,y1);
    }
    
    LineSegment(PVector p0, PVector p1) {
        start = new PVector(p0.x, p0.y);
        end = new PVector(p1.x, p1.y);
    }
    
    void draw() {
        noFill();
        stroke(255,0,0,30);
        strokeWeight(2);
        line(start.x, start.y, end.x, end.y);
        fill(255,0,0,30);
        noStroke();
        ellipse(start.x, start.y, gridStep/2,gridStep/2);
        ellipse(end.x, end.y, gridStep/2,gridStep/2);
    }
}
