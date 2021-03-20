//
//  Copyright © Borna Noureddin. All rights reserved.
//

#ifndef Renderer_h
#define Renderer_h
#import <GLKit/GLKit.h>
#import "GameObject.h"

@interface Renderer : NSObject

@property bool useFog;

- (void)setup:(GLKView *)view;

- (void)setIsFoggy:(bool) newIsFoggy;
- (void)setIsDay:(bool) newIsDay;
- (void)clear;
- (void)draw:(GameObject *) obj;

@end

#endif /* Renderer_h */
