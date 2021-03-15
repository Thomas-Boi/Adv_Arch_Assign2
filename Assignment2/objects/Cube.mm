//
//  Cube.m
//  Assignment2
//
//  Created by socas on 2021-03-14.
//

#import "Cube.h"

@interface Cube()
{
    std::chrono::time_point<std::chrono::steady_clock> lastTime;
    float rotAngle;
    
}
@end

@implementation Cube
- (void)initRotation
{
    // Initialize UI element variables
    rotAngle = 0.0f;

    // Initialize GL color and other parameters
    lastTime = std::chrono::steady_clock::now();
}

- (void)loadTransformation:(GLKMatrix4) transformation
{
    // Calculate elapsed time
    auto currentTime = std::chrono::steady_clock::now();
    auto elapsedTime = std::chrono::duration_cast<std::chrono::milliseconds>(currentTime - lastTime).count();
    lastTime = currentTime;

    rotAngle += 0.001f * elapsedTime;
    if (rotAngle >= 360.0f)
        rotAngle = 0.0f;
    
    super.modelViewMatrix = GLKMatrix4Rotate(transformation, rotAngle, 0.0f, 1.0f, 0.0f);

    super.normalMatrix = GLKMatrix3InvertAndTranspose(GLKMatrix4GetMatrix3(super.modelViewMatrix), NULL);
    
}
@end
