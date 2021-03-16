//
//  Wall2D.m
//  Assignment2
//
//  Created by socas on 2021-03-15.
//

#import "Wall2D.h"

@interface Wall2D()
{
    
}
@end

@implementation Wall2D

- (void)makeNorthWall
{
    GLKMatrix4 scaledTransform = GLKMatrix4Scale(super.modelViewMatrix, 1, 0.25, 1);
    [super loadTransformation:scaledTransform];
}

- (void)makeSouthWall
{
    GLKMatrix4 scaledTransform = GLKMatrix4Scale(super.modelViewMatrix, 1, 0.25, 1);
    [super loadTransformation:scaledTransform];
}

- (void)makeWestWall
{
    
}

- (void)makeEastWall
{
    
}

@end
