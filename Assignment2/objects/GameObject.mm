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
    
    // Model
    float *vertices, *normals, *texCoords;
    GLuint *indices;
    
    // VAO and VBO buffers
    GLuint vertexArray;
    GLuint vertexBuffers[3];
    GLuint indexBuffer;
    
    // Lighting parameters
    // ### Add lighting parameter variables here...
    
}
@end

@implementation GameObject
// props
@synthesize _id;
@synthesize modelMatrix;
@synthesize modelViewMatrix;
@synthesize normalMatrix;

// lighting
@synthesize diffuseLightPosition;
@synthesize diffuseComponent;

@synthesize vertexArray;
@synthesize indexBuffer;
@synthesize numIndices;

// shaders
@synthesize programObject;
@synthesize texture;

- (GLint *) uniforms
{
    return _uniforms;
}


// methods
// get the model info from GLESRenderer then bind it to the vertexArray
// property
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
    _uniforms[UNIFORM_LIGHT_SPECULAR_POSITION] = glGetUniformLocation(programObject, "specularLightPosition");
    _uniforms[UNIFORM_LIGHT_DIFFUSE_POSITION] = glGetUniformLocation(programObject, "diffuseLightPosition");
    _uniforms[UNIFORM_LIGHT_DIFFUSE_COMPONENT] = glGetUniformLocation(programObject, "diffuseComponent");
    _uniforms[UNIFORM_LIGHT_SHININESS] = glGetUniformLocation(programObject, "shininess");
    _uniforms[UNIFORM_LIGHT_SPECULAR_COMPONENT] = glGetUniformLocation(programObject, "specularComponent");
    _uniforms[UNIFORM_LIGHT_AMBIENT_COMPONENT] = glGetUniformLocation(programObject, "ambientComponent");
    _uniforms[UNIFORM_USE_FOG] = glGetUniformLocation(programObject, "useFog");
    
    // Set up lighting parameters
    // ### Set default lighting parameter values here...

    return true;
}

// bind the texture file to the object
- (void)loadTexture:(NSString *)textureFileName
{
    // Load texture to apply and set up texture in GL
    texture = [self setupTexture:textureFileName];
    glActiveTexture(GL_TEXTURE0); // set texture 0 to be active
    // uniforms[UNIFORM_TEXTURE] will store the sampler2D
    // 0 is the number of texture.
    glUniform1i(_uniforms[UNIFORM_TEXTURE], 0);
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

// load the transformation for the GameObject
- (void)loadModelMatrix:(GLKMatrix4) modelMatrix
{
    self.modelMatrix = modelMatrix;
    normalMatrix = GLKMatrix3InvertAndTranspose(GLKMatrix4GetMatrix3(modelMatrix), NULL);
    modelViewMatrix = modelMatrix;
}

- (void)setDiffuseLightPosition:(GLKVector4)diffuseLightPosition DiffuseComponent: (GLKVector4)component
{
    self.diffuseLightPosition = diffuseLightPosition;
    self.diffuseComponent = component;
}

- (void)setDefaultDiffuseLight
{
    [self setDiffuseLightPosition:GLKVector4Make(0, 1, 0, 1) DiffuseComponent:GLKVector4Make(255/255.0f, 255/255.0f, 255/255.0f, 1.0)];
}


// lifecycle
// update the object every draw cycle
// this should be implemented by the child classes
- (void)update
{
    
    
}

// update the object every draw cycle.
// Also set its new transformation
// this should be implemented by the child classes
- (void)updateWithViewMatrix:(GLKMatrix4) viewMatrix
{
    modelViewMatrix = GLKMatrix4Multiply(viewMatrix, modelMatrix);
}


// deallocate the object
- (void)dealloc
{
    glDeleteProgram(programObject);
}
@end

