//
import flixel.addons.effects.FlxTrail;
import flixel.util.FlxGradient;

var papsBODY:Character;

var dadCircularMotion:Bool = false;
var dadOrbitTime:Float = 0;
var dadOrbitRadius:Float = 150;
var dadStartX:Float = 5000;
var dadStartY:Float = 5000;
var dadEndX:Float = 1000;
var dadBaseY:Float = 300; // BASE PAPS

var ogTimeCol = [];
var ogCol1;

var gradient;

function create() {
    doHealthbarFade = false;
    papsBODY = new Character(0, 0, 'phantom_paps_br_body');
    papsBODY.scrollFactor.set(1, 1);
    papsBODY.x = dad.x - 50;
    papsBODY.y = dad.y + 0;
    papsBODY.scale.set(1.3, 1.3);

    insert(members.indexOf(dad), papsBODY);
    papsBODY.visible = false;

    camMoveOffset = 22;
    autoTitleCard = false;

    gradient = FlxGradient.createGradientFlxSprite(1, 520, [0x00000000,0xA0510F0F, 0xA0510F0F, 0xC4650E0E,0xA9FF0000, 0xFFFF0000, 0xFFFF0000, 0xFFFF0000, 0xFFFF0000],1,-90,true);
    gradient.scale.x = FlxG.width; gradient.updateHitbox();
    gradient.scale.x = 9000;
    gradient.scale.y = 8;
    gradient.angle = 0;
    gradient.flipY = true;
    gradient.updateHitbox();
    gradient.x = dad.x-4900; gradient.y = dad.y-1000;
    gradient.blend = 0; gradient.color = 0xFF7A0B0B;
    gradient.alpha = 0;

    insert(members.indexOf(stage.stageSprites["light"]), gradient);
    add(gradient);
}

function postCreate() {
    ogTimeCol = timeBarColors;
    ogCol1 = healthBarColors[0];
}

var lock24FPS:Array<{sprite:FlxSprite, x:Float, y:Float, anim:String}> = [];
var dad24FPS:{x:Float, y:Float, anim:String} = null;
var head24FPS:{x:Float, y:Float, anim:String} = null;
public var __coolTimer:Float = 0;
function update(elapsed:Float) {
    __coolTimer += elapsed;

    for (info in lock24FPS) {
        var sprite = info.sprite;
        if (sprite.animation.frameName != info.anim) {
            sprite.x = info.x; sprite.y = info.y;
            if (info.angle != null) sprite.angle = info.angle;
            info.anim = sprite.animation.frameName;
        }
    }

    if (dad24FPS != null) {
        var waveSpeed = __coolTimer * 3;
        var bobX = Math.sin(waveSpeed) * 50;
        var bobY = Math.cos(waveSpeed * 0.8) * 40 + Math.sin(waveSpeed * 1.5) * 10;

        dad24FPS.x = dadStartX + bobX - (dadCircularMotion ? 50 : 0);
        dad24FPS.y = dadStartY + bobY;
    }

    if (head24FPS != null) {
        dadOrbitTime += elapsed * 1.5;

        var orbitSpeed = dadOrbitTime * 1.7;
        var t = (Math.sin(orbitSpeed*.8) * 0.5) + .5;
        t += Math.sin(orbitSpeed * 0.5) * 0.15;
        t += Math.cos(orbitSpeed * 1.7) * 0.1;

        var easedT = Math.sin(t * Math.PI * 0.5);

        var mainArc = Math.sin(t * Math.PI) * -dadOrbitRadius * 1.6;
        var tilt = Math.cos(orbitSpeed * 1.2) * 25;
        var sway = Math.sin(orbitSpeed * 3.5) * 15;
        var pulse = Math.sin(orbitSpeed * 0.5) * 10;

        head24FPS.x = FlxMath.lerp(dadStartX, dadEndX, easedT) + tilt + pulse;
        head24FPS.y = dadBaseY + mainArc + sway + pulse + tilt;

        // var papSpin = Math.sin(orbitSpeed/4) * 360;
        // papSpin += Math.sin(orbitSpeed * 0.3) * 90;
        // papSpin += Math.sin(orbitSpeed * .3) * 30;
        // papSpin += Math.cos(dadOrbitTime) * 45;

        // head24FPS.angle = papSpin;
    }

    //gradient.angle = -80 + -Math.abs(10 * Math.sin(__coolTimer*.5));
    for (paptrail in papsTrails) {
        for (i => trail in paptrail.members) {
            var scale = FlxMath.bound(1.3 + .2 + (.2 * FlxMath.fastSin(__coolTimer + (i * FlxG.random.float((Conductor.stepCrochet / 1000) * 0.5, (Conductor.stepCrochet / 1000) * 1.2)))), 0.9, 999);
            trail.scale.set(scale, scale);

            if (dadCircularMotion) 
                trail.centerOrigin();
        }
    }

    if (dadCircularMotion) {
        dad.centerOrigin();
    }

    if ((curStep >= 1664 && curStep <= 3308) && curCameraTarget == 0) {
        camAngleOffset = .6;
    } else {
        camAngleOffset = .3;
    }
}

function stepHit(step:Int) {
    switch(step) {
        case 0:
            if (FlxG.save.data.mechanics) {
     PlayState.qqqeb = true;
     removeMobileControls();
     addMobileControls();
     mobileControls.instance.visible = true;
    }
    mobileControls.instance.buttonLeft.color = 0xFFC24B99;
    mobileControls.instance.buttonDown.color = 0xFFC24B99;
    mobileControls.instance.buttonUp.color = 0xFFC24B99;
    mobileControls.instance.buttonRight.color = 0xFFC24B99;
        case 176:
            showTitleCard();
        case 436:
            camZoomLerpMult = .65;
        case 849:
            createDadClone(dadPos, 1.15);
        case 1664:
            if (FlxG.save.data.mechanics) {
            PlayState.qqqeb = false;
            removeMobileControls();
            addMobileControls();
		    mobileControls.instance.visible = true;
		    }
		    mobileControls.instance.buttonLeft.color = 0xFFF9393F;
            mobileControls.instance.buttonDown.color = 0xFFF9393F;
            mobileControls.instance.buttonUp.color = 0xFFF9393F;
            mobileControls.instance.buttonRight.color = 0xFFF9393F;
            
            lightShader.lightcol = [255., 0., 0.];
            lightShader.bright = .2;
            dust.BRIGHT = 0;

            stage.getSprite("ground").visible = false;
            stage.getSprite("fg").visible = false;
            dadClone.visible = false;

            stage.getSprite("paps_bg").visible = true;
            stage.getSprite("paps_fg").visible = true;

            remove(dad);
            insert(members.indexOf(stage.stageSprites["paps_fg"]), dad);

            dadStartX = dad.x;
            dadStartY = dad.y;

            dad24FPS = {sprite: dad, x: dadStartX, y: dadStartY, anim: dad.animation.frameName};
            lock24FPS.push(dad24FPS);
            spawnPapsTrail(dad);

            bfPos = 400;
            createBFClone(bfPos, 1.25);

            controlDad = false;
            timeBarColors = [0xFFFF0000, 0xFF000000];
        case 2669:
            papsBODY.visible = true;

            dadCircularMotion = true;
            dad.x = dadStartX;
            dad.y = dadBaseY;
            dadOrbitTime = 0;

            lock24FPS = [];

            dad24FPS = {sprite: papsBODY, x: dadStartX, y: dadStartY, anim: papsBODY.animation.frameName};
            lock24FPS.push(dad24FPS);
            dad24FPS = lock24FPS[papsBODY];

            head24FPS = {sprite: dad, x: dadStartX, y: dadStartY, angle: 0, anim: dad.animation.frameName};
            lock24FPS.push(head24FPS);

            clearTrails();

            spawnPapsTrail(dad);
            spawnPapsTrail(papsBODY);
        case 3005:
            papsBODY.visible = false;
            dadCircularMotion = false;

            lock24FPS = [];
            
            clearTrails();
            spawnPapsTrail(dad);

            dad24FPS = {sprite: dad, x: dadStartX, y: dadStartY, anim: dad.animation.frameName};
            lock24FPS.push(dad24FPS);
            FlxTween.tween(dad, {x: dadStartX, y: dadStartY}, 1, {ease: FlxEase.quadInOut});

        case 3321:
            if (FlxG.save.data.mechanics) {
            PlayState.qqqeb = true;
            removeMobileControls();
            addMobileControls();
            mobileControls.instance.visible = true;
            }
            mobileControls.instance.buttonLeft.color = 0xFFC24B99;
            mobileControls.instance.buttonDown.color = 0xFFC24B99;
            mobileControls.instance.buttonUp.color = 0xFFC24B99;
            mobileControls.instance.buttonRight.color = 0xFFC24B99;
            
            lock24FPS = [];
            clearTrails();

            controlDad = true;

            lightShader.lightcol = [255., 241., 255.];
            lightShader.bright = 1;
            dust.BRIGHT = 10;

            stage.getSprite("ground").visible = true;
            stage.getSprite("fg").visible = true;

            stage.getSprite("paps_bg").visible = false;
            stage.getSprite("paps_fg").visible = false;

            bfPos = null;
            createBFClone(bfPos2, 1.25);
            dadClone.visible = true;

            timeBarColors = ogTimeCol;
        case 4064:
            bfClone.visible = false;
            healthBarColors[0] = 0x00000000;
            dustiniconP2.alpha = 0;
            dust.BRIGHT = 0;
            for (name => sprite in stage.stageSprites) 
                sprite.visible = false;

            camMoveOffset = 0;
            camAngleOffset = 0;
        case 4672:
            bfClone.visible = true;
            healthBarColors[0] = ogCol1;
            dustiniconP2.alpha = 1;
            dust.BRIGHT = 10;
            for (name => sprite in stage.stageSprites) 
                sprite.visible = true;

            stage.getSprite("paps_bg").visible = false;
            stage.getSprite("paps_fg").visible = false;

            camMoveOffset = 5;
            camAngleOffset = .3;
        case 4052:
            strumLines.members[0].characters[0].alpha = 0;
        case 4320:
            FlxTween.tween(strumLines.members[0].characters[0], {alpha: 1}, 5, {ease: FlxEase.quadInOut});
        case 976 | 1320 | 4834 | 5186:
            spawnPapsTrail(strumLines.members[3].characters[0], .2);
            FlxTween.tween(strumLines.members[3].characters[0], {alpha: .56}, 2, {ease: FlxEase.quadInOut});

            FlxTween.tween(gradient, {alpha: .27}, 2,  {ease: FlxEase.quadOut});
        case 1104 | 1360 | 4928:
            clearTrails();
            FlxTween.tween(strumLines.members[3].characters[0], {alpha: 0}, .5, {ease: FlxEase.quadInOut});

            FlxTween.tween(gradient, {alpha: 0}, 1.3,  {ease: FlxEase.quadIn});

    }
}


function onDadHit(note:Note):Void {
    if (papsBODY != null && papsBODY.visible == true) {
        var dirNames = ['LEFT', 'DOWN', 'UP', 'RIGHT'];
        var animName = 'sing' + dirNames[note.direction];
        papsBODY.playAnim(animName, true);
    }
}

public var papCameraNormalizer:Float = .1;
function onCameraMove(_) {
    // normalize mtt movement a bit
    if (_.strumLine.characters[0].curCharacter == "phantom_paps_br") {
        _.position.x -= (dad.x - dadStartX)*FlxMath.lerp(.8, 1, papCameraNormalizer);
        _.position.y -= (dad.y - dadStartY)*FlxMath.lerp(.7, 1, papCameraNormalizer);
    }
}

var papsTrails:Array<FlxTrail> = [];
function spawnPapsTrail(sprite:FlxSprite, alpha:Float = 0.3) {
    trail = new FlxTrail(sprite, null, 32, 11, 0.3, 0.045);
    trail.color = 0xFFFFFFFF;
    insert(members.indexOf(sprite), trail);
    papsTrails.push(trail);
    // trail.rotationsEnabled = false;
    return trail;
}

function clearTrails() {
    for (trail in papsTrails) {
        remove(trail);
        trail.destroy();
    }

    papsTrails = [];
}

function bloom_flash() {
    bloom_new.brightness = 2; bloom_new.size = 30;

    FlxTween.num(2, 1.78, (Conductor.stepCrochet / 1000) * 8, {ease: FlxEase.quadOut}, (val:Float) -> {bloom_new.brightness = val;});
    FlxTween.num(22, 20, (Conductor.stepCrochet / 1000) * 8, {ease: FlxEase.quadOut}, (val:Float) -> {bloom_new.size = val;});

    executeEvent({name: "Bloom Effect", time: 0, params: [false, 1.25, 4, "linear", "In"]});
    executeEvent({name: "Bloom Effect", time: 0, params: [true, 1, 8, "quad", "Out"]});
}

var imageCine:Int = 0;
function cineHit() {
    imageCine++;
    stage.stageSprites['cine' + Std.string(imageCine)].alpha = 1;
    stage.stageSprites['cine' + Std.string(imageCine)].scale.x = .8;
    stage.stageSprites['cine' + Std.string(imageCine)].scale.y = .8;
    stage.stageSprites['cine' + Std.string(imageCine)].y += 17;
    FlxG.camera.zoom += 0.12;
    camHUD.zoom += 0.06;
    FlxTween.tween(stage.stageSprites['cine' + Std.string(imageCine)], {alpha: 0, "scale.x": .7, "scale.y": .7, y: stage.stageSprites['cine' + Std.string(imageCine)].y-17}, (Conductor.stepCrochet / 1000) * 10, {ease: FlxEase.quadOut});
}