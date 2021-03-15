//
//  GameManager.h
//  WizQuest
//
//  Created by socas on 2021-02-23.
//

#ifndef GameManager_h
#define GameManager_h
#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>
#import "GameObject.h"
#import "Player.h"
#import "Platform.h"
#import "Renderer.h"
#import "ObjectTracker.h"
#import "Transformations.h"

@interface GameManager : NSObject

- (void) initManager:(GLKView *)view initialPlayerTransform:(GLKMatrix4) transform;
- (void) addObject:(GameObject *) obj;
- (void) update:(GLKMatrix4) transformations;
- (void) draw;

@end


#endif /* GameManager_h */
