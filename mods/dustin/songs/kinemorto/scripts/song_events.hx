//
import flixel.addons.display.FlxBackdrop;
import flixel.effects.FlxFlicker;

var papyrusNutting:FlxSprite;
var flickerSprite:FlxSprite;
var fog:FlxSprite;
var blackwhite:CustomShader;
var oldstatic:CustomShader;
var radial:CustomShader;
var warp:CustomShader;

function postCreate() {
    papyrusNutting = new FunkinSprite(0, 0, Paths.image("game/cutscenes/kinemorto/papyrusBLOWINGup"));
    papyrusNutting.addAnim('burstin', 'pop off girl', 13);
    papyrusNutting.antialiasing = Options.antialiasing;
    papyrusNutting.scale.set(0.68, 0.68);
    insert(members.length - 1, papyrusNutting);
    papyrusNutting.scrollFactor.set();
    papyrusNutting.screenCenter();
    papyrusNutting.zoomFactor = 0;
    papyrusNutting.alpha = 0.00001;
    papyrusNutting.animation.finishCallback = (_) -> {
        papyrusNutting.alpha = 0.0001;
        executeEvent({name: "Screen Coverer", time: 0, params: [false, 0xFF000000, 1, 4, "linear", "In", "camHUD", "back"]});
    }

    papyrusNutting.cameras = [camCharacters];

    fog = new FlxBackdrop(Paths.image("game/cutscenes/kinemorto/fogBG"));
    fog.scale.set(3, 3);
    fog.alpha = 0.0001;
    insert(members.indexOf(stage.stageSprites["head"]) , fog);
    fog.velocity.x = 80;
    fog.scrollFactor.set();

    blackwhite = new CustomShader("blackwhite");
    blackwhite.grayness = 0;
    if (Options.gameplayShaders) 
        for (cam in [FlxG.camera, camHUD, camCharacters]) cam.addShader(blackwhite);

    oldstatic = new CustomShader("static");
    oldstatic.time = 0; oldstatic.strength = 0;
    if (Options.gameplayShaders && FlxG.save.data.static) 
        for (cam in [FlxG.camera, camHUD, camCharacters]) cam.addShader(oldstatic);

    warp = new CustomShader("warp");
    warp.distortion = 0;
    if (Options.gameplayShaders && FlxG.save.data.warp) FlxG.camera.addShader(warp);
    if (Options.gameplayShaders && FlxG.save.data.warp) camCharacters.addShader(warp);

    radial = new CustomShader("radial");
    radial.blur = 0;
    radial.center = [0.5, 0.5];
    if (Options.gameplayShaders) FlxG.camera.addShader(radial);

    speedy = true;
    idleSpeed = .5;

    flickerSprite = new FunkinSprite().makeSolid(FlxG.width, FlxG.height, 0xFF000000);
    flickerSprite.scrollFactor.set(0, 0);
    flickerSprite.zoomFactor = 0;
    flickerSprite.cameras = [camHUD];
    flickerSprite.alpha = 0.0;
    add(flickerSprite);

    FlxFlicker.flicker(flickerSprite, 9999999, 0.05);
}

public var shaketime:Float = 0;
var time:Float = 0;
function update(elapsed:Float) {
    if (shaketime > 0) {
        var xMod:Float = FlxG.random.float(-1, 1)*1.5;
        var yMod:Float = FlxG.random.float(-1, 1)*1.5;

        for (cam in [camGame, camCharacters, camHUD,camHUD2]) {
            cam.scroll.x += xMod; cam.scroll.y += yMod;
        }
        shaketime -= elapsed;
    }

    time += elapsed;
    oldstatic.time = time;
    if (papyrusNutting.alpha < 1) return;

    papyrusNutting.screenCenter();
    papyrusNutting.x += FlxG.random.float(-10, 10);
    papyrusNutting.y += FlxG.random.float(-10, 10);

    dad.animation.finishCallback = function(animName:String) {
        if (animName == "intro") {
            dad.playAnim("intro2");
        }
    };
}

function stepHit(step:Int) {
    switch (step) {
        case 49:
            dad.playAnim("intro");
            dad.animation.finishCallback = function(animName:String) {
                if (animName == "intro") {
                    dad.playAnim("intro2");
                }
            };
        case 736:
            dad.playAnim("stoopidDeath");
            dad.animation.finishCallback = function(animName:String) {
                if (animName == "stoopidDeath") {
                    dad.playAnim("stoopidDeath2");
                }

                if (animName == "stoopidDeath2") {
                    dad.playAnim("stoopidDeath3");
                }
            };
        case 2: doHealthbarFade = false; 
        case 96: FlxG.camera.followLerp = 0.06; 
        case 106: FlxG.camera.followLerp = 0.04;
        case 312 | 672:
            FlxTween.num(.3, 0, (Conductor.stepCrochet / 1000) * 6, {ease: FlxEase.cubeIn}, (val:Float) -> {water.strength = val;});
            FlxTween.num(.2, 0, (Conductor.stepCrochet / 1000) * 6, {ease: FlxEase.cubeIn}, (val:Float) -> {chromWarp.distortion = val;});
            FlxTween.num(1.3, 0, (Conductor.stepCrochet / 1000) * 8, {ease: FlxEase.quadOut}, (val:Float) -> {bloom_new.brightness = val;});
            FlxTween.num(35, 10, (Conductor.stepCrochet / 1000) * 8, {ease: FlxEase.quadOut}, (val:Float) -> {bloom_new.size = val;});
        case 384:
            FlxTween.num(.3, 0, (Conductor.stepCrochet / 1000) * 16, {ease: FlxEase.cubeIn}, (val:Float) -> {water.strength = val;});
            FlxTween.num(.2, 0, (Conductor.stepCrochet / 1000) * 8, {ease: FlxEase.cubeIn}, (val:Float) -> {chromWarp.distortion = val;});
        case 416:
            flickerSprite.alpha = 0.012;

            FlxTween.num(0, .001, (Conductor.stepCrochet / 1000) * 12, {ease: FlxEase.cubeIn}, (val:Float) -> {radial.blur = val;});
            FlxTween.num(0, .3, (Conductor.stepCrochet / 1000) * 12, {ease: FlxEase.cubeIn}, (val:Float) -> {water.strength = val;});
            if(oldstatic != null) FlxTween.num(0, .8, (Conductor.stepCrochet / 1000) * 4, {ease: FlxEase.quadOut}, (val:Float) -> {oldstatic.strength = val;});
            if(blackwhite != null) FlxTween.num(0, .25, (Conductor.stepCrochet / 1000) * 1,  {ease: FlxEase.quadOut}, (val:Float) -> {blackwhite.grayness = val;});

            FlxTween.num(1.6, .6, (Conductor.stepCrochet / 1000) * 4, {ease: FlxEase.quadOut}, (val:Float) -> {snowSpeed = val;});
            FlxTween.num(1, 2.8, (Conductor.stepCrochet / 1000) * 4, {ease: FlxEase.quadOut}, (val:Float) -> {snowShader2.BRIGHT = val;});
            FlxTween.num(1, 2.4, (Conductor.stepCrochet / 1000) * 4, {ease: FlxEase.quadOut}, (val:Float) -> {snowShader.BRIGHT = val;});

            camHUD.removeShader(water);

            FlxTween.num(0, .44, (Conductor.stepCrochet / 1000) * 8, {ease: FlxEase.quadOut}, (val:Float) -> {bloom_new.brightness = val;});
            FlxTween.num(10, 13, (Conductor.stepCrochet / 1000) * 8, {ease: FlxEase.quadOut}, (val:Float) -> {bloom_new.size = val;});

            FlxTween.num(1, 1.7, (Conductor.stepCrochet / 1000) * 8, {ease: FlxEase.quadOut}, (val:Float) -> {fogShader.INTENSITY = val;});
        case 544: // YEA!! -bf
            flickerSprite.alpha = 0;

            FlxTween.num(.087, .001, (Conductor.stepCrochet / 1000) * 6, {ease: FlxEase.cubeOut}, (val:Float) -> {radial.blur = val;});
            FlxTween.num(.3, 0, (Conductor.stepCrochet / 1000) * 12, {ease: FlxEase.cubeIn}, (val:Float) -> {water.strength = val;});
            if(oldstatic != null) FlxTween.num(.8, 0, (Conductor.stepCrochet / 1000) * 4, {ease: FlxEase.quadOut}, (val:Float) -> {oldstatic.strength = val;});
            if(blackwhite != null) FlxTween.num(.25, .15, (Conductor.stepCrochet / 1000) * 1,  {ease: FlxEase.quadOut}, (val:Float) -> {blackwhite.grayness = val;});

            FlxTween.num(.6, 2.2, (Conductor.stepCrochet / 1000) * 4, {ease: FlxEase.quadOut}, (val:Float) -> {snowSpeed = val;});
            FlxTween.num(2.8,  1.6, (Conductor.stepCrochet / 1000) * 4, {ease: FlxEase.quadOut}, (val:Float) -> {snowShader2.BRIGHT = val;});
            FlxTween.num(2.4, 1.6, (Conductor.stepCrochet / 1000) * 4, {ease: FlxEase.quadOut}, (val:Float) -> {snowShader.BRIGHT = val;});

            FlxTween.num(.44, 0, (Conductor.stepCrochet / 1000) * 8, {ease: FlxEase.quadOut}, (val:Float) -> {bloom_new.brightness = val;});
            FlxTween.num(13, 10, (Conductor.stepCrochet / 1000) * 8, {ease: FlxEase.quadOut}, (val:Float) -> {bloom_new.size = val;});

            FlxTween.num(1.7, 1.6, (Conductor.stepCrochet / 1000) * 8, {ease: FlxEase.quadOut}, (val:Float) -> {fogShader.INTENSITY = val;});

            camZoomMult = .94;
        case 726:
            camZoomMult = 1;
        case 800:
            for (cam in FlxG.cameras.list) cam.visible = false;
            new FlxTimer().start(0.08, () -> {
                for (cam in FlxG.cameras.list) cam.visible = true;

                papyrusNutting.alpha = 1;
                papyrusNutting.playAnim("burstin", true);

                camCharacters.shake(0.015, 0.14);
            });
        case 832:
            snowShader2.BRIGHT = 2; snowShader.BRIGHT = 2;
            fogShader.INTENSITY = 1.3; camZoomMult = 1;
            radial.blur = .019; idleSpeed = 0.2; snowSpeed = 1.5;
            oldstatic.strength = 2; blackwhite.grayness = .7;

            bloom_new.brightness = 1.2; water.strength = .2;
        case 872:
            radial.blur = .03;
            oldstatic.strength = 3;
            flickerSprite.alpha = 0.02;
        case 912:
            if(oldstatic != null) FlxTween.num(3, 2, (Conductor.stepCrochet / 1000) * 4, {ease: FlxEase.quadOut}, (val:Float) -> {oldstatic.strength = val;});
            FlxTween.num(.03, 0.019, (Conductor.stepCrochet / 1000) * 4, {ease: FlxEase.cubeIn}, (val:Float) -> {radial.blur = val;});

        case 936: 
            FlxG.camera.followLerp = 0.17;
            camMoveOffset = 30;
        case 942:
            FlxG.camera.followLerp = 0.04;
            camMoveOffset = 15;
        case 1000:
            FlxTween.num(1.5, 3, (Conductor.stepCrochet / 1000) * 4, {ease: FlxEase.quadOut}, (val:Float) -> {snowSpeed = val;});
            FlxTween.num(2, 1.5, (Conductor.stepCrochet / 1000) * 4, {ease: FlxEase.quadOut}, (val:Float) -> {snowShader2.BRIGHT = val;});
            FlxTween.num(2, 1.5, (Conductor.stepCrochet / 1000) * 4, {ease: FlxEase.quadOut}, (val:Float) -> {snowShader.BRIGHT = val;});

            FlxTween.num(.087, .001, (Conductor.stepCrochet / 1000) * 12, {ease: FlxEase.cubeOut}, (val:Float) -> {radial.blur = val;});

            FlxTween.num(1.2, 0, (Conductor.stepCrochet / 1000) * 8, {ease: FlxEase.quadOut}, (val:Float) -> {bloom_new.brightness = val;});
            FlxTween.num(.2, 0, (Conductor.stepCrochet / 1000) * 12, {ease: FlxEase.cubeIn}, (val:Float) -> {water.strength = val;});

            if(oldstatic != null) FlxTween.num(2, 0, (Conductor.stepCrochet / 1000) * 4, {ease: FlxEase.quadOut}, (val:Float) -> {oldstatic.strength = val;});
            if(blackwhite != null) FlxTween.num(.7, 0, (Conductor.stepCrochet / 1000) * 1,  {ease: FlxEase.quadOut}, (val:Float) -> {blackwhite.grayness = val;});
            flickerSprite.alpha = 0.0;
        case 1006 | 1012 | 1018 | 1032 | 1038 | 1044 | 1088:
            FlxTween.num(.02, .001, (Conductor.stepCrochet / 1000) * 3.4, {ease: FlxEase.cubeOut}, (val:Float) -> {radial.blur = val;});
            FlxTween.num(.2, .0, (Conductor.stepCrochet / 1000) * 3.4, {ease: FlxEase.quadOut}, (val:Float) -> {warp.distortion = val;});
            FlxTween.num(.3, 0, (Conductor.stepCrochet / 1000) * 3.4, {ease: FlxEase.cubeOut}, (val:Float) -> {chromWarp.distortion = val;});
            FlxTween.num(1, 0, (Conductor.stepCrochet / 1000) * 3.4, {ease: FlxEase.cubeOut}, (val:Float) -> {glitching.glitchAmount = val;});
        case 1128:
            if(oldstatic != null) FlxTween.num(0, 4.6, (Conductor.stepCrochet / 1000) * 1, {ease: FlxEase.quadOut}, (val:Float) -> {oldstatic.strength = val;});
            if(blackwhite != null) FlxTween.num(0, .4, (Conductor.stepCrochet / 1000) * 1,  {ease: FlxEase.quadOut}, (val:Float) -> {blackwhite.grayness = val;});
            flickerSprite.alpha = 0.03;

            FlxTween.num(0, 1.3, ((Conductor.stepCrochet / 1000) * 6), {ease: FlxEase.quadOut}, (val:Float) -> {bloom_new.brightness = val;});
            FlxTween.num(0, 0.05, (Conductor.stepCrochet / 1000) * 6, {ease: FlxEase.cubeIn}, (val:Float) -> {chromWarp.distortion = val;});
            FlxTween.num(0, 0.07, (Conductor.stepCrochet / 1000) * 6, {ease: FlxEase.cubeIn}, (val:Float) -> {water.strength = val;});
            FlxTween.num(1.5, 2, (Conductor.stepCrochet / 1000) * 4, {ease: FlxEase.quadOut}, (val:Float) -> {snowShader2.BRIGHT = val;});
            FlxTween.num(1.5, 2, (Conductor.stepCrochet / 1000) * 4, {ease: FlxEase.quadOut}, (val:Float) -> {snowShader.BRIGHT = val;});
            FlxTween.num(.0, .01, (Conductor.stepCrochet / 1000) * 12, {ease: FlxEase.cubeOut}, (val:Float) -> {radial.blur = val;});

            FlxTween.num(3, 1.7, (Conductor.stepCrochet / 1000) * 4, {ease: FlxEase.quadOut}, (val:Float) -> {snowSpeed = val;});
        case 1384:
            if (Options.gameplayShaders) camCharacters.addShader(chromWarp);
            if(blackwhite != null) FlxTween.num(.4, .7, (Conductor.stepCrochet / 1000) * 1,  {ease: FlxEase.quadOut}, (val:Float) -> {blackwhite.grayness = val;});
            FlxTween.num(0.07, 0.1, (Conductor.stepCrochet / 1000) * 12, {ease: FlxEase.cubeIn}, (val:Float) -> {water.strength = val;});
            FlxTween.num(.087, .015, (Conductor.stepCrochet / 1000) * 6, {ease: FlxEase.cubeOut}, (val:Float) -> {radial.blur = val;});
            FlxTween.num(0.02, 0.01, (Conductor.stepCrochet / 1000) * 6, {ease: FlxEase.cubeIn}, (val:Float) -> {chromWarp.distortion = val;});

            FlxTween.num(2, 2.3, (Conductor.stepCrochet / 1000) * 4, {ease: FlxEase.quadOut}, (val:Float) -> {snowShader2.BRIGHT = val;});
            FlxTween.num(2, 2.3, (Conductor.stepCrochet / 1000) * 4, {ease: FlxEase.quadOut}, (val:Float) -> {snowShader.BRIGHT = val;});
            FlxTween.num(1.7, 2.6, (Conductor.stepCrochet / 1000) * 4, {ease: FlxEase.quadOut}, (val:Float) -> {snowSpeed = val;});
        case 1385:
            FlxTween.num(1.3, 1.8, ((Conductor.stepCrochet / 1000) * 6), {ease: FlxEase.quadOut}, (val:Float) -> {bloom_new.brightness = val;});
            FlxTween.num(10, 15, (Conductor.stepCrochet / 1000) * 8, {ease: FlxEase.quadOut}, (val:Float) -> {bloom_new.size = val;});
    }

    // please dont slime me out for this fnf coder twitter -lunar
    if ((step >= 552 && step <= 795) && step % 4 == 0) {
        FlxTween.num(.01, .001, (Conductor.stepCrochet / 1000) * 4, {ease: FlxEase.cubeOut}, (val:Float) -> {radial.blur = val;});
        FlxTween.num(.5, .0, (Conductor.stepCrochet / 1000) * 4, {ease: FlxEase.quadIn}, (val:Float) -> {warp.distortion = val;});
        FlxTween.num(.14, 0, (Conductor.stepCrochet / 1000) * 4, {ease: FlxEase.cubeIn}, (val:Float) -> {chromWarp.distortion = val;});
    } 
}

var time:Float = 0;
function update(elapsed:Float) {
    time += elapsed;
    oldstatic.time = time;

    radial.center = [
        0.5 + (0.15*FlxMath.fastSin(time)),
        0.5 + (0.15*FlxMath.fastCos(time))
    ];
}

function changeToSans() {
    bones.x = FlxG.width + bones.width;
    bones.playAnim("sans");
}

var endin:Bool = false;
function bgFog() {
    endin = true; pluey = -1;
    FlxTween.tween(fog, {alpha: 1}, 5, {ease: FlxEase.sineInOut});
    FlxTween.color(dad, 5, 0xFFFFFFFF, 0xFF000000, {ease: FlxEase.sineInOut});
    FlxTween.color(boyfriend, 5, 0xFFFFFFFF, 0xFF000000, {ease: FlxEase.sineInOut});

    var head = stage.stageSprites["head"];
    var kms = head.getGraphicMidpoint();
    camFollow.setPosition(kms.x+175, kms.y-50);
    FlxG.camera.followLerp /= 5;

    FlxTween.color(head, 5, 0xFFFFFFFF, 0xFF000000, {ease: FlxEase.sineInOut});
    head.cameras = [camCharacters];
}

function onCameraMove(event) {
    event.cancelled = endin;
}

function epicimpact() {
    if (!Options.gameplayShaders) return;
    for (cam in FlxG.cameras.list) cam.visible = false;
    new FlxTimer().start(0.08, () -> {
        shaketime = .4; endin = true; lerpCamZoom = false; bones.visible = false;

        for (cam in FlxG.cameras.list) cam.visible = true;
        camGame.visible = false; bloom_new.brightness = .5;

        snowShader.BRIGHT = 1.4;
        snowShader2.BRIGHT = 1.4;
        fogShader.INTENSITY = 1.56; 
        if (Options.gameplayShaders) camCharacters.addShader(radial);
        camCharacters.removeShader(chromWarp);

        chromWarp.distortion = 0; impact.threshold = .12; glitching.glitchAmount = 2.6;
        executeEvent({name: "ScreenCoverer", time: 0, params: [false, 0xFF000000, 0.1, 4, "quad", "Out", "camHUD", "back"]});

        new FlxTimer().start(0.093, () -> {
            endin = false; lerpCamZoom = true; bones.visible = true;
            camGame.visible = true;

            impact.threshold = -1;
            snowShader.BRIGHT = 2;
            snowShader2.BRIGHT = 2;
            fogShader.INTENSITY = 1.3; 
            camCharacters.removeShader(radial);
            if (Options.gameplayShaders) camCharacters.addShader(chromWarp);

            executeEvent({name: "Bloom Effect", time: 0, params: [false, 1.3, 4, "linear", "In"]});
            executeEvent({name: "Bloom Effect", time: 0, params: [true, 1, 2, "quad", "Out"]});

            FlxTween.num(1, 0, ((Conductor.stepCrochet / 1000) * 4), {ease: FlxEase.cubeIn}, (val:Float) -> {glitching.glitchAmount = val;});

            FlxTween.num(1.8, 1.3, ((Conductor.stepCrochet / 1000) * 6 * 2), {ease: FlxEase.quadOut}, (val:Float) -> {bloom_new.brightness = val;});
        });
    });
}