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

- (void) initManager:(GLKView *)view initialPlayerTransform:(GLKMatrix4) transform;
- (void) initManager:(GLKView *)view initialCubeTransform:(GLKMatrix4) transform playerTransform:(GLKMatrix4) pTransform;
- (void) addObject:(GameObject *) obj;
- (void) update:(GLKMatrix4) transformations initialCubeTranform:(GLKMatrix4) cubeTransformations;
- (void) draw;

@end


#endif /* GameManager_h */
