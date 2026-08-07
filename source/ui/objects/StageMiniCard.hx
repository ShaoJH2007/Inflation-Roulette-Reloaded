package ui.objects;

class StageMiniCard extends SuffButton {
	public var stage:String;

	var bg:FlxSprite;
	var outline:FlxSprite;
	var charNameText:FlxText;

	public var alwaysHighlighted = false;

	public function new(x:Float, y:Float, stage:String) {
		this.stage = stage;
		super(x, y, null, null, null, Constants.CHARACTER_CARD_DIMENSIONS[0], Constants.CHARACTER_CARD_DIMENSIONS[1], false);

		var bgGraphic = Paths.getImage('ui/menus/characterSelect/stages/$stage');
		if (bgGraphic == null)
			bgGraphic = Paths.getImage('ui/menus/characterSelect/stages/random');
		bg = new FlxSprite().loadGraphic(bgGraphic);
		var rectOffset = FlxPoint.get(24, 4);
		if (stage == 'random')
			rectOffset.x = (bgGraphic.width - 140) / 2;
		bg.clipRect = FlxRect.get(rectOffset.x, rectOffset.y, 140, 190);
		bg.setPosition(-rectOffset.x + 5, 1);
		bg.updateHitbox();
		add(bg);

		outline = new FlxSprite().loadGraphic(Utilities.makeBorder(Constants.CHARACTER_CARD_DIMENSIONS[0], Constants.CHARACTER_CARD_DIMENSIONS[1]));
		add(outline);

		charNameText = new FlxText(6, 6, width - 6 * 2, Language.getPhrase('stage.$stage.name').toUpperCase());
		charNameText.setFormat(Paths.getFont('small'), 32, FlxColor.WHITE);
		charNameText.setBorderStyle(OUTLINE, 0x80000000, 0.25);
		add(charNameText);
	}

	override private function get_width():Int {
		return Constants.CHARACTER_CARD_DIMENSIONS[0];
	}

	override private function get_height():Int {
		return Constants.CHARACTER_CARD_DIMENSIONS[1];
	}

	public function setScale(x:Float, y:Float) {
		btnBG.setGraphicSize(Std.int(width * x), Std.int(height * y));
		btnBG.updateHitbox();
		for (item in [bg, outline]) {
			item.scale.set(x, y);
			item.updateHitbox();
		}
	}

	override function update(elapsed:Float) {
		super.update(elapsed);

		outline.visible = this.hovered || alwaysHighlighted;
		outline.color = !alwaysHighlighted ? 0xFFFFFFFF : 0xFFFF00FF;

		btnBG.visible = false;
		btnOutline.visible = false;
	}
}
