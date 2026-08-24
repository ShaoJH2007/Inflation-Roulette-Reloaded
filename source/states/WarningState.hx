package states;

import ui.objects.SuffIconButton;

class WarningState extends SuffState {
	var warningTitle:FlxText;
	var warningDesc:FlxText;
	var acceptButton:SuffButton;
	var languageButton:SuffIconButton;

	public override function create() {
		super.create();

		WindowUtil.setTitle(Language.getPhrase('warningMenu.windowDisplay'));

		warningTitle = new FlxText(0, 0, 0, Language.getPhrase('warningMenu.title'));
		warningTitle.setFormat(Paths.getFont('default'), 80, 0xFFFF0000);
		warningTitle.screenCenter();
		add(warningTitle);

		warningDesc = new FlxText(0, 0, FlxG.width * 0.85 - ScreenSafeArea.X * 2, Language.getPhrase('warningMenu.content'));
		warningDesc.setFormat(Paths.getFont('default'), 32, 0xFFFFFFFF, JUSTIFY);
		warningDesc.x = Std.int((FlxG.width - warningDesc.width) / 2);
		add(warningDesc);

		acceptButton = new SuffButton(0, 0, Language.getPhrase('menu.accept'), null, null, 220, 100);
		acceptButton.btnOutlineColor = acceptButton.btnOutlineColorHovered = acceptButton.btnOutlineColorClicked = acceptButton.btnOutlineColorDisabled = 0xFFFFFFFF;
		acceptButton.btnTextColorDisabled = 0xFF000000;
		acceptButton.btnBGColor = 0xFF000000;
		acceptButton.btnBGColorHovered = 0xFF000000;
		acceptButton.btnBGColorDisabled = 0xFFFFFFFF;
		acceptButton.btnBGColorClicked = 0xFF000000;
		acceptButton.screenCenter();
		acceptButton.onClick = function() {
			PreloadState.hasBeenWarned = true;
			FlxTransitionableState.skipNextTransIn = true;
			FlxTransitionableState.skipNextTransOut = true;
			SuffState.switchState(new InitStartupState());
		}
		add(acceptButton);

		warningTitle.y = (FlxG.height - (warningTitle.height + warningDesc.height + acceptButton.height + 10)) / 2;
		warningDesc.y = warningTitle.y + warningTitle.height;
		acceptButton.y = warningDesc.y + warningDesc.height + 10;

		languageButton = new SuffIconButton(20, 20, 'buttons/language', null, 2);
		languageButton.x = FlxG.width - languageButton.width - 20;
		languageButton.y = FlxG.height - languageButton.height - 20;
		languageButton.btnOutlineColor = languageButton.btnOutlineColorHovered = languageButton.btnOutlineColorClicked = 0xFFFFFFFF;
		languageButton.btnBGColor = languageButton.btnBGColorHovered = languageButton.btnBGColorClicked = 0xFF000000;
		languageButton.onClick = function () {
			LanguageSelectState.atWarningState = true;
			SuffState.switchState(new LanguageSelectState());
		};
		add(languageButton);
	}

	public override function update(elapsed:Float) {
		super.update(elapsed);
	}
}
