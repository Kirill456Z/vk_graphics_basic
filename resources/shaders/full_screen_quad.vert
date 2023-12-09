#version 450
#extension GL_ARB_separate_shader_objects : enable

layout (location = 0 ) out VS_OUT
{
  vec2 texCoord;
} vOut;

void main()
{
    if (gl_VertexIndex == 0) {
        vOut.texCoord = vec2 (0.0, 0.0);
        gl_Position = vec4 (-1.0f, -1.0f, 0.0f, 1.0f);
    }
    if (gl_VertexIndex == 1) {
        vOut.texCoord = vec2 (2.0, 0.0);
        gl_Position = vec4 (3.0f, -1.0f, 0.0f, 1.0f);
    }
    if (gl_VertexIndex == 2) {
        vOut.texCoord = vec2 (0.0, 2.0);
        gl_Position = vec4 (-1.0f, 3.0f, 0.0f, 1.0f);
    }
}