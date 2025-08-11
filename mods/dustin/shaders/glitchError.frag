#pragma header

uniform float iTime;

void main()
{
    vec2 uv = openfl_TextureCoordv;

    // Horizontal RGB glitch
    float glitch = sin(iTime * 10.0) * 0.005;

    vec4 col;
    col.r = flixel_texture2D(bitmap, uv + vec2(glitch, 0.0)).r;
    col.g = flixel_texture2D(bitmap, uv).g;
    col.b = flixel_texture2D(bitmap, uv - vec2(glitch, 0.0)).b;
    col.a = 1.0;

    // Optional scanline effect
    float scanline = sin(uv.y * 800.0 * 4.0 + iTime * 20.0) * 0.05;
    col.rgb -= scanline;

    gl_FragColor = col;
}
