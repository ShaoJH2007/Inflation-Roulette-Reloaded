package shaders;

import flixel.system.FlxAssets.FlxShader;

class GaussianBlurShader extends FlxShader {
	// Original shader:
	@:glFragmentSource('
	#pragma header
	const float PI = 3.141592654;
	const float Directions = 16.0;
	const float Quality = 8.0;
	uniform float uSize;
	uniform float uBrightness;

	void main() {
		vec2 Radius = uSize / openfl_TextureSize;
		vec2 uv = openfl_TextureCoordv.xy;
		vec4 Color = texture2D(bitmap, uv);

		// Blur calculations
		for (float d = 0.0; d < PI * 2.0; d += PI * 2.0 / Directions) {
			for (float i = 1.0 / Quality; i <= 1.0; i += 1.0 / Quality) {
				Color += texture2D(bitmap, uv + vec2(cos(d), sin(d)) * Radius * i);
			}
		}

		Color /= Quality * Directions - 15.0;
		gl_FragColor = vec4(Color.rgb * uBrightness, Color.a);
	}
    ')

	public var size(default, set):Float = 8;
	public var brightness(default, set):Float = 1;

	function set_size(value:Float):Float {
		size = value;
		uSize.value = [value];
		return value;
	}

	function set_brightness(value:Float):Float {
		brightness = value;
		uBrightness.value = [value];
		return value;
	}

	public function new(size:Float = 8.0, brightness:Float = 1) {
		super();
		this.size = size;
		this.brightness = brightness;
	}
}