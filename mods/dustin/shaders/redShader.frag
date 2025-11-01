#pragma header

void main() {
    vec4 baseColor = texture2D(bitmap, openfl_TextureCoordv);
    if (baseColor.a > 0.0) {
        gl_FragColor = vec4(1.0, 1.0, 1.0, baseColor.a);
    } else {
        gl_FragColor = vec4(0.0);
    }
}
