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
#import "Cube.h"
#import "Renderer.h"
#import "ObjectTracker.h"
#import "Transformations.h"
#import "MazeManager.h"

@interface GameManager : NSObject

- (void) initManager:(GLKView *)view;
- (void) addObject:(GameObject *) obj;
- (void) update:(GLKMatrix4) viewMatrix;
- (void) draw;

@property bool display2DMap;

@end


#endif /* GameManager_h */
