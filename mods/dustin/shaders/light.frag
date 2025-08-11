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

float ns;

// Improved derivative approximation
float approxDerivative(float x) {
    vec2 uv = gl_FragCoord.xy / res;
    float eps = 1.0 / max(res.x, res.y);
    float x1 = fract(x);
    float x2 = fract(x + eps);
    return abs(x2 - x1) / eps * 2.0; // Increased multiplier for better results
}

float sFract(float x, float sm) {
    const float sf = 5.0; 
    float fw = approxDerivative(x);
    vec2 u = vec2(x, fw*sf*sm);
    u.x = fract(u.x);
    u += (1.0 - 2.0*u)*step(u.y, u.x);
    return clamp(1.0 - u.x/u.y, 0.0, 1.0);
}

float sFloor(float x) { 
    return x - sFract(x, 1.0); 
} 

// Optimized hash function
vec3 hash33(vec3 p) { 
    p = fract(p * 0.3183099 + 0.1);
    p *= 17.0;
    return fract(p.xzy * p.yxz) * 2.0 - 1.0;
}

// Improved tetrahedral noise
float tetraNoise(in vec3 p) {
    vec3 i = floor(p + dot(p, vec3(0.33333333)));  
    p -= i - dot(i, vec3(0.16666666));
    vec3 i1 = step(p.yzx, p), i2 = max(i1, 1.0 - i1.zxy); 
    i1 = min(i1, 1.0 - i1.zxy);    
    vec3 p1 = p - i1 + 0.16666666, p2 = p - i2 + 0.33333333, p3 = p - 0.5;
    vec4 v = max(0.5 - vec4(dot(p, p), dot(p1, p1), dot(p2, p2), dot(p3, p3)), 0.0);
    vec4 d = vec4(dot(p, hash33(i)), dot(p1, hash33(i + i1)), dot(p2, hash33(i + i2)), dot(p3, hash33(i + 1.0)));
    return clamp(dot(d, v*v*v*8.0)*1.732 + 0.5, 0.0, 1.0); // Clamped to 0-1 range
}

float func(vec2 p) {
    float n = tetraNoise(vec3(p.x*4.0, p.y*4.0, 0.0) - vec3(0.0, 0.25, 0.5)*time);
    float taper = 0.1 + dot(p, p*vec2(0.35, 1.0)); // Increased base taper
    n = max(n - taper, 0.0)/max(1.0 - taper, 0.00001);
    ns = n; 
    const float palNum = 50.0; // Reduced palette steps for smoother look
    return n*0.25 + clamp(sFloor(n*(palNum - 0.001))/(palNum - 1.0), 0.0, 1.0)*0.75;
}

float coolNoise() {
    vec2 u = (gl_FragCoord.xy - res.xy*0.4)/res.y;
    float f = func(u);
    float ssd = ns; 
    return f*0.4 + ssd*0.6;
}

const mat3 p = mat3(13.323122,23.5112,21.71123,21.1212,28.7312,11.9312,21.8112,14.7212,61.3934);

uniform int LAYERS;
uniform float DEPTH;
uniform float WIDTH;
uniform float SPEED;

void main() {
    vec2 trueFragCoord = gl_FragCoord.xy;
    vec2 centeredPixel = trueFragCoord - res.xy * 0.5;
    vec2 zoomedCenteredPixel = centeredPixel * (1.0/(cameraZoom + 1.0));
    vec2 pixel = zoomedCenteredPixel + res.xy * 0.5 + cameraPosition.xy;
    vec2 uvCentered = (2.0 * pixel / res.y);
    if (flipY) uvCentered.y *= -1.0;
    
    // Improved melt calculation
    float meltiness = smoothstep(0.0, 1.0, 1.0 - (pixel.y-snowMeltRect.y)/snowMeltRect.w);
    if (pixel.y >= snowMeltRect.y + snowMeltRect.w) meltiness = 0.0;
    
    vec3 acc = vec3(0.0);
    float dof = 5.0*sin(time*0.1);
    
    // Optimized snow layers
    const int MAX_LAYERS = 30; // Reduced for performance
    for (int i=STARTING_LAYERS; i<MAX_LAYERS; i++) {
        if (i >= LAYERS) break;
        float fi = float(i);
        vec2 q = uvCentered*(1.0+fi*DEPTH*0.8); // Reduced depth effect
        q += vec2(0.0, SPEED*time/(1.0 + fi*DEPTH*0.03));
        vec3 n = vec3(floor(q),31.189+fi);
        vec3 m = floor(n)*0.00001 + fract(n);
        vec3 mp = (31415.9+m)/fract(p*m);
        vec3 r = fract(mp);
        vec2 s = abs(mod(q,1.0)-0.5+0.9*r.xy-0.45);
        s += 0.01*abs(2.0*fract(10.0*q.yx)-1.0); 
        float d = 0.6*max(s.x-s.y,s.x+s.y)+max(s.x,s.y)-0.01;
        float edge = 0.005+0.05*min(0.5*abs(fi-5.0-dof),1.0);
        acc += vec3(smoothstep(edge,-edge,d)*(r.x/(1.0+0.05*fi*DEPTH))); // Increased depth attenuation
    }
    
    vec4 rect = vec4(snowMeltRect.x, snowMeltRect.y, snowMeltRect.z, snowMeltRect.w);
    if (snowMelts && pixel.x >= rect.x && pixel.x < rect.x + rect.z && pixel.y >= rect.y) {
        acc *= meltiness * meltiness; // Squared for better melt transition
    }
    
    vec4 flixelColor = texture2D(bitmap, openfl_TextureCoordv);
    float noiseFactor = coolNoise() * 0.4;
    vec3 snowColor = acc * vec3(1.0, 1.0, 0.8) * (0.7 + noiseFactor); // Adjusted colors
    gl_FragColor = flixelColor + vec4(snowColor, flixelColor.a * 0.8); // Better blending
}