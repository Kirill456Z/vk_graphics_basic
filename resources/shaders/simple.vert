#version 450
#extension GL_ARB_separate_shader_objects : enable
#extension GL_GOOGLE_include_directive : require

#include "unpack_attributes.h"


layout(location = 0) in vec4 vPosNorm;
layout(location = 1) in vec4 vTexCoordAndTang;

layout(push_constant) uniform params_t
{
    mat4 mProjView;
    mat4 mModel;
} params;


layout (location = 0 ) out VS_OUT
{
    vec3 wPos;
    vec3 wNorm;
    vec3 wTangent;
    vec2 texCoord;

} vOut;

layout(std430, binding = 1) readonly buffer InstanceTransforms {
    mat4 instance_transforms[];
};

layout(std430, binding = 2) readonly buffer VisibleInstanceIndices {
    uint visible_instances[];
};


out gl_PerVertex { vec4 gl_Position; };
void main(void)
{
    mat4 currentModel = instance_transforms[visible_instances[gl_InstanceIndex]];
    //mat4 currentModel = params.mModel;

    const vec4 wNorm = vec4(DecodeNormal(floatBitsToInt(vPosNorm.w)),         0.0f);
    const vec4 wTang = vec4(DecodeNormal(floatBitsToInt(vTexCoordAndTang.z)), 0.0f);

    vOut.wPos     = (currentModel * vec4(vPosNorm.xyz, 1.0f)).xyz;
    vOut.wNorm    = normalize(mat3(transpose(inverse(currentModel))) * wNorm.xyz);
    vOut.wTangent = normalize(mat3(transpose(inverse(currentModel))) * wTang.xyz);
    vOut.texCoord = vTexCoordAndTang.xy;

    gl_Position   = params.mProjView * vec4(vOut.wPos, 1.0);
}
