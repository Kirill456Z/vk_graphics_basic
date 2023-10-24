#version 450
#extension GL_ARB_separate_shader_objects : enable

layout(location = 0) out vec4 color;

layout (binding = 0) uniform sampler2D colorTex;

layout (location = 0 ) in VS_OUT
{
  vec2 texCoord;
} surf;

void sort_inplace(inout vec4 pixels[9]) {
  for (int iter1 = 0; iter1 < 9; iter1++) {
    for (int iter2 = 0; iter2 < 8 - iter1; iter2 ++) {
      vec4 buf1 = pixels[iter1];
      vec4 buf2 = pixels[iter2 + 1];
      pixels[iter1] = min(buf1, buf2);
      pixels[iter2+1]  = max(buf1, buf2);
    }
  }
}

void main()
{
  vec4 pixels[9];
  pixels[0] = textureLod(colorTex, surf.texCoord, 0);
  pixels[1] = textureLodOffset(colorTex, surf.texCoord, 0, ivec2(0,  1));
  pixels[2] = textureLodOffset(colorTex, surf.texCoord, 0, ivec2(0,  -1));
  pixels[3] = textureLodOffset(colorTex, surf.texCoord, 0, ivec2(-1,  1));
  pixels[4] = textureLodOffset(colorTex, surf.texCoord, 0, ivec2(-1,  0));
  pixels[5] = textureLodOffset(colorTex, surf.texCoord, 0, ivec2(-1,  -1));
  pixels[6] = textureLodOffset(colorTex, surf.texCoord, 0, ivec2(1,  1));
  pixels[7] = textureLodOffset(colorTex, surf.texCoord, 0, ivec2(1,  0));
  pixels[8] = textureLodOffset(colorTex, surf.texCoord, 0, ivec2(1,  -1));

  sort_inplace(pixels);

  color = pixels[4];
}
