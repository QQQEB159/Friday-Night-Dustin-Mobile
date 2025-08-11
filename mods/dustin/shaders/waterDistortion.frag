#pragma header

//  Heat Distortion (ported, cleaned and edited by Nex_isDumb and chezzar)
//  Original by Peace: https://www.shadertoy.com/view/XsVSRd

uniform float time;
uniform float strength;

float rand(vec2 n)
{
    return fract(sin(dot(n, vec2(12.9898, 4.1414))) * 43758.5453);
}

float noise(vec2 n)
{
    const vec2 d = vec2(0.0, 1.0);
    vec2 b = floor(n), f = smoothstep(vec2(0.0), vec2(1.0), fract(n));
    return mix(mix(rand(b), rand(b + d.yx), f.x), mix(rand(b + d.xy), rand(b + d.yy), f.x), f.y);
}

void main()
{
    vec2 p_d = openfl_TextureCoordv;

    p_d.y += time * 0.1;
    vec2 dst_offset = (vec4(noise(p_d * vec2(30))).xy - vec2(0.3, 0.3)) * strength * 0.03;

    gl_FragColor = flixel_texture2D(bitmap, openfl_TextureCoordv.st + dst_offset);
}
