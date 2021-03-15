//
//  ObjectTracker.h
//  WizQuest
//
//  Created by socas on 2021-02-23.
//

#ifndef ObjectTracker_h
#define ObjectTracker_h

#import "Player.h"
#import "Platform.h"
#import "Cube.h"
#import <Foundation/Foundation.h>


@interface ObjectTracker : NSObject

@property(readonly) Player *player;
@property(readonly) Cube *cube;
@property(readonly) NSMutableArray *platforms;

- (void) addPlayer: (Player *) player;
- (void) addCube: (Cube *) cube;
- (void) addPlatform: (Platform *) platform;
- (void) cleanUp;

@end

#endif /* ObjectTracker_h */
