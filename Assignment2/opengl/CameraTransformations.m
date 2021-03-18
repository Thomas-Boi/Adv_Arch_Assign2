//
//  CameraTransformations.m
//  A01055477_Assignment1
//
//  Created by socas on 2021-02-17.
//

#import "CameraTransformations.h"

@interface CameraTransformations ()
{
    GLKVector3 originalTranslation;
    GLKVector3 originalTarget;
    float originalRotation;
    
    // only has one rotation axis for this assignment
    GLKVector3 position;
    float rotation;
    GLKVector3 rotAxis;
    GLKVector3 _upwardVector;
    GLKVector3 _target;
}
@end


@implementation CameraTransformations

- (id)initWithPosition:(GLKVector3)newPosition Rotation:(float)newRotation RotationAxis:(GLKVector3)rotationAxis
{
    if (self = [super init])
    {
        position = newPosition;
        rotation = newRotation;
        rotAxis = rotationAxis;
        //_target = target;
        //_upwardVector = upward;
        
        // save initial translation and rotation
        originalTranslation = position;
        originalRotation = rotation;
        //originalTarget = target
    }
    return self;
}

- (id)init
{
    // by default, only rotate around the y axis
    return [self initWithPosition:GLKVector3Make(0, 0, 0) Rotation:0 RotationAxis:GLKVector3Make(0, 1, 0)];
}

// translate the position of the camera in world space
- (void)translate:(GLKVector3)t
{  
    position = GLKVector3Add(position, t);
}

// rotate the camera in world space
- (void)rotate:(float)rotAngle
{
    // rotate using right hand rule will have counter clockwise rotation
    // make it clockwise by default
    rotation += rotAngle;
    if (rotation >= 360) {
        rotation -= 360;
    }
    else if (rotation <= -360) {
        rotation += 360;
    }
}

- (void)reset
{
    position = originalTranslation;
    rotation = originalRotation;
}

// create the model view matrix
- (GLKMatrix4)getViewMatrix
{
    GLKMatrix4 viewMatrix = GLKMatrix4Identity;
    
    // create the quaternion so no gimbal lock
    // flip the rotation so everything else rotates the opposite way
    GLKQuaternion rotQuat = GLKQuaternionMakeWithAngleAndVector3Axis(-rotation, rotAxis);
    GLKMatrix4 quaternionMatrix = GLKMatrix4MakeWithQuaternion(rotQuat);
    
    // we are shifting the world based on the camera's position
    // so we have to go the opposite direction
    viewMatrix = GLKMatrix4Translate(viewMatrix, -position.x, -position.y, -position.z);
    viewMatrix = GLKMatrix4Multiply(viewMatrix, quaternionMatrix);
    return viewMatrix;
}
@end
