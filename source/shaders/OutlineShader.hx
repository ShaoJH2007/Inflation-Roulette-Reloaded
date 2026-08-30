package shaders;

import flixel.system.FlxAssets.FlxShader;

class OutlineShader extends FlxShader {
	public var color(default, set):FlxColor;
	public var thickness(default, set):Float = 4.0;
	public var enabled(default, set):Bool = true;
	function set_color(value:FlxColor) {
		this.color = value;
		this.data.uColor.value = [value.redFloat, value.greenFloat, value.blueFloat, value.alphaFloat];
		return value;
	}
	function set_thickness(value:Float) {
		this.thickness = value;
		this.data.uThickness.value = [value];
		return value;
	}
	function set_enabled(value:Bool) {
		this.enabled = value;
		this.data.uEnabled.value = [value];
		return value;
	}
	@:glFragmentSource('
	#pragma header
	uniform vec4 uColor;
	uniform float uThickness;
	uniform bool uEnabled;
	
	const float PI = 3.141592654;
	
	void main() {
		vec2 uv = openfl_TextureCoordv;
		vec4 texColor = flixel_texture2D(bitmap, uv);
		if (!uEnabled || texColor.a > 0.0) {
			gl_FragColor = texColor;
			return;
		}
		float alpha = 0.0;
		vec2 inc = uThickness / openfl_TextureSize.xy;
		float iterations = uThickness * 4.0;
		for (float i = 0.0; i <= iterations; i += 1.0) {
			float outlineX = sin(i / iterations * PI * 2.0) * inc.x;
			float outlineY = cos(i / iterations * PI * 2.0) * inc.y;
			alpha += flixel_texture2D(bitmap, uv + vec2(outlineX, outlineY)).a;
		}
		if (alpha > 0.0) {
			gl_FragColor = uColor;
		} else {
			gl_FragColor = vec4(0.0);
		}
	}
	')
	public function new(color:FlxColor = 0xFFFFFFFF, thickness:Float = 4) {
		super();
		this.color = color;
		this.thickness = thickness;
	}
}
