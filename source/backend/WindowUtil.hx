package backend;

import openfl.system.Capabilities;
import openfl.Lib;

class WindowUtil {
	public static var AVAILABLE_RESOLUTIONS:Array<Array<Int>> = [];
	inline public static function setTitle(...params:String) {
		#if !html
		var text:Array<String> = [Language.getPhrase('metadata.title') + ' (${Preferences.data.resolution[0]}×${Preferences.data.resolution[1]})'];
		for (i in params) {
			text.push(i);
		}
		lime.app.Application.current.window.title = text.join(' · ');
		#end
	}

	inline public static function getMonitorResolution():FlxPoint {
		return FlxPoint.get(Capabilities.screenResolutionX, Capabilities.screenResolutionY);
	}

	inline public static function getWindowResolution():FlxPoint {
		return FlxPoint.get(Lib.current.stage.window.width, Lib.current.stage.window.height);
	}

	public static function calculateResolutions() {
		AVAILABLE_RESOLUTIONS = [];
		final curMonitorRes = getMonitorResolution();
		final resolutionFactor = 8;
		final minWidth = Std.int(80 / resolutionFactor);
		final maxWidth = Std.int(curMonitorRes.x / resolutionFactor);
		for (i in minWidth...maxWidth + 1) {
			var width = i * resolutionFactor;
			var heightFloat:Float = 9 / 16 * width;
			var height = Math.floor(heightFloat);
			if (Math.ceil(heightFloat) != height || height % resolutionFactor != 0)
				continue;
			// 16:9
			AVAILABLE_RESOLUTIONS.push([width, height]);
			trace('Pushed available resolution: [$width, $height]');
		}
		if (resolutionIndexOf([Std.int(curMonitorRes.x), Std.int(curMonitorRes.y)]) == -1)
			AVAILABLE_RESOLUTIONS.push([Std.int(curMonitorRes.x), Std.int(curMonitorRes.y)]);
	}
	
	public static function screenCenter() {
		#if desktop
		var scrRes = getMonitorResolution();
		var winRes = getWindowResolution();
		Lib.current.stage.window.move(
			Std.int((scrRes.x - winRes.x) / 2),
			Std.int((scrRes.y - winRes.y) / 2)
		);
		trace('Centered window to screen at [${Lib.current.stage.window.x}, ${Lib.current.stage.window.y}]');
		#end
	}
	
	inline public static function isFullscreen() {
		var scrRes = getMonitorResolution();
		var winRes = getWindowResolution();
		return (scrRes.x == winRes.x && scrRes.y == winRes.y);
	}
	
	public static function resizeWindow(width:Int = 1280, height:Int = 720) {
		#if desktop
		FlxG.resizeWindow(width, height);
		trace('Resized window: [$width, $height]');
		if (isFullscreen())
			trace('Game is now in fullscreen');
		#end
	}
	
	public static function resolutionIndexOf(res:Array<Int>) {
		// Binary search
		var low = 0;
		var high = AVAILABLE_RESOLUTIONS.length - 1;
		while (low <= high) {
			var mid = Std.int(low + (high - low) / 2);
			if (AVAILABLE_RESOLUTIONS[mid][0] == res[0] && AVAILABLE_RESOLUTIONS[mid][1] == res[1])
				return mid;
			else if (AVAILABLE_RESOLUTIONS[mid][0] > res[0] || AVAILABLE_RESOLUTIONS[mid][1] > res[1])
				high = mid - 1;
			else if (AVAILABLE_RESOLUTIONS[mid][0] < res[0] || AVAILABLE_RESOLUTIONS[mid][1] < res[1])
				low = mid + 1;
		}
		// Can't find shit
		return -1;
	}
}
