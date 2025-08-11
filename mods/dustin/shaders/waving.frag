#pragma header

uniform float time;
uniform float strength;
uniform float speed;

float ns;
float sFract(float x, float sm){
    const float sf = 1.; 
    vec2 u = vec2(x, fwidth(x)*sf*sm);
    u.x = fract(u.x);
    u += (1. - 2.*u)*step(u.y, u.x);
    return clamp(1. - u.x/u.y, 0., 1.); // Cos term ommitted.
}
float sFloor(float x){ return x - sFract(x, 1.);} 
vec3 hash33(vec3 p){ 
    float n = sin(dot(p, vec3(7, 157, 113)));    
    return fract(vec3(2097152, 262144, 32768)*n)*2. - 1.; // return fract(vec3(64, 8, 1)*32768.0*n)*2.-1.; 
}
float tetraNoise(in vec3 p){
    vec3 i = floor(p + dot(p, vec3(1./3.)) );  p -= i - dot(i, vec3(1./6.));
    vec3 i1 = step(p.yzx, p), i2 = max(i1, 1. - i1.zxy); i1 = min(i1, 1. - i1.zxy);    
    vec3 p1 = p - i1 + 1./6., p2 = p - i2 + 1./3., p3 = p - .5;
    vec4 v = max(.5 - vec4(dot(p, p), dot(p1, p1), dot(p2, p2), dot(p3, p3)), 0.);
    vec4 d = vec4(dot(p, hash33(i)), dot(p1, hash33(i + i1)), dot(p2, hash33(i + i2)), dot(p3, hash33(i + 1.)));
    return clamp(dot(d, v*v*v*8.)*1.732 + .5, 0., 2.); // Not sure if clamping is necessary. Might be overkill.
}
float func(vec2 p){
    float n = tetraNoise(vec3(p.x*4., p.y*4., 0) - vec3(0, .25, .5)*time);
    float taper = .0 + dot(p, p*vec2(.35, 1));
    n = max(n - taper, 0.)/max(1. - taper, .0000);
    ns = n; 
    const float palNum = 100.; 
    return n*.25 + clamp(sFloor(n*(palNum - .001))/(palNum - 1.), 0., 1.)*.75;
}

float coolNoise() {
    vec2 u = (gl_FragCoord.xy)/openfl_TextureSize.y;
    float f = func(u);
    float ssd = ns; 
    return f*.4 + ssd*.6;;
}

void main() {
    vec2 uv = openfl_TextureCoordv.xy;

    float noise = coolNoise() * 0.03;

    float waveX = (abs(sin(uv.y * 4.0 + time * speed))*.9) + (cos(uv.y * 7.0 + time * speed * 3.0)*.3)*noise;
    float waveY = (abs(cos(uv.x * 4.0 + time * speed))*.4) + (cos(uv.y * 3.0 + time * speed * 6.0)*.2) + sin(uv.y * 4.0 + time * speed);

    waveX = (floor(waveX * 10.0) / 30.0);
    waveY = (floor(waveY * 30.0) / 60.0)*.3;

    vec2 offset = vec2(waveX, waveY) * strength * (0.02 + (noise*0.07));
    gl_FragColor = flixel_texture2D(bitmap, uv + offset);
}