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

- (id)initWithPosition:(GLKVector3)position Rotation:(float) rotation RotationAxis:(GLKVector3)upward;
- (id)init;

- (void)translate:(GLKVector3)t;

- (void)rotate:(float)rotation;

- (void)reset;

- (GLKMatrix4)getViewMatrix;

@end

#endif /* CameraTransformations_h */
