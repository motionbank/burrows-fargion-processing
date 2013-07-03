class Skeleton
{
    SkeletonPose[] poses;
    int currentPose = 0;
    
    Skeleton () {
        poses = new SkeletonPose[0];
    }
    
    void addPose ( Object data )
    {
        int frame = int( data[ 0 ] );
        poses[frame] = new SkeletonPose( data );
    }
    
    void draw ()
    {
        poses[currentPose].draw();
    }
    
    SkeletonPose pose ()
    {
        return poses[currentPose];
    }
    
    SkeletonPose pose ( int which )
    {
        return poses[which];
    }
    
    void move ()
    {
        currentPose++;
        currentPose %= poses.length;
    }
    
    void setPose ( int which )
    {
        if ( which >= 0 && which < poses.length )
            currentPose = which;
    }
}

class SkeletonPose
{
    int FRAME = 0, 
        VALIDITY = 1, 
        KINECT_TIMESTAMP = 2, 
        SKELETON_ID = 3;
        
    int HIP_CENTER = 4,
        SPINE = 1+4,
        SHOULDER_CENTER = 2+4,
        HEAD = 3+4,
        SHOULDER_LEFT = 4+4,
        ELBOW_LEFT = 5+4,
        WRIST_LEFT = 6+4,
        HAND_LEFT = 7+4,
        SHOULDER_RIGHT = 8+4,
        ELBOW_RIGHT = 9+4,
        WRIST_RIGHT = 10+4,
        HAND_RIGHT = 11+4,
        HIP_LEFT = 12+4,
        KNEE_LEFT = 13+4,
        ANKLE_LEFT = 14+4,
        FOOT_LEFT = 15+4,
        HIP_RIGHT = 16+4,
        KNEE_RIGHT = 17+4,
        ANKLE_RIGHT = 18+4,
        FOOT_RIGHT = 19+4;
    
    Point3D head, spine,
            shoulderLeft, shoulderCenter, shoulderRight,
            elbowLeft, elbowRight,
            wristLeft, wristRight,
            handLeft, handRight,
            hipLeft, hipCenter, hipRight,
            kneeLeft, kneeRight, 
            ankleLeft, ankleRight,
            footLeft, footRight;

    SkeletonPose ( String d ) 
    {
        head = new Point3D( d[HEAD] ); 
        
        spine = new Point3D( d[SPINE]);
        
        shoulderLeft = new Point3D( d[SHOULDER_LEFT]);
        shoulderCenter = new Point3D( d[SHOULDER_CENTER]);
        shoulderRight = new Point3D( d[SHOULDER_RIGHT]);
        
        elbowLeft = new Point3D( d[ELBOW_LEFT]); 
        elbowRight = new Point3D( d[ELBOW_RIGHT]);
        
        wristLeft = new Point3D( d[WRIST_LEFT]); 
        wristRight = new Point3D( d[WRIST_RIGHT]);
        
        handLeft = new Point3D( d[HAND_LEFT]); 
        handRight = new Point3D( d[HAND_RIGHT]);
        
        hipLeft = new Point3D( d[HIP_LEFT]); 
        hipCenter = new Point3D( d[HIP_CENTER]); 
        hipRight = new Point3D( d[HIP_RIGHT]);
        
        kneeLeft = new Point3D( d[KNEE_LEFT]); 
        kneeRight = new Point3D( d[KNEE_RIGHT]); 
        
        ankleLeft = new Point3D( d[ANKLE_LEFT]); 
        ankleRight = new Point3D( d[ANKLE_RIGHT]);
        
        footLeft = new Point3D( d[FOOT_LEFT]); 
        footRight  = new Point3D( d[FOOT_RIGHT]);
    }
    
    void draw ()
    {
        noStroke();
        drawJoints();
        noFill();
        stroke( 255 );
        drawConnections();
    }
    
    void drawJoints ()
    {
        fill( 255 );
        
        //fill( 255, 0, 0 );
        drawJoint( head.x,           head.y,           head.z );
        drawJoint( shoulderCenter.x, shoulderCenter.y, shoulderCenter.z );
        drawJoint( shoulderLeft.x,   shoulderLeft.y,   shoulderLeft.z );
        drawJoint( shoulderRight.x,  shoulderRight.y,  shoulderRight.z );
        
        //fill( 0, 255, 0 );
        drawJoint( elbowLeft.x,      elbowLeft.y,      elbowLeft.z );
        drawJoint( elbowRight.x,     elbowRight.y,     elbowRight.z );
        drawJoint( wristLeft.x,      wristLeft.y,      wristLeft.z );
        drawJoint( wristRight.x,     wristRight.y,     wristRight.z );
        drawJoint( handLeft.x,       handLeft.y,       handLeft.z );
        drawJoint( handRight.x,      handRight.y,      handRight.z );
        
        //fill( 0, 0, 255 );
        drawJoint( spine.x,          spine.y,          spine.z );
        drawJoint( hipLeft.x,        hipLeft.y,        hipLeft.z );
        drawJoint( hipCenter.x,      hipCenter.y,      hipCenter.z );
        drawJoint( hipRight.x,       hipRight.y,       hipRight.z );
        drawJoint( kneeLeft.x,       kneeLeft.y,       kneeLeft.z );
        drawJoint( kneeRight.x,      kneeRight.y,      kneeRight.z );
        drawJoint( ankleLeft.x,      ankleLeft.y,      ankleLeft.z );
        drawJoint( ankleRight.x,     ankleRight.y,     ankleRight.z );
        drawJoint( footLeft.x,       footLeft.y,       footLeft.z );
        drawJoint( footRight.x,      footRight.y,      footRight.z );
    }
    
    void drawConnections ()
    {
        drawConnection( head, shoulderCenter );
        drawConnection( shoulderCenter, spine );
        drawConnection( spine, hipCenter );
        
        drawConnection( shoulderCenter, shoulderLeft );
        drawConnection( shoulderLeft, elbowLeft );
        drawConnection( elbowLeft, wristLeft );
        drawConnection( wristLeft, handLeft );
        
        drawConnection( shoulderCenter, shoulderRight );
        drawConnection( shoulderRight, elbowRight );
        drawConnection( elbowRight, wristRight );
        drawConnection( wristRight, handRight );
        
        drawConnection( hipCenter, hipLeft );
        drawConnection( hipLeft, kneeLeft );
        drawConnection( kneeLeft, ankleLeft );
        drawConnection( ankleLeft, footLeft );
        
        drawConnection( hipCenter, hipRight );
        drawConnection( hipRight, kneeRight );
        drawConnection( kneeRight, ankleRight );
        drawConnection( ankleRight, footRight );
    }
    
    void drawConnection ( Point3D from, Point3D to )
    {
        line( from.x, from.y, from.z, to.x, to.y, to.z );
    }
    
    void drawJoint ( float x, float y, float z )
    {
        pushMatrix();
        translate( x, y, z );
        cube( 0.01 );
        popMatrix();
    }
}

class Point3D
{
    float x, y, z;

    Point3D ( float _x, float _y, float _z ) 
    {
        x = _x;
        y = _y;
        z = _z;
    }
    
    Point3D ( Object data )
    {
        x = data[0];
        y = data[1];
        z = data[2];
    }
}
