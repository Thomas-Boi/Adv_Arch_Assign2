//
//  Wall3D.h
//  Assignment2
//
//  Created by socas on 2021-03-15.
//

#ifndef Wall3D_h
#define Wall3D_h

#import "GameObject.h"
#import <Foundation/Foundation.h>

@interface Wall3D : GameObject

- (void)makeNorthWall: (bool)westPresent EastWallPresent:(bool)eastPresent;
- (void)makeSouthWall: (bool)westPresent EastWallPresent:(bool)eastPresent;
- (void)makeWestWall: (bool)northPresent SouthWallPresent:(bool)southPresent;
- (void)makeEastWall: (bool)northPresent SouthWallPresent:(bool)southPresent;

@end

#endif /* Wall3D_h */
