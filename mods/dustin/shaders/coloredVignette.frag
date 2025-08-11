#pragma header

uniform vec3 color;
uniform float amount;
uniform float strength;

uniform bool transperency;

void main() {
    vec4 flixelColor = flixel_texture2D(bitmap, openfl_TextureCoordv);
    vec2 uv = getCamPos(openfl_TextureCoordv);

    if (transperency) {
        float dist = distance(openfl_TextureCoordv, vec2(0.5));

        float vignette = mix(1.0, 1.0 - amount, dist);
        float shapedVignette = pow(vignette, strength);  // stronger falloff
        float vignetteStrength = 1.0 - shapedVignette;

        vec3 vignetteColor = color * vignetteStrength;

        gl_FragColor = flixelColor + vec4(vignetteColor, vignetteStrength);
    } else {
        vec3 col = pow(textureCam(bitmap, uv).rgb, vec3(1.0 / strength));

        float vignette = mix(1.0, 1.0 - amount, distance(uv, vec2(0.5)));
        col = pow(mix(col * color, col, vignette), vec3(strength));

        gl_FragColor = vec4(col, 1.0);
    }
}
