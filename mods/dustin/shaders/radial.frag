// https://www.shadertoy.com/view/XsfSDs
#pragma header

uniform float blur;
uniform vec2 center;

const int nsamples = 15;

void main()
{
	vec2 uv = openfl_TextureCoordv;
    uv -= center;

    vec4 color = flixel_texture2D(bitmap, openfl_TextureCoordv);
    if (blur <= 0.0) {
        gl_FragColor = color;
        return;
    }

    float precompute = blur * (1.0 / float(nsamples - 1));
    for(int i = 1; i < nsamples; i++) {
        float scale = 1.0 + (float(i)* precompute);
        color += flixel_texture2D(bitmap, uv * scale + center);
    }
    color /= float(nsamples);
    
	gl_FragColor = color;
}