package states.extras;

import ui.objects.SuffIconButton;
import flixel.addons.display.FlxGridOverlay;
import ui.objects.GalleryEnvelope;
import states.extras.GalleryEntryState;

class GalleryMainMenuState extends SuffState {
	var allowInput:Bool = false;

	var bg:FlxSprite;
	var leftButton:SuffIconButton;
	var rightButton:SuffIconButton;
	var grid:FlxBackdrop;
	var envelopes:FlxTypedSpriteGroup<GalleryEnvelope> = new FlxTypedSpriteGroup<GalleryEnvelope>();
	var exitButton:SuffIconButton;
	var allowInputTimer:FlxTimer;

	var envelopeWidth:Float = 0;
	final envelopeSpacing:Float = 80;

	public var currentPage:Int = 0;
	public var lastPage:Int = 0;
	public static var envelopesPerPage = 6;
	var envelopeList:Array<String> = [];

	public override function create() {
		Paths.clearUnusedMemory();
		Paths.clearStoredMemory();

		super.create();

		WindowUtil.setTitle(Language.getPhrase('galleryMainMenu.windowDisplay'));

		bg = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, 0xFFFFFFFF);
		bg.color = 0xFFE0E0E0;
		bg.scrollFactor.set();
		add(bg);

		grid = new FlxBackdrop(FlxGridOverlay.createGrid(64, 64, 128, 128, true, 0x60FFFFFF, 0x00FFFFFF));
		grid.scrollFactor.set();
		grid.velocity.set(64, 64);
		add(grid);

		add(envelopes);
		envelopeList = Paths.readDirectories('data/extras/gallery/envelopes', 'data/extras/gallery/envelopes/envelopeList.txt', 'json');
		envelopeList.remove('dev');
		envelopeList.push('dev');
		envelopeList.remove('community');
		envelopeList.push('community');
		trace(envelopeList);
		envelopesPerPage = Std.int(Math.max(1, (FlxG.width - ScreenSafeArea.X * 2 - 140 - 140) / (envelopeSpacing * 2)));
		lastPage = Math.ceil(envelopeList.length / envelopesPerPage) - 1;
		if (lastPage < 0)
			lastPage = 0;
		// Make sure dev envelope is at the last

		leftButton = new SuffIconButton(20 + ScreenSafeArea.X, 20, 'buttons/left', null, 2);
		leftButton.screenCenter(Y);
		leftButton.onClick = function() {
			changePage(-1);
		};
		add(leftButton);

		rightButton = new SuffIconButton(20, 20, 'buttons/right', null, 2);
		rightButton.x = FlxG.width - rightButton.width - 20 - ScreenSafeArea.X;
		rightButton.screenCenter(Y);
		rightButton.onClick = function() {
			changePage(1);
		};
		add(rightButton);

		changePage(0, true);

		exitButton = new SuffIconButton(20, 20 + ScreenSafeArea.Y, 'buttons/exit', null, 2);
		exitButton.x = FlxG.width - exitButton.width - 20 - ScreenSafeArea.X;
		exitButton.onClick = function() {
			exitMenu();
		};
		add(exitButton);
	}
	
	function changePage(delta:Int = 0, initialize:Bool = false) {
		if (!allowInput && !initialize)
			return;
		if (allowInputTimer != null)
			allowInputTimer.cancel();
		leftButton.visible = false;
		rightButton.visible = false;
		allowInput = false;
		currentPage = Std.int(FlxMath.bound(currentPage + delta, 0, lastPage));
		if (initialize)
			loadPage();
		else {
			envelopes.forEachAlive(function(member:GalleryEnvelope) {
				member.intendedPos.x = FlxMath.signOf(delta) == 1 ? -member.width - 100 : FlxG.width + 100;
			});
			new FlxTimer().start(0.25, function(_) loadPage());
		}
	}
	
	function loadPage() {
		var firstIndex = currentPage * envelopesPerPage;
		var lastIndex = Std.int(Math.min(firstIndex + envelopesPerPage, envelopeList.length) - 1);
		var miniListLength = lastIndex - firstIndex + 1;
		envelopes.clear();
		for (member in envelopes) {
			var envelope = member;
			FlxTween.cancelTweensOf(envelope);
			envelope.destroy();
		}
		envelopes.x = 0;
		for (num in 0...miniListLength) {
			var item = envelopeList[num + firstIndex];
			var envelope:GalleryEnvelope = new GalleryEnvelope(0, 0, item);
			envelopeWidth = envelope.width + envelopeSpacing * (miniListLength - 1);
			envelope.originalPos = FlxPoint.get((FlxG.width - envelopeWidth) / 2 + num * envelopeSpacing, (FlxG.height - envelope.height) / 2);
			envelope.x = envelope.intendedPos.x = envelope.originalPos.x;
			envelope.y = envelope.intendedPos.y = FlxG.height + 100;
			FlxTween.tween(envelope, {'intendedPos.y': envelope.originalPos.y}, 0.75, {
				ease: FlxEase.quintOut,
				startDelay: 0.1 * num,
				onStart: function(_) {
					SuffState.playUISound(Paths.getSoundRandom('game/weapon', 1, 3), 1, 2.25 + Math.random() * 0.25);
				},
				onUpdate: function(_) {
					envelope.y = envelope.intendedPos.y;
				}
			});
			envelope.onClick = function() {
				confirmSelection();
			};
			envelopes.add(envelope);
		}
		allowInputTimer = new FlxTimer().start(miniListLength * 0.1 + 0.4, function(_){
			allowInput = true;
		});
		leftButton.visible = (currentPage > 0);
		rightButton.visible = (currentPage < lastPage);
	}

	function exitMenu() {
		if (!allowInput) return;
		allowInput = false;
		SuffState.switchState(new MainMenuState());
	}

	function confirmSelection() {
		allowInput = false;
		FlxTween.tween(leftButton, {alpha: 0}, 0.25);
		FlxTween.tween(rightButton, {alpha: 0}, 0.25);
		FlxTween.tween(exitButton, {alpha: 0}, 0.25);
		for (num => item in envelopes.members) {
			item.disabled = true;
			if (num == selectedIndex) {
				GalleryEntryState.envelopeData = item.envelopeData;
				FlxTween.tween(item, {
					'intendedPos.x': (FlxG.width - item.width) / 2,
					'intendedPos.y': (FlxG.height - item.height) / 2,
					angle: 0
				}, 0.25, {
					ease: FlxEase.quintOut
				});
				FlxTween.color(bg, 0.5, bg.color, FlxColor.fromString(item.envelopeData.color));
			} else {
				FlxTween.tween(item, { 'intendedPos.y': FlxG.height * 1.25 }, 0.25, {
					ease: FlxEase.quintOut
				});
			}
		}
		new FlxTimer().start(0.5, function(_) {
			SuffState.switchState(new GalleryEntryState());
		});
	}

	var selectedIndex:Int = 0;

	public override function update(elapsed:Float) {
		super.update(elapsed);

		if (!allowInput)
			return;

		selectedIndex = Math.floor((FlxG.mouse.getScreenPosition(this.camera).x - (FlxG.width - envelopeWidth) / 2)
		/ (envelopeWidth / envelopes.members.length));
		selectedIndex = Std.int(FlxMath.bound(selectedIndex, 0, envelopes.members.length - 1));
		var selectedMember = envelopes.members[selectedIndex];
		if (selectedMember == null)
			return;
		selectedMember.intendedPos.x = selectedMember.originalPos.x;
		for (num => item in envelopes.members) {
			item.disabled = num != selectedIndex;
			if (num != selectedIndex) {
				item.intendedPos.y = (FlxG.height - item.height) / 2 + envelopeSpacing * 2;
				if (num > selectedIndex) {
					item.intendedPos.x = selectedMember.originalPos.x + selectedMember.width / 2 + envelopeSpacing * (num -
					selectedIndex);
				} else if (num < selectedIndex) {
					item.intendedPos.x = selectedMember.originalPos.x - selectedMember.width / 2 + envelopeSpacing * (num -
					selectedIndex);
				}
			} else {
				item.intendedPos.y = (FlxG.height - item.height) / 2;
			}
		}
		if (Controls.justPressed('exit')) {
			exitMenu();
		}
	}
}