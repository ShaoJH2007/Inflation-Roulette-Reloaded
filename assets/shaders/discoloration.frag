uniform vec3 tintColor;
uniform float intensity;
uniform sampler2D maskTexture;
uniform int maskIndex;

uniform bool uUseMask;
// x = left, y = top, z = right, w = bottom
uniform vec4 frameBounds;

void mainImage( out vec4 fragColor, in vec2 fragCoord ) {
	vec2 uv = fragCoord / iResolution.xy;
	vec4 color = texture(iChannel0, uv);

	// Skip math entirely if base pixel is already transparent
	if (color.a == 0.0) {
		gl_FragColor = vec4(0.0);
		return;
	}

	if (uUseMask) {
		vec2 localCoord = (uv - frameBounds.xy) / (frameBounds.zw - frameBounds.xy);
		vec4 maskColor = texture(maskTexture, frameBounds.xy + localCoord * (frameBounds.zw - frameBounds.xy));
		color.rgb = mix(color.rgb, tintColor.rgb * maskColor.rgb, intensity * maskColor.a);
	} else {
		color.r *= pow(tintColor.r, intensity);
		color.g *= pow(tintColor.g, intensity);
		color.b *= pow(tintColor.b, intensity);
	}

	fragColor = color;
}