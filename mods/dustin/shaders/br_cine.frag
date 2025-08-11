#pragma header

uniform float time;

void main() 
{
    vec2 uv = openfl_TextureCoordv.xy;
    vec4 col = flixel_texture2D(bitmap, uv);

    gl_FragColor = col;
}