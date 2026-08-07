package shaders;

import flixel.system.FlxAssets.FlxShader;
import openfl.display.BitmapData;

class DiscolorationMaskedShader extends FlxShader {
	@:glFragmentSource('
	#pragma header
    uniform vec3 tintColor;
    uniform float intensity;
    uniform sampler2D maskTexture;
    uniform int maskIndex;

    uniform bool uUseMask;
    // x = left, y = top, z = right, w = bottom
    uniform vec4 frameBounds;

    void main() {
        vec4 color = flixel_texture2D(bitmap, openfl_TextureCoordv);
        vec4 maskColor = vec4(0.0);

        // Skip math entirely if base pixel is already transparent
        if (color.a == 0.0) {
            gl_FragColor = vec4(0.0);
            return;
        }

		if (uUseMask) {
			vec2 localCoord = (openfl_TextureCoordv - frameBounds.xy) / (frameBounds.zw - frameBounds.xy);
			maskColor = flixel_texture2D(maskTexture, frameBounds.xy + localCoord * (frameBounds.zw - frameBounds.xy));
			color.rgb = mix(color.rgb, tintColor.rgb * maskColor.rgb, intensity * maskColor.a);
		} else {
			color.r *= pow(tintColor.r, intensity);
			color.g *= pow(tintColor.g, intensity);
			color.b *= pow(tintColor.b, intensity);
		}

		gl_FragColor = vec4(color.rgb, color.a);
	}
	')
	public var maskBitmaps:Array<BitmapData> = [];
	public var color(default, set):Array<Float> = [0, 0, 0];
	public var strength(default, set):Float = 0;
	public var useMask(default, set):Bool = false;

	private function set_color(value:Array<Float>):Array<Float> {
		color = value;
		tintColor.value = [value[0] / 255, value[1] / 255, value[2] / 255];
		return value;
	}
	private function get_color():Array<Float> {
		return tintColor.value;
	}
	
	private function set_strength(value:Float):Float {
		this.strength = FlxMath.bound(value, 0, 1);
		intensity.value = [this.strength];
		return value;
	}
	private function get_strength():Float {
		return intensity.value[0];
	}

	public function new(color:Array<Float>) {
		super();
		this.maskIndex.value = [0];
		this.useMask = false;
		this.frameBounds.value = [
			0,
			0,
			640,
			640
		];
		this.color = color;
		this.strength = 0;
	}

	public function set_useMask(value:Bool):Bool {
		useMask = value;
		uUseMask.value = [value];
		return value;
	}

	public function initMask(index:Int = 0, bitmap:BitmapData):Void {
		if (index > this.maskBitmaps.length - 1) this.maskBitmaps.resize(index + 1);
		this.maskBitmaps[index] = bitmap;
	}

	public function setMask(index:Int = 0):Void {
		this.maskTexture.input = maskBitmaps[index];
	}

	public function setFrameBounds(x:Float, y:Float, width:Float, height:Float):Void {
		this.frameBounds.value = [
			x,
			y,
			width,
			height
		];
	}

	public function update(elapsed:Float) {}
}
