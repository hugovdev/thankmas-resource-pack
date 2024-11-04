#version 150

#moj_import <light.glsl>
#moj_import <fog.glsl>

in vec3 Position;
in vec4 Color;
in vec2 UV0;
in ivec2 UV2;
in vec3 Normal;

uniform sampler2D Sampler2;

uniform mat4 ModelViewMat;
uniform mat4 ProjMat;
uniform vec3 ChunkOffset;
uniform int FogShape;

out float vertexDistance;
out vec4 vertexColor;
out vec4 lightColor;
out vec2 texCoord0;
out float diffuseLight;

void main() {
    vec3 pos = Position + ChunkOffset;
    gl_Position = ProjMat * ModelViewMat * vec4(pos, 1.0);

    diffuseLight = max(Color.g, Color.b);
    vertexDistance = fog_distance(pos, FogShape);
    vertexColor = vec4(Color.rgb / diffuseLight, Color.a);
    lightColor = minecraft_sample_lightmap_custom(Sampler2, UV2, diffuseLight);
    texCoord0 = UV0;
}