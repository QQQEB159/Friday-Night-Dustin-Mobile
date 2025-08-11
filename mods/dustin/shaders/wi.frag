#pragma header

uniform float iTime;
uniform float glitchModifier;
uniform vec3 iResolution;
uniform bool moveScreenFullX;
uniform bool moveScreenX;
uniform bool moveScreenFullY;
uniform float fullglitch;
uniform bool working;
uniform float timeMulti;
uniform float effectMulti;

vec3 mod289(vec3 x) {
    return x - floor(x * (1.0 / 289.0)) * 289.0;
}

vec2 mod289(vec2 x) {
    return x - floor(x * (1.0 / 289.0)) * 289.0;
}

vec3 permute(vec3 x) {
    return mod289(((x*34.0)+1.0)*x);
}

float snoise(vec2 v)
{
        const vec4 C = vec4(0.211324865405187,  // (3.0-sqrt(3.0))/6.0
                0.366025403784439,  // 0.5*(sqrt(3.0)-1.0)
                -0.577350269189626,  // -1.0 + 2.0 * C.x
                0.024390243902439); // 1.0 / 41.0

    // First corner
    vec2 i  = floor(v + dot(v, C.yy) );
    vec2 x0 = v -   i + dot(i, C.xx);

    // Other corners
    vec2 i1;
    //i1.x = step( x0.y, x0.x ); // x0.x > x0.y ? 1.0 : 0.0
    //i1.y = 1.0 - i1.x;
    i1 = (x0.x > x0.y) ? vec2(1.0, 0.0) : vec2(0.0, 1.0);
    // x0 = x0 - 0.0 + 0.0 * C.xx ;
    // x1 = x0 - i1 + 1.0 * C.xx ;
    // x2 = x0 - 1.0 + 2.0 * C.xx ;
    vec4 x12 = x0.xyxy + C.xxzz;
    x12.xy -= i1;

    // Permutations
    i = mod289(i); // Avoid truncation effects in permutation
    vec3 p = permute( permute( i.y + vec3(0.0, i1.y, 1.0 ))
            + i.x + vec3(0.0, i1.x, 1.0 ));

    vec3 m = max(0.5 - vec3(dot(x0,x0), dot(x12.xy,x12.xy), dot(x12.zw,x12.zw)), 0.0);
    m = m*m ;
    m = m*m ;

    // Gradients: 41 points uniformly over a line, mapped onto a diamond.
    // The ring size 17*17 = 289 is close to a multiple of 41 (41*7 = 287)

    vec3 x = 2.0 * fract(p * C.www) - 1.0;
    vec3 h = abs(x) - 0.5;
    vec3 ox = floor(x + 0.5);
    vec3 a0 = x - ox;

    // Normalise gradients implicitly by scaling m
    // Approximation of: m *= inversesqrt( a0*a0 + h*h );
    m *= 1.79284291400159 - 0.85373472095314 * ( a0*a0 + h*h );

    // Compute final noise value at P
    vec3 g;
    g.x  = a0.x  * x0.x  + h.x  * x0.y;
    g.yz = a0.yz * x12.xz + h.yz * x12.yw;
    return (fullglitch * 130) * dot(m, g);
}

float onOff(float a, float b, float c)
{
    return step(c, sin(iTime + a*cos(iTime*b)));
}

float ramp(float y, float start, float end)
{
    float inside = step(start,y) - step(end,y);
    float fact = (y-start)/(end-start)*inside;
    return (1.-fact) * inside;
}

vec4 getVideo(vec2 uv)
{
    vec2 look = uv;

    if (moveScreenFullX) {
        float time = (iTime * 2.0);
        
        // Create large, incidental noise waves
        float noise2 = max(0.0, snoise(vec2(time, uv.y * 0.3)) - 0.3) * (1.0 / 0.7);
        
        // Offset by smaller, constant noise waves
        noise2 = noise2 + (snoise(vec2(time*10.0, uv.y * 2.4)) - 0.5) * 0.15;
        
        // Apply the noise as x displacement for every line
        float xpos = uv.x - noise2 * noise2 * 0.25;

        look = vec2(xpos, uv.y);
    }

    float window = 1./(1.+20.*(look.y-mod(iTime/4.,1.))*(look.y-mod(iTime/4.,1.)));
    if (moveScreenX) {
        look.x = look.x + (sin(look.y*10. + iTime)/50.*onOff((4. * timeMulti),(4. * timeMulti),(.3 * timeMulti))*(1.+cos(iTime*80.))*window)*(glitchModifier*2);
    }
    

    float vShift = 0.4*onOff((2. * timeMulti),(3. * timeMulti),(.9 * timeMulti))*(sin((iTime * effectMulti))*sin((iTime * effectMulti)*20.) + (0.5 + 0.1*sin((iTime * effectMulti)*200.)*cos((iTime * effectMulti))));
    if (moveScreenFullY) {
        look.y = mod(look.y + vShift*glitchModifier, 1.);
    }
    
    vec4 video = flixel_texture2D(bitmap,look);

    return video;
}

float random(vec2 uv)
{
    return fract(sin(dot(uv, vec2(15.5151, 42.2561))) * 12341.14122 * sin(iTime * 0.03));
}

float noise(vec2 uv)
{
    vec2 i = floor(uv);
    vec2 f = fract(uv);

    float a = random(i);
    float b = random(i + vec2(1.,0.));
    float c = random(i + vec2(0., 1.));
    float d = random(i + vec2(1.));

    vec2 u = smoothstep(0., 1., f);

    return mix(a,b, u.x) + (c - a) * u.y * (1. - u.x) + (d - b) * u.x * u.y;
}


vec2 scandistort(vec2 uv) {
    float scan1 = clamp(cos(uv.y * 2.0 + iTime), 0.0, 1.0);
    float scan2 = clamp(cos(uv.y * 2.0 + iTime + 4.0) * 10.0, 0.0, 1.0) ;
    float amount = scan1 * scan2 * uv.x;

    return uv;
}

void main()
{
    if (working) {
        vec2 uv = openfl_TextureCoordv;

        uv = scandistort(uv);
        vec4 video = getVideo(uv);
        
        gl_FragColor = video;
    } else {
        vec2 uv = openfl_TextureCoordv;
        gl_FragColor = flixel_texture2D(bitmap,uv);
    }
}