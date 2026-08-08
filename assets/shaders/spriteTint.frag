uniform vec3 uColor;
uniform float uIntensity;

void mainImage( out vec4 fragColor, in vec2 fragCoord ) {
	vec2 uv = fragCoord / iResolution.xy;
	vec4 texColor = texture2D(iChannel, uv);
	fragColor = vec4(mix(texColor.rgb, mix(vec3(0, 0, 0), uColor, texColor.a), uIntensity), texColor.a);
}