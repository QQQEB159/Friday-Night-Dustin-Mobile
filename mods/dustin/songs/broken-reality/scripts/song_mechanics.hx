//
import flixel.util.FlxSort;

var normalStrumPoses:Array<Array<Array<Int>>> = [];
var arrowSine:Bool = false;

var strumsOffsets:Array = [for (i in 0...4) [0,0]];

function postCreate() {
    for (i=>strum in strumLines.members) {
        normalStrumPoses[i] = [for (s in strum.members) [s.x, s.y]];
    }
}

var drainTimer:Float = 0;
var drainEnabled:Bool = true;
public var drainAmount:Float = 1.2;

public var pluey:Float = 0;
public var hudOffY:Float = 0;
function update(elapsed:Float) {
    if (drainEnabled && drainTimer > 0) {
        if (health >= 0.15) health -= 0.05 * (drainAmount * (didDamage ? .65 : 1)) * elapsed;
        drainTimer -= elapsed;
    }

    for (k => s in strumLines.members[1].members) {
        normalStrumPoses[1][k][1] = strumLines.members[0].members[0].y;
        s.noteAngle = 0;
        s.x = lerp(s.x, normalStrumPoses[1][k][0] + strumsOffsets[k][0], FlxEase.circInOut(.27));
        s.y = lerp(s.y, normalStrumPoses[1][k][1] + strumsOffsets[k][1], FlxEase.circInOut(.27));
    }

    negMultX = lerp(negMultX, desiredMultX, FlxEase.circInOut(.27));
    negMultY = lerp(negMultY, desiredMultY, FlxEase.circInOut(.27));

    hudX = lerp(hudX, desiredHudX, FlxEase.sineInOut(.2));
    moveHUD(hudX, hudY + hudOffY);
    
    if (pluey != -1) {
        var strumColor:FlxColor = FlxColor.interpolate(0xFFFFFFFF, 0xFF83A2FF, pluey);
        for (i=>strum in strumLines.members[1].members)
            strum.color = strumColor;
        strumLines.members[1].notes.forEach(function (note) {
            note.color = strumColor;
        });
    }
}

var hudX:Float = 283.5;
var desiredHudX:Float = 283.5;
var hudY:Float = 564;
var hudTween:FlxTween;
function goDownScroll() {
    if (!FlxG.save.data.mechanics) return;
    pluOUT();

    desiredHudX = 283.5; desiredMultX = 0;
    desiredMultY = -1;

    if (hudTween != null) hudTween.cancelChain();
    for (i in 0...4) {
        (new FlxTimer()).start(i*.06, (_) -> {
            strumsOffsets[i][0] = 0;
            strumsOffsets[i][1] = 506; // 720-50-104-50-10
            FlxTween.cancelTweensOf(strumLines.members[1].members[i]);
            FlxTween.tween(strumLines.members[1].members[i], {angle: -360}, (Conductor.stepCrochet / 1000) * 4, {ease: FlxEase.circOut, onComplete: (_) -> {
                strumLines.members[1].members[i].angle = 0;
            }});
        });
    }

    hudTween = FlxTween.num(hudY, 564+300, (Conductor.stepCrochet / 1000) * 4.5, {ease: FlxEase.circInOut}, (val:Float) -> {
        hudY = val;
    }).then(
        hudTween = FlxTween.num(-400, 50, (Conductor.stepCrochet / 1000) * 4.5, {ease: FlxEase.circInOut}, (val:Float) -> {
            hudY = val;
        })
    );
}

function pluSFX() {
    if (!FlxG.save.data.mechanics) return;
    // camHUD.shake(0.002, 0.3);
    FlxG.sound.play(Paths.sound('undertale/snd_break2'), .67);
    FlxG.sound.play(Paths.sound('undertale/snd_noise'), .8);
    FlxG.sound.play(Paths.sound('undertale/snd_impact'), .2);
}

var doingPLU:Bool = false;
function pluOUT() {
    pluSFX();
    if (doingPLU) return;
    doingPLU = true;

    FlxTween.num(0, .9, (Conductor.stepCrochet / 1000) * 2, {ease: FlxEase.sineInOut, startDelay: (Conductor.stepCrochet / 1000) * 1}, (val:Float) -> {pluey = val;});
    (new FlxTimer()).start((Conductor.stepCrochet / 1000) * 16, function (_) {
        FlxTween.num(.9, 0, (Conductor.stepCrochet / 1000) * 4, {ease: FlxEase.sineInOut, startDelay: (Conductor.stepCrochet / 1000) * 1}, (val:Float) -> {pluey = val;});
        (new FlxTimer()).start((Conductor.stepCrochet / 1000) * 4, function (_) {
            doingPLU = false;
        });
    });
}

function fadeSansStrums(salpha:String) {
    if (!FlxG.save.data.mechanics) return;
    var falpha = Std.parseFloat(salpha);
    for (k=>s in strumLines.members[0].members) {
        FlxTween.tween(s, {alpha: falpha}, (Conductor.stepCrochet / 1000) * 16, {ease: FlxEase.circInOut});
    }
}

function goUpScroll() {
    if (!FlxG.save.data.mechanics) return;
    pluOUT();

    desiredHudX = 283.5; desiredMultX = 0;
    desiredMultY = 1;
    if (hudTween != null) hudTween.cancelChain();
    for (i in 0...4) {
        (new FlxTimer()).start(i*.06, (_) -> {
            strumsOffsets[i][0] = 0;
            strumsOffsets[i][1] = 0; // 720-50-104-50-10
            FlxTween.cancelTweensOf(strumLines.members[1].members[i]);
            FlxTween.tween(strumLines.members[1].members[i], {angle: 360}, (Conductor.stepCrochet / 1000) * 4, {ease: FlxEase.circOut, onComplete: (_) -> {
                strumLines.members[1].members[i].angle = 0;
            }});
        });
    }

    hudTween = FlxTween.num(hudY, -400, (Conductor.stepCrochet / 1000) * 4.5, {ease: FlxEase.circInOut}, (val:Float) -> {
        hudY = val;
    }).then(
        hudTween = FlxTween.num(564+300, 564, (Conductor.stepCrochet / 1000) * 4.5, {ease: FlxEase.circInOut}, (val:Float) -> {
            hudY = val;
        })
    );
}

function moveHUD(hudx:Float, hudy:Float) {
    dustinHealthBG.x = hudx; dustinHealthBG.y = hudy;
    dustinHealthBar.x = hudx + 46;  dustinHealthBar.y = hudy+(camHUD.downscroll ? 25 : 32);
    timeBarBG.x = hudx + 77; timeBarBG.y = hudy + 74;
    timeBar.x = timeBarBG.x; timeBar.y = timeBarBG.y;
    scoreTxt.x = dustinHealthBG.x + 56; scoreTxt.y = dustinHealthBG.y + 114;
    missesTxt.x = dustinHealthBG.x + 116; missesTxt.y = dustinHealthBG.y + 114;
    accuracyTxt.x = dustinHealthBG.x + 116; accuracyTxt.y = dustinHealthBG.y + 114;
}

function create()
    strumLines.members[1].onNoteUpdate.add(onNoteUpdate);

public var desiredMultX:Float = 0;
public var negMultX:Float = 0;
public var desiredMultY:Float = 1;
public var negMultY:Float = 1;
function onNoteUpdate(e:NoteUpdateEvent) {
    e.__reposNote = false;
    var note:Note = e.note;

    var baseScrollFactor:Float = 0.45 * CoolUtil.quantize(scrollSpeed, 100);
    var timeUntilNote:Float = note.strumTime - Conductor.songPosition;
    var posy:Float = timeUntilNote * baseScrollFactor;
    if (note.isSustainNote) posy += Strum.N_WIDTHDIV2;

    note.y = e.strum.y + posy * negMultY;
    note.x = e.strum.x + (((e.strum.width - note.width) / 2) * Math.abs(negMultY)) + (posy * desiredMultX);

    if (note.isSustainNote) {
        note.health = negMultX < 0 ? -1 : 1;
        note.angle = 90 * negMultX; 
        if (note.animation.name == "holdend") {
            note.scale.y = negMultY;
            note.y -= Math.min(0, negMultY)*110;
        }
        note.y -= e.strum.height/2 * baseScrollFactor * Math.abs(Math.min(0, negMultY));
    }
}

function onDadHit()  {
    if (!FlxG.save.data.mechanics) return;
    drainTimer += .12;
}

function enableDrain() {
    if (!FlxG.save.data.mechanics) return;
    drainEnabled = true;
    drainTimer = 0;
}

function disableDrain() {
    if (!FlxG.save.data.mechanics) return;
    drainEnabled = false;
    drainTimer = 0;
}

function changeDrainAmount(salpha:String) {
    if (!FlxG.save.data.mechanics) return;
    var falpha = Std.parseFloat(salpha);
    drainAmount = falpha;
}