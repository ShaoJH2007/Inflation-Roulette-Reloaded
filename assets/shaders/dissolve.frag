// Perlin Noise: Simple 2d perlin noise by SpectreSpect
// https://www.shadertoy.com/view/DsK3W1

uniform float seed;

vec2 n22 (vec2 p) {
	vec3 a = fract(p.xyx * vec3(123.34 + seed, 234.34, 345.65));
	a += dot(a, a + 34.45);
	return fract(vec2(a.x * a.y, a.y * a.z));
}

vec2 getGradient(vec2 pos) {
	float twoPi = 6.283185;
	float angle = n22(pos).x * twoPi;
	return vec2(cos(angle), sin(angle));
}

float perlinNoise(vec2 uv, float cells_count) {
	vec2 posInGrid = uv * cells_count;
	vec2 cellPosInGrid = floor(posInGrid);
	vec2 localPosInCell = (posInGrid - cellPosInGrid);
	vec2 blend = localPosInCell * localPosInCell * (3.0 - 2.0 * localPosInCell);

	vec2 topLeft = cellPosInGrid + vec2(0, 1);
	vec2 topRight = cellPosInGrid + vec2(1, 1);
	vec2 bottomLeft = cellPosInGrid + vec2(0, 0);
	vec2 bottomRight = cellPosInGrid + vec2(1, 0);

	float topLeftDot = dot(posInGrid - topLeft, getGradient(topLeft));
	float topRightDot = dot(posInGrid - topRight, getGradient(topRight));
	float bottomLeftDot = dot(posInGrid - bottomLeft, getGradient(bottomLeft));
	float bottomRightDot = dot(posInGrid - bottomRight, getGradient(bottomRight));

	float noiseVal = mix(
		mix(bottomLeftDot, bottomRightDot, blend.x),
		mix(topLeftDot, topRightDot, blend.x),
		blend.y);


	return (0.5 + 0.5 * (noiseVal / 0.75));
}

void mainImage( out vec4 fragColor, in vec2 fragCoord ) {
	vec2 uv = fragCoord / iResolution.xy;

	float height = perlinNoise(uv * iResolution.xy / vec2(320.0, 320.0), 16.0);

	vec3 pixel = texture(iChannel0, uv).rgb;

	//remove if for performance
	float condition = 1. - step(height, iTime);

	fragColor = vec4(pixel * condition, condition);
}