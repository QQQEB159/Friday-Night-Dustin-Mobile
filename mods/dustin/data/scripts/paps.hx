
/*
    emitter = new FlxTypedEmitter(boyfriend.x-2000, boyfriend.y+700);
    
    emitter.launchMode = FlxEmitterMode.SQUARE;
    emitter.velocity.set(-30, -300, 30, 0);
    emitter.alpha.set(1, 1, 0, 0);
    emitter.lifespan.set(3, 5);

    emitter.width = 2800;
    emitter.maxSize = 200;

    for (i in 0...emitter.maxSize) {
        var particle:FlxParticle = new FlxParticle();
        var size:Int = [4, 6, 8][FlxG.random.int(0,2)];
        particle.makeGraphic(size, size, 0x00FFFFFF);
        FlxSpriteUtil.drawCircle(particle, size/2, size/2, size/2, CoolUtil.lerpColor(0xFF0567A4, 0xFFB2DFE9, FlxG.random.float(0,1)));
        emitter.add(particle);
    }

    insert(members.indexOf(stage.stageSprites["bridge"]), emitter);

    emitter.start(false, 0.04);
*/