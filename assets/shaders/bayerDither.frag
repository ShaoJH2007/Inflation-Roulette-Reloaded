const mat4x4 threshold = mat4x4(
	0., 8., 2., 10.,
	12., 4., 14., 6.,
	3., 11., 1., 9.,
	15., 7., 13., 5.
);
const float factor = 2.;
const vec3 lum = vec3(0.2126, 0.7152, 0.0722);
const vec3 colors[2] = vec3[2](
	vec3(
		51.0 / 256.0,
		51.0 / 256.0,
		25.0 / 256.0
	),
	vec3(
		229.0 / 256.0,
		256.0 / 256.0,
		256.0 / 256.0
	)
);

int getClosest(int x, int y, float v) {
    mat4x4 thresholdT = transpose(threshold);
    float t = thresholdT[x][y] / 16.;
    if (v < t) {
        return 0;
    } else {
        return 1;
    }
}

void mainImage( out vec4 fragColor, in vec2 fragCoord ) {
	vec2 uv = floor(fragCoord / factor) / (iResolution.xy / factor);
    vec4 color = texture(iChannel0, uv);
    int x = int(fragCoord.x / factor) % 4;
    int y = int(fragCoord.y / factor) % 4;
    float monoColor = dot(lum, color.rgb);
    int selectedColor = getClosest(x, y, monoColor);
    int selectedAlpha = getClosest(x, y, color.a);
    fragColor = vec4(colors[selectedColor], selectedAlpha);
}