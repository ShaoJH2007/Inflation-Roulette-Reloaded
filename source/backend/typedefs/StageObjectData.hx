package backend.typedefs;

typedef StageObjectData = {
	id:String,
	?type:String,
	graphic:String,
	position:Array<String>,
	?shader:String,
	?hideInDecreaseDetail:Bool,
	?showInDecreaseDetail:Bool,
	?angle:Float,
	?alpha:Float,
	?flipX:Bool,
	?flipY:Bool,
	?blend:String,
	?color:String,
	?antialiasing:Bool,
	?velocity:Array<Float>,
	?angularVelocity:Float,
	?scrollFactor:Array<Float>,
	?scale:Array<Float>,
	?updateHitbox:Bool,
	?animations:Array<AnimationData>,
	?hideCharacter:String, // Hide this graphic when this character is in the game.
	?showCharacter:String, // Show this graphic when this character is in the game.
	?respawnTime:Float,
	?randomAnim:Bool,
	?randomAnimOnRespawn:Bool,
	?walkMovement:Array<Float>,
	?reactionTime:Float,
	?walkStep:Array<Float>,
}
