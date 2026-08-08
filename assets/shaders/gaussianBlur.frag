const float PI = 3.141592654;
const float DIRECTIONS = 16.0;
const float QUALITY = 8.0;
uniform float uSize;
uniform float uBrightness;

void mainImage( out vec4 fragColor, in vec2 fragCoord ) {
    vec2 RADIUS = uSize / iResolution.xy;
    vec2 uv = fragCoord / iResolution.xy;
    vec4 color = texture(iChannel0, uv);

    // Blur calculations
    for (float d = 0.0; d < PI * 2.0; d += PI * 2.0 / DIRECTIONS) {
        for (float i = 1.0 / QUALITY; i <= 1.0; i += 1.0 / QUALITY) {
            color += texture2D(iChannel0, uv + vec2(cos(d), sin(d)) * RADIUS * i);
        }
    }

    color /= QUALITY * DIRECTIONS - 15.0;
    fragColor = vec4(color.rgb * uBrightness, color.a);
}