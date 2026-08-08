package ui.objects;

import flixel.addons.display.FlxRuntimeShader;

class AchievementIcon extends FlxSprite {
	public static var grayscaleShader:FlxRuntimeShader;
	
	public var locked(default, set):Bool = false;
	public function new(x:Float, y:Float, id:String, locked:Bool = false) {
		super(x, y);

		initShader();
		this.locked = locked;
		loadIconGraphic(id, locked);
	}
	
	public static function initShader() {
		if (!Preferences.data.enableGLSL || grayscaleShader != null) return;
		grayscaleShader = Paths.getShader('grayscale');
	}
	
	private function set_locked(value:Bool):Bool {
		this.locked = value;
		if (locked) {
			if (Preferences.data.enableGLSL)
				this.shader = grayscaleShader;
			else
				this.alpha = 0.375;
		} else {
			if (Preferences.data.enableGLSL)
				this.shader = null;
			else
				this.alpha = 1;
		}
		return value;
	}

	public function loadIconGraphic(id:String, locked:Bool = false) {
		if (Preferences.data.enablePopping && Paths.fileExists(Paths.getImagePath
		('ui/menus/achievements/icons/${id}_popping')))
			id = id + '_popping';
		var iconPath = 'ui/menus/achievements/icons/$id';
		if (!Paths.fileExists(Paths.getImagePath(iconPath)))
			iconPath = 'ui/menus/achievements/icons/fallback/placeholder';
		if (Achievements.achievementsList.exists(id) && Achievements.achievementsList.get(id).hideIcon == true && locked)
			iconPath = 'ui/menus/achievements/icons/fallback/hidden';

		loadGraphic(Paths.getImage(iconPath));
	}

	override function update(elapsed:Float) {
		super.update(elapsed);
	}
}
