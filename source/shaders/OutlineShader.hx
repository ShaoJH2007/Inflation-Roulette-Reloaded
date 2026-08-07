package shaders;

import flixel.system.FlxAssets.FlxShader;

class OutlineShader extends FlxShader {
	@:glFragmentSource('
	#pragma header
	uniform vec4 uColor;
	uniform float uThickness;
	uniform bool uEnabled;
	
	const float PI = 3.141592654;

	void main() {
		vec4 texColor = texture2D(bitmap, openfl_TextureCoordv);
		if (!uEnabled || texColor.a > 0.0) {
			gl_FragColor = texColor;
			return;
		}
		float alpha = 0.0;
		vec2 inc = uThickness / openfl_TextureSize;
		float iterations = uThickness * 4.0;
		for (float i = 0.0; i <= iterations; i += 1.0) {
			float outlineX = sin(i / iterations * PI * 2.0) * inc.x;
			float outlineY = cos(i / iterations * PI * 2.0) * inc.y;
			alpha += texture2D(bitmap, openfl_TextureCoordv + vec2(outlineX, outlineY)).a;
		}
		if (alpha > 0.0) {
			gl_FragColor = uColor;
	  	} else {
			gl_FragColor = vec4(0.0);
	  	}
	}
	')

	public var thickness(default, set):Int = 2;
	public var color(default, set):FlxColor;
	public var enabled(default, set):Bool = true;

	function set_thickness(value:Int):Int {
		thickness = value;
		uThickness.value = [value];
		return value;
	}

	function set_color(value:FlxColor):FlxColor {
		color = value;
		uColor.value = [value.redFloat, value.greenFloat, value.blueFloat, value.alphaFloat];
		return value;
	}
	
	function set_enabled(value:Bool):Bool {
		enabled = value;
		uEnabled.value = [value];
		return value;
	}
	
	public function new(thickness:Int = 2, color:FlxColor = 0xFFFFFFFF) {
		super();
		this.thickness = thickness;
		this.color = color;
		this.enabled = true;
	}
}