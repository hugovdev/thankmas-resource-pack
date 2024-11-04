#version 150

// stolen from https://github.com/bradleyq/shader-toolkit

#moj_import <fog.glsl>

in vec3 Position;
in vec2 UV0;
in vec4 Color;
in vec3 Normal;

uniform mat4 ModelViewMat;
uniform mat4 ProjMat;
uniform int FogShape;

out vec2 texCoord0;
out float vertexDistance;
out vec4 vertexColor;
out vec3 normal;
out float yval;

float slide(float val , float start, float end) {
    return clamp((val - start) / (end - start), 0.0, 1.0);
}

void main() {
    gl_Position = ProjMat * ModelViewMat * vec4(Position, 1.0);

    texCoord0 = UV0;
    vertexDistance = fog_distance((ModelViewMat * vec4(Position, 1.0)).xyz, FogShape);

    // try the flatten the cloud shading as much as possible
    vec4 col = vec4(mix(Color.rgb, vec3(1.0), 0.9), 0.8);

    vertexColor = col;
    normal = Normal;

    yval = 0.0;

    int faceVert = gl_VertexID % 4;
    if (((faceVert == 1 || faceVert == 2) && abs(dot(normal, vec3(1.0, 0.0, 0.0))) > 0.99)
      ||((faceVert == 0 || faceVert == 1) && abs(dot(normal, vec3(0.0, 0.0, 1.0))) > 0.99)){
        yval = 1.0;
    }

    if (dot(normal, vec3(0.0, 1.0, 0.0)) > 0.99) {
        yval = 1.0;
    }
}