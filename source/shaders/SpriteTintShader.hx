package shaders;

import flixel.system.FlxAssets.FlxShader;

class SpriteTintShader extends FlxShader {
	public var color(default, set):FlxColor;
	public var intensity(default, set):Float = 0.0;
	function set_color(value:FlxColor) {
		color = value;
		this.data.uColor.value = [value.redFloat, value.greenFloat, value.blueFloat];
		return value;
	}
	function set_intensity(value:Float) {
		intensity = value;
		this.data.uIntensity.value = [value];
		return value;
	}
	@:glFragmentSource('
	#pragma header
	uniform vec3 uColor;
	uniform float uIntensity;
	
	void main() {
		vec2 uv = openfl_TextureCoordv;
		vec4 texColor = flixel_texture2D(bitmap, uv);
		gl_FragColor = vec4(mix(texColor.rgb, mix(vec3(0, 0, 0), uColor, texColor.a), uIntensity), texColor.a);
	}
	')
	public function new() {
		super();
		this.color = 0xFFFFFFFF;
		this.intensity = 1.0;
	}
}
