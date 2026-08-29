package states;
import ui.objects.SuffVideoSprite;
import backend.Gameplay;
import shaders.MeltShader;
import shaders.BlackToAlphaShader;

class StartupState extends SuffState {
	var allowToSkip:Bool = false;
	var bg:FlxSprite;
	var bgAlphaTween:FlxTween;
	var video:SuffVideoSprite;
	static final videoSkipTime:Int = 6913;
	var noSkipTimer:FlxTimer;
	
	var meltShader:MeltShader;
	var blackToAlphaShader:BlackToAlphaShader;

	public override function create() {
		super.create();

		WindowUtil.setTitle(Constants.COPYRIGHT);

		var bgList = Gameplay.globalStageList.copy();
		bgList.remove('void');
		bg = new FlxSprite().loadGraphic(Paths.getImage('ui/menus/characterSelect/stages/blurred/${FlxG.random.getObject(bgList)}'));
		bg.setGraphicSize(FlxG.width * 1.25);
		bg.updateHitbox();
		bg.antialiasing = !Preferences.data.enableForcedAliasing;
		bg.screenCenter(Y);
		bg.alpha = 0;
		
		video = new SuffVideoSprite(0, 0);
		video.onFormat(function() {
			video.setGraphicSize(FlxG.width);
			video.updateHitbox();
			video.screenCenter();
			video.volume = Preferences.data.musicVolume;
		});
		video.onEnd(function() {
			FlxTransitionableState.skipNextTransIn = true;
			SuffState.switchState(new MainMenuState());
		});

		if (Preferences.data.enableGLSL) {
			meltShader = new MeltShader();
			bg.shader = meltShader;
			add(bg);
			add(video);
		} else {
			bg.blend = LIGHTEN;
			add(video);
			add(bg);
		}

		if (video.load(Paths.getVideo('nicklySufferLogo'))) {
			bgAlphaTween = FlxTween.tween(bg, {alpha: 0.75}, 1, {
				onComplete: function(_) {
					FlxTween.tween(bg, {alpha: 0}, 1, {
						startDelay: 3.5
					});
				}
			});
			bg.velocity.x = (FlxG.width - bg.width) / 5.5;
			video.start();
			if (Preferences.data.enableGLSL) {
				blackToAlphaShader = new BlackToAlphaShader();
				video.shader = blackToAlphaShader;
			}
			allowToSkip = true;
			noSkipTimer = new FlxTimer().start(videoSkipTime * 0.001, function(_ ) allowToSkip = false);
		} else {
			trace('Cannot load startup video. Skipping.');
			FlxTransitionableState.skipNextTransIn = true;
			SuffState.switchState(new MainMenuState());
		}
	}

	function skipIntro() {
		if (!allowToSkip)
			return;
		noSkipTimer.cancel();
		bgAlphaTween.cancel();
		bg.destroy();
		allowToSkip = false;

		video.time = videoSkipTime;
	}

	public override function update(elapsed:Float) {
		super.update(elapsed);
		
		if (bg != null && meltShader != null)
			meltShader.update(elapsed);
		
		if (!video.isPlaying) return;
		if (Controls.justPressed('exit') || FlxG.mouse.justPressed) {
			skipIntro();
		}
	}
}
