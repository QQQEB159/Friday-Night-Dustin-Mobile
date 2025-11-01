//
import openfl.Lib;

public var dadClone:Character = null;
public var bfClone:Character = null;

public var dadPos:Float = 670;
public var bfPos:Float = /*400*/ null;
public var bfPos2:Float = 620;

public var bloom_new:CustomShader;
public var lightShader:CustomShader;

public var chromWarp:CustomShader;
public var dust:CustomShader;
public var br_cine:CustomShader;

function postCreate() {
    executeEvent({
        name: "Screen Coverer",
        time: Conductor.songPosition,
        params: [false, 0xFF000000, 1, 4, "linear", "In", "camHUD", "front"]
    });

    bloom_new = new CustomShader("bloom_new");
    bloom_new.size = 20; bloom_new.brightness = 1.78;
    bloom_new.directions = 16; bloom_new.quality = 5;
    bloom_new.threshold = .75;

    // autoTitleCard = false;

    dustinHealthBar.flipX = true;
    dustinHealthBG.flipX = true;

    dustiniconP1.flipX = true;
    dustiniconP2.flipX = true;
    reverseIcons = true;

    camZoomMult = .965;
    FlxG.camera.followLerp = .03;

    stage.stageSprites["ground"].color = 0xffb7ace4;
    stage.stageSprites["fg"].color = 0xffb7ace4;

    lightShader = new CustomShader("light_preprocess");
    lightShader.threshold = .5;
    lightShader.time = 0; lightShader.bright = 1;
    lightShader.lightcol = [255., 241., 255.];
    if (Options.gameplayShaders && FlxG.save.data.godrays) stage.stageSprites["light"].shader = lightShader;
    else remove(stage.stageSprites["light"]);

    br_cine = new CustomShader("br_cine");
    br_cine.time = 0;
    // FlxG.camera.addShader(br_cine);

    chromWarp = new CustomShader("chromaticWarp");
    chromWarp.distortion = 0.0;

    dust = new CustomShader("dust");
    dust.cameraZoom = FlxG.camera.zoom; dust.flipY = true;
    dust.cameraPosition = [FlxG.camera.scroll.x, FlxG.camera.scroll.y];
    dust.time = 0; dust.res = [FlxG.width, FlxG.height];
    dust.LAYERS = 15; dust.DEPTH = .9;
    dust.WIDTH = .01; dust.SPEED = .3;
    dust.STARTING_LAYERS = 4;
    dust.pixely = false;
    dust.BRIGHT = 10;
    dust.Wzoom = 1;

    // camGame.addShader(chromWarp);
    if (Options.gameplayShaders && FlxG.save.data.bloom) FlxG.camera.addShader(bloom_new);
    if (Options.gameplayShaders && FlxG.save.data.particles) FlxG.camera.addShader(dust);
    if (Options.gameplayShaders && FlxG.save.data.bloom) camHUD.addShader(bloom_new);

    createDadClone(dadPos, 1.15);
    createBFClone(bfPos2, 1.25);

    stage.getSprite("paps_bg").visible = false;
    stage.getSprite("paps_fg").visible = false;

    remove(strumLines.members[3].characters[0]);
    insert(members.indexOf(dad)-1, strumLines.members[3].characters[0]);

    strumLines.members[3].characters[0].alpha = 0;
}

var undertaleFrameTime:Float = 1/30;
var undertaleFrameCounter:Float = 0;

var tottalTimer:Float = FlxG.random.float(100, 1000);  // Stole this from the snow shader script cuz I liked the idea lmfao  - Nex
function update(elapsed:Float) {
    tottalTimer += elapsed;
    lightShader.time = tottalTimer;
    br_cine.time = tottalTimer;

    undertaleFrameCounter += elapsed;
    if (undertaleFrameCounter > undertaleFrameTime) {
        undertaleFrameCounter = 0;
        dust.time = tottalTimer*.7;

    }
    dust.cameraZoom = FlxG.camera.zoom;
    dust.cameraPosition = [FlxG.camera.scroll.x, FlxG.camera.scroll.y];
    dust.Wzoom = Math.max(0.9, 1 / (Lib.application.window.width/FlxG.width));

    // Sync Dad cool reflection
    if (dadClone != null) {
        if (dadClone.animation.name != dadClone.animation.name) 
            dadClone.animation.play(dad.animation.name, true);

        dadClone.animation.stop();
        dadClone.animation.frameIndex = dad.animation.frameIndex;

		dadClone.frameOffset.set(dad.frameOffset.x, dad.frameOffset.y);

        dadClone.offset.set(dadClone.globalOffset.x * (dadClone.isPlayer != dadClone.playerOffsets ? 1 : -1), -dadClone.globalOffset.y);
        dadClone.setPosition(dad.x, dad.y + dadPos);
    }

    // Sync BF cool reflection
    if (bfClone != null) {
        if (bfClone.animation.name != bfClone.animation.name) 
            bfClone.animation.play(boyfriend.animation.name, true);

        bfClone.animation.stop();
        bfClone.animation.frameIndex = boyfriend.animation.frameIndex;

		bfClone.frameOffset.set(boyfriend.frameOffset.x, -boyfriend.frameOffset.y*.3);

        bfClone.offset.set(bfClone.globalOffset.x * (bfClone.isPlayer != bfClone.playerOffsets ? 1 : -1), -bfClone.globalOffset.y);
        bfClone.setPosition(boyfriend.x, boyfriend.y + (bfPos != null ? bfPos : bfPos2) + (2630 - boyfriend.y));
    }
}

function postUpdate(elapsed:Float) {
    var waveSpeed = tottalTimer * 2.1;
    var bobX = Math.sin(waveSpeed) * 50;
    var bobY = Math.cos(waveSpeed * 0.8) * 40 + Math.sin(waveSpeed * 1.5) * 10;

    strumLines.members[3].characters[0].x = dad.x + 500 + bobX;
    strumLines.members[3].characters[0].y = dad.y - 60 + bobY;
}

public function createDadClone(offset:Float, sizeChar:Float) {
    if (dadClone != null) {
        remove(dadClone);
        dadClone.destroy();
        dadClone = null;
    }

    dadClone = new Character(0, 0, dad.curCharacter);
    dadClone.scrollFactor.set(1, 1);
    dadClone.scale.set(sizeChar, sizeChar);
    dadClone.flipY = true;
    dadClone.alpha = 0.3;
    dadClone.setPosition(dad.x, dad.y + offset);

    insert(members.indexOf(dad), dadClone);
}

public function createBFClone(offset:Float, sizeChar:Float) {
    if (bfClone != null) {
        remove(bfClone);
        bfClone.destroy();
        bfClone = null;
    }

    bfClone = new Character(0, 0, boyfriend.curCharacter);
    bfClone.scrollFactor.set(1, 1);
    bfClone.scale.set(sizeChar, sizeChar);
    bfClone.flipY = true;
    bfClone.alpha = 0.3;
    bfClone.setPosition(boyfriend.x, boyfriend.y + offset);

    insert(members.indexOf(boyfriend), bfClone);
}