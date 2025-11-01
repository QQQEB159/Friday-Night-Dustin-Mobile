//
public var dust:CustomShader;
public var oldstatic:CustomShader;

function postCreate() {
    gf.alpha = 0;

    dad.alpha = 0;
    boyfriend.alpha = 0;

    dust = new CustomShader("lab_dust");
    dust.cameraZoom = FlxG.camera.zoom; dust.flipY = true;
    dust.cameraPosition = [FlxG.camera.scroll.x, FlxG.camera.scroll.y];
    dust.time = 0; dust.res = [FlxG.width, FlxG.height];
    dust.LAYERS = 10; dust.DEPTH = 2;
    dust.WIDTH = .08; dust.SPEED = .5;
    dust.STARTING_LAYERS = 4;
    dust.pixely = false;
    dust.BRIGHT = 1;

    dust.dustFade = boyfriend.y;
    dust.dustRange = 1800;

    oldstatic = new CustomShader("static");
    oldstatic.time = 0; oldstatic.strength = 1.3;
    if (Options.gameplayShaders && FlxG.save.data.particles) FlxG.camera.addShader(dust);
    if (Options.gameplayShaders && FlxG.save.data.static) FlxG.camera.addShader(oldstatic);

    executeEvent({
        name: "Screen Coverer",
        time: Conductor.songPosition,
        params: [false, 0xFF000000, 1, 4, "linear", "In", "camHUD", "front"]
    });

    autoTitleCard = false;
}

    //FlxTween.tween(boyfriend, {x: boyfriend.x - 700}, 3.7, {ease: FlxEase.quintInOut});
    //FlxTween.tween(boyfriend, {y: boyfriend.y - 500}, 3.7, {ease: FlxEase.quintInOut});
