// Original: https://www.shadertoy.com/view/Xsl3zn
// Created by inigo quilez - iq
// License Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported License.

void mainImage( out vec4 fragColor, in vec2 fragCoord ) {
	vec2 uv = fragCoord / iResolution.xy;
	vec2 warp = texture2D(iChannel0, uv + iTime * vec2(0.05, 0.05)).xz;

	vec2 st = uv + warp * 0.125;

	fragColor = vec4(texture(iChannel0, st));
}