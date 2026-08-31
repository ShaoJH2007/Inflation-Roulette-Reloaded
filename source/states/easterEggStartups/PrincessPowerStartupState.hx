package states.easterEggStartups;

import objects.particles.Sparkle;
import openfl.display.BitmapData;
import shaders.SpriteTintShader;
import shaders.GaussianBlurShader;
import openfl.filters.ShaderFilter;
import shaders.BloomShader;
import flixel.addons.effects.FlxTrail;

class PrincessPowerStartupState extends SuffState {
	var allowToSkip:Bool = false;
	var body:FlxSprite;
	var bodyDressed:FlxSprite;
	var head:FlxSprite;
	var pole:FlxSprite;
	var ajuniga:FlxSprite;
	var glitter:FlxBackdrop;
	var bodyDressedShadow:FlxTrail;
	var dressWidthQuant:Int = 8;
	var dressWidths:Array<Int> = [0, 8, 8, 24, 24, 40, 104, 160, 168, 168, 168, 136, 136, 160, 184, 224, 240, 248, 264, 272, 280, 304, 320, 328, 400, 592, 592, 592, 592, 576, 536, 528, 528, 360, 352, 344, 336, 328, 320, 320, 328, 336, 352, 336, 336, 344, 312, 304, 304, 304, 304, 304, 288, 272, 264, 256, 256, 256, 272, 272, 272, 272, 272, 272, 272, 272, 272, 280, 280, 280, 280, 280, 280, 272, 240, 216, 208, 208, 208, 232, 224, 208, 200, 120, 0];
	// i give up bro (i made this in python instead)

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

		WindowUtil.setTitle('A DRESS MOST EXQUISITE YOUR HIGHNESS');
		if (Preferences.data.enableGLSL) {
			camGame.filters = [];
			var bloomShader:BloomShader = new BloomShader(1.0, 4.0, 0.0);
			bloomShader.direction = [1.0, 0.25];
			if (!Preferences.data.decreaseDetail) {
				var blurShader:GaussianBlurShader = new GaussianBlurShader(4);
				blurShader.direction = [1.0, 0.25];
				camGame.filters.push(new ShaderFilter(blurShader));
			}
			camGame.filters.push(new ShaderFilter(bloomShader));
		}

		glitter = new FlxBackdrop(Paths.getImage('ui/menus/easterEggStartups/princesspower/glitter'), Y);
		glitter.screenCenter(X);
		glitter.alpha = 0;
		glitter.velocity.y = FlxG.height * 2;
		body = new FlxSprite(0, FlxG.height).loadGraphic(Paths.getImage('ui/menus/easterEggStartups/princesspower/body'));
		body.screenCenter(X);
		body.origin.y = body.height * 0.95;
		var bodyDressedGraphic = Paths.getImage('ui/menus/easterEggStartups/princesspower/bodyDressed');
		bodyDressed = new FlxSprite().loadGraphic(bodyDressedGraphic, true, Std.int(bodyDressedGraphic.width / 3), bodyDressedGraphic.height);
		bodyDressed.animation.add('idle', [0]);
		bodyDressed.animation.add('pose', [1]);
		bodyDressed.animation.add('fly', [2]);
		bodyDressed.animation.play('idle');
		bodyDressed.clipRect = FlxRect.get(0, 0, body.width, 0);
		pole = new FlxSprite().loadGraphic(Paths.getImage('ui/menus/easterEggStartups/princesspower/pole'));
		head = new FlxSprite();
		head.frames = Paths.getSparrowAtlas('ui/menus/easterEggStartups/princesspower/head');
		head.animation.addByPrefix('spin', 'idle', 24);
		head.animation.addByIndices('idle', 'idle', [0], '');
		head.animation.play('idle');

		ajuniga = new FlxSprite().loadGraphic(Paths.getImage('ui/menus/language/ajuniga'));
		ajuniga.screenCenter();
		ajuniga.origin.y = ajuniga.height * 0.475;
		ajuniga.y += 40;
		ajuniga.scale.set(0, 0);
		ajuniga.camera = camHUD;

		glitter.antialiasing = ajuniga.antialiasing = body.antialiasing = bodyDressed.antialiasing = head.antialiasing = pole.antialiasing = !Preferences.data.enableForcedAliasing;

		bodyDressedShadow = new FlxTrail(body, null, 10, 2, 0.325, 0.05);
		bodyDressedShadow.color = 0xFF00C060;
		
		add(glitter);
		add(bodyDressedShadow);
		add(body);
		add(bodyDressed);
		add(head);
		add(pole);

		var leftBar = new FlxSprite().makeGraphic(Std.int((FlxG.width - FlxG.width * 3 / 4) / 2), FlxG.height, 0xFF000000);
		leftBar.camera = camHUD;
		add(leftBar);
		var rightBar = new FlxSprite().makeGraphic(Std.int((FlxG.width - FlxG.width * 3 / 4) / 2), FlxG.height, 0xFF000000);
		rightBar.x = FlxG.width - rightBar.width;
		rightBar.camera = camHUD;
		add(rightBar);
		add(ajuniga);

		FlxG.camera.flash(0xFFFFFFFF, 0.25);
		glitter.alpha = 1;
		SuffState.playMusic('utilities');
		allowToSkip = true;
		FlxTween.tween(body, {y: (FlxG.height - body.height) / 2}, 60 / 170 * 16, {
			ease: FlxEase.cubeInOut,
			onComplete: function(_) {
				SuffState.playSound(Paths.getSound('game/denialActivatePressurize'), 1);
				FlxG.camera.flash(0xFFFFFFFF, 0.25);
				head.animation.play('spin', true);
				startTf = true;
			}
		});
	}

	var startTf:Bool = false;
	var tfFinished:Bool = false;
	var spawnSparkleTick:Float = 0;
	var spawnShadowTick:Float = 0;

	function skipIntro() {
		if (!allowToSkip)
			return;

		allowToSkip = false;

		FlxTween.cancelTweensOf(body);
		FlxTween.tween(body, {y: -body.height - 180}, 1, {ease: FlxEase.backIn});
		FlxTween.tween(bodyDressed.scale, {x: 1.5, y: 1.5}, 1, {ease: FlxEase.backIn});
		SuffState.playSound(Paths.getSound('game/skills/skillAmnesia'), 1, 0.75);
		SuffState.playSound(Paths.getSound('game/skills/skillAmnesia'), 1, 0.75);
		new FlxTimer().start(1 + FlxG.random.float(), function(_) {
			SuffState.playMusic('null');
			SuffState.playSound(Paths.getSound('scream'), 1);
			FlxTween.tween(ajuniga.scale, {x: 4, y: 3}, 0.25, {onComplete: function(_) {
				new FlxTimer().start(0.25, function(_) {
					SuffState.playSound(Paths.getSound('aCarinhaDele'), 0.125);
					FlxTransitionableState.skipNextTransIn = true;
					SuffState.switchState(new MainMenuState());
				});
			}});
		});
	}

	public override function update(elapsed:Float) {
		body.clipRect = FlxRect.get(0, bodyDressed.clipRect.height, body.width, body.height - bodyDressed.clipRect.height);
		bodyDressed.x = pole.x = body.x;
		bodyDressed.y = pole.y = body.y;
		head.x = body.x + 248;
		head.y = body.y + 84;
		body.offset.x = Math.sin(this.elapsedTime * Math.PI * 0.5) * 64;
		body.offset.y = Math.sin(this.elapsedTime * Math.PI) * 16;
		head.offset.x = bodyDressed.offset.x = pole.offset.x = body.offset.x;
		head.offset.y = bodyDressed.offset.y = pole.offset.y = body.offset.y;
		super.update(elapsed);
		
		
		if (startTf) {
			bodyDressed.clipRect.height += elapsed * body.height / (60 / 170 * 16);
			spawnSparkleTick -= elapsed;
			if (spawnSparkleTick <= 0) {
				var curDressWidth = dressWidths[Math.floor(bodyDressed.clipRect.height / dressWidthQuant)];
				var sparkleCount = Std.int(curDressWidth * 0.05);
				for (i in 0...sparkleCount) {
					var sparkle:Sparkle = new Sparkle(body.x + (body.width - curDressWidth) / 2 + curDressWidth / (sparkleCount - 1) * i, body.y + bodyDressed.clipRect.height, function(_) _.destroy(), 0.5);
					sparkle.x += FlxG.random.int(-20, 20);
					sparkle.y += FlxG.random.int(-20, 20);
					sparkle.acceleration.y -= FlxG.random.int(180, 1920);
					sparkle.velocity.x = FlxG.random.int(-320, 320);
					add(sparkle);
				}
				SuffState.playSound(Paths.getSoundRandom('ui/transition/pop', 1, 5), FlxG.random.float(0.25, 0.5), FlxG.random.float(3, 5));
				spawnSparkleTick = 0.1;
			}
			if (bodyDressed.clipRect.height >= body.height) {
				remove(bodyDressedShadow);
				bodyDressedShadow.destroy();
				bodyDressedShadow = new FlxTrail(bodyDressed, null, 10, 3, 0.325, 0.05);
				bodyDressedShadow.color = 0xFF00C060;
				members.insert(members.indexOf(bodyDressed) - 1, bodyDressedShadow);
				bodyDressed.clipRect.height = bodyDressed.height;
				allowToSkip = false;
				startTf = false;
				tfFinished = true;
				new FlxTimer().start(0.5, function(_) {
					SuffState.playSound(Paths.getSound('game/confetti'), 0.75, 4);
					bodyDressed.scale.set(1.2, 0.8);
					FlxTween.tween(bodyDressed.scale, {x: 1, y: 1}, 0.75, {ease: FlxEase.cubeOut});
					bodyDressed.animation.play('pose', true);
					new FlxTimer().start(1, function(_) {
						bodyDressed.animation.play('fly', true);
						allowToSkip = true;
						skipIntro();
					});
				});
			}
		}

		body.visible = pole.visible = head.visible = (bodyDressed.animation.curAnim.name == 'idle');

		if (Controls.justPressed('exit') || FlxG.mouse.justPressed) {
			skipIntro();
		}
	}
}
