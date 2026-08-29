package shaders;

import flixel.system.FlxAssets.FlxShader;

class MeltShader extends FlxShader {
	@:glFragmentSource('
	#pragma header
	// Original: https://www.shadertoy.com/view/Xsl3zn
	// Created by inigo quilez - iq
	// License Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported License.
	
	uniform float iTime;
	
	void main() {
		vec2 uv = openfl_TextureCoordv;
		vec2 warp = texture2D(bitmap, uv + iTime * vec2(0.05, 0.05)).xz;
	
		vec2 st = uv + warp * 0.125;
	
		gl_FragColor = vec4(flixel_texture2D(bitmap, st));
	}
	')
	public var time(default, set):Float = 0.0;
	function set_time(value:Float) {
		this.time = value;
		this.data.iTime.value = [value];
		return value;
	}
	public function new() {
		super();
	}
	public function update(elapsed:Float) {
		this.time += elapsed;
	}
}
