//
//  GameObject.m
//  WizQuest
//
//  Created by socas on 2021-02-23.
//

#import "GameObject.h"
// List of vertex attributes
enum
{
    ATTRIB_POSITION,
    ATTRIB_NORMAL,
    ATTRIB_TEXTURE_COORDINATE,
    NUM_ATTRIBUTES
};

#define BUFFER_OFFSET(i) ((char *)NULL + (i))



@interface GameObject()
{
    // shader
    GLESRenderer glesRenderer; // use the cube for now
    GLint _uniforms[NUM_UNIFORMS];
    GLuint crateTexture;
    
    // Model
    float *vertices, *normals, *texCoords;
    GLuint *indices;
    
    // VAO and VBO buffers
    GLuint vertexArray;
    GLuint vertexBuffers[3];
    GLuint indexBuffer;
    
    
}
@end

@implementation GameObject
// props
@synthesize _id;
@synthesize modelViewMatrix;
@synthesize normalMatrix;

@synthesize vertexArray;
@synthesize indexBuffer;
@synthesize numIndices;

// shaders
@synthesize programObject;
- (GLint *) uniforms
{
    return _uniforms;
}


// methods
- (void)loadModels:(NSString *)modelName
{
    // Create VAOs
    glGenVertexArrays(1, &vertexArray);
    glBindVertexArray(vertexArray);

    // Create VBOs
    glGenBuffers(NUM_ATTRIBUTES, vertexBuffers);   // One buffer for each attribute (position, tex, normal). See the uniforms at the top
    glGenBuffers(1, &indexBuffer);                 // Index buffer

    // Generate vertex attribute values from model
    int numVerts;
    numIndices = glesRenderer.GenCube(1.0f, &vertices, &normals, &texCoords, &indices, &numVerts);

    // Set up VBOs...
    
    // Position
    glBindBuffer(GL_ARRAY_BUFFER, vertexBuffers[0]);
    glBufferData(GL_ARRAY_BUFFER, sizeof(GLfloat)*3*numVerts, vertices, GL_STATIC_DRAW);
    glEnableVertexAttribArray(ATTRIB_POSITION);
    glVertexAttribPointer(ATTRIB_POSITION, 3, GL_FLOAT, GL_FALSE, 3*sizeof(float), BUFFER_OFFSET(0));
    
    // Normal vector
    glBindBuffer(GL_ARRAY_BUFFER, vertexBuffers[1]);
    glBufferData(GL_ARRAY_BUFFER, sizeof(GLfloat)*3*numVerts, normals, GL_STATIC_DRAW);
    glEnableVertexAttribArray(ATTRIB_NORMAL);
    glVertexAttribPointer(ATTRIB_NORMAL, 3, GL_FLOAT, GL_FALSE, 3*sizeof(float), BUFFER_OFFSET(0));
    
    // Texture coordinate
    glBindBuffer(GL_ARRAY_BUFFER, vertexBuffers[2]);
    glBufferData(GL_ARRAY_BUFFER, sizeof(GLfloat)*3*numVerts, texCoords, GL_STATIC_DRAW);
    glEnableVertexAttribArray(ATTRIB_TEXTURE_COORDINATE);
    glVertexAttribPointer(ATTRIB_TEXTURE_COORDINATE, 2, GL_FLOAT, GL_FALSE, 2*sizeof(float), BUFFER_OFFSET(0));
    
    
    // Set up index buffer
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, indexBuffer);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(int)*numIndices, indices, GL_STATIC_DRAW);
    
    // Reset VAO
    glBindVertexArray(0);
    
    // Load texture to apply and set up texture in GL
    crateTexture = [self setupTexture:@"crate.jpg"];
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, crateTexture);
    // uniforms[UNIFORM_TEXTURE] will store the sampler2D
    // 0 is the number of texture.
    glUniform1i(_uniforms[UNIFORM_TEXTURE], 0);
    
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
    
    // Bind attribute locations.
    // This needs to be done prior to linking.
    glBindAttribLocation(programObject, ATTRIB_POSITION, "position");
    glBindAttribLocation(programObject, ATTRIB_NORMAL, "normal");
    glBindAttribLocation(programObject, ATTRIB_TEXTURE_COORDINATE, "texCoordIn");
    
    // Link shader program
    programObject = glesRenderer.LinkProgram(programObject);

    // Get uniform locations.
    _uniforms[UNIFORM_MODELVIEWPROJECTION_MATRIX] = glGetUniformLocation(programObject, "modelViewProjectionMatrix");
    _uniforms[UNIFORM_NORMAL_MATRIX] = glGetUniformLocation(programObject, "normalMatrix");
    _uniforms[UNIFORM_MODELVIEW_MATRIX] = glGetUniformLocation(programObject, "modelViewMatrix");
    _uniforms[UNIFORM_TEXTURE] = glGetUniformLocation(programObject, "texSampler");
    // ### Add lighting uniform locations here...

    // Set up lighting parameters
    // ### Set default lighting parameter values here...

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

