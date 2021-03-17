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
    NSMutableArray *_walls3D;
    
}

@end

@implementation MazeManager

- (NSMutableArray *)walls2D {
    return _walls2D;
}

- (NSMutableArray *)walls3D {
    return _walls3D;
}

// create a maze with said rows and columns
// the depth is the z position of the southern most wall
- (void) createMazeWithRows:(int)rows Columns:(int)cols Depth:(float)dist
{
    _walls2D = [[NSMutableArray alloc] init];
    _walls3D = [[NSMutableArray alloc] init];

    mazeGenerator = new Maze(rows, cols);
    mazeGenerator -> Create();
    [self createWalls2D: rows AndCols:cols];
    [self createWallsAndFloor3D: rows AndCols:cols Depth:dist];
}

// create the 2D walls
- (void) createWalls2D: (int)rows AndCols: (int)cols
{
    // maze dimensions
    int mazeLength = 4;
    //int mazeWidth = 4;
    int mazeDepth = -5;
    
    // make square cells
    float cellWidth = (float) mazeLength / rows;
    float halfCellWidth = cellWidth / 2;

    // sizes for the 2D wall
    float wallLength = cellWidth;
    float wallWidth = wallLength / 4;
    float halfWallWidth = wallWidth / 2;

    // scale vector
    GLKVector3 horizontalWallScale = GLKVector3Make(wallLength, wallWidth, wallWidth);
    GLKVector3 verticalWallScale = GLKVector3Make(wallWidth, wallLength, wallWidth);

    // coordinate of the top left corner of the maze
    float topLeftY = cellWidth * 2;
    float topLeftX = -cellWidth * 2;

    // coordinate of the center of the top left cell
    float startX = topLeftX + halfCellWidth;
    float startY = topLeftY - halfCellWidth;
    
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
        GameObject *obj = [[GameObject alloc] init];
        [obj setupVertShader:@"RedShader.vsh" AndFragShader:@"RedShader.fsh"];
        [obj loadModels:@"Cube"];
        [obj loadTransformation:transform];
        
        [_walls2D addObject:obj];
        
    }
}

// create the 3D walls
- (void) createWallsAndFloor3D: (int)rows AndCols: (int)cols Depth:(float)depth
{
    // maze dimensions
    int mazeLength = 10;  // z
    
    // make square cells
    float cellWidth = (float) mazeLength / rows;
    float halfCellWidth = cellWidth / 2;

    // sizes for the 3D wall
    float wallLength = cellWidth; // long side
    float wallWidth = wallLength / 5; // short side
    float wallHeight = cellWidth * 2;
    float halfWallWidth = wallWidth / 2;

    // scale vector
    GLKVector3 westToEastWallScale = GLKVector3Make(wallLength, wallHeight, wallWidth);
    GLKVector3 northToSouthWallScale = GLKVector3Make(wallWidth, wallHeight, wallLength);

    // coordinate of the north west corner of the maze
    float northWestX = -mazeLength + halfCellWidth; // centered the maze
    float northWestZ = -(mazeLength + depth); // this would make the southern most edge about depth units away from z-axis
    
    // coordinate of the center of the top left cell
    float startX = northWestX + halfCellWidth;
    float startZ = northWestZ + halfCellWidth;
    
    // y position for all walls
    float wallY = 0; // so the feet of the wall is on 0
    
    for (int row = 0; row < rows; row++)
    {
        float z = startZ + row * cellWidth;
        for (int col = 0; col < cols; col++)
        {
            float x = startX + col * cellWidth;
            MazeCell cell = mazeGenerator -> GetCell(row, col);
            if (cell.northWallPresent)
            {
                float wallX = x;
                float wallZ = z - halfCellWidth + halfWallWidth;
                GLKMatrix4 transformation = [Transformations createModelViewMatrixWithTranslation:GLKVector3Make(wallX, wallY, wallZ) Rotation:0 RotationAxis:GLKVector3Make(0, 0, 0) Scale:westToEastWallScale];
                [self makeWall3D: transformation];
            }
            
            if (cell.southWallPresent)
            {
                float wallX = x;
                float wallZ = z + halfCellWidth - halfWallWidth;
                GLKMatrix4 transformation = [Transformations createModelViewMatrixWithTranslation:GLKVector3Make(wallX, wallY, wallZ) Rotation:0 RotationAxis:GLKVector3Make(0, 0, 0) Scale:westToEastWallScale];
                [self makeWall3D: transformation];
            }
            
            if (cell.westWallPresent)
            {
                float wallX = x - halfCellWidth + halfWallWidth;
                float wallZ = z;
                GLKMatrix4 transformation = [Transformations createModelViewMatrixWithTranslation:GLKVector3Make(wallX, wallY, wallZ) Rotation:0 RotationAxis:GLKVector3Make(0, 0, 0) Scale:northToSouthWallScale];
                [self makeWall3D: transformation];
            }
            
            if (cell.eastWallPresent)
            {
                float wallX = x + halfCellWidth - halfWallWidth;
                float wallZ = z;
                GLKMatrix4 transformation = [Transformations createModelViewMatrixWithTranslation:GLKVector3Make(wallX, wallY, wallZ) Rotation:0 RotationAxis:GLKVector3Make(0, 0, 0) Scale:northToSouthWallScale];
                [self makeWall3D: transformation];
            }
            
            
        }
    }
    
    // create the floor
    @autoreleasepool {
        float floorLength = mazeLength * 2;
        GLKMatrix4 transformation = [Transformations createModelViewMatrixWithTranslation:GLKVector3Make(0, wallY - wallHeight / 2, -5) Rotation:0 RotationAxis:GLKVector3Make(0, 0, 0) Scale:GLKVector3Make(floorLength, 0.01, floorLength)];
        
        GameObject *obj = [[GameObject alloc] init];
        [obj setupVertShader:@"RedShader.vsh" AndFragShader:@"RedShader.fsh"];
        [obj loadModels:@"Cube"];
        [obj loadTransformation:transformation];
        
        [_walls3D addObject:obj];
    }
     
}

// make a 3D wall and add it to the _walls3D array
- (void) makeWall3D: (GLKMatrix4) transform
{
    @autoreleasepool {
        GameObject *obj = [[GameObject alloc] init];
        [obj setupVertShader:@"TextureShader.vsh" AndFragShader:@"TextureShader.fsh"];
        [obj loadModels:@"Cube"];
        [obj loadTransformation:transform];
        [obj loadTexture:@"brick.jpg"];
        [_walls3D addObject:obj];
        
    }
}
@end
