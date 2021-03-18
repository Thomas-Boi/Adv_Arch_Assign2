//
//  ObjectTracker.m
//  WizQuest
//
//  Created by socas on 2021-02-23.
//

#import "ObjectTracker.h"

@interface ObjectTracker()
{
    NSMutableArray *_objects;
}

@end

@implementation ObjectTracker

// props

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
