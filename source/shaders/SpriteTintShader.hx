package shaders;

import flixel.system.FlxAssets.FlxShader;

class SpriteTintShader extends FlxShader {
	@:glFragmentSource('
	#pragma header
	uniform vec3 uColor;
	uniform float uIntensity;

	void main() {
		vec4 texColor = texture2D(bitmap, openfl_TextureCoordv);
		gl_FragColor = vec4(mix(texColor.rgb, mix(vec3(0, 0, 0), uColor, texColor.a), uIntensity), texColor.a);
	}
	')

	public var color(default, set):FlxColor;
	public var intensity(default, set):Float;

	function set_color(value:FlxColor):FlxColor {
		color = value;
		uColor.value = [color.redFloat, color.greenFloat, color.blueFloat];
		return value;
	}

	function set_intensity(value:Float):Float {
		intensity = value;
		uIntensity.value = [intensity];
		return value;
	}
	
	public function new(color:FlxColor = 0xFFFF0000, intensity:Float = 1) {
		super();
		this.color = color;
		this.intensity = intensity;
	}
}