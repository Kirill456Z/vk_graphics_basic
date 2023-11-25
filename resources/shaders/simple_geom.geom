#version 450

layout(triangles) in;
layout(triangle_strip, max_vertices = 18) out;

layout(push_constant) uniform params_t
{
    mat4 mProjView;
    mat4 mModel;
    float timer;
} params;

layout(location = 0) in VS_OUT
{
    vec3 wPos;
    vec3 wNorm;
    vec3 wTangent;
    vec2 texCoord;
} vOut[];

layout(location = 0) out GS_OUT
{
    vec3 wPos;
    vec3 wNorm;
    vec3 wTangent;
    vec2 texCoord;
} gOut;

vec3 move_vertex(vec3 pos, vec3 move, float time) {
    if (abs(pos.y) > 1.1 || abs(pos.x) > 1.1) {
      return pos;
    }
    float add = max(sin(3.0 * time + 3.0 * pos.y), 0);
    vec3 res = pos + move * add * 0.1;
    return res;
}

void main()
{
    for (int j = 0; j < gl_in.length() / 3; j++) {
        int i = j * 3;
        vec3 v1_pos = move_vertex(vOut[i].wPos, vOut[i].wNorm, params.timer);
        vec3 v2_pos = move_vertex(vOut[i + 1].wPos, vOut[i+1].wNorm, params.timer);
        vec3 v3_pos = move_vertex(vOut[i + 2].wPos, vOut[i+2].wNorm, params.timer);

        gOut.wPos = v1_pos;
        gOut.wNorm = vOut[i].wNorm;
        gl_Position = params.mProjView * vec4(gOut.wPos, 1.0);
        EmitVertex();

        gOut.wPos = v2_pos;
        gOut.wNorm = vOut[i+1].wNorm;
        gl_Position = params.mProjView * vec4(gOut.wPos, 1.0);
        EmitVertex();

        gOut.wPos = v3_pos;
        gOut.wNorm = vOut[i+2].wNorm;
        gl_Position = params.mProjView * vec4(gOut.wPos, 1.0);
        EmitVertex();

        EndPrimitive();
    }
}