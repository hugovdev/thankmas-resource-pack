#version 150

#moj_import <fog.glsl>
#moj_import <emissives.glsl>

uniform sampler2D Sampler0;

uniform vec4 ColorModulator;
uniform float FogStart;
uniform float FogEnd;
uniform vec4 FogColor;

in float vertexDistance;
in vec4 vertexColor;
in vec4 lightColor;
in vec2 texCoord0;
in float diffuseLight;

out vec4 fragColor;

void main() {
    vec4 color = texture(Sampler0, texCoord0);
    int alpha = getAlpha(textureLod(Sampler0, texCoord0, 0).a);

#ifdef DISCARD
    if (color.a < DISCARD) discard;
#endif
    color *= vertexColor;
    
    color = applyLighting(alpha, color, vec4(vec3(diffuseLight), 1.0), lightColor) * ColorModulator;
    fragColor = linear_fog(color, vertexDistance, FogStart, FogEnd, FogColor);
}