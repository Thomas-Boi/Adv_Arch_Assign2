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
    NSMutableArray *_walls2D;
}

@end

@implementation MazeManager

- (NSMutableArray *)walls2D {
    return _walls2D;
}

- (void) createMazeWithRows:(int)rows Columns:(int)cols
{
    _walls2D = [[NSMutableArray alloc] init];
    mazeGenerator = new Maze(rows, cols);
    mazeGenerator -> Create();
    [self createWalls2D: rows AndCols:cols];
    
    
}

// create the 2D walls
- (void) createWalls2D: (int)rows AndCols: (int)cols
{
    // maze dimensions
    int mazeLength = 8;
    //int mazeWidth = 4;
    int mazeDepth = -5;

    // coordinate of the top left corner of the maze
    int topLeftY = 4;
    int topLeftX = -4;
    
    // make square cells
    float cellWidth = (float) mazeLength / rows;
    float halfCellWidth = cellWidth / 2;

    // sizes for the 2D wall
    float wallLength = cellWidth;
    float wallWidth = wallLength / 4;
    NSLog(@"%f", wallWidth);
    float halfWallWidth = wallWidth / 2;

    // scale vector
    GLKVector3 horizontalWallScale = GLKVector3Make(wallLength, wallWidth, 1.0f);
    GLKVector3 verticalWallScale = GLKVector3Make(wallWidth, wallLength, 1.0f);

    int startX = topLeftX + halfCellWidth;
    int startY = topLeftY - halfCellWidth;
    
    for (int row = 0; row < rows; row++)
    {
        float y = startY - row * cellWidth;
        for (int col = 0; col < cols; col++)
        {
            float x = startX + col * cellWidth;
            MazeCell cell = mazeGenerator -> GetCell(row, col);
            if (cell.northWallPresent)
            {
                float wallX = x;
                float wallY = y + halfCellWidth - halfWallWidth;
                GLKMatrix4 transformation = [Transformations createModelViewMatrixWithTranslation:GLKVector3Make(wallX, wallY, mazeDepth) Rotation:0 RotationAxis:GLKVector3Make(0, 0, 0) Scale:horizontalWallScale];
                [self makeWall2D: transformation];
            }
            
            if (cell.southWallPresent)
            {
                float wallX = x;
                float wallY = y - halfCellWidth + halfWallWidth;
                GLKMatrix4 transformation = [Transformations createModelViewMatrixWithTranslation:GLKVector3Make(wallX, wallY, mazeDepth) Rotation:0 RotationAxis:GLKVector3Make(0, 0, 0) Scale:horizontalWallScale];
                [self makeWall2D: transformation];
            }
            
            if (cell.westWallPresent)
            {
                float wallX = x - halfCellWidth + halfWallWidth;
                float wallY = y;
                GLKMatrix4 transformation = [Transformations createModelViewMatrixWithTranslation:GLKVector3Make(wallX, wallY, mazeDepth) Rotation:0 RotationAxis:GLKVector3Make(0, 0, 0) Scale:verticalWallScale];
                [self makeWall2D: transformation];
            }
            
            if (cell.eastWallPresent)
            {
                float wallX = x + halfCellWidth - halfWallWidth;
                float wallY = y;
                GLKMatrix4 transformation = [Transformations createModelViewMatrixWithTranslation:GLKVector3Make(wallX, wallY, mazeDepth) Rotation:0 RotationAxis:GLKVector3Make(0, 0, 0) Scale:verticalWallScale];
                [self makeWall2D: transformation];
            }
            
            
        }
    }
}

// make a 2D wall and add it to the _walls2D array
- (void) makeWall2D: (GLKMatrix4) transform
{
    @autoreleasepool {
        Wall2D *obj = [[Wall2D alloc] init];
        [obj setupVertShader:@"Shader.vsh" AndFragShader:@"Shader.fsh"];
        [obj loadModels:@"Cube"];
        [obj loadTransformation:transform];
        [obj loadTexture:@"crate.jpg"];
        
        [_walls2D addObject:obj];
        
    }
}
@end
