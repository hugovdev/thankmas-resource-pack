#define ALPHA(value) if(alpha == value) return true;

#define EMISSIVE bool checkEmissive(int alpha) {
#define UNLIT return false; } bool checkUnlit(int alpha) {
#define NO_NORMAL_SHADING return false; } bool checkNoNormalShading(int alpha) {
#define HALF_EMISSIVE return false; } bool checkHalfEmissive(int alpha) {

#define END_CONFIG return false; }

#moj_import <emissives_config.glsl>

int getAlpha(float a) {
    return int(a * 255.5);
}

vec4 applyLighting(int alpha, vec4 albedo, vec4 normalLighting, vec4 lightmap) {
    if(checkUnlit(alpha)) {
        albedo.a = 1.0;
        return albedo;
    }

    if(checkNoNormalShading(alpha)) {
        albedo.a = 1.0;
        return albedo * lightmap;
    }

    if(checkEmissive(alpha)) {
        albedo.a = 1.0;
        return albedo * normalLighting;
    }

    if(checkHalfEmissive(alpha)) {
        albedo.a = 1.0;
        return albedo * mix(normalLighting * lightmap, vec4(1.0), 0.5);
    }

    return albedo * normalLighting * lightmap;
}