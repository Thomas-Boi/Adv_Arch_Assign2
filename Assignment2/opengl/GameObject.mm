//
//  GameObject.m
//  WizQuest
//
//  Created by socas on 2021-02-23.
//

#import "GameObject.h"

@interface GameObject()
{
    GLESRenderer glesRenderer; // use the cube for now
    GLint _uniforms[NUM_UNIFORMS];
}
@end

@implementation GameObject
// props
@synthesize _id;
@synthesize programObject;
@synthesize modelViewMatrix;
@synthesize normalMatrix;
@synthesize vertices;
@synthesize normals;
@synthesize texCoords;
@synthesize indices;
@synthesize numIndices;
- (GLint *) uniforms
{
    return _uniforms;
}


// methods
- (void)loadModels:(NSString *)modelName
{
    // numIndices = glesRenderer.GenCube(1.0f, &vertices, &normals, &texCoords, &indices);
} 

// attach the shaders to the program object
// also initialize the programObject
- (bool)setupVertShader:(NSString *) vShaderName AndFragShader:(NSString *) fShaderName
{
    char *vShaderStr = glesRenderer.LoadShaderFile([[[NSBundle mainBundle] pathForResource:[vShaderName stringByDeletingPathExtension] ofType:[vShaderName pathExtension]] cStringUsingEncoding:1]);
    char *fShaderStr = glesRenderer.LoadShaderFile([[[NSBundle mainBundle] pathForResource:[fShaderName stringByDeletingPathExtension] ofType:[fShaderName pathExtension]] cStringUsingEncoding:1]);
    programObject = glesRenderer.LoadProgram(vShaderStr, fShaderStr);
    if (programObject == 0)
        return false;
    
    // Set up uniform variables so we can access it with ease
    _uniforms[UNIFORM_MODELVIEWPROJECTION_MATRIX] = glGetUniformLocation(programObject, "modelViewProjectionMatrix");
    _uniforms[UNIFORM_NORMAL_MATRIX] = glGetUniformLocation(programObject, "normalMatrix");
    _uniforms[UNIFORM_PASSTHROUGH] = glGetUniformLocation(programObject, "passThrough");
    _uniforms[UNIFORM_SHADEINFRAG] = glGetUniformLocation(programObject, "shadeInFrag");
    _uniforms[UNIFORM_TEXTURE] = glGetUniformLocation(programObject, "texSampler");

    return true;
}


// Load in and set up texture image (adapted from Ray Wenderlich)
- (GLuint)setupTexture:(NSString *)fileName
{
    CGImageRef spriteImage = [UIImage imageNamed:fileName].CGImage;
    if (!spriteImage) {
        NSLog(@"Failed to load image %@", fileName);
        exit(1);
    }
    
    size_t width = CGImageGetWidth(spriteImage);
    size_t height = CGImageGetHeight(spriteImage);
    
    GLubyte *spriteData = (GLubyte *) calloc(width*height*4, sizeof(GLubyte));
    
    CGContextRef spriteContext = CGBitmapContextCreate(spriteData, width, height, 8, width*4, CGImageGetColorSpace(spriteImage), kCGImageAlphaPremultipliedLast);
    
    CGContextDrawImage(spriteContext, CGRectMake(0, 0, width, height), spriteImage);
    
    CGContextRelease(spriteContext);
    
    GLuint texName;
    glGenTextures(1, &texName);
    glBindTexture(GL_TEXTURE_2D, texName);
    
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
    
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, (int)width, (int)height, 0, GL_RGBA, GL_UNSIGNED_BYTE, spriteData);
    
    free(spriteData);
    return texName;
}

- (void)loadTransformation:(GLKMatrix4) transformation
{
    modelViewMatrix = transformation;
    normalMatrix = GLKMatrix3InvertAndTranspose(GLKMatrix4GetMatrix3(modelViewMatrix), NULL);
    
}

// lifecycle
- (void)dealloc
{
    glDeleteProgram(programObject);
}
@end

