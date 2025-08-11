//
importScript("data/scripts/snowing-shader");
import openfl.filters.ShaderFilter;

public var blackOverlay:FlxSprite;

public var fogShader:CustomShader;
public var gradientShader:CustomShader;
public var camCharacters:FlxCamera;
public var camForeground:FlxCamera;

public var chromWarp:CustomShader;
public var water:CustomShader;
public var glitching:CustomShader;

public var impact:CustomShader;

public var bloom_new:CustomShader;
public var screenVignette2:CustomShader;

function create() {
    if(Options.gameplayShaders) {
    bloom_new = new CustomShader("bloom_new");
    bloom_new.size = 10; bloom_new.brightness = 1.4;
    bloom_new.directions = 16; bloom_new.quality = 3;
    bloom_new.threshold = .5;

    if(FlxG.save.data.fogShader) {
    fogShader = new CustomShader("fog");
    fogShader.cameraZoom = FlxG.camera.zoom;
    fogShader.cameraPosition = [FlxG.camera.scroll.x, FlxG.camera.scroll.y];
    fogShader.res = [FlxG.width, FlxG.height]; fogShader.time = 0;

    fogShader.FOG_COLOR = [166./255., 185./255., 189./255.]; fogShader.BG = [0.0, 0.0, 0.0];
    fogShader.ZOOM = 3.0; fogShader.OCTAVES = 4; fogShader.FEATHER = 100;
    fogShader.INTENSITY = 1;

    fogShader.applyY = 1520;
    fogShader.applyRange = 900;
    }

    if(FlxG.save.data.gradientShader) {
    gradientShader = new CustomShader("gradient");
    gradientShader.cameraZoom = FlxG.camera.zoom;
    gradientShader.cameraPosition = [FlxG.camera.scroll.x, FlxG.camera.scroll.y];
    gradientShader.res = [FlxG.width, FlxG.height];

    gradientShader.applyY = 1520;
    gradientShader.applyRange = 1000;
    }
    }

    camCharacters = new FlxCamera(0, 0);
    camForeground = new FlxCamera(0, 0);

    for (cam in [camGame, camHUD, camHUD2]) FlxG.cameras.remove(cam, false);
    for (cam in [camGame, camCharacters, camForeground, camHUD, camHUD2]) {cam.bgColor = 0x00000000; FlxG.cameras.add(cam, cam == camGame);}

    if(Options.gameplayShaders) {
    screenVignette2 = new CustomShader("coloredVignette");
    screenVignette2.strength = 1.0; screenVignette2.transperency = true;
    screenVignette2.amount = 1;
    screenVignette2.color = [0.0, 0.0, 0.0];

    chromWarp = new CustomShader("chromaticWarp");
    chromWarp.distortion = .3;
    if (FlxG.save.data.distortion) camGame.addShader(chromWarp);

    water = new CustomShader("waterDistortion");
    water.strength = .0;
    if (FlxG.save.data.distortion) camGame.addShader(water);

    impact = new CustomShader("impact_frames");
    impact.threshold = -1;
    // impact.threshold = .4;

    glitching = new CustomShader("glitching2");
    glitching.time = 0; glitching.glitchAmount = 0;

    if(FlxG.save.data.impact) camCharacters.addShader(impact);
    if(FlxG.save.data.glitching) camCharacters.addShader(glitching);
    if(FlxG.save.data.screenVignette2) camCharacters.addShader(screenVignette2);
    if (FlxG.save.data.bloom) camCharacters.addShader(bloom_new);
    if(FlxG.save.data.gradientShader) camCharacters.addShader(gradientShader);
    if(FlxG.save.data.saturation) camCharacters.addShader(saturation);
    if(FlxG.save.data.fogShader) {
    camCharacters.addShader(fogShader);
    }

    if(FlxG.save.data.saturation) camForeground.addShader(saturation);
    if (FlxG.save.data.bloom) camForeground.addShader(bloom);
    }

    stage.stageSprites["BG4"].cameras = [camForeground];
    stage.stageSprites["BG4"].color = 0xFF1B1B1B;

    blackOverlay = new FlxSprite(-2000, -500);
    blackOverlay.makeSolid(4000, 1500, 0xFF1B1B1B);
    blackOverlay.scrollFactor.set(0, 0);
    blackOverlay.alpha = 1;
    blackOverlay.cameras = [camGame];
    add(blackOverlay); 

    snowSpeed = 7;
}

function onCountdown(event) event.sprite?.cameras = [camCharacters];

function postCreate() {
    if(Options.gameplayShaders) {
    if (FlxG.save.data.particles) camGame.addShader(snowShader);
    if (FlxG.save.data.particles) camCharacters.addShader(snowShader2);

    if (FlxG.save.data.distortion) camHUD.addShader(water);
    }
}

var __timer:Float = 0; 
public var gfAlpha:Float = 0;
function update(elapsed:Float) {
    __timer += elapsed;
    if (!cancelCamMove) {
        if(Options.gameplayShaders) {
        if(FlxG.save.data.fogShader) {
        fogShader.time = __timer;
        }
        water.time = __timer;
        glitching.time = __timer;
        }
    }

    if(Options.gameplayShaders) {
    if(FlxG.save.data.fogShader) {
    fogShader.cameraZoom = FlxG.camera.zoom;
    fogShader.cameraPosition = [FlxG.camera.scroll.x, FlxG.camera.scroll.y];
    }

    if(FlxG.save.data.gradientShader) {
    gradientShader.cameraZoom = FlxG.camera.zoom;
    gradientShader.cameraPosition = [FlxG.camera.scroll.x, FlxG.camera.scroll.y];
    }
    }

    gf.x = 1397 + Math.sin(__timer)*24;
    gf.y = 850 + (Math.sin(__timer*2)/2)*(12);

    gf.alpha = (0.7 + Math.sin(__timer)*.04)*gfAlpha;

    for (cam in [camCharacters, camForeground]) {
        cam.scroll = FlxG.camera.scroll;
        cam.zoom = FlxG.camera.zoom;
        cam.angle = FlxG.camera.angle;
    }

    for (strum in strumLines)
        for (char in strum.characters)
            char.cameras = [camCharacters];
}