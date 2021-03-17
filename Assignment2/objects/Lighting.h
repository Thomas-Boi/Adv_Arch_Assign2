//
//  Lighting.h
//  Assignment2
//
//  Created by Sebastian Bejm on 2021-03-16.
//

#ifndef Lighting_h
#define Lighting_h

#import <GLKit/GLKit.h>
#import "GLESRenderer.hpp"
#import "UniformEnum.h"
#import <Foundation/Foundation.h>

@interface Lighting : NSObject

@property(readonly) int _id;
@property GLKMatrix4 modelViewMatrix;
@property GLKMatrix3 normalMatrix;

// VAO and index buffer
@property(readonly) GLuint vertexArray;
@property(readonly) GLuint indexBuffer;
@property(readonly) GLuint numIndices;

// shaders
@property(readonly) GLint *uniforms;
@property(readonly) GLuint programObject;

// creating the objects
- (bool)setupVertShader:(NSString *) vShaderName AndFragShader:(NSString *) fShaderName;
- (void)loadModels:(NSString *)modelName;
- (void)loadTransformation:(GLKMatrix4) transformation;
- (void)loadTexture:(NSString *)textureFileName;

// lifecyces
- (void)update;
- (void)updateWithTransformation:(GLKMatrix4) transformation;

@end
#endif
