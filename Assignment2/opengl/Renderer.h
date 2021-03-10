//
//  Copyright © Borna Noureddin. All rights reserved.
// this declares the interface for Renderer.mm

#ifndef Renderer_h
#define Renderer_h
#import <GLKit/GLKit.h>

@interface Renderer : NSObject

@property float rotAngle;
@property bool isRotating;

- (void)setup:(GLKView *)view;
- (void)loadModels;
- (void)update: (GLKMatrix4) modelViewMatrix;
- (void)draw:(CGRect)drawRect;

@end

#endif /* Renderer_h */
