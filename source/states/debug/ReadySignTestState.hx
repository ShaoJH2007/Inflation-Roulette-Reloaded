package states.debug;

import backend.Filler;
import backend.Gameplay;
import objects.Character;
import ui.objects.SuffIconButton;
import ui.objects.ReadySign;

class ReadySignTestState extends SuffState {
	var exiting:Bool = false;
	var exitButton:SuffIconButton;
	
	var readySign:ReadySign;

	public override function create() {
		super.create();

		readySign = new ReadySign();
		readySign.moveSign(true);
		add(readySign);

		exitButton = new SuffIconButton(20, 20, 'buttons/exit', null, 2);
		exitButton.x = FlxG.width - exitButton.width - 20;
		exitButton.onClick = function() {
			exitMenu();
		};
		add(exitButton);
	}

	function exitMenu() {
		if (exiting)
			return;
		exiting = true;
		SuffState.switchState(new MainMenuState());
	}
	
	var readySignShown:Bool = true;

	public override function update(elapsed:Float) {
		super.update(elapsed);

		if (Controls.justPressed('exit')) {
			exitMenu();
		}

		if (FlxG.keys.justPressed.ENTER) {
			readySignShown = !readySignShown;
			readySign.moveSign(readySignShown);
		}
	}
}
