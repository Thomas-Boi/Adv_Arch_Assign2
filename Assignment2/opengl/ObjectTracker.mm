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
    NSMutableArray *_objects;
}

@end

@implementation ObjectTracker

// props
@synthesize player=_player;
@synthesize cube=_cube;

- (NSMutableArray *) objects
{
    return _objects;
}

- (id) init
{
    if ([super init])
    {
        _objects = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void) addPlayer: (Player *) player
{
    _player = player;
}

- (void) addCube: (Cube *) cube
{
    _cube = cube;
}

- (void) addObject: (GameObject *) obj
{
    [_objects addObject:obj];
}

// check and see if we need to delete
// any objects from the array.
- (void) cleanUp
{
    
}

@end
