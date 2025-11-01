// SHADER MODDED BY LUNAR (YOU CAN USE THIS FOR WHATEVER IDC!!!!!)
// Optimized for performance on integrated graphics.
#pragma header

// --- Uniforms ---
uniform float time;
uniform vec2 res;

uniform float cameraZoom;
uniform vec2 cameraPosition;

uniform int STARTING_LAYERS;
uniform bool flipY; // Note: This uniform is not used in the original logic.

uniform bool pixely;
uniform float Wzoom;

uniform float BRIGHT;
uniform int LAYERS;
uniform float DEPTH;
uniform float WIDTH;
uniform float SPEED;

// --- Performance-Oriented Constants ---
// The maximum number of layers to render, regardless of the uniform.
// This is the most important setting for performance on low-end hardware.
const int MAX_PERFORMANCE_LAYERS = 8;

// --- Simplified Noise for Performance ---
// A much faster 2D gradient noise to replace the heavy tetraNoise.
vec2 hash2d(vec2 p) {
    p = vec2(dot(p, vec2(127.1, 311.7)), dot(p, vec2(269.5, 183.3)));
    return -1.0 + 2.0 * fract(sin(p) * 43758.5453123);
}

float simpleNoise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    vec2 u = f * f * (3.0 - 2.0 * f); // Smoothstep

    vec2 ga = hash2d(i + vec2(0.0, 0.0));
    vec2 gb = hash2d(i + vec2(1.0, 0.0));
    vec2 gc = hash2d(i + vec2(0.0, 1.0));
    vec2 gd = hash2d(i + vec2(1.0, 1.0));

    float n = mix(mix(dot(ga, f - vec2(0.0, 0.0)), dot(gb, f - vec2(1.0, 0.0)), u.x),
                  mix(dot(gc, f - vec2(0.0, 1.0)), dot(gd, f - vec2(1.0, 1.0)), u.x), u.y);
    return 0.5 + 0.5 * n;
}

// Generates a contoured noise pattern using the fast noise.
float getContourNoise(vec2 p) {
    // Use a faster noise function with a scale similar to the original.
    float n = simpleNoise(p * 4.0 - time * 0.25);
    
    // Apply a simple vignette/taper to fade noise at the edges.
    float taper = dot(p, p * vec2(0.35, 1.0));
    n = max(n - taper, 0.0) / max(1.0 - taper, 0.0001);

    // The sFract function is still relatively cheap and provides the contour effect.
    // We'll re-implement it here to avoid dependencies on the old code.
    float contour_levels = 100.0;
    float sFract_val = fract(n * contour_levels);
    float sFloor_val = (n * contour_levels - sFract_val) / contour_levels;
    
    return mix(sFloor_val, sFloor_val + 1.0 / contour_levels, smoothstep(0.0, 1.0, sFract_val));
}


// --- "Just Snow" Functions (Optimized) ---
// This function renders the multi-layered snow effect with simplified math.

// Calculates the accumulated color of all snow layers.
vec3 renderSnowLayers(vec2 uv, float time) {
    vec3 acc = vec3(0.0);
    
    // Clamp the number of layers to a performance-friendly maximum.
    int layerCount = min(LAYERS, MAX_PERFORMANCE_LAYERS);
    if (layerCount <= STARTING_LAYERS) {
        return vec3(0.0);
    }

    // Pre-calculate values outside the loop.
    float widthModifier = pixely ? 1.5 : 1.0;
    float dof = 0.5 * sin(time * 0.1); // Simplified DOF calculation

    for (int i = STARTING_LAYERS; i < layerCount; i++) {
        float fi = float(i);
        
        // Parallax scrolling
        vec2 q = uv * (1.0 + fi * DEPTH);
        
        // Add drift and movement
        float drift = (WIDTH * widthModifier) * (mod(fi * 7.238917, 1.0) - 0.5);
        q += vec2(q.y * drift, -(SPEED * time) / (1.0 + fi * DEPTH * 0.03));

        // Simplified hash for snowflake properties
        vec2 r = fract(sin(vec2(dot(q, vec2(127.1, 311.7)), dot(q, vec2(269.5, 183.3)))) * 43758.5453);

        // Simplified snowflake shape (a simple circle)
        vec2 s = abs(fract(q) - 0.5);
        float d = length(s) - 0.01 * r.x; // Use length for a circular shape
        
        // Simplified DOF edge calculation
        float edge = 0.005 + 0.05 * min(abs(fi - 5.0 - dof), 1.0);
        
        // Accumulate color
        float weight = r.y / (1.0 + 0.02 * fi * DEPTH);
        acc += vec3(smoothstep(edge, -edge, d) * weight);
    }
    return acc;
}

// --- Main Function ---
void main() {
    // Early exit if the effect is disabled.
    if (BRIGHT <= 0.0) {
        gl_FragColor = flixel_texture2D(bitmap, openfl_TextureCoordv.xy);
        return;
    }

    // --- Coordinate Transformation ---
    vec2 screenSize = openfl_TextureSize.xy;
    vec2 normalizedCoord = gl_FragCoord.xy / screenSize;
    vec2 ndc = normalizedCoord * 2.0 - 1.0;
    ndc /= cameraZoom;
    vec2 zoomedScreenCoord = (ndc + 1.0) * 0.5 * res;
    vec2 worldCoord = zoomedScreenCoord + cameraPosition;
    
    vec2 st = worldCoord.xy / res.xy;
    st *= res.xy / res.y;
    vec2 uv = st * Wzoom;

    // --- Render Effects ---
    // 1. Render the snow layers (now with a hard cap on performance).
    vec3 snowAccumulation = renderSnowLayers(uv, time);
    
    // 2. Generate the contour noise pattern (now using a fast noise function).
    float contourNoise = getContourNoise(uv);
    
    // 3. Combine effects.
    vec3 effectColor = snowAccumulation * 0.8 * (0.6 + contourNoise * 3.0);

    // --- Color Blending ---
    vec4 originalColor = flixel_texture2D(bitmap, openfl_TextureCoordv.xy);
    
    // Apply the effect, modulated by the original color's brightness.
    float brightnessModulation = pow(dot(originalColor.rgb, vec3(1.0/3.0)), 1.7) * 0.9;
    originalColor.rgb += effectColor * BRIGHT * (pixely ? 1.6 : 1.0) * brightnessModulation * 0.3;

    // --- Alpha Handling (Optimized to avoid branching) ---
    // If the original pixel is transparent, use the effect's brightness as alpha.
    float effectBrightness = dot(effectColor, vec3(1.0/3.0));
    // step(originalColor.a, 0.001) is 1.0 if alpha is near 0, 0.0 otherwise.
    originalColor.a = max(originalColor.a, effectBrightness * step(originalColor.a, 0.001));

    gl_FragColor = originalColor;
}
