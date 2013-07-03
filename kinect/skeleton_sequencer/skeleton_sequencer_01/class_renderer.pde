
// takes a block of kinect data and renders it as line drawing

class KinectRenderer
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

    KinectRenderer () {}
    
    void draw ( Object data )
    {
        noStroke();
        drawJoints( data );
        noFill();
        stroke( 255 );
        drawConnections( data );
    }
    
    Object getHipCenter ( Object data )
    {
        return data[HIP_CENTER];
    }
    
    void drawJoints ( Object data )
    {
        fill( 255 );
        
        //fill( 255, 0, 0 );
        drawJoint( data[HEAD][0],           data[HEAD][1],           data[HEAD][2] );
        drawJoint( data[SHOULDER_CENTER][0], data[SHOULDER_CENTER][1], data[SHOULDER_CENTER][2] );
        drawJoint( data[SHOULDER_LEFT][0],   data[SHOULDER_LEFT][1],   data[SHOULDER_LEFT][2] );
        drawJoint( data[SHOULDER_RIGHT][0],  data[SHOULDER_RIGHT][1],  data[SHOULDER_RIGHT][2] );
        
        //fill( 0, 255, 0 );
        drawJoint( data[ELBOW_LEFT][0],      data[ELBOW_LEFT][1],      data[ELBOW_LEFT][2] );
        drawJoint( data[ELBOW_RIGHT][0],     data[ELBOW_RIGHT][1],     data[ELBOW_RIGHT][2] );
        drawJoint( data[WRIST_LEFT][0],      data[WRIST_LEFT][1],      data[WRIST_LEFT][2] );
        drawJoint( data[WRIST_RIGHT][0],     data[WRIST_RIGHT][1],     data[WRIST_RIGHT][2] );
        drawJoint( data[HAND_LEFT][0],       data[HAND_LEFT][1],       data[HAND_LEFT][2] );
        drawJoint( data[HAND_RIGHT][0],      data[HAND_RIGHT][1],      data[HAND_RIGHT][2] );
        
        //fill( 0, 0, 255 );
        drawJoint( data[SPINE][0],          data[SPINE][1],          data[SPINE][2] );
        drawJoint( data[HIP_LEFT][0],        data[HIP_LEFT][1],        data[HIP_LEFT][2] );
        drawJoint( data[HIP_CENTER][0],      data[HIP_CENTER][1],      data[HIP_CENTER][2] );
        drawJoint( data[HIP_RIGHT][0],       data[HIP_RIGHT][1],       data[HIP_RIGHT][2] );
        drawJoint( data[KNEE_LEFT][0],       data[KNEE_LEFT][1],       data[KNEE_LEFT][2] );
        drawJoint( data[KNEE_RIGHT][0],      data[KNEE_RIGHT][1],      data[KNEE_RIGHT][2] );
        drawJoint( data[ANKLE_LEFT][0],      data[ANKLE_LEFT][1],      data[ANKLE_LEFT][2] );
        drawJoint( data[ANKLE_RIGHT][0],     data[ANKLE_RIGHT][1],     data[ANKLE_RIGHT][2] );
        drawJoint( data[FOOT_LEFT][0],       data[FOOT_LEFT][1],       data[FOOT_LEFT][2] );
        drawJoint( data[FOOT_RIGHT][0],      data[FOOT_RIGHT][1],      data[FOOT_RIGHT][2] );
    }
    
    void drawConnections ( Object data )
    {
        drawConnection( data[HEAD], data[SHOULDER_CENTER] );
        drawConnection( data[SHOULDER_CENTER], data[SPINE] );
        drawConnection( data[SPINE], data[HIP_CENTER] );
        
        drawConnection( data[SHOULDER_CENTER], data[SHOULDER_LEFT] );
        drawConnection( data[SHOULDER_LEFT], data[ELBOW_LEFT] );
        drawConnection( data[ELBOW_LEFT], data[WRIST_LEFT] );
        drawConnection( data[WRIST_LEFT], data[HAND_LEFT] );
        
        drawConnection( data[SHOULDER_CENTER], data[SHOULDER_RIGHT] );
        drawConnection( data[SHOULDER_RIGHT], data[ELBOW_RIGHT] );
        drawConnection( data[ELBOW_RIGHT], data[WRIST_RIGHT] );
        drawConnection( data[WRIST_RIGHT], data[HAND_RIGHT] );
        
        drawConnection( data[HIP_CENTER], data[HIP_LEFT] );
        drawConnection( data[HIP_LEFT], data[KNEE_LEFT] );
        drawConnection( data[KNEE_LEFT], data[ANKLE_LEFT] );
        drawConnection( data[ANKLE_LEFT], data[FOOT_LEFT] );
        
        drawConnection( data[HIP_CENTER], data[HIP_RIGHT] );
        drawConnection( data[HIP_RIGHT], data[KNEE_RIGHT] );
        drawConnection( data[KNEE_RIGHT], data[ANKLE_RIGHT] );
        drawConnection( data[ANKLE_RIGHT], data[FOOT_RIGHT] );
    }
    
    void drawConnection ( Object from, Object to )
    {
        line( from[0], from[1], from[2], to[0], to[1], to[2] );
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
