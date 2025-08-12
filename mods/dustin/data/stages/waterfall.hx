// 
import flixel.effects.particles.FlxTypedEmitter;
import flixel.effects.particles.FlxParticle;
import flixel.effects.particles.FlxEmitterMode;
import flixel.util.FlxSpriteUtil;

var gfShaderSprite;
var blackOverlay;
var beam;
var maxTimeTween:FlxTween;
var heat:CustomShader = null;
var heat2:CustomShader = null;

function create() {
    if(Options.gameplayShaders) {
    if (FlxG.save.data.distortion) {
    FlxG.camera.addShader(heat2 = new CustomShader("waterDistortion"));
    camHUD.addShader(heat = new CustomShader("waterDistortion"));
    heat.strength = 0;
    heat2.strength = 0;
    }
    }

    /*
    spawnWaterEmitter(-600, 325, 300);
    spawnWaterEmitter(-600, 680, 300);
    spawnWaterEmitter(90, 700, 350);
    spawnWaterEmitter(1100, 550, 250);
    spawnWaterEmitter(1200, 660, 400);
    spawnWaterEmitter(760, 440, 250);
    */
}

function postCreate() {
    blackOverlay = new FlxSprite();
    blackOverlay.makeGraphic(3000, 3000, FlxColor.BLACK);
    blackOverlay.scrollFactor.set(1, 1);
    blackOverlay.screenCenter();
    blackOverlay.alpha = 0;
    add(blackOverlay);

    beam = new Character(gf.x, gf.y, "LightBeameye", stage.isCharFlipped("LightBeameye", false));
    beam.visible = false;
    beam.x = gf.x;
    beam.y = gf.y;
    add(beam);

    beam.x += 600;
    beam.y += -225;

    gfShaderSprite = new Character(gf.x, gf.y, "undyne_hurt_white", stage.isCharFlipped("undyne_hurt_white", false));
    gfShaderSprite.alpha = 0;
    gfShaderSprite.x = gf.x;
    gfShaderSprite.y = gf.y;
    add(gfShaderSprite);

    customLengthOverride = 199000;
}

var tottalTimer:Float = FlxG.random.float(50, 300);

function update(elapsed:Float) {
    if(Options.gameplayShaders) {
    if (FlxG.save.data.distortion) {
    heat?.time = (tottalTimer += elapsed);
    heat2?.time = (tottalTimer += elapsed);
    }
    }
    if (beam.visible) {
        switch (gf.animation.curAnim.name) {
            case "idle":
                beam.x = gf.x;
                beam.y = gf.y;

                beam.x += 600;
                beam.y += -225;
            case "singUP":
                beam.x = gf.x;
                beam.y = gf.y;
                
                beam.x += 600;
                beam.y += -370;
            case "singDOWN":
                beam.x = gf.x;
                beam.y = gf.y;
                
                beam.x += 710;
                beam.y += -140;
            case "singLEFT":
                beam.x = gf.x;
                beam.y = gf.y;
                
                beam.x += 450;
                beam.y += -235;
            case "singRIGHT":
                beam.x = gf.x;
                beam.y = gf.y;
                
                beam.x += 730;
                beam.y += -210;
            default:
                beam.x = gf.x;
                beam.y = gf.y;

                beam.x += 600;
                beam.y += -225;
        }
    }
}

function stepHit(step:Int) {
    switch (step) {
        case 740:
            FlxTween.tween(bg, {alpha: 0}, 2, {ease: FlxEase.quadOut});
            FlxTween.tween(bg_front, {alpha: 0}, 2, {ease: FlxEase.quadOut});
            FlxTween.tween(wall_left, {alpha: 0}, 2, {ease: FlxEase.quadOut});
            FlxTween.tween(wall_right, {alpha: 0}, 2, {ease: FlxEase.quadOut});
            FlxTween.tween(bridge, {alpha: 0}, 3, {ease: FlxEase.quadOut});
            FlxTween.tween(shards, {alpha: 0}, 3, {ease: FlxEase.quadOut});
            FlxTween.tween(gf, {alpha: 0}, 3, {ease: FlxEase.quadOut});
            FlxTween.tween(dad, {alpha: 0}, 3, {ease: FlxEase.quadOut});

            FlxTween.tween(cracks, {alpha: 0}, 3, {ease: FlxEase.quadOut});
            FlxTween.tween(bones, {alpha: 0}, 3, {ease: FlxEase.quadOut});
        case 761:
            if(Options.gameplayShaders) {
            if (FlxG.save.data.distortion) {
            heat.strength = 0.2;
            heat2.strength = 0.3;
            }
            }
            gf.alpha = 1;
            gf.visible = false;

            dad.alpha = 0;

            for (strum in cpuStrums.members)
                if (strum != null) strum.alpha = 0;

            FlxTween.tween(bg, {alpha: 1}, 4.5, {ease: FlxEase.quadOut});
            FlxTween.tween(bg_front, {alpha: 1}, 4.5, {ease: FlxEase.quadOut});
            FlxTween.tween(wall_left, {alpha: 1}, 4.5, {ease: FlxEase.quadOut});
            FlxTween.tween(wall_right, {alpha: 1}, 4.5, {ease: FlxEase.quadOut});
            FlxTween.tween(bridge, {alpha: 1}, 3.5, {ease: FlxEase.quadOut});
            FlxTween.tween(shards, {alpha: 1}, 3.5, {ease: FlxEase.quadOut});
            FlxTween.tween(cracks, {alpha: 1}, 3.5, {ease: FlxEase.quadOut});
            FlxTween.tween(bones, {alpha: 1}, 3.5, {ease: FlxEase.quadOut});

        case 762:
            dad.alpha = 0;
            FlxTween.tween(dad, {alpha: 1}, 3, {ease: FlxEase.quadOut});

        case 787:
            // Tween paps sturms to 0.3 alpha
            for (strum in cpuStrums.members)
                if (strum != null)
                    FlxTween.tween(strum, {alpha: 0.3}, 0.75, {ease: FlxEase.sineInOut});

        case 1095:
            FlxTween.tween(dad, {alpha: 0}, 1.5, {ease: FlxEase.quadOut});

        case 1107:
            dad.alpha = 1;
            gf.alpha = 1;
            if(Options.gameplayShaders) {
            if (FlxG.save.data.distortion) {
            heat.strength = 0;
            heat2.strength = 0;
            }
            }
            for (strum in cpuStrums.members)
                if (strum != null) strum.alpha = 1;
            gf.visible = true;

        case 1526:
            FlxTween.tween(gfShaderSprite, { alpha: 1 }, 1.5);
            FlxTween.tween(blackOverlay, { alpha: 1 }, 1.5);
            FlxG.camera.shake(0.002, 0.3);

        case 1530:
            FlxG.camera.shake(0.004, 0.3);

        case 1533:
            FlxG.camera.shake(0.006, 0.4);

        case 1536:
            FlxG.camera.shake(0.008, 0.4);

        case 1539:
            FlxG.camera.shake(0.01, 0.3);

        case 1541:
            FlxG.camera.shake(0.015, 0.3);

        case 1543:
            FlxG.camera.shake(0.02, 0.5);
            beam.visible = true;
            gfShaderSprite.visible = false;
            blackOverlay.visible = false;

            cracks.alpha = 0;
            bones.alpha = 0;

            // Tween the max song length from 199000ms to 307000ms over 3 seconds
            if (maxTimeTween != null) maxTimeTween.cancel();

            var duration:Float = 3.0;
            var startLength:Float = customLengthOverride;
            var endLength:Float = 307000;

            maxTimeTween = FlxTween.num(startLength, endLength, duration, {ease: FlxEase.quadOut}, function(val:Float) {
                customLengthOverride = val;
            }, function() {
                customLengthOverride = endLength;
            });

        case 2183:
            beam.visible = false;


        case 1295:
                FlxG.camera.shake(0.015, 0.4);

                stage.stageSprites["BLASTER_IMPACT1"].alpha = 1;
                new FlxTimer().start(0.2, () -> {
                    stage.stageSprites["BLASTER_IMPACT1"].alpha = 0;
                    stage.stageSprites["BLASTER_IMPACT2"].alpha = 1;

                    new FlxTimer().start(0.1, () -> {
                        stage.stageSprites["BLASTER_IMPACT2"].alpha = 0;
                        stage.stageSprites["BLASTER_IMPACT3"].alpha = 1;

                         new FlxTimer().start(0.1, () -> {
                        stage.stageSprites["BLASTER_IMPACT3"].alpha = 0;
                    });
                    });
                });

        case 2157:
                FlxG.camera.shake(0.02, 0.6);

                stage.stageSprites["BLASTER_IMPACT4"].alpha = 1;
                new FlxTimer().start(0.2, () -> {
                    stage.stageSprites["BLASTER_IMPACT4"].alpha = 0;
                    stage.stageSprites["BLASTER_IMPACT5"].alpha = 1;

                    new FlxTimer().start(0.1, () -> {
                        stage.stageSprites["BLASTER_IMPACT5"].alpha = 0;
                        stage.stageSprites["BLASTER_IMPACT6"].alpha = 1;

                         new FlxTimer().start(0.1, () -> {
                        stage.stageSprites["BLASTER_IMPACT6"].alpha = 0;
                    });
                    });
                });
    }
}

// LUNAR PLS FIX THESE THEYRE MAKING THE RAM GO CRAZY:SOB:  - Nex
function spawnWaterEmitter(ex:Float, ey:Float, ewidth:Float) {
    emitter = new FlxTypedEmitter(ex, ey);
    
    emitter.launchMode = FlxEmitterMode.SQUARE;
    emitter.velocity.set(-30, -300, 30, 0);
    emitter.alpha.set(.2, .4, 0, 0);
    emitter.lifespan.set(1, 2);

    emitter.width = ewidth;
    emitter.maxSize = 40;

    for (i in 0...emitter.maxSize) {
        var particle:FlxParticle = new FlxParticle();
        var size:Int = [3, 4, 8][FlxG.random.int(0,2)];
        particle.makeGraphic(size, size, 0x00FFFFFF);
        particle.scrollFactor.set(0.8, 0.8);
        FlxSpriteUtil.drawCircle(particle, size/2, size/2, size/2, CoolUtil.lerpColor(0xFFB2DFE9, 0xFF408696, FlxG.random.float(0, 1)));
        emitter.add(particle);
    }

    insert(members.indexOf(stage.stageSprites["wall_left"]), emitter);
    //add(emitter);
    emitter.start(false, 0.08);
}