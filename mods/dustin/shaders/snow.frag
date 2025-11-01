// SHADER MODDED BY LUNAR - FIXED VERSION
#pragma header

uniform float time;
uniform vec2 res;
uniform float cameraZoom;
uniform vec2 cameraPosition;
uniform int STARTING_LAYERS;
uniform bool flipY;
uniform vec4 snowMeltRect;
uniform bool snowMelts;
uniform bool pixely;
uniform float BRIGHT;
uniform int LAYERS;
uniform float DEPTH;
uniform float WIDTH;
uniform float SPEED;

float ns;

float approxFwidth(float x) {
    vec2 uv = gl_FragCoord.xy / res;
    float eps = 1.0 / max(res.x, res.y);
    float x1 = fract(x);
    float x2 = fract(x + eps);
    return abs(x2 - x1) / eps * 2.0;
}

float sFract(float x, float sm) {
    const float sf = 1.0; 
    float fw = approxFwidth(x);
    vec2 u = vec2(x, fw*sf*sm);
    u.x = fract(u.x);
    u += (1.0 - 2.0*u)*step(u.y, u.x);
    return clamp(1.0 - u.x/u.y, 0.0, 1.0);
}

float sFloor(float x) { 
    return x - sFract(x, 1.0); 
} 

vec3 hash33(vec3 p) { 
    p = fract(p * 0.3183099 + 0.1);
    p *= 17.0;
    return fract(p.xzy * p.yxz) * 2.0 - 1.0;
}

float tetraNoise(in vec3 p) {
    vec3 i = floor(p + dot(p, vec3(0.33333333)));  
    p -= i - dot(i, vec3(0.16666666));
    vec3 i1 = step(p.yzx, p), i2 = max(i1, 1.0 - i1.zxy); 
    i1 = min(i1, 1.0 - i1.zxy);    
    vec3 p1 = p - i1 + 0.16666666, p2 = p - i2 + 0.33333333, p3 = p - 0.5;
    vec4 v = max(0.5 - vec4(dot(p, p), dot(p1, p1), dot(p2, p2), dot(p3, p3)), 0.0);
    vec4 d = vec4(dot(p, hash33(i)), dot(p1, hash33(i + i1)), dot(p2, hash33(i + i2)), dot(p3, hash33(i + 1.0)));
    return clamp(dot(d, v*v*v*8.0)*1.732 + 0.5, 0.0, 1.0);
}

float func(vec2 p) {
    float n = tetraNoise(vec3(p.x*4.0, p.y*4.0, 0.0) - vec3(0.0, 0.25, 0.5)*time);
    float taper = 0.1 + dot(p, p*vec2(0.35, 1.0));
    n = max(n - taper, 0.0)/max(1.0 - taper, 0.00001);
    ns = n; 
    const float palNum = 50.0;
    return n*0.25 + clamp(sFloor(n*(palNum - 0.001))/(palNum - 1.0), 0.0, 1.0)*0.75;
}

float coolNoise() {
    vec2 u = (gl_FragCoord.xy - openfl_TextureSize.xy*0.4)/openfl_TextureSize.y;
    float f = func(u);
    float ssd = ns; 
    return f*0.4 + ssd*0.6;
}

const mat3 p = mat3(13.323122,23.5112,21.71123,21.1212,28.7312,11.9312,21.8112,14.7212,61.3934);

float brightness(vec3 color) {
    return dot(color, vec3(0.299, 0.587, 0.114));
}

void main() {
    vec2 trueFragCoord = gl_FragCoord.xy * (res / openfl_TextureSize);
    vec2 centeredPixel = trueFragCoord - res.xy * 0.5;
    vec2 zoomedCenteredPixel = centeredPixel * (1.0/(cameraZoom + 1.0));
    vec2 pixel = zoomedCenteredPixel + res.xy * 0.5 + cameraPosition.xy;
    vec2 uvCentered = (2.0 * pixel / res.y);
    
    if (flipY) uvCentered.y *= -1.0;
    
    float meltiness = smoothstep(0.0, 1.0, 1.0 - (pixel.y-snowMeltRect.y)/snowMeltRect.w);
    if (pixel.y >= snowMeltRect.y + snowMeltRect.w) meltiness = 0.0;
    
    if (pixely) {
        uvCentered = floor(uvCentered / 0.009) * 0.009;
    }
    
    vec3 acc = vec3(0.0);
    float dof = 5.0*sin(time*0.1);
    
    // Fixed type conversion issues by casting to int
    int startingLayers = int(STARTING_LAYERS);
    int maxLayers = 5;
    int layers = int(LAYERS);
    
    for (int i = startingLayers; i < maxLayers; i++) {
        if (i >= layers) break;
        float fi = float(i);
        vec2 q = uvCentered*(1.0+fi*DEPTH);
        float widthMod = WIDTH * (pixely ? 1.5 : 1.0);
        q += vec2(q.y*(widthMod*mod(fi*7.238917,1.0)-widthMod*0.5) + 
                 (SPEED * ((float(layers)-fi)*0.2)*(time*0.4)),
                 SPEED*time/(1.0+fi*DEPTH*0.03));
        vec3 n = vec3(floor(q),31.189+fi);
        vec3 m = floor(n)*0.00001 + fract(n);
        vec3 mp = (31415.9+m)/fract(p*m);
        vec3 r = fract(mp);
        vec2 s = abs(mod(q,1.0)-0.5+0.9*r.xy-0.45);
        s += 0.01*abs(2.0*fract(10.0*q.yx)-1.0); 
        float d = 0.6*max(s.x-s.y,s.x+s.y)+max(s.x,s.y)-0.01;
        float edge = 0.005+0.05*min(0.5*abs(fi-5.0-dof),1.0);
        acc += vec3(smoothstep(edge,-edge,d)*(r.x/(1.0+0.02*fi*DEPTH))); // Fixed missing parenthesis here
    }
    
    if (snowMelts) {
        vec4 rect = vec4((snowMeltRect.x / openfl_TextureSize.x) * res.x,
                        (snowMeltRect.y / openfl_TextureSize.y) * res.y,
                        (snowMeltRect.z / openfl_TextureSize.x) * res.x,
                        (snowMeltRect.w / openfl_TextureSize.y) * res.y);
        rect.xy += openfl_TextureSize.xy-res.xy;
        
        if (pixel.x >= rect.x && pixel.x < rect.x + rect.z && pixel.y >= rect.y) {
            acc *= meltiness * meltiness;
        }
    }
    
    vec4 flixelColor = texture2D(bitmap, openfl_TextureCoordv);
    vec3 effect = acc * 0.8 * (0.6 + (coolNoise() * 0.4));
    effect *= (pixely ? 1.6 : 1.0) * BRIGHT;
    flixelColor.rgb += effect;
    
    // Fixed comparison with 0.0 instead of 0
    if (flixelColor.a == 0.0 && (effect.r > 0.0 || effect.g > 0.0 || effect.b > 0.0)) {
        flixelColor.a = brightness(effect);
    }
    
    gl_FragColor = flixelColor;
}