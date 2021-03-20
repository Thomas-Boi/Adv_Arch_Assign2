// fragment shader. this does nothing rn
#version 300 es

precision highp float;

in vec3 eyeNormal;
in vec4 eyePos;
in vec2 texCoordOut;

out vec4 fragColor;

uniform sampler2D texSampler;

// ### Set up lighting parameters as uniforms
//uniforms for lighting parameters
uniform vec4 specularLightPosition;
uniform vec4 diffuseLightPosition;
uniform vec4 diffuseComponent;
uniform float shininess;
uniform vec4 specularComponent;
uniform vec4 ambientComponent;
uniform bool useFog;

void main()
{
    // ### Calculate phong model using lighting parameters and interpolated values from vertex shader
    // ambient lighting calculation
    vec4 ambient = ambientComponent;

    // diffuse lighting calculation
    vec3 N = normalize(eyeNormal);
    float nDotVP = max(0.0, dot(N, normalize(diffuseLightPosition.xyz)));
    vec4 diffuse = diffuseComponent * nDotVP;
    
    // specular lighting calculation
    vec3 E = normalize(-eyePos.xyz);
    vec3 L = normalize(specularLightPosition.xyz - eyePos.xyz);
    vec3 H = normalize(L+E);
    float Ks = pow(max(dot(N, H), 0.0), shininess);
    vec4 specular = Ks*specularComponent;
    if( dot(L, N) < 0.0 ) {
        // if the dot product is negative, this is a fragment on the other side of the object and hence not affected by the specular light
        specular = vec4(0.0, 0.0, 0.0, 1.0);
    }

    // Regular textured simplified Phong
    fragColor = ambient + specular;
    fragColor = fragColor * texture(texSampler, texCoordOut);
    
    if (useFog)
    {
        // Fog effect added (linear)
        float fogDist = (gl_FragCoord.z / gl_FragCoord.w);
        vec4 fogColour = vec4(1.0, 1.0, 1.0, 1.0);
        float fogFactor = (10.0 - fogDist) / (10.0 - 1.0);
        fogFactor = clamp(fogFactor, 0.0, 1.0);
        fragColor = mix(fogColour, fragColor, fogFactor);
    }
    
    // ### Modify this next line to modulate texture with calculated phong shader values
    //fragColor = texture(texSampler, texCoordOut);
    fragColor.a = 1.0;
}

