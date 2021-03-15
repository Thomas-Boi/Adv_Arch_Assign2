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
    
}
@end

@implementation Cube
- (void)initRotation
{
    // Initialize GL color and other parameters
    lastTime = std::chrono::steady_clock::now();
}

- (void)update
{
    // Calculate elapsed time
    auto currentTime = std::chrono::steady_clock::now();
    auto elapsedTime = std::chrono::duration_cast<std::chrono::milliseconds>(currentTime - lastTime).count();
    lastTime = currentTime;

    float rotAngle = 0.001f * elapsedTime;
    
    GLKMatrix4 newTransformation = GLKMatrix4Rotate(super.modelViewMatrix, rotAngle, 0.0f, 1.0f, 0.0f);

    [super updateWithTransformation:newTransformation];
}
@end
