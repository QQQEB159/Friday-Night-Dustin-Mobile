var canTrail:Bool = false;
var trailTimer:Float = 0;
var trailInterval:Float = 0.200; // Every 1/8 second (~120 BPM step rate)
var dadTrails:Array<FlxSprite> = [];

function postCreate() {
	stage.getSprite("final_rocks").camera = camGame;

	stage.getSprite("final_rocks").visible = false;
	stage.getSprite("rocks").visible = false;
}

function beatHit(beat:Int) {
	if (beat >= 329 && beat % 4 == 1 && beat < 521) {
		FlxG.camera.shake(0.02, 0.5);
		stage.getSprite("rocks").visible = true;
		stage.getSprite("rocks").playAnim("rocks_falling");
	}

	if (beat == 521) {
		FlxG.camera.shake(0.05, 1.5);
		stage.getSprite("final_rocks").visible = true;
		stage.getSprite("final_rocks").playAnim("rocks_ending");
	}
}

function stepHit(step:Int) {
	if (step >= 1828) {
		canTrail = true;
	}
}

function update(elapsed:Float) {
    if (canTrail) {
    	trailTimer += elapsed;
	    if (trailTimer >= trailInterval) {
	        trailTimer = 0;
	        spawnDadTrail();
	    }
    }
    
}

function spawnDadTrail() {
    var xOffset = FlxG.random.float(-50, 50);
    var yOffset = FlxG.random.float(-50, 50);
    var trail = new FlxSprite(dad.x + xOffset + -600, dad.y + yOffset + 200);

    trail.frames = dad.frames;
    trail.animation.copyFrom(dad.animation);
    trail.animation.play(dad.animation.name, true);
    trail.animation.curAnim.curFrame = dad.animation.curAnim.curFrame;
    trail.scale.set(dad.scale.x, dad.scale.y);
    trail.offset.set(dad.offset.x, dad.offset.y);
    trail.updateHitbox();
    trail.alpha = 0.4;
    trail.angle = dad.angle;
    trail.flipX = dad.flipX;
    trail.cameras = [camGame];
    trail.scrollFactor.set(dad.scrollFactor.x, dad.scrollFactor.y);
    insert(members.indexOf(dad), trail);

    dadTrails.push(trail);

    FlxTween.tween(trail, {alpha: 0}, 0.3, {
        onComplete: function(twn:FlxTween) {
            trail.kill();
            remove(trail, true);
            dadTrails.remove(trail);
            trail.destroy();
        }
    });
}