//
//  Transformations.h
//  A01055477_Assignment1
//
//  Created by socas on 2021-02-17.
//

#ifndef Transformations_h
#define Transformations_h

#import <GLKit/GLKit.h>

@interface Transformations : NSObject

- (id)initWithScale:(float)s Translation:(GLKVector3)t Rotation:(float)r RotationAxis:(GLKVector3)rotAxis;
- (void)start;
- (void)scale:(float)s;

- (void)translate:(GLKVector3)t withMultiplier:(float)m;
- (void)translateBy:(GLKVector3)t;

- (void)rotate:(float)rotation withMultiplier:(float)m;
- (void)rotateBy:(float)r;

- (void)reset;
- (GLKMatrix4)getModelViewMatrix;
+ (GLKMatrix4)createModelViewMatrixWithTranslation:(GLKVector3)translation Rotation:(float)rotation RotationAxis:(GLKVector3)rotAxis Scale:(GLKVector3)scale;

@end

#endif /* Transformations_h */
