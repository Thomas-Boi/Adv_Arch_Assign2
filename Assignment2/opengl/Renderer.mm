//
//  Copyright © Borna Noureddin. All rights reserved.
//

#import "Renderer.h"
#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>
#include <chrono>
#include "GLESRenderer.hpp"



//===========================================================================
//  GL uniforms, attributes, etc.

// List of uniform values used in shaders
#define BUFFER_OFFSET(i) ((char *)NULL + (i))

//===========================================================================
//  Class interface
@interface Renderer () {

    // iOS hooks
    GLKView *theView;

    GLKMatrix4 projectionMatrix;
    
    // Lighting parameters
    // ### Add lighting parameter variables here...
    //GLKVector4 specularLightPosition;
    //GLKVector4 specularComponent;
    //GLfloat shininess;
    //GLKVector4 ambientComponent;
}

@end

//===========================================================================
//  Class implementation
@implementation Renderer

@synthesize useFog;

//=======================
// Initial setup of GL using iOS view
//=======================
- (void)setup:(GLKView *)view
{
    // Create GL context
    view.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES3];
    if (!view.context) {
        NSLog(@"Failed to create ES context");
    }

    // Set up context
    view.drawableDepthFormat = GLKViewDrawableDepthFormat24;
    theView = view;
    [EAGLContext setCurrentContext:view.context];

    // Fog uniforms
    useFog = 0;
    
    // Set up lighting values
    //specularComponent = GLKVector4Make(0.8f, 0.1f, 0.1f, 1.0f);
    //specularLightPosition = GLKVector4Make(0.0f, 0.0f, 1.0f, 1.0f);
    //shininess = 1000.0f;
    //ambientComponent = GLKVector4Make(0.2f, 0.2f, 0.2f, 1.0f);
    //objects[0].diffuseLightPosition = GLKVector4Make(0.0f, 1.0f, 0.0f, 1.0f);
    //objects[0].diffuseComponent = GLKVector4Make(0.1f, 0.8f, 0.1f, 1.0f);
    //objects[1].diffuseLightPosition = GLKVector4Make(-2.0f, 1.0f, 0.0f, 1.0f);
    //objects[1].diffuseComponent = GLKVector4Make(0.0f, 1.0f, 0.0f, 1.0f);
    
    // Initialize GL color and other parameters
    glClearColor ( 0.0f, 0.0f, 0.0f, 0.0f );
    glEnable(GL_DEPTH_TEST);
    
    // Setup blending
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    glEnable(GL_BLEND);
    
    // Calculate projection matrix
    float aspect = fabsf((float)(theView.bounds.size.width / theView.bounds.size.height));
    projectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(65.0f), aspect, 0.1f, 100.0f);
    
}

- (void)clear
{
    // Clear window
    glClearColor(0.0f, 0.0f, 0.0f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
}

//=======================
// Draw calls for each frame
//=======================
- (void)draw:(GameObject *) obj
{
    
    // Select VAO
    glBindVertexArray(obj.vertexArray);
    
    // select the shader program
    glUseProgram(obj.programObject);
    
    // Select IBO (index buffer object) and draw
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, obj.indexBuffer);
    
    // select the texture
    glBindTexture(GL_TEXTURE_2D, obj.texture);
    
    // Set up uniforms for the shaders
    GLKMatrix4 modelViewProjectionMatrix = GLKMatrix4Multiply(projectionMatrix, obj.modelViewMatrix);

    // pass on global lighting, fog and texture values
    //glUniform4fv(obj.uniforms[UNIFORM_LIGHT_SPECULAR_POSITION], 1, specularLightPosition.v);
    //glUniform1i(obj.uniforms[UNIFORM_LIGHT_SHININESS], shininess);
    //glUniform4fv(obj.uniforms[UNIFORM_LIGHT_SPECULAR_COMPONENT], 1, specularComponent.v);
    //glUniform4fv(obj.uniforms[UNIFORM_LIGHT_AMBIENT_COMPONENT], 1, ambientComponent.v);
    glUniform1i(obj.uniforms[UNIFORM_USE_FOG], useFog);
    
    // ### Set values for lighting parameter uniforms here...
    //glUniform4fv(obj.uniforms[UNIFORM_LIGHT_DIFFUSE_POSITION], 1, obj.diffuseLightPosition.v);
    //glUniform4fv(obj.uniforms[UNIFORM_LIGHT_DIFFUSE_COMPONENT], 1, obj.diffuseComponent.v);
    
    glUniformMatrix4fv(obj.uniforms[UNIFORM_MODELVIEWPROJECTION_MATRIX], 1, 0, modelViewProjectionMatrix.m);
    glUniformMatrix3fv(obj.uniforms[UNIFORM_NORMAL_MATRIX], 1, 0, obj.normalMatrix.m);

    glDrawElements(GL_TRIANGLES, obj.numIndices, GL_UNSIGNED_INT, 0);
    
}

@end

