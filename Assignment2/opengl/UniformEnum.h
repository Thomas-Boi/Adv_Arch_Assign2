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
    UNIFORM_TEXTURE,
    UNIFORM_MODELVIEW_MATRIX,
    // ### Add uniforms for lighting parameters here...
    //UNIFORM_LIGHT_SPECULAR_POSITION,
    //UNIFORM_LIGHT_DIFFUSE_POSITION,
    //UNIFORM_LIGHT_DIFFUSE_COMPONENT,
    //UNIFORM_LIGHT_SHININESS,
    //UNIFORM_LIGHT_SPECULAR_COMPONENT,
    //UNIFORM_LIGHT_AMBIENT_COMPONENT,
    UNIFORM_USE_FOG,
    NUM_UNIFORMS
} UniformEnum;

#endif /* UniformEnum_h */
