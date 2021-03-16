//
//  Wall2D.h
//  Assignment2
//
//  Created by socas on 2021-03-15.
//

#ifndef Wall2D_h
#define Wall2D_h

#import "GameObject.h"
#import <Foundation/Foundation.h>

@interface Wall2D : GameObject

- (void)makeNorthWall;
- (void)makeSouthWall;
- (void)makeWestWall;
- (void)makeEastWall;

@end

#endif /* Wall2D_h */
