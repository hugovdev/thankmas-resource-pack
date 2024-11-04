#version 150

#moj_import <light_config.glsl>

#define MINECRAFT_LIGHT_POWER   (0.6)
#define MINECRAFT_AMBIENT_LIGHT (0.4)

float getPerFaceLighting(vec3 normalWS) {
    return dot(abs(normalWS) * vec3(0.6, 0.75 + 0.25 * sign(normalWS.y), 0.8), vec3(1.0));
}

vec4 minecraft_mix_light(vec3 lightDir0, vec3 lightDir1, vec3 normal, vec4 color) {
    lightDir0 = normalize(lightDir0);
    lightDir1 = normalize(lightDir1);
    float light0 = max(0.0, dot(lightDir0, normal));
    float light1 = max(0.0, dot(lightDir1, normal));
    float lightAccum = min(1.0, (light0 + light1) * MINECRAFT_LIGHT_POWER + MINECRAFT_AMBIENT_LIGHT);
    return vec4(color.rgb * lightAccum, color.a);
}

vec4 minecraft_sample_lightmap(sampler2D lightMap, ivec2 uv) {
    return texture(lightMap, clamp(uv / 256.0, vec2(0.5 / 16.0), vec2(15.5 / 16.0)));
}

vec4 minecraft_sample_lightmap_custom(sampler2D lightMap, ivec2 uv, inout float faceLighting) {
    #ifdef CUSTOM_LIGHTING
    faceLighting = mix(faceLighting, 1.0, uv.x / 256.0);
    #endif
    return texture(lightMap, clamp(uv / 256.0, vec2(0.5 / 16.0), vec2(15.5 / 16.0)));
}