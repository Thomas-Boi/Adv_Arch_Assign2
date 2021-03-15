//
//  UniformEnum.h
//  WizQuest
//
//  Created by socas on 2021-02-26.
//

#ifndef UniformEnum_h
#define UniformEnum_h

// Uniform index.
// hold important data as seen below
// these values are constant across all
// passes between the vertex and frag shader
typedef enum
{
    UNIFORM_MODELVIEWPROJECTION_MATRIX,
    UNIFORM_NORMAL_MATRIX,
    UNIFORM_PASSTHROUGH,
    UNIFORM_SHADEINFRAG,
    UNIFORM_TEXTURE,
    NUM_UNIFORMS
} UniformEnum;

#endif /* UniformEnum_h */
