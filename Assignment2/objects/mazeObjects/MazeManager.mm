//
//  MazeManager.m
//  Assignment2
//
//  Created by socas on 2021-03-15.
//

#import "MazeManager.h"

@interface MazeManager()
{
    Maze *mazeGenerator;
    NSMutableArray *_cells;
}

@end

@implementation MazeManager

@synthesize rowCount;
@synthesize colCount;

- (void) createMazeWithRows:(int)rows Columns:(int)cols
{
    mazeGenerator = new Maze();
    mazeGenerator -> Create();
    rowCount = rows;
    colCount = cols;
    [self createWalls];
}

- (void) createWalls
{
    for (int row = 0; row < rowCount; row++)
    {
        for (int col = 0; col < colCount; col++)
        {
            MazeCell cell = mazeGenerator -> GetCell(row, col);
            
            if (cell.northWallPresent)
            {
                Wall2D *wall = [[Wall2D alloc] init];
                [wall makeNorthWall];
                [_cells addObject:wall];
            }
        }
    }
}

@end
