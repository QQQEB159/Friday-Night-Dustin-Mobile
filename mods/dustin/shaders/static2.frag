// shader from lunar: https://github.com/Dewott2501/Mario-Madness/blob/main/source/TitleScreenShaders.hx#L183-L226

#pragma header

uniform float iTime;
uniform float strengthMulti;

const float maxStrength = .5;
const float minStrength = 0.3;

const float speed = 2.00;

float random (vec2 noise) {
    return fract(sin(dot(noise.xy,vec2(10.998,98.233)))*12433.14159265359);
}

void main() {
    vec2 uv = openfl_TextureCoordv.xy;
    vec2 uv2 = fract(openfl_TextureCoordv.xy*fract(sin(iTime*speed)));
    
    float _maxStrength = clamp(sin(iTime/2.0),minStrength,maxStrength) * strengthMulti;
    
    vec3 colour = vec3(random(uv2.xy) - 0.1)*_maxStrength;
    vec4 flixel = flixel_texture2D(bitmap, uv);
    vec3 background = vec3(flixel);
    
    gl_FragColor = vec4(background-colour, flixel.a);
}