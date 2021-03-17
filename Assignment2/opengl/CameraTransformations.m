//
//  CameraTransformations.m
//  A01055477_Assignment1
//
//  Created by socas on 2021-02-17.
//

#import "CameraTransformations.h"

@interface CameraTransformations ()
{
    GLKVector3 translateEnd;
    
    GLKVector3 originalTranslation;
    GLKQuaternion originalRotation;
    
    GLKQuaternion rotationEnd;
}
@end


@implementation CameraTransformations

- (id)initWithTranslation:(GLKVector3)t Rotation:(float)r RotationAxis:(GLKVector3)rotAxis
{
    if (self = [super init])
    {
        translateEnd = t;
        
        r = GLKMathDegreesToRadians(r);
        rotationEnd = GLKQuaternionIdentity;
        GLKQuaternion rotQuat = GLKQuaternionMakeWithAngleAndVector3Axis(-r, rotAxis);
        rotationEnd = GLKQuaternionMultiply(rotQuat, rotationEnd);
        
        // save initial translation and rotation
        originalTranslation = translateEnd;
        originalRotation = rotationEnd;
    }
    return self;
}

- (id)init
{
    return [self initWithTranslation:GLKVector3Make(0, 0, 0) Rotation:0 RotationAxis:GLKVector3Make(1, 0, 0)];
}

// translate the position of the camera in world space
- (void)translate:(GLKVector3)t withMultiplier:(float)m {
        
    t = GLKVector3MultiplyScalar(t, m);
    float dx = translateEnd.x + t.x;
    float dy = translateEnd.y + t.y;
    float dz = translateEnd.z + t.z;
    
    translateEnd = GLKVector3Make(dx, dy, dz);
}

// rotate the camera in world space
- (void)rotate:(float)rotation rotationAxis:(GLKVector3)rotAxis withMultiplier:(float)m
{
    // rotate using right hand rule will have counter clockwise rotation
    // make it clockwise by default
    float deltaRotation = -rotation * m;
    GLKQuaternion rotQuat = GLKQuaternionMakeWithAngleAndVector3Axis(deltaRotation, rotAxis);
    rotationEnd = GLKQuaternionMultiply(rotQuat, rotationEnd);
}

- (void)reset
{
    translateEnd = originalTranslation;
    rotationEnd = originalRotation;
}

// create the model view matrix
- (GLKMatrix4)getViewMatrix
{
    GLKMatrix4 viewMatrix = GLKMatrix4Identity;
    GLKMatrix4 quaternionMatrix = GLKMatrix4MakeWithQuaternion(rotationEnd);
    
    // we are shifting the world based on the camera's position
    // so we have to go the opposite direction
    viewMatrix = GLKMatrix4Translate(viewMatrix, -translateEnd.x, -translateEnd.y, -translateEnd.z);
    viewMatrix = GLKMatrix4Multiply(viewMatrix, quaternionMatrix);
    return viewMatrix;
}
@end
