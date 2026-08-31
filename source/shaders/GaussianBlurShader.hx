package shaders;

import flixel.system.FlxAssets.FlxShader;

class GaussianBlurShader extends FlxShader {
	public var size(default, set):Float = 16.0;
	public var direction(default, set):Array<Float> = [1.0, 1.0];
	function set_size(value:Float) {
		this.size = value;
		this.data.uSize.value = [value];
		return value;
	}
	function set_direction(value:Array<Float>) {
		this.direction = [value[0], value[1]];
		this.data.uDirection.value = [value[0], value[1]];
		return value;
	}
	@:glFragmentSource('
	#pragma header
	const float PI = 3.141592654;
	const float DIRECTIONS = 16.0;
	const float QUALITY = 8.0;
	uniform float uSize;
	uniform vec2 uDirection;
	
	void main() {
		vec2 RADIUS = uSize / openfl_TextureSize.xy;
		vec2 uv = openfl_TextureCoordv;
		vec4 color = flixel_texture2D(bitmap, uv);
	
		// Blur calculations
		for (float d = 0.0; d < PI * 2.0; d += PI * 2.0 / DIRECTIONS) {
			for (float i = 1.0 / QUALITY; i <= 1.0; i += 1.0 / QUALITY) {
				color += flixel_texture2D(bitmap, uv + vec2(cos(d) * uDirection.x, sin(d) * uDirection.y) * RADIUS * i);
			}
		}
	
		color /= QUALITY * DIRECTIONS - 15.0;
		gl_FragColor = color;
	}
	')
	public function new(size:Float = 16.0) {
		super();
		this.size = size;
		this.direction = [1, 1];
	}
}
