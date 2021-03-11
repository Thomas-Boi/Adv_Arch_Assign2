//
//  Copyright © Borna Noureddin. All rights reserved.
//

#ifndef Renderer_h
#define Renderer_h
#import <GLKit/GLKit.h>

@interface Renderer : NSObject

- (void)setup:(GLKView *)view;      // Set up GL using the current View
- (void)loadModels;                 // Load models (e.g., cube to rotate)
- (void)update:(GLKMatrix4) modelViewTransform;                     // Update GL
- (void)draw:(CGRect)drawRect;      // Make the GL draw calls

@end

#endif /* Renderer_h */
