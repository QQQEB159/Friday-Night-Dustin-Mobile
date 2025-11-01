#pragma header
uniform float threshold;
void main()
{
    // Normalized pixel coordinates (from 0 to 1)
    vec2 uv = openfl_TextureCoordv;

    // Time varying pixel color
    vec4 col = flixel_texture2D(bitmap, openfl_TextureCoordv);
    if (threshold == -1.0) {
        gl_FragColor = col;
        return;
    }
    if (float(col.rgb) > threshold) col.rgb = vec3(1.0);
    else col.rgb = vec3(0.0);

    // Output to screen
    gl_FragColor = col;
}