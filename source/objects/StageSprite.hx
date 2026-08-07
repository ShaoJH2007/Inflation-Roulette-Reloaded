package objects;

class StageSprite extends FlxSprite {
	public var walkStep:Array<Float> = [0, 0];
	public var walkMovement:Array<Float> = [0, 0];
	public var randomAnimOnRespawn:Bool = false;
	public var respawnTime:Float = -1;
	public var reactionTime:Float = -1;
	public var animBackToIdle:Bool = true;

	public var age:Float = 0;
	public var totalAge:Float = 0;
	public var originalOffset:FlxPoint = FlxPoint.weak(0, 0);
	public var originalPosition:FlxPoint = FlxPoint.weak(0, 0);

	public function new(x:Float = 0, y:Float = 0) {
		super(x, y);
		originalPosition.set(x, y);
		originalOffset = offset.clone();
		
		if (shader != null && shader?.data != null) {
			if (shader?.data?.iTime != null)
				shader.data.iTime.value = [0];
			if (shader?.data?.iTimeDelta != null)
				shader.data.iTimeDelta.value = [0];
		}
	}
	
	var mouseClickPos:FlxPoint = FlxPoint.get(-1, -1);

	public override function update(elapsed:Float) {
		super.update(elapsed);
		age += elapsed;
		totalAge += elapsed;
		if (walkStep[1] != 0)
			offset.x = originalOffset.x + Math.abs(Math.sin(y / walkStep[1])) * walkMovement[0];
		if (walkStep[0] != 0)
			offset.y = originalOffset.y + Math.abs(Math.sin(x / walkStep[0])) * walkMovement[1];
		if (respawnTime > 0 && age >= respawnTime) {
			age = 0;
			if (randomAnimOnRespawn)
				animation.play(FlxG.random.getObject(animation.getNameList()), true);
			setPosition(originalPosition.x, originalPosition.y);
		}
		
		if (shader != null && shader?.data != null) {
			if (shader?.data?.iTime != null)
				shader.data.iTime.value = [totalAge];
			if (shader?.data?.iTimeDelta != null)
				shader.data.iTimeDelta.value = [elapsed];
			if (shader?.data?.iFrameRate != null)
				shader.data.iFrameRate.value = [FlxG.drawFramerate];
			if (shader?.data.iMouse != null) {
				if (FlxG.mouse.justPressed)
					mouseClickPos.set(FlxG.mouse.x, FlxG.mouse.y);
				if (!FlxG.mouse.pressed) {
					shader.data.iMouse.value = [
						this.x - this.offset.x + mouseClickPos.x,
						this.y - this.offset.y + mouseClickPos.y,
						this.x - this.offset.x + FlxG.mouse.x,
						this.y - this.offset.y + FlxG.mouse.y
					];
				} else {
					shader.data.iMouse.value = [
						this.x - this.offset.x + FlxG.mouse.x,
						this.y - this.offset.y + FlxG.mouse.y,
						-1,
						-1
					];
				}
			}
		}
	}
}