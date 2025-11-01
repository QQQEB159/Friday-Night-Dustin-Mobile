#pragma header

uniform vec3 color;
uniform float amount;
uniform float strength;

void main() {
    vec4 flixelColor = flixel_texture2D(bitmap, openfl_TextureCoordv);
    vec2 uv = getCamPos(openfl_TextureCoordv);

    vec3 col = pow(textureCam(bitmap, uv).rgb, vec3(1.0 / strength));

    float vignette = mix(1.0, 1.0 - amount, distance(uv, vec2(0.5)));
    col = pow(mix(col * color, col, vignette), vec3(strength));

    gl_FragColor = vec4(col, flixelColor.a);
}
