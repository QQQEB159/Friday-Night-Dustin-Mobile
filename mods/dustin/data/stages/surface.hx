//
var tankman_ghost_char;
var steve_ghost_char;
var drumer_ghost_char;
var pico_char;


var iTime:Float = 0;
var floatPhase:Float = 0;

var baseDadX:Float;
var baseDadY:Float;
var baseBFX:Float;
var baseBFY:Float;

var currentFloatRadius:Float = 20;
var currentFloatSpeed:Float = 2;

var targetFloatRadius:Float = 20;
var targetFloatSpeed:Float = 2;


var steveChar;
var canFloat:Bool = true;
var isResetting:Bool = false;

public var heat:CustomShader;

var drumerFloatPhase:Float = 0;
var drumerBaseX:Float = 0;
var drumerBaseY:Float = 0;
var drumerMotionActive:Bool = false;

var playerChar;

function create() {
    if(Options.gameplayShaders) {
    bloom_new = new CustomShader("bloom_new");
    bloom_new.size = 100; bloom_new.brightness = 2.2;
    bloom_new.directions = 40; bloom_new.quality = 5;
    bloom_new.threshold = .7;

    bloom_new2 = new CustomShader("bloom_new");
    bloom_new2.size = 20; bloom_new2.brightness = 1.78;
    bloom_new2.directions = 16; bloom_new2.quality = 5;
    bloom_new2.threshold = .75;

    if (FlxG.save.data.bloom) camGame.addShader(bloom_new);
    if (FlxG.save.data.bloom) camHUD.addShader(bloom_new2);

    heat = new CustomShader("heatwave");
    heat.time = 0; heat.speed = 0.2; 
    heat.even = false;
    heat.strength = 0.22; 

    heatcam = new CustomShader("heatwave");
    heatcam.time = 0; heatcam.speed = 0.1; 
    heatcam.even = false;
    heatcam.strength = 0.8; 

    if (FlxG.save.data.distortion) stage.getSprite("background").shader = heatcam;

    wave = new CustomShader("waving");
    wave.time = 0; wave.speed = 0.4; 
    wave.even = false;
    wave.strength = 0.3; 

    if (FlxG.save.data.distortion) {
    stage.getSprite("mountain").shader = heat;
    stage.getSprite("city").shader = heat;

    stage.getSprite("grass").shader = wave;
    }
    }

    tankman_ghost_char = strumLines.members[3].characters[0];
    steve_ghost_char = strumLines.members[4].characters[0];
    drumer_ghost_char = strumLines.members[5].characters[0];
    steveChar = strumLines.members[6].characters[0];
    pico_char = strumLines.members[2].characters[0];


    pico_char.alpha = 0;

    tankman_ghost_char.alpha = 0;
    steve_ghost_char.alpha = 0;
    drumer_ghost_char.alpha = 0;

    baseDadX = steve_ghost_char.x;
    baseDadY = steve_ghost_char.y;

    baseBFX = tankman_ghost_char.x;
    baseBFY = tankman_ghost_char.y;

    autoTitleCard = false;
    
}

function postCreate() {
    steveChar.x = dad.x - 400;
    steveChar.y = dad.y - 100;

    steveChar.alpha = 0;
    remove(steveChar);
    insert(members.indexOf(dad), steveChar);

    playerChar = new Character(0, 0, 'player_uprising');
    playerChar.scrollFactor.set(1, 1);
    playerChar.x = boyfriend.x + 1000;
    playerChar.y = boyfriend.y + 350;

    playerChar.alpha = 0;
    insert(members.indexOf(boyfriend), playerChar);

    executeEvent({
        name: "Screen Coverer",
        time: Conductor.songPosition,
        params: [false, 0xFF000000, 1, 4, "linear", "In", "camHUD", "front"]
    });

    text_appear.x = (FlxG.width - text_appear.width) / 2;
    text_appear.x += 240;
    text_appear.y += 470;
    text_appear.alpha = 0;

    text_appear2.x = (FlxG.width - text_appear2.width) / 2;
    text_appear2.x += 300;
    text_appear2.y -= 1400;
    text_appear2.alpha = 0;


    dad.color = 0xFF242424;
    boyfriend.color = 0xFF242424;

    mountain.color = 0xFF000000;
    city.color = 0xFF060606;
    grass.color = 0xFF1B1B1B;
    ground.color = 0xFF1A1A1A;

    tankman_ghost_char.color = 0xFF242424;
    steve_ghost_char.color = 0xFF242424;
    drumer_ghost_char.color = 0xFF242424;

    hitbox.buttonLeft.color = 0xFFC15700;
    hitbox.buttonDown.color = 0xFFC15700;
    hitbox.buttonUp.color = 0xFFC15700;
    hitbox.buttonRight.color = 0xFFC15700;
}

function stepHit(step:Int) {
    switch (step) {
        case 40:
            text_appear2.y += 450;
            text_appear2.alpha = 0;

            FlxTween.tween(text_appear2, {y: text_appear2.y - 800, alpha: 1}, 7, {
                ease: FlxEase.quadInOut,
                onComplete: function(_) {
                    FlxTween.tween(text_appear2, {alpha: 0}, 5, {ease: FlxEase.quadInOut});
                }
            });
        case 400:
            FlxTween.tween(tankman_ghost_char, {alpha: 0.9}, 1, {ease: FlxEase.quadInOut});
            FlxTween.tween(steve_ghost_char, {alpha: 0.9}, 1, {ease: FlxEase.quadInOut});
            FlxTween.tween(drumer_ghost_char, {alpha: 0.9}, 1, {ease: FlxEase.quadInOut});

        case 1122:
            FlxTween.tween(steveChar, {alpha: 0.5}, 0.5, {ease: FlxEase.quadInOut});

        case 1152:
            FlxTween.tween(steveChar, {alpha: 0}, 1, {ease: FlxEase.quadInOut});

        case 1184:
            FlxTween.tween(playerChar, {alpha: 0.4}, 0.5, {ease: FlxEase.quadInOut});

        case 1260:
            FlxTween.tween(playerChar, {alpha: 0}, 0.5, {ease: FlxEase.quadInOut});

        case 696:
            FlxTween.tween(steveChar, {alpha: 0.9}, 3, {ease: FlxEase.quadInOut});

        case 824:
            FlxTween.tween(playerChar, {alpha: 0.4}, 1, {ease: FlxEase.quadInOut});

        case 960:
            FlxTween.tween(steveChar, {alpha: 0}, 5, {ease: FlxEase.quadInOut});
            FlxTween.tween(playerChar, {alpha: 0}, 1, {ease: FlxEase.quadInOut});

        case 1088:
            targetFloatRadius = 70;
            targetFloatSpeed = 3;

        // PICO APPEARS

        case 1322:
            FlxTween.tween(drumer_ghost_char, {alpha: 0}, 0.5, {ease: FlxEase.quadInOut});

        case 1336:
            pico_char.alpha = 1;

            text_appear.y -= 50;
            text_appear.alpha = 0;

            FlxTween.tween(text_appear, {y: text_appear.y - 300, alpha: 1}, 2.5, {
                ease: FlxEase.quadInOut,
                onComplete: function(_) {
                    FlxTween.tween(text_appear, {alpha: 0}, 5, {ease: FlxEase.quadInOut});
                }
            });

            

        case 1344:
            targetFloatRadius = 20; 
            targetFloatSpeed = 2; 
            resetFloatPosition();


        case 1664:
            targetFloatRadius = 90; 
            targetFloatSpeed = 4; 

        case 1728:
            targetFloatRadius = 20; 
            targetFloatSpeed = 2;

        case 1600:
            remove(drumer_ghost_char);
            insert(members.indexOf(grass), drumer_ghost_char);

            FlxTween.tween(drumer_ghost_char, {alpha: 0.9}, 3, {ease: FlxEase.quadInOut});
            FlxTween.tween(drumer_ghost_char, {y: drumer_ghost_char.y - 300}, 3, {ease: FlxEase.quadInOut});

            var targetY = drumer_ghost_char.y - 300;
            FlxTween.tween(drumer_ghost_char, {y: targetY}, 3, {
                ease: FlxEase.quadInOut,
                onComplete: function(_) {
                    drumerGoGo();
                }
            });

            drumerBaseX = drumer_ghost_char.x;
            drumerBaseY = targetY;

            FlxTween.tween(playerChar, {alpha: 0.6}, 1, {ease: FlxEase.quadInOut});

        case 1970:
            targetFloatRadius = 140; 
            targetFloatSpeed = 5; 



        case 2240:
            targetFloatRadius = 20; 
            targetFloatSpeed = 2;

        case 1728:
            FlxTween.tween(playerChar, {alpha: 0}, 1, {ease: FlxEase.quadInOut});

        case 1920:
            FlxTween.tween(playerChar, {alpha: 0.6}, 0.5, {ease: FlxEase.quadInOut});

        case 2110:
            FlxTween.tween(playerChar, {alpha: 0}, 1, {ease: FlxEase.quadInOut});

        case 2106:
            FlxTween.tween(steveChar, {alpha: 0.9}, 2, {ease: FlxEase.quadInOut});

        case 2232:
            FlxTween.tween(steveChar, {alpha: 0}, 1, {ease: FlxEase.quadInOut});


        case 2356:
            FlxTween.tween(drumer_ghost_char, {alpha: 0}, 0.7, {ease: FlxEase.quadInOut});
            FlxTween.tween(steve_ghost_char, {alpha: 0}, 0.7, {ease: FlxEase.quadInOut});
            FlxTween.tween(tankman_ghost_char, {alpha: 0}, 0.7, {ease: FlxEase.quadInOut});

        case 2432:
            FlxTween.tween(steve_ghost_char, {alpha: 0.9}, 0.7, {ease: FlxEase.quadInOut});

        case 2624:
            FlxTween.tween(drumer_ghost_char, {alpha: 0.9}, 0.7, {ease: FlxEase.quadInOut});

        case 2880:
            FlxTween.tween(tankman_ghost_char, {alpha: 0.9}, 0.7, {ease: FlxEase.quadInOut});

        case 3000:
            targetFloatRadius = 180; 
            targetFloatSpeed = 5; 

        case 3002:
            FlxTween.tween(playerChar, {alpha: 0.6}, 0.5, {ease: FlxEase.quadInOut});

        case 3116:
            targetFloatRadius = 80; 
            targetFloatSpeed = 3; 

        case 3138:
            targetFloatRadius = 180; 
            targetFloatSpeed = 3; 

        case 3248:
            targetFloatRadius = 20; 
            targetFloatSpeed = 2;

            FlxTween.tween(drumer_ghost_char, {alpha: 0}, 4, {ease: FlxEase.quadInOut});
            FlxTween.tween(steve_ghost_char, {alpha: 0}, 4, {ease: FlxEase.quadInOut});
            FlxTween.tween(tankman_ghost_char, {alpha: 0}, 4, {ease: FlxEase.quadInOut});

        case 3312:
            FlxTween.tween(steveChar, {alpha: 0.7}, 1, {ease: FlxEase.quadInOut});

        case 3392:
            FlxTween.tween(steveChar, {alpha: 0}, 1, {ease: FlxEase.quadInOut});

        case 1824, 3247:
            FlxTween.tween(playerChar, {alpha: 0}, 1, {ease: FlxEase.quadInOut});


        case 2368, 3264:
            dad.color = 0xFF242424;
            boyfriend.color = 0xFF242424;
            pico_char.color = 0xFF242424;
            steveChar.color = 0xFF242424;

            mountain.color = 0xFF000000;
            city.color = 0xFF060606;
            grass.color = 0xFF1B1B1B;
            ground.color = 0xFF1A1A1A;

            tankman_ghost_char.color = 0xFF242424;
            steve_ghost_char.color = 0xFF242424;
            drumer_ghost_char.color = 0xFF242424;

        case 416, 2625:
            dad.color = 0xFFFFFFFF;
            boyfriend.color = 0xFFFFFFFF;
            pico_char.color = 0xFFFFFFFF;
            steveChar.color = 0xFFFFFFFF;

            tankman_ghost_char.color = 0xFFFFFFFF;
            steve_ghost_char.color = 0xFFFFFFFF;
            drumer_ghost_char.color = 0xFFFFFFFF;

            mountain.color = 0xFFFFFFFF;
            city.color = 0xFFFFFFFF;
            grass.color = 0xFFFFFFFF;
            ground.color = 0xFFFFFFFF;
    }
}

function drumerGoGo():Void {
    drumerMotionActive = true;
}


function onPlayerHit(note:Note):Void {
    if (playerChar != null && playerChar.alpha != 0) {
        var dirNames = ['LEFT', 'DOWN', 'UP', 'RIGHT'];
        var animName = 'sing' + dirNames[note.direction];
        playerChar.playAnim(animName, true);
    }
}

var iTime:Float = 0;
var tottalTimer:Float = FlxG.random.float(100, 1000);
function update(elapsed:Float) {

    if (drumerMotionActive) {
        drumerFloatPhase += elapsed * 1.5;

        var radiusX = 80;
        var radiusY = 40;

        var dx = Math.sin(drumerFloatPhase) * radiusX;
        var dy = Math.sin(drumerFloatPhase * 1.5) * radiusY;

        drumer_ghost_char.x = drumerBaseX + dx;
        drumer_ghost_char.y = drumerBaseY + dy;
    }


    var lerpFactor = elapsed * 3; 
    currentFloatRadius = FlxMath.lerp(currentFloatRadius, targetFloatRadius, lerpFactor);
    currentFloatSpeed = FlxMath.lerp(currentFloatSpeed, targetFloatSpeed, lerpFactor);

    // awesome fucking realistic floating
    var speedMod = 1 + Math.sin(iTime * 0.5) * 0.3;
    floatPhase += currentFloatSpeed * elapsed * speedMod;




    iTime += elapsed;
    if(Options.gameplayShaders) {
    heat?.time = (tottalTimer += elapsed);
    heatcam?.time = (tottalTimer += elapsed);

    wave?.time = (tottalTimer += elapsed);
    }


    if (canFloat) {
        var floatX = Math.sin(floatPhase) * currentFloatRadius;
        var floatY = Math.sin(floatPhase * 2) * (currentFloatRadius / 2);

        var floatX2 = Math.sin(iTime * 2) * 20;
        var floatY2 = Math.sin(iTime * 4) * 10;

        steve_ghost_char.x = baseDadX + floatX;     
        steve_ghost_char.y = baseDadY + floatY;

        tankman_ghost_char.x = baseBFX - floatX2;
        tankman_ghost_char.y = baseBFY + floatY2;
    }

}

function resetFloatPosition():Void {
    if (isResetting) return;
    isResetting = true;
    canFloat = false;

    FlxTween.tween(steve_ghost_char, {x: baseDadX, y: baseDadY}, 2, {
        ease: FlxEase.quadInOut,
        onComplete: function(_) {
            isResetting = false;
            canFloat = true;
        }
    });

    FlxTween.tween(tankman_ghost_char, {x: baseBFX, y: baseBFY}, 2, {
        ease: FlxEase.quadInOut
    });
}
