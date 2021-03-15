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
@property GLKMatrix4 modelViewMatrix;
@property GLKMatrix3 normalMatrix;

// VAO and index buffer
@property(readonly) GLuint vertexArray;
@property(readonly) GLuint indexBuffer;
@property(readonly) GLuint numIndices;

// shaders
@property(readonly) GLint *uniforms;
@property(readonly) GLuint programObject;


- (bool)setupVertShader:(NSString *) vShaderName AndFragShader:(NSString *) fShaderName;
- (void)loadModels:(NSString *)modelName;
- (void)loadTransformation:(GLKMatrix4) transformation;
- (void)update;
- (void)updateWithTransformation:(GLKMatrix4) transformation;

@end
#endif /* GameObject_h */
