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
@property(readonly) GLuint programObject;
@property(readonly) GLKMatrix4 modelViewMatrix;
@property(readonly) GLKMatrix3 normalMatrix;
@property(readonly) float *vertices;
@property(readonly) float *normals;
@property(readonly) float *texCoords;
@property(readonly) int *indices;
@property(readonly) int numIndices;
@property(readonly) GLint *uniforms;

- (bool)setupVertShader:(NSString *) vShaderName AndFragShader:(NSString *) fShaderName;
- (void)loadModels:(NSString *)modelName;
- (void)loadTransformation:(GLKMatrix4) transformation;
@end
#endif /* GameObject_h */
