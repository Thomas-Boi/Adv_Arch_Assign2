//
//  GameObject.h
//  WizQuest
//
//  Created by socas on 2021-02-23.
//


#ifndef GameObject_h
#define GameObject_h

#import <GLKit/GLKit.h>
#import "GLESRenderer.hpp"
#import "UniformEnum.h"
#import <Foundation/Foundation.h>

@interface GameObject : NSObject
@property(readonly) int _id;
@property GLKMatrix4 modelMatrix;
@property GLKMatrix4 modelViewMatrix;
@property GLKMatrix3 normalMatrix;

// diffuse lighting parameters
//@property GLKVector4 diffuseLightPosition;
//@property GLKVector4 diffuseComponent;

// VAO and index buffer
@property(readonly) GLuint vertexArray;
@property(readonly) GLuint indexBuffer;
@property(readonly) GLuint numIndices;

// shaders
@property(readonly) GLint *uniforms;
@property(readonly) GLuint programObject;
@property(readonly) GLuint texture;

// creating the objects
- (bool)setupVertShader:(NSString *) vShaderName AndFragShader:(NSString *) fShaderName;
- (void)loadModels:(NSString *)modelName;
- (void)loadModelMatrix:(GLKMatrix4) modelMatrix;
- (void)loadTexture:(NSString *)textureFileName;

// lifecyces
- (void)update;
- (void)updateWithViewMatrix:(GLKMatrix4) viewMatrix;

@end
#endif /* GameObject_h */
