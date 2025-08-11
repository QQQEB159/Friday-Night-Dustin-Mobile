//
import flixel.tweens.FlxTweenManager;

var normalStrumPoses:Array<Array<Array<Int>>> = [];
var modChartTweens:FlxTweenManager;

var ogBFColor:FlxColor = 0xFFFFFFFF;
var heart:FlxSprite;
function postCreate() {
    modChartTweens = new FlxTweenManager();
    for (i=>strum in strumLines.members) {
        normalStrumPoses[i] = [for (s in strum.members) [s.x, s.y]];
    }

    strumLines.members[1].onNoteUpdate.add(onNoteUpdate);

    heart = new FunkinSprite().loadGraphic(Paths.image("game/heart"));
	heart.scale.set(48/1024, 48/1024);
	heart.updateHitbox(); heart.visible = false;
	heart.antialiasing = false;
    heart.cameras = [camCharacters];
	add(heart);

    ogBFColor = ogHealthColors[1];
    FlxG.sound.play(Paths.sound('soul_transformation'), 0); // preload
}

function stepHit(step:Int) {
    switch (step) {
        case 544: 
            time = 0; 
            if (FlxG.save.data.mechanics) {
                doPapModChart = doSineChart = true;
            }

            FlxTween.num(0, 1, (Conductor.stepCrochet / 1000) * 32, {ease: FlxEase.sineInOut, startDelay: (Conductor.stepCrochet / 1000) * 1}, (val:Float) -> {sineAmount = val;});
            FlxTween.num(0, .7, (Conductor.stepCrochet / 1000) * 4, {ease: FlxEase.sineInOut, startDelay: (Conductor.stepCrochet / 1000) * 1}, (val:Float) -> {pluey = val;});

            heart.colorTransform.color = 0xFF003cff; heart.visible = true;
            FlxG.sound.play(Paths.sound('soul_transformation'), .75);
        case 800: 
            if (FlxG.save.data.mechanics) {
                doPapModChart = false; doSineChart = false;
            }
            pluey = 0;
            heart.colorTransform.color = 0xffff0000;
        case 832: if (FlxG.save.data.mechanics) doSansMechanicSustains = true;
        case 1000: 
            if (FlxG.save.data.mechanics) {
                doSineChart = true;
                doSansMechanicNormal = true;
            }

            FlxTween.num(0, 1.3, (Conductor.stepCrochet / 1000) * 6, {ease: FlxEase.sineInOut, startDelay: (Conductor.stepCrochet / 1000) * 1}, (val:Float) -> {sineAmount = val;});
            FlxTween.num(0, .7, (Conductor.stepCrochet / 1000) * 4, {ease: FlxEase.sineInOut, startDelay: (Conductor.stepCrochet / 1000) * 1}, (val:Float) -> {pluey = val;});

            heart.colorTransform.color = 0xFF003cff; heart.visible = true;
            FlxG.sound.play(Paths.sound('soul_transformation'), .75);
        case 1572:
            heart.colorTransform.color = 0xffff0000;
            FlxTween.num(1.3, 0, (Conductor.stepCrochet / 1000) * 6, {ease: FlxEase.sineInOut, startDelay: (Conductor.stepCrochet / 1000) * 1}, (val:Float) -> {sineAmount = val;});
            FlxTween.num(.7, 0, (Conductor.stepCrochet / 1000) * 8, {ease: FlxEase.sineInOut, startDelay: (Conductor.stepCrochet / 1000) * 1}, (val:Float) -> {pluey = val;});
        case 1592:
            heart.colorTransform.color = null;
            FlxTween.tween(heart, {alpha: 0},  (Conductor.stepCrochet / 1000) * 6, {ease: FlxEase.sineInOut});
            doSansMechanicNormal = doSansMechanicSustains = false;
    }
}

public var doPapModChart:Bool = false;
public var doSineChart:Bool = false;
var sineAmount:Float = 0;
public var pluey:Float = 0; // bluey pluey same thing... - lunar
function beatHit(beat:Int) {
    if (!doPapModChart) return;
    for (i=>strum in strumLines.members[1].members) {
        if ((beat % 2 == 0 && (i == 0 || i == 2)) || (beat % 2 != 0 && (i == 1 || i == 3))) continue;

        modChartTweens.cancelTweensOf(strum);
        modChartTweens.cancelTweensOf(strum.scale);

        strum.y = normalStrumPoses[1][i][1]; strum.scale.y = 0.646; strum.scale.x = 0.646; strum.angle = 0;
        strum.health = -1;

        modChartTweens.tween(strum.scale, {y: finalNotesScale*1.15, x: finalNotesScale*1.15}, ((Conductor.crochet / 4) / 1000), { // SCALE TWEEN
            ease: FlxEase.circOut,
            onComplete: function() {
                modChartTweens.tween(strum.scale, {y: 0.646, x: 0.646}, ((Conductor.crochet / 4) / 1000), {ease: FlxEase.circIn, startDelay: 0.2});

        }});

        modChartTweens.tween(strum, {x: normalStrumPoses[1][i][0], y: normalStrumPoses[1][i][1] - FlxG.random.int(38,42), angle: -20 * (beat % 2 == 0 ? -1 : 1)}, (Conductor.crochet / 3) / 1000, { // BOUNCY
            ease: FlxEase.circOut,
            onComplete: function() {
                modChartTweens.tween(strum, {x: normalStrumPoses[1][i][0], y: normalStrumPoses[1][i][1], angle: 0}, (Conductor.crochet / 3) / 1000, {ease: FlxEase.circIn, startDelay: 0.1, onComplete: (_) -> {strum.health = 1;}});
        }});
    }
}

var time:Float = 0;
function update(elapsed:Float) {
    time += elapsed;

    var tweenedObjects:Array<Dynamic> = [];
    modChartTweens.update(elapsed);
    for (tween in modChartTweens._tweens)
        tweenedObjects.push(tween._object);

    for (i=>strum in strumLines.members[1].members) {
        if (!tweenedObjects.contains(strum)) {
            strum.x = normalStrumPoses[1][i][0];
            strum.y = normalStrumPoses[1][i][1];
            strum.angle = 0;
        }

        if (strum.health != -1 && doSineChart) {
            strum.x += (10*FlxMath.fastCos((time*3) + ((Conductor.stepCrochet / 1000) * (i*2) * 4)))*sineAmount;
            strum.y += (8*FlxMath.fastSin((time*3) + ((Conductor.stepCrochet / 1000) * (i*2) * 4)))*sineAmount;
            strum.angle += (8*FlxMath.fastSin((time*3) + ((Conductor.stepCrochet / 1000) * (i*2) * 4)))*sineAmount;
        }

        strum.noteAngle = strum.angle*.3;
    }

    heart.x = boyfriend.x+160+(3*FlxMath.fastCos((time*1.3) + ((Conductor.stepCrochet / 1000))));
    heart.y = boyfriend.y+525+(4*FlxMath.fastSin((time*2) + ((Conductor.stepCrochet / 1000))));

    switch (boyfriend.animation.name) {
        case "singLEFT" | "singLEFTmiss": heart.x -= 110; heart.y -= 15;
        case "singDOWN" | "singDOWNmiss": heart.x -= 65; heart.y += 85;
        case "singUP" | "singUPmiss": heart.x += 30; heart.y -= 65;
        case "singRIGHT" | "singRIGHTmiss": heart.x += 110; heart.y += 5;
    }

    if (pluey != -1) {
        var strumColor:FlxColor = FlxColor.interpolate(0xFFFFFFFF, 0xFF2C61FF, pluey);
        for (i=>strum in strumLines.members[1].members)
            strum.color = strumColor;
        strumLines.members[1].notes.forEach(function (note) {
            note.color = strumColor;
        });
        dustiniconP1.color = boyfriend.color = strumColor;
        ogHealthColors[1] = FlxColor.interpolate(ogBFColor, 0xFF062792, pluey*1.3);
    }

}

var slowTime:Float = (hitWindow * 0.5 * 2.4);
var slowSustainTime:Float = slowTime*1.2;

var doSansMechanicNormal:Bool = false;
var doSansMechanicSustains:Bool = false;
function onNoteUpdate(e:NoteUpdateEvent) {
    var note:Note = e.note;
    if (note.isSustainNote) return;

    var nextNoteIsSustain:Bool = note.nextNote != null ? note.nextNote.isSustainNote : false;
    var timeToUse:Float = nextNoteIsSustain ? slowSustainTime : slowTime;

    var allowedSustains:Bool = (doSansMechanicSustains && nextNoteIsSustain);
    var allowedNormal:Bool = (doSansMechanicNormal && !nextNoteIsSustain);

    if ((note.strumTime > (Conductor.songPosition + timeToUse)) && (allowedSustains || allowedNormal)) {
        e.__reposNote = false;

        var strum:Strum = strumLines.members[1].members[note.noteData];
        var posx = strum.x+((strum.width-note.width)/2);
        note.x = posx;

        var posy:Float = (note.strumTime - Conductor.songPosition) * (0.45 * CoolUtil.quantize(scrollSpeed, 100));
        // if (note.isSustainNote) pos += Strum.N_WIDTHDIV2;
        posy += strum.y;

        var progress:Float = 1-((note.strumTime - (Conductor.songPosition+timeToUse))/2000);
        note.y = FlxMath.lerp(nextNoteIsSustain ? 3200 : 5300, posy, FlxEase.quadIn(progress));
        
        // var progress2:Float = FlxEase.circOut(1-(note.strumTime - ((Conductor.songPosition+(timeToUse*1.3))))/1000);
        // note.x = FlxMath.lerp((note.noteData > 1) ? 120 : -120, posx, FlxEase.quadIn(progress));
    }
}