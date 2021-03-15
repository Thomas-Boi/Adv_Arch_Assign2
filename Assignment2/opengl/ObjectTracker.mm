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
    Cube *_cube;
    NSMutableArray *_platforms;
}

@end

@implementation ObjectTracker

// props
@synthesize player=_player;
@synthesize cube=_cube;

- (NSMutableArray *) platforms
{
    return _platforms;
}

- (void) addPlayer: (Player *) player
{
    _player = player;
}

- (void) addCube: (Cube *) cube
{
    _cube = cube;
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
