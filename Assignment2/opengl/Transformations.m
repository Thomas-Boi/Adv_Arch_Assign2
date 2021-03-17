//
//  Transformations.m
//  A01055477_Assignment1
//
//  Created by socas on 2021-02-17.
//

#import "Transformations.h"

@interface Transformations ()
{    
    float scaleStart;
    float scaleEnd;
    
    GLKVector3 translateStart;
    GLKVector3 translateEnd;
    
    GLKVector3 originalTranslation;
    GLKQuaternion originalRotation;
    
    float rotationStart;
    GLKQuaternion rotationEnd;
    GLKVector3 rotationAxis;
}
@end


@implementation Transformations

- (id)initWithScale:(float)s Translation:(GLKVector3)t Rotation:(float)r RotationAxis:(GLKVector3)rotAxis
{
    if (self = [super init])
    {
        scaleEnd = s;
        translateEnd = t;
        rotationAxis = rotAxis;
        
        r = GLKMathDegreesToRadians(r);
        rotationEnd = GLKQuaternionIdentity;
        GLKQuaternion rotQuat = GLKQuaternionMakeWithAngleAndVector3Axis(-r, rotationAxis);
        rotationEnd = GLKQuaternionMultiply(rotQuat, rotationEnd);
        
        // save initial translation and rotation
        originalTranslation = translateEnd;
        originalRotation = rotationEnd;
    }
    return self;
}

- (void)start
{
    scaleStart = scaleEnd;
    translateStart = GLKVector3Make(0.0f, 0.0f , 0.0f);
    rotationStart = 0.0f;
}

- (void)scale:(float)s
{
    scaleEnd = s * scaleStart;
}

- (void)translate:(GLKVector3)t withMultiplier:(float)m
{
    t = GLKVector3MultiplyScalar(t, m);
        
    float dx = translateEnd.x + (t.x-translateStart.x);
    // reverse direction cause in Swift, downward is positive but in OpenGL, upward
    // is positive
    float dy = translateEnd.y - (t.y-translateStart.y);
        
    translateEnd = GLKVector3Make(dx, dy, 0.0f);
    translateStart = GLKVector3Make(t.x, t.y, 0.0f);
}

- (void)translateBy:(GLKVector3)t {
        
    float dx = translateEnd.x + t.x;
    float dy = translateEnd.y + t.y;
    float dz = translateEnd.z + t.z;
    
    translateEnd = GLKVector3Make(dx, dy, dz);
}

- (void)rotate:(float)rotation withMultiplier:(float)m
{
    // reverse sign so the rotation is counter clockwise when swipe left to right
    float deltaRotation = -(rotation - rotationStart) * m;
    rotationStart = rotation;
    GLKQuaternion rotQuat = GLKQuaternionMakeWithAngleAndVector3Axis(deltaRotation, rotationAxis);
    rotationEnd = GLKQuaternionMultiply(rotQuat, rotationEnd);
}

- (void)rotateBy:(float)r {
    
}

- (void)reset
{
    translateEnd = originalTranslation;
    rotationEnd = originalRotation;
}

// create the model view matrix
- (GLKMatrix4)getModelViewMatrix
{
    GLKMatrix4 modelViewMatrix = GLKMatrix4Identity;
    GLKMatrix4 quaternionMatrix = GLKMatrix4MakeWithQuaternion(rotationEnd);
    
    modelViewMatrix = GLKMatrix4Translate(modelViewMatrix, translateEnd.x, translateEnd.y, translateEnd.z);
    modelViewMatrix = GLKMatrix4Multiply(modelViewMatrix, quaternionMatrix);
    modelViewMatrix = GLKMatrix4Scale(modelViewMatrix, scaleEnd, scaleEnd, scaleEnd);
    return modelViewMatrix;
}

// static function that can be used to create mv matrix on the fly.
+ (GLKMatrix4)createModelMatrixWithTranslation:(GLKVector3)translation Rotation:(float)rotation RotationAxis:(GLKVector3)rotAxis Scale:(GLKVector3)scale
{
    GLKMatrix4 modelMatrix = GLKMatrix4Identity;
    
    rotation = GLKMathDegreesToRadians(rotation);
    GLKQuaternion rotQuat = GLKQuaternionMakeWithAngleAndVector3Axis(rotation, rotAxis);
    GLKMatrix4 quaternionMatrix = GLKMatrix4MakeWithQuaternion(rotQuat);
    
    modelMatrix = GLKMatrix4Translate(modelMatrix, translation.x, translation.y, translation.z);
    modelMatrix = GLKMatrix4Multiply(modelMatrix, quaternionMatrix);
    modelMatrix = GLKMatrix4Scale(modelMatrix, scale.x, scale.y, scale.z);
     
    return modelMatrix;
}
@end
