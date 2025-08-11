#pragma header
uniform float time;
uniform float threshold;

const vec2 center = vec2(0.5, 0.5);

const int nsamples = 130;

vec4 preproccess_tex(vec2 uv) {

    uv.x += sin(time + (uv.y*4.0)) * 0.001;
    uv.y += cos(time + (uv.x*4.0)) * 0.001;
    if (float(flixel_texture2D(bitmap, uv).rgb) > threshold)  {
        vec4 col = vec4(1.0);
        col.r *= 255./255.;
        col.g *= 241./255.;
        col.b *= 255./255.;
        return col;
    }
    
    return vec4(0.0);
}

// Algorithm found in https://medium.com/community-play-3d/god-rays-whats-that-5a67f26aeac2
vec4 crepuscular_rays(vec2 texCoords, vec2 pos) {
    float decay = 0.83;
    float density = .94;

    float weight = 0.3 + sin(time)*.02; 

    vec2 tc = texCoords.xy;
    vec2 deltaTexCoord = tc - pos.xy;
    deltaTexCoord *= (1.0 / float(nsamples) * density);
    float illuminationDecay = 1.0;

    vec4 color = preproccess_tex(tc.xy) * vec4(0.1);
	
    tc += deltaTexCoord * (fract( sin(dot(texCoords.xy, vec2(12.9898, 78.233)))* 43758.5453) * .9);
    for (int i = 0; i < nsamples; i++)
	{
        tc -= deltaTexCoord;
        vec4 sampl = preproccess_tex(tc.xy) * vec4(0.4);

        sampl *= illuminationDecay * weight;
        color += sampl;
        illuminationDecay *= decay;
    }
    
    return color;
}

void main()
{
    vec2 uv = openfl_TextureCoordv;

    vec4 col = preproccess_tex(uv) + crepuscular_rays(uv, vec2(0.5+ cos(time+.32/2)*.04, 0.3 + sin(time/2)*.03));

    gl_FragColor = col;
}