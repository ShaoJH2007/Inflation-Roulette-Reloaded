package shaders;

import openfl.display.BitmapData;
import flixel.addons.display.FlxRuntimeShader;

class DiscolorationMaskedShader extends FlxRuntimeShader {
	public var maskBitmaps:Array<BitmapData> = [];
	public var color(default, set):Array<Float> = [0, 0, 0];
	public var strength(default, set):Float = 0;
	public var useMask(default, set):Bool = false;

	private function set_color(value:Array<Float>):Array<Float> {
		color = value;
		data.tintColor.value = [value[0] / 255, value[1] / 255, value[2] / 255];
		return value;
	}
	private function get_color():Array<Float> {
		return data.tintColor.value;
	}
	
	private function set_strength(value:Float):Float {
		this.strength = FlxMath.bound(value, 0, 1);
		data.intensity.value = [this.strength];
		return value;
	}
	private function get_strength():Float {
		return data.intensity.value[0];
	}

	public function new(color:Array<Float>) {
		super(Paths.getShader('discoloration').glFragmentSource);
		this.data.maskIndex.value = [0];
		this.useMask = false;
		this.data.frameBounds.value = [
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
		this.data.uUseMask.value = [value];
		return value;
	}

	public function initMask(index:Int = 0, bitmap:BitmapData):Void {
		if (index > this.maskBitmaps.length - 1) this.maskBitmaps.resize(index + 1);
		this.maskBitmaps[index] = bitmap;
	}

	public function setMask(index:Int = 0):Void {
		this.data.maskTexture.input = maskBitmaps[index];
	}

	public function setFrameBounds(x:Float, y:Float, width:Float, height:Float):Void {
		this.data.frameBounds.value = [
			x,
			y,
			width,
			height
		];
	}

	public function update(elapsed:Float) {}
}
