#version 300 es

layout(location = 0) in vec4 position;
layout(location = 1) in vec3 normal;
out vec4 v_color;

uniform mat4 modelViewProjectionMatrix;

void main()
{
    // Simple passthrough shader
    v_color = vec4(1, 1, 1, 0.25); // white

    gl_Position = modelViewProjectionMatrix * position;
}
