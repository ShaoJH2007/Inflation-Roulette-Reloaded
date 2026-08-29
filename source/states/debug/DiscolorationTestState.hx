package states.debug;

import ui.objects.SuffIconButton;
import objects.Character;
import backend.Gameplay;
import backend.Filler;

class DiscolorationTestState extends SuffState {
	var exiting:Bool = false;
	var exitButton:SuffIconButton;

	var characterGroup:FlxTypedGroup<Character>;
	
	var camGame:FlxCamera;
	var camHUD:FlxCamera;

	public override function create() {
		camGame = new FlxCamera(0, 0, FlxG.width, FlxG.height);
		camHUD = new FlxCamera(0, 0, FlxG.width, FlxG.height);
		camGame.bgColor = 0xFF000000;
		camHUD.bgColor.alpha = 0;

		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camHUD, false);

		FlxG.cameras.setDefaultDrawTarget(camGame, true);
		super.create();

		Gameplay.currentFiller = new Filler('berry');

		characterGroup = new FlxTypedGroup<Character>();
		for (index => charId in Gameplay.globalCharacterList) {
			var firstX = FlxG.width / 2 - (Gameplay.globalCharacterList.length - 1) / 2 * 200;
			var character = new Character(charId, firstX + index * 200, FlxG.height * 0.825);
			characterGroup.add(character);
		}
		add(characterGroup);
		FlxG.camera.zoom = 0.825;

		exitButton = new SuffIconButton(20, 20, 'buttons/exit', null, 2);
		exitButton.x = FlxG.width - exitButton.width - 20;
		exitButton.camera = camHUD;
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

	public override function update(elapsed:Float) {
		super.update(elapsed);

		if (Controls.justPressed('exit')) {
			exitMenu();
		}

		if (Controls.justPressed('left') || Controls.justPressed('right')) {
			if (Controls.justPressed('left'))
				for (char in characterGroup) char.discolorationIntensity -= 0.1;
			else if (Controls.justPressed('right'))
				for (char in characterGroup) char.discolorationIntensity += 0.1;
			for (char in characterGroup) char.discoloration.intensity = char.discolorationIntensity;
		}

		if (Controls.justPressed('up') || Controls.justPressed('down')) {
			if (Controls.justPressed('up'))
				for (char in characterGroup) char.currentPressure += 1;
			else if (Controls.justPressed('down'))
				for (char in characterGroup) char.currentPressure -= 1;
			for (char in characterGroup) char.playAnim('shocked');
		}
	}
}
