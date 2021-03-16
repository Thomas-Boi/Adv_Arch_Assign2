//
//  MazeManager.h
//  Assignment2
//
//  Created by socas on 2021-03-15.
//

#ifndef MazeManager_h
#define MazeManager_h

#import "maze.hpp"
#import "GameObject.h"
#import "Transformations.h"
#import <Foundation/Foundation.h>

@interface MazeManager : NSObject

@property(readonly) NSMutableArray *walls2D;

- (void) createMazeWithRows:(int)rows Columns:(int)cols;
@end

#endif /* MazeManager_h */
