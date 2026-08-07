const vec3 lum = vec3(0.2126, 0.7152, 0.0722);

void mainImage( out vec4 fragColor, in vec2 fragCoord ) {
    vec2 uv = fragCoord / iResolution.xy;
    vec4 texColor = texture(iChannel0, uv);
    
    vec3 gray = vec3(dot(lum, texColor.rgb));
    fragColor = vec4(texColor.rgb, gray);
}