uniform sampler2D uGrid;
uniform vec2 uGridSize;
uniform vec2 uTexSize;

void mainImage( out vec4 fragColor, in vec2 fragCoord ) {
	vec2 uv = fragCoord / iResolution.xy;
	vec4 texColor = texture(iChannel0, uv);
	vec2 dt = iTime / uGridSize * 32;
	uv -= dt;
	vec4 maskColor = texture(uGrid, fract(uv * uTexSize.xy / uGridSize));
	if (texColor.a > 0.0) {
		fragColor = vec4(maskColor.rgb, texColor.a);
	} else {
		fragColor = vec4(0.0);
	}
}