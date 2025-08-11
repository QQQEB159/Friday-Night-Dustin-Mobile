//
var bouncingTween:FlxTween;
var heart:FlxSprite;
var strumShiftAmount:Float = -320;
var strumsShifted:Bool = false;

function postCreate() {
    heart = new FunkinSprite().loadGraphic(Paths.image("game/monster_heart"));
    heart.scale.set(0.1, 0.1);
    heart.updateHitbox();
    heart.antialiasing = false;
    add(heart);

    heart.x = 2000; heart.y = 1200;
    heart.alpha = 0;

    autoTitleCard = false;

    stage.getSprite("guitar_background").visible = false;
    stage.getSprite("guitar_foreground").visible = false;
    stage.getSprite("ghosts").visible = false;

    executeEvent({
        name: "Screen Coverer",
        time: Conductor.songPosition,
        params: [false, 0xFF000000, 1, 4, "linear", "In", "camHUD", "front"]
    });
}

function stepHit(step:Int) {
    switch (step) {
        case 292:
            showTitleCard();
        case 1404:
            strumLines.members[2].characters[0].visible = true;
            bg_char.y =  bg_char.y + 600;
            dad.x = dad.x + 200;
            dad.y = dad.y - 50;
        case 1422:
            FlxTween.tween(bg_char, {y: bg_char.y - 600}, 0.7, {
                ease: FlxEase.quadOut,
                onComplete: function(twn:FlxTween) {
                    startBouncing();
                }
            });
        case 1472:
            if (bouncingTween != null) {
                bouncingTween.cancel();
                bouncingTween = null;
            }
        case 1896:
            FlxTween.tween(dad, {x: dad.x + 550}, 0.7, {ease: FlxEase.quintInOut});
            FlxTween.tween(dad, {y: dad.y + 30}, 0.7, {ease: FlxEase.quintInOut});
        case 1960:
            FlxTween.tween(dad, {x: dad.x - 550}, 0.7, {ease: FlxEase.quintInOut});
            FlxTween.tween(dad, {y: dad.y - 30}, 0.7, {ease: FlxEase.quintInOut});
        case 2408:
            strumLines.members[3].characters[0].visible = true;
        case 2416:
            FlxTween.tween(heart, { y: 700, alpha: 1 }, 3, { ease: FlxEase.quadOut });
        case 2436:
            heart.visible = false;
            FlxG.camera.shake(0.05, 0.3);


        case 2992:
            shiftStrums();

        case 3104:
            FlxTween.tween(scoreTxt, {alpha: 1}, 1, {ease: FlxEase.quadOut});
            FlxTween.tween(accuracyTxt, {alpha: 1}, 1, {ease: FlxEase.quadOut});
            FlxTween.tween(missesTxt, {alpha: 1}, 1, {ease: FlxEase.quadOut});

            for (strum in playerStrums.members)
                if (strum != null)
                    FlxTween.tween(strum, {alpha: 1}, 1, {ease: FlxEase.quadOut});

            for (strumLine in strumLines)
                for (note in strumLine.notes)
                    FlxTween.tween(note, {alpha: 1}, 1, {ease: FlxEase.quadOut});
        case 3112:
            stage.getSprite("guitar_background").visible = true;
            stage.getSprite("guitar_foreground").visible = true;

            stage.getSprite("room").visible = false;
            stage.getSprite("tenna").visible = false;
            stage.getSprite("lights").visible = false;
            stage.getSprite("bg_char").visible = false;
            dad.visible = false;
            strumLines.members[3].characters[0].visible = false;
            strumLines.members[2].characters[0].visible = false;
            strumLines.members[4].characters[0].visible = false;
        case 3124:
            FlxG.camera.shake(0.04, 0.3);
        case 3252:
            FlxG.camera.shake(0.02, 0.2);
            stage.getSprite("ghosts").visible = true;
    }
}

function startBouncing() {
    bouncingTween = FlxTween.tween(bg_char, {y: bg_char.y + 100}, 0.5, {
        type: FlxTween.PINGPONG,
        ease: FlxEase.sineInOut,
        looped: true
    });
}

function shiftStrums():Void {
    var shift = strumsShifted ? -strumShiftAmount : strumShiftAmount;
    var tweenTime = 0.5;
    var tweensLeft = 0;


    for (strumLine in strumLines) {
        for (sprite in strumLine.members) {
            if (sprite != null) {
                tweensLeft++;
                FlxTween.tween(sprite, {x: sprite.x + shift}, tweenTime, {
                    ease: FlxEase.quadOut,
                });
            }
        }

        for (note in strumLine.notes) {
            if (note != null) {
                tweensLeft++;
                FlxTween.tween(note, {x: note.x + shift}, tweenTime, {
                    ease: FlxEase.quadOut,
                });
            }
        }
    }

    strumsShifted = !strumsShifted;
}