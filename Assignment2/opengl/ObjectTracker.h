//
//  ObjectTracker.h
//  WizQuest
//
//  Created by socas on 2021-02-23.
//

#ifndef ObjectTracker_h
#define ObjectTracker_h

#import "Player.h"
#import "Cube.h"
#import <Foundation/Foundation.h>


@interface ObjectTracker : NSObject

@property(readonly) NSMutableArray *objects;

- (void) addObject: (GameObject *) platform;
- (void) cleanUp;

@end

#endif /* ObjectTracker_h */
