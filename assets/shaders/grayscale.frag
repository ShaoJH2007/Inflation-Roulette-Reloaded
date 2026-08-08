const vec3 lum = vec3(0.2126, 0.7152, 0.0722);

vec4 desaturate(vec4 color, float factor) {
    vec3 gray = vec3(dot(lum, color.rgb));
    return vec4(mix(color.rgb, gray, factor), color.a);
}

void mainImage( out vec4 fragColor, in vec2 fragCoord ) {
    vec2 uv = fragCoord / iResolution.xy;
    fragColor = desaturate(texture(iChannel0, uv), 1.0);
}