//

var bombs_clusters:Array<Dynamic> = [];
var arrowKeyIndicator:FlxSprite;

function postCreate() {
    arrowKeyIndicator = new FlxSprite().loadGraphic(Paths.image("game/undertale/arrow_key"));
    arrowKeyIndicator.scale.set(1.6, 1.6);
    arrowKeyIndicator.cameras = [camUndertale];
	arrowKeyIndicator.updateHitbox();
	arrowKeyIndicator.antialiasing = false;
    arrowKeyIndicator.visible = false;
    insert(9999, arrowKeyIndicator);

    autoTitleCard = false;
    if (Options.gameplayShaders && FlxG.save.data.saturation) camCharacters.addShader(saturation);

    undertale_updates.push(undertale_update);
}

function tutorial() {
    update_battlebox();
    box_open_animation();

    battleBox.x = FlxG.width/2 - battleBox.bWidth/2;
    battleBox.y = FlxG.height*.525 - battleBox.bHeight/2;

    soulHitbox.x = FlxG.width/2 - (soulHitbox.width/2);
    soulHitbox.y = FlxG.height*.525 - (soulHitbox.height/2);

    idealBoxWidth = 220;
    idealBoxHeight = 200;
}

var bombTimer:FlxTimer;
function attack() {
    update_battlebox();
    box_open_animation();

    battleBox.x = FlxG.width/2 - battleBox.bWidth/2;
    battleBox.y = FlxG.height*.525 - battleBox.bHeight/2;

    soulHitbox.x = FlxG.width/2 - (soulHitbox.width/2);
    soulHitbox.y = FlxG.height*.525 - (soulHitbox.height/2);

    spawn_bonewalls();

    FlxTween.num(0, 1, 3.1, {ease: FlxEase.circOut}, (val:Float) -> {
        boneAppearRight = Math.floor(val*70)/70;
    });

    FlxTween.num(0, 1, 3.1, {ease: FlxEase.circOut, startDelay: 0.2}, (val:Float) -> {
        boneAppearLeft = Math.floor(val*70)/70;
    });

    bombTimer = (new FlxTimer()).start(1.5, function (t) {
        switch (FlxG.random.int(0, 2)) {
            case 2: spawn_bomb_cluster(4, 4, 8);
            case 1: spawn_bomb_cluster(3, 12, 16);
            default: spawn_bomb_cluster(2, 60, 8);
        }
    }, 9999);

    doblaster_timer();
}

var blasterTimer:FlxTimer;
var cancelBlasters:Bool = false;
function doblaster_timer() {
    if (cancelBlasters) return;
    if (blasterTimer == null) blasterTimer = new FlxTimer();

    blasterTimer.start((Conductor.stepCrochet / 1000) * 6.9, function (t) {
        var direction:Bool = FlxG.random.bool();
        spawn_gasterblaster((direction ? 960 : 300) + (FlxG.random.float(-30, 30)), FlxG.random.float(100, 340), direction ? 90 : -90, FlxG.random.float(2.5, 3.1), FlxG.random.int(0, 7));
        (new FlxTimer()).start((Conductor.stepCrochet / 1000) * 1.1, function () {
            (new FlxTimer()).start((Conductor.stepCrochet / 1000) * 24, function () {
                doblaster_timer();
            });
        });
    });
}

function stepHit(step:Int) {
    if (!FlxG.save.data.mechanics)
        return;

    switch (step) {
        case 0:
            FlxTween.num(0, 1, 1, null, (val:Float) -> {
                camHUD.bgColor = FlxColor.interpolate(0x00000000, 0x82000000, Math.floor(val*10)/10);
            });
        case 4: 
            tutorial();

            executeEvent({name: "Lyrics", time: 0, params: ["Set Size", "32", 0xFFFFFFFF, false]});
            executeEvent({name: "Lyrics", time: 0, params: ["Add Text", "BE PREPARED TO PROTECT YOUR SOUL.", 0xFFFFFFFF, false]});

        case 8: arrowKeyIndicator.visible = true;
        case 62:
            executeEvent({name: "Lyrics", time: 0, params: ["Enable text history (On, Off)", "32", 0xFFFFFFFF, false]});
            executeEvent({name: "Lyrics", time: 0, params: ["Set Color", "PRESS Z", 0xFFFFFF00, false]});
            executeEvent({name: "Lyrics", time: 0, params: ["Add Text", "PRESS Z", 0xFFFFFF00, false]});
        case 63:
            arrowKeyIndicator.visible = false;
            switch_soul_mode(SOUL_YELLOW);

            spawn_mttbomb(FlxG.width/2 - 18, 200);
        case 112:
            for (bomb in bombs) bomb.ID = 0; // mark to explode
            box_close_animation();

            FlxTween.num(1, 0, 2, null, (val:Float) -> {
                camHUD.bgColor = FlxColor.interpolate(0x00000000, 0x82000000, Math.floor(val*10)/10);
            });
        case 1984:
            FlxTween.num(0, 1, 1, null, (val:Float) -> {
                camHUD.bgColor = FlxColor.interpolate(0x00000000, 0x82000000, Math.floor(val*10)/10);
            });

            attack();
            invisTimer = invisTime*3;
        case 2200: cancelBlasters = true;
        case 2180:
            bombTimer.cancel();
            blasterTimer.cancel();

            allowSoulDamage = false;
            FlxTween.num(1, 0, 1, {ease: FlxEase.circOut}, (val:Float) -> {
                boneAppearRight = Math.floor(val*70)/70;
            });

            FlxTween.num(1, 0, 1, {ease: FlxEase.circOut, startDelay: 0.2}, (val:Float) -> {
                boneAppearLeft = Math.floor(val*70)/70;
            });

            for (bomb in bombs) bomb.ID = 0; // mark to explode
        case 2204: 
            box_close_animation();
            FlxTween.num(1, 0, 1, null, (val:Float) -> {
                camHUD.bgColor = FlxColor.interpolate(0x00000000, 0x82000000, Math.floor(val*10)/10);
            });
    }
}

function spawn_bomb_cluster(amount:Float = 3, xoffset:Float = 0, gap:Float) {
    bombs_clusters.push({x: -1, xoff: xoffset, gap: gap, y: -100, bombs: [
        for (i in 0...amount)
            spawn_mttbomb(-999, -999)
    ]});
}


function undertale_update(elapsed:Float) {
    for (bombinfo in bombs_clusters) {
        bombinfo.y += 11;
        bombinfo.x = camBones.x + get_bone_wave_x_left_smooth(bombinfo.y-camBones.y);

        for (i => bomb in bombinfo.bombs) {
            bomb.x = bombinfo.x + i * (32+bombinfo.gap) + bombinfo.xoff;
            bomb.y = bombinfo.y;
        }

        if (bombinfo.y >= FlxG.height+24) {
            bombs_clusters.remove(bombinfo);
            for (bomb in bombinfo.bombs) {
                bombs.remove(bomb);
                bomb.ID = MARKED_FOR_DELETION_NEXT_FRAME;
            }
        }
    }
}

function update(elapsed:Float) {
    if (!arrowKeyIndicator.visible) return;

    if (FlxG.keys.justPressed.LEFT || FlxG.keys.justPressed.RIGHT || FlxG.keys.justPressed.UP || FlxG.keys.justPressed.DOWN) arrowKeyIndicator.visible = false;

    arrowKeyIndicator.x = soulHitbox.x - 15;
    arrowKeyIndicator.y = soulHitbox.y - 8;
}

function onGameOver() {
    cancelBlasters = true;
    if (bombTimer != null) bombTimer.cancel();
    if (blasterTimer != null) blasterTimer.cancel();
}