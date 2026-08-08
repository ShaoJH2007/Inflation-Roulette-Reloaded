package shaders;

import flixel.addons.display.FlxRuntimeShader;

class DissolveShader extends FlxRuntimeShader {
	public var updating:Bool = false;
	public var decayRate:Float = 0.0;
	public var time(default, set):Float = 0.0;

	private function get_time():Float {
		return data.iTime.value[0];
	}

	private function set_time(value:Float):Float {
		time = value;
		data.iTime.value = [value];
		return value;
	}

	public function new() {
		super(Paths.getShader('dissolve').glFragmentSource);
		time = 0.0;
		data.seed.value = [FlxG.random.float(-123.34, 123.34)];
	}

	public function dissolve() {
		decayRate = 1.0;
	}

	public function undissolve() {
		decayRate = -1.0;
	}

	public function update(elapsed:Float) {
		time = FlxMath.bound(time + elapsed * decayRate, 0.0, 1.0);
	}
}
