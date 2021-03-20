//
//  CameraTransformations.h
//  A01055477_Assignment1
//
//  Created by socas on 2021-02-17.
//

#ifndef CameraTransformations_h
#define CameraTransformations_h

#import <GLKit/GLKit.h>

@interface CameraTransformations : NSObject
- (id)initWithPosition:(GLKVector3)position ForwardVector:(GLKVector3)forward UpwardVector:(GLKVector3)upward Rotation:(float)newRotation RotationAxis:(GLKVector3)rotationAxis;

- (id)initWithDefaultValues;

- (void)translate:(float)forwardVelocity;

- (void)rotate:(float)rotation;

- (void)reset;

- (GLKMatrix4)getViewMatrix;

@end

#endif /* CameraTransformations_h */
