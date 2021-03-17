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

- (id)initWithTranslation:(GLKVector3)t Rotation:(float)r RotationAxis:(GLKVector3)rotAxis;
- (id)init;

- (void)translate:(GLKVector3)t withMultiplier:(float)m;

- (void)rotate:(float)rotation rotationAxis:(GLKVector3)rotAxis withMultiplier:(float)m;

- (void)reset;

- (GLKMatrix4)getViewMatrix;

@end

#endif /* CameraTransformations_h */
