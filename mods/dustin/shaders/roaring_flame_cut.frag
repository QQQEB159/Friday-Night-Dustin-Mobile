#pragma header

uniform float time;
uniform float intensitiy;
uniform float zoom;

vec3 rgb2hsv(vec3 c) {
    vec4 K = vec4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
    vec4 p = mix(vec4(c.bg, K.wz), vec4(c.gb, K.xy), step(c.b, c.g));
    vec4 q = mix(vec4(p.xyw, c.r), vec4(c.r, p.yzx), step(p.x, c.r));

    float d = q.x - min(q.w, q.y);
    float e = 1.0e-10;
    return vec3(abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
}

vec3 hsv2rgb(vec3 c) {
    vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
    vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
    return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}

float rand(vec2 n) {
    return fract(sin(cos(dot(n, vec2(12.9898,12.1414)))) * 83758.5453);
}

float noise(vec2 n) {
    const vec2 d = vec2(0.0, 1.0);
    vec2 b = floor(n), f = smoothstep(vec2(0.0), vec2(1.0), fract(n));
    return mix(mix(rand(b), rand(b + d.yx), f.x), mix(rand(b + d.xy), rand(b + d.yy), f.x), f.y);
}

float fbm(vec2 n) {
    float total = 0.0, amplitude = 1.0;
    for (int i = 0; i <5; i++) {
        total += noise(n) * amplitude;
        n += n*1.7;
        amplitude *= 0.47;
    }
    return total;
}

const vec3 c1 = vec3(0.5, 0.0, 0.1);
const vec3 c2 = vec3(0.9, 0.1, 0.0);
const vec3 c3 = vec3(0.2, 0.1, 0.7);
const vec3 c4 = vec3(1.0, 0.9, 0.1);
const vec3 c5 = vec3(0.1);
const vec3 c6 = vec3(0.9);

void main() {
    vec2 speed = vec2(2.4, 0.3);
    float shift = 1.327+sin(time*2.0)/2.4;
    
	float dist = 8.5-sin(time*0.4)/1.89;
    
    vec2 p = (gl_FragCoord.xy*zoom) * dist / openfl_TextureSize.xx;
    p.x -= time/1.1;
    p.y = 1.0-p.y;
    float q = fbm(p - time * 0.08 + 1.0 * sin(time * 2.0) / 5.0);
    float qb = fbm(p - time * 0.02 + 0.1 * cos(time * 2.0) / 2.5);
    float q2 = fbm(p - time * 1.0 - 5.0 * cos(time * 1.5) / 3.5) - 6.0;
    float q3 = fbm(p - time * 2.0 - 10.0 * cos(time * 1.5) / 15.0) - 4.0;
    float q4 = fbm(p - time * 3.5 - 20.0 * sin(time * 2.0) / 10.0) + 2.0;

    q = (q + qb - .4 * q2 -2.0*q3  + .6*q4)/3.8;
    vec2 r = vec2(fbm(p + q /2.0 + time * speed.x - p.x - p.y), fbm(p + q - time * speed.y));
    vec3 c = mix(c1, c2, fbm(p + r)) + mix(c3, c4, r.x) - mix(c5, c6, r.y);
    vec3 color = c * (0.7 + 0.3 * cos(shift * gl_FragCoord.y / openfl_TextureSize.y));

    color += .05;
    color.r *= .9;
    vec3 hsv = rgb2hsv(color*intensitiy);
    hsv.y *= clamp(hsv.z, 0.6, 1.2);
hsv.z *= clamp(hsv.y, 0.6, 1.2);

    color = hsv2rgb(hsv);

    float verticalFade = (gl_FragCoord.y / openfl_TextureSize.y) - 0.3;
    verticalFade = clamp(verticalFade, 0.0, 0.7);


    color *= verticalFade;

    gl_FragColor = vec4(color, intensitiy * verticalFade);

}