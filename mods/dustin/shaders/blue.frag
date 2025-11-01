// SHADER MODDED BY LUNAR (YOU CAN USE THIS FOR WHATEVER IDC!!!!!)
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

float sFract(float x, float sm){
    const float sf = 1.; 
    
    // Replaced fwidth(x) with a manual approximation based on screen resolution.
    // fwidth(x) is not available in all GLSL versions, so we use 1.0 / res.y
    // as a constant approximation for the screen-space derivative.
    vec2 u = vec2(x, (1.0 / res.y) * sf * sm);
    
    u.x = fract(u.x);
    u += (1. - 2.*u)*step(u.y, u.x);
    return clamp(1. - u.x/u.y, 0., 1.);
}
float sFloor(float x){ return x - sFract(x, 1.); } 
vec3 hash33(vec3 p){ 
    float n = sin(dot(p, vec3(7, 157, 113)));    

    return fract(vec3(2097152.0, 262144.0, 32768.0)*n)*2. - 1.; 
}
float tetraNoise(in vec3 p){
    vec3 i = floor(p + dot(p, vec3(1./3.)) );  p -= i - dot(i, vec3(1./6.));
    vec3 i1 = step(p.yzx, p), i2 = max(i1, 1. - i1.zxy); i1 = min(i1, 1. - i1.zxy);    
    vec3 p1 = p - i1 + 1./6., p2 = p - i2 + 1./3., p3 = p - .5;
    vec4 v = max(.5 - vec4(dot(p, p), dot(p1, p1), dot(p2, p2), dot(p3, p3)), 0.);
    vec4 d = vec4(dot(p, hash33(i)), dot(p1, hash33(i + i1)), dot(p2, hash33(i + i2)), dot(p3, hash33(i + 1.)));

    return clamp(dot(d, v*v*v*8.)*1.732 + .5, 0., 2.);
}
float func(vec2 p){
    float n = tetraNoise(vec3(p.x*4., p.y*4., 0.0) - vec3(0, .25, .5)*time);
    float taper = .0 + dot(p, p*vec2(.35, 1.0)); 
	n = max(n - taper, 0.)/max(1. - taper, .0000);
    ns = n; 
    const float palNum = 100.; 
    return n*.25 + clamp(sFloor(n*(palNum - .001))/(palNum - 1.), 0., 1.)*.75;
}

float coolNoise() {
    vec2 u = (gl_FragCoord.xy - openfl_TextureSize.xy*.4)/openfl_TextureSize.y;
    float f = func(u);
    float ssd = ns; 
    return f*.4 + ssd*.6;;
}

uniform int LAYERS;
uniform float DEPTH;
uniform float WIDTH;
uniform float SPEED;

const mat3 p = mat3(13.323122,23.5112,21.71123,21.1212,28.7312,11.9312,21.8112,14.7212,61.3934);

void main()
{
	vec2 trueFragCoord = gl_FragCoord.xy * (res / openfl_TextureSize);

    vec2 centeredPixel = trueFragCoord - res.xy * 0.5;
    vec2 zoomedCenteredPixel = centeredPixel * (1.0/(cameraZoom + 1.));
    vec2 pixel = zoomedCenteredPixel + res.xy * 0.5 + cameraPosition.xy;

	vec2 uvCentered = (2.0 * (pixel) / (res.y));
    if (flipY) uvCentered.y *= -1.0;
	
	float meltiness = abs(1.0-((pixel.y-snowMeltRect.y)/snowMeltRect.w));

	if (pixel.y >= snowMeltRect.y + snowMeltRect.w) meltiness = 0.0;

	vec3 acc = vec3(0.0);
	float dof = 5.*sin(time*.1);
	for (int i=STARTING_LAYERS;i<LAYERS;i++) {
		float fi = float(i);
		vec2 q = uvCentered*(1.+fi*DEPTH);
		q += vec2(0.0, SPEED*time/(1. + fi*DEPTH*.03));
		vec3 n = vec3(floor(q),31.189+fi);
		vec3 m = floor(n)*.00001 + fract(n);
		vec3 mp = (31415.9+m)/fract(p*m);
		vec3 r = fract(mp);
		vec2 s = abs(mod(q,1.0)-.5+.9*r.xy-.45);
		s += .01*abs(2.0*fract(10.0*q.yx)-1.0); 
		float d = .6*max(s.x-s.y,s.x+s.y)+max(s.x,s.y)-.01;
		float edge = .005+.05*min(.5*abs(fi-5.0-dof),1.0); 
		acc += vec3(smoothstep(edge,-edge,d)*(r.x/(1.0+.02*fi*DEPTH)));
	}

	vec4 rect = vec4((snowMeltRect.x / openfl_TextureSize.x) * res.x,
        (snowMeltRect.y / openfl_TextureSize.y) * res.y,
        (snowMeltRect.z / openfl_TextureSize.x) * res.x,
        (snowMeltRect.w / openfl_TextureSize.y) * res.y);
	rect.xy += openfl_TextureSize.xy-res.xy;

	if (snowMelts && ((pixel.x >= rect.x) && (pixel.x < rect.x + rect.z) && (pixel.y >= rect.y)))
		acc *= meltiness;

    vec4 flixelColor = flixel_texture2D(bitmap, openfl_TextureCoordv.xy);

	gl_FragColor = flixelColor + vec4(acc * vec3(0.4, 0.7, 1.5) * 1.0 * (2.0 + (coolNoise() * 0.4)), flixelColor.a);
}
