uniform vec4 uColor;
uniform float uThickness;
uniform bool uEnabled;

const float PI = 3.141592654;

void mainImage( out vec4 fragColor, in vec2 fragCoord ) {
    vec2 uv = fragCoord / iResolution.xy;
    vec4 texColor = texture2D(iChannel0, uv);
    if (!uEnabled || texColor.a > 0.0) {
        fragColor = texColor;
        return;
    }
    float alpha = 0.0;
    vec2 inc = uThickness / iResolution.xy;
    float iterations = uThickness * 4.0;
    for (float i = 0.0; i <= iterations; i += 1.0) {
        float outlineX = sin(i / iterations * PI * 2.0) * inc.x;
        float outlineY = cos(i / iterations * PI * 2.0) * inc.y;
        alpha += texture2D(iChannel0, uv + vec2(outlineX, outlineY)).a;
    }
    if (alpha > 0.0) {
        gl_FragColor = uColor;
    } else {
        gl_FragColor = vec4(0.0);
    }
}