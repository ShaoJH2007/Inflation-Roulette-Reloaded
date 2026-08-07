package states;
import ui.objects.SuffVideoSprite;
import backend.Gameplay;
import backend.ShaderUtil;

class StartupState extends SuffState {
	var allowToSkip:Bool = false;
	var bg:FlxSprite;
	var video:SuffVideoSprite;
	static final videoSkipTime:Int = 6913;
	var noSkipTimer:FlxTimer;

	public override function create() {
		super.create();

		Window.setTitle(Constants.COPYRIGHT);

		var bgList = Gameplay.globalStageList.copy();
		bgList.remove('void');
		bg = new FlxSprite().loadGraphic(Paths.getImage('ui/menus/characterSelect/stages/blurred/${FlxG.random.getObject(bgList)}'));
		bg.setGraphicSize(FlxG.width * 1.25);
		bg.updateHitbox();
		bg.screenCenter(Y);
		bg.alpha = 0;
		add(bg);
		
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
		add(video);

		if (video.load(Paths.getVideo('nicklySufferLogo_noBg'))) {
			FlxTween.tween(bg, {alpha: 1}, 1, {
				onComplete: function(_) {
					FlxTween.tween(bg, {alpha: 0}, 1, {
						startDelay: 3.5
					});
				}
			});
			FlxTween.tween(bg, {x: FlxG.width - bg.width}, 5.5);
			video.start();
			video.shader = ShaderUtil.initShader('nicklySufferLogo');
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
		allowToSkip = false;

		video.time = videoSkipTime;
	}

	public override function update(elapsed:Float) {
		super.update(elapsed);

		if (!video.isPlaying) return;
		if (Controls.justPressed('exit') || FlxG.mouse.justPressed) {
			skipIntro();
		}
	}
}
