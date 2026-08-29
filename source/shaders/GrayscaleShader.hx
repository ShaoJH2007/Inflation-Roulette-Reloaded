package shaders;

import flixel.system.FlxAssets.FlxShader;

class GrayscaleShader extends FlxShader {
	@:glFragmentSource('
	#pragma header
	const vec3 lum = vec3(0.2126, 0.7152, 0.0722);

	void main() {
		vec4 texColor = flixel_texture2D(bitmap, openfl_TextureCoordv);
		vec3 gray = vec3(dot(lum, texColor.rgb));
		gl_FragColor = vec4(gray, texColor.a);
	}
	')
	public function new() {
		super();
	}
}
