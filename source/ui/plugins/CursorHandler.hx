package ui.plugins;
import ui.plugins.CursorHandler;

class CursorHandler extends FlxBasic {
	public static var instance:Null<CursorHandler> = null;
	public static var cursorVisible(default, set):Bool = false;
	public static var timeSinceCursorChange:Float = 0;

	private static function set_cursorVisible(value:Bool):Bool {
		cursorVisible = value;
		FlxG.mouse.visible = #if !mobile cursorVisible #else false #end;
		return value;
	}

	public function new() {
		super();
	}

	public static function initialize() {
		FlxG.plugins.drawOnTop = true;
		instance = new CursorHandler();
		FlxG.plugins.add(instance);
		cursorVisible = true;
	}

	public static var currentCursorStyle:String = 'default';
	static var curSpriteContainerImage:String = '';

	public static function setCursorStyle(value:String) {
		currentCursorStyle = value;
	}

	inline static function changeCursorImage(tag:String, pressed:Bool = false):Void {
		var imageName = tag + (pressed ? 'Held' : '');
		if (curSpriteContainerImage == imageName)
			return;
		timeSinceCursorChange = 0;
		curSpriteContainerImage = imageName;
		FlxG.mouse.load(Paths.getImage('ui/plugins/cursor/$imageName').bitmap, 1, -7, -6);
	}

	public override function update(elapsed:Float) {
		if (instance == null || !cursorVisible)
			return;
		timeSinceCursorChange += elapsed;
		if (timeSinceCursorChange > 5) {
			setCursorStyle('default');
		}
		if (Preferences.data.useBuiltInCursor)
            changeCursorImage(currentCursorStyle, FlxG.mouse.pressed);
		if (Preferences.data.playCursorSounds) {
			if (FlxG.mouse.justPressed) {
				SuffState.playUISound(Paths.getSound('ui/cursorClick'), 0.75, FlxG.random.float(2.5, 5));
			} else if (FlxG.mouse.justReleased) {
				SuffState.playUISound(Paths.getSound('ui/cursorClick'), 0.25, FlxG.random.float(1.5, 2));
			}
		}
		super.update(elapsed);
	}
}
