//
//  GameManager.m
//  WizQuest
//
//  Created by socas on 2021-02-23.
//

#import "GameManager.h"


@interface GameManager()
{
    Renderer *renderer;
    ObjectTracker *tracker;
    MazeManager *mazeManager;
}

@end

@implementation GameManager

@synthesize display2DMap;

- (void) initManager:(GLKView *)view
{
    renderer = [[Renderer alloc] init];
    [renderer setup:view];
    tracker = [[ObjectTracker alloc] init];
    
    mazeManager = [[MazeManager alloc] init];
    [mazeManager createMazeWithRows:4 Columns:4 Depth:7];
    [self loadObjects];
    
    display2DMap = false;
}

// add the player, platforms, and enemies to the tracker
- (void) loadObjects
{
    @autoreleasepool {
        GLKMatrix4 cubeTransform = [Transformations createModelMatrixWithTranslation:GLKVector3Make(0.0, -1.0, -7.0) Rotation:0.0 RotationAxis:GLKVector3Make(1.0, 0.0, 0.0) Scale:GLKVector3Make(1.0, 1.0, 1.0)];
        Cube *cube = [self createCube:@"playerModel" VertShader:@"TextureShader.vsh" FragShader:@"TextureShader.fsh" Transformation:cubeTransform];
        [cube initRotation];
        [tracker addObject:cube];
        
        for (GameObject *wall in mazeManager.walls3D) {
            [tracker addObject: wall];
        }
    }
}

// create a cube here. Need the model, shaders, and its
// initial transformation (position, rotation, scale)
- (Cube *) createCube:(NSString *) modelName VertShader:(NSString *) vShaderName FragShader:(NSString *) fShaderName Transformation:(GLKMatrix4) transformations
{
    @autoreleasepool {
        Cube *obj = [[Cube alloc] init];
        [obj setupVertShader:vShaderName AndFragShader:fShaderName];
        [obj loadModels:modelName];
        [obj loadModelMatrix:transformations];
        [obj loadTexture:@"crate.jpg"];
        [obj setDefaultDiffuseLight];
        return obj;
    }
}

// add object during run time here
- (void) addObject:(GameObject *) obj
{

}

- (void)setIsFoggy:(bool) newIsFoggy
{
    [renderer setIsFoggy:newIsFoggy];
}

- (void)setIsDay:(bool) newIsDay
{
    [renderer setIsDay:newIsDay];
}

// update the player movement and slide the platform here
- (void) update:(GLKMatrix4) viewMatrix
{
    for (GameObject *object in tracker.objects)
    {
        [object updateWithViewMatrix:viewMatrix];
    }
    
}

- (void) draw
{
    [renderer clear];

    for (GameObject *obj in tracker.objects)
    {
        [renderer draw:obj];
    }
    
    if (display2DMap)
    {
        glClear(GL_DEPTH_BUFFER_BIT);
        [self draw2DMaze];
        //return;
    }
}

- (void)draw2DMaze
{
    for (GameObject *wall in mazeManager.walls2D)
    {
        [renderer draw:wall];
    }
}

@end
