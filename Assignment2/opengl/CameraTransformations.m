//
//  CameraTransformations.m
//  A01055477_Assignment1
//
//  Created by socas on 2021-02-17.
//

#import "CameraTransformations.h"

@interface CameraTransformations ()
{
    GLKVector3 originalPosition;
    GLKVector3 originalForwardVector;
    float originalRotation;
    
    // only has one rotation axis for this assignment
    GLKVector3 position;
    float rotation;
    GLKVector3 rotAxis;
    GLKVector3 upwardVector;
    GLKVector3 forwardVector;
}
@end


@implementation CameraTransformations
- (id)initWithPosition:(GLKVector3)newPosition ForwardVector:(GLKVector3)forward UpwardVector:(GLKVector3)upward Rotation:(float)newRotation RotationAxis:(GLKVector3)rotationAxis
{
    if (self = [super init])
    {
        position = newPosition;
        forwardVector = forward; // face z by default
        upwardVector = upward;
        rotation = newRotation;
        rotAxis = rotationAxis;
        
        // save initial translation and rotation
        originalPosition = position;
        originalForwardVector = forward;
        originalRotation = rotation;
        
    }
    return self;
}

- (id)initWithDefaultValues
{
    // by default, only rotate around the y axis
    return [self initWithPosition:GLKVector3Make(0, 0, 0) ForwardVector:GLKVector3Make(0, 0, -5) UpwardVector:GLKVector3Make(0, 1, 0) Rotation:0 RotationAxis:GLKVector3Make(0, 1, 0)];
}

// translate the position of the camera in world space
- (void)translate:(float)forwardVelocity
{
    /*
    float xComponent = fabs(forwardVelocity) * sin(rotation);
    float zComponent = fabs(forwardVelocity) * cos(rotation);
    
    if (forwardVelocity < 0)
    {
        xComponent = -xComponent;
        zComponent = -zComponent;
    }
     */
    GLKVector3 move = GLKVector3Make(0, 0, forwardVelocity);
    position = GLKVector3Add(position, move);
}

// rotate the camera in world space
- (void)rotate:(float)rotAngle
{
    // rotate using right hand rule will have counter clockwise rotation
    // make it clockwise by default
    rotation += rotAngle;
    NSLog(@"%f", rotation);
    if (rotation >= 360) {
        rotation -= 360;
    }
    else if (rotation <= -360) {
        rotation += 360;
    }
}

- (void)reset
{
    position = originalPosition;
    rotation = originalRotation;
}

// create the model view matrix
- (GLKMatrix4)getViewMatrix
{
    
    // create the quaternion so no gimbal lock
    // flip the rotation so everything else rotates the opposite way
    GLKQuaternion rotQuat = GLKQuaternionMakeWithAngleAndVector3Axis(-rotation, rotAxis);
    GLKMatrix4 quaternionMatrix = GLKMatrix4MakeWithQuaternion(rotQuat);
    
    // we are shifting the world based on the camera's position
    // so we have to go the opposite direction
    // update the forward vector
    GLKVector3 rotatedForwardVector = GLKMatrix4MultiplyVector3(quaternionMatrix, forwardVector);
    
    GLKVector3 target = GLKVector3Add(position, rotatedForwardVector);
    GLKMatrix4 viewMatrix = GLKMatrix4MakeLookAt(position.x, position.y, position.z, target.x, target.y, target.z, upwardVector.x, upwardVector.y, upwardVector.z);
    /*
    GLKMatrix4 viewMatrix = GLKMatrix4Identity;
    viewMatrix = GLKMatrix4Translate(viewMatrix, -position.x, -position.y, -position.z);
    viewMatrix = GLKMatrix4Multiply(viewMatrix, quaternionMatrix);
     */
    return viewMatrix;
}
@end
