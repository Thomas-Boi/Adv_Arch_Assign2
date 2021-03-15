//
//  ObjectTracker.m
//  WizQuest
//
//  Created by socas on 2021-02-23.
//

#import "ObjectTracker.h"

@interface ObjectTracker()
{
    Player *_player;
    NSMutableArray *_platforms;
}

@end

@implementation ObjectTracker

// props
@synthesize player=_player;

- (NSMutableArray *) platforms
{
    return _platforms;
}

- (void) addPlayer: (Player *) player
{
    _player = player;
}

- (void) addPlatform: (Platform *) platform
{
    [_platforms addObject:platform];
}

// check and see if we need to delete
// any objects from the array.
- (void) cleanUp
{
    
}

@end
