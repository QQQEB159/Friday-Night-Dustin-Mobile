//
import flixel.tweens.FlxTween;
import flixel.tweens.misc.NumTween;
import flixel.tweens.FlxEase;

var desiredCamAngle:Float = 4;
var isAngle:Bool = true;
var isGlitch:Bool = true;
var isGlitch2:Bool = false;
var starthittingthegriddy:Bool = false;
var glitch:CustomShader = null;
var glitch2:CustomShader = null;
var distortionTween:NumTween;

var alphaTimer:Float = 0;
var fadeInterval:Float = 2.5;
var fadeAmount:Float = 0.1;

var glitchTimer:Float = 0;
var glitchValues:Array<Float> = [0.1, 0.2, 0.3, 0.4];
var glitchValues2:Array<Float> = [0.4, 0.6, 0.8, 1];

var itslikeprettywarpedtoo:CustomShader = null;

var up:Bool = true;


function create() {
    if(Options.gameplayShaders) {
    glitch = new CustomShader("glitching");
    glitch2 = new CustomShader("glitching");
    if (FlxG.save.data.glitching) camGame.addShader(glitch);
    if (FlxG.save.data.glitching) camHUD.addShader(glitch2);

    glitch.AMT = 0;
    glitch2.AMT = 0;
    }

    cinematic_bars_vin.camera = camHUD;
}



function postCreate() {
    desiredCamAngle = 4;

    dad.playAnim("talk", true);

    bg_legacy.visible = false;
    il_legacy.visible = false;

    sanses_bg.visible = false;
    sanses_front.visible = false;
    thero_appear.visible = false;

    autoTitleCard = false;

    gf.alpha = 0;

    executeEvent({
        name: "Screen Coverer",
        time: Conductor.songPosition,
        params: [false, 0xFF000000, 1, 4, "linear", "In", "camHUD", "front"]
    });

    var vignetteCam = new FlxCamera();
    FlxG.cameras.add(vignetteCam, false);
    vignetteCam.bgColor = 0x00000000;

    gasterBlaster.camera = vignetteCam;
    hate_vignette.camera = vignetteCam;
    hate_vignette.alpha = 0;
    gasterBlaster.visible = false;


    itslikeprettywarpedtoo = new CustomShader("chromaticWarp");
    if (Options.gameplayShaders){
        if (FlxG.save.data.distortion) camGame.addShader(itslikeprettywarpedtoo);
        itslikeprettywarpedtoo.distortion = 1;
    }

    if (camHUD.downscroll) {
        gasterBlaster.y -= 480;
    }
    hitbox.buttonLeft.color = 0xFF00FFFF;
    hitbox.buttonDown.color = 0xFF00FFFF;
    hitbox.buttonUp.color = 0xFF00FFFF;
    hitbox.buttonRight.color = 0xFF00FFFF;
}

function update(elapsed:Float) {
    baseAngle = isAngle ? desiredCamAngle : 0;

    if (isGlitch)
    {
        glitchTimer += elapsed;
        if (glitchTimer >= 0.15) {
            glitchTimer = 0;

            var randIndex = FlxG.random.int(0, glitchValues.length - 1);
            if(Options.gameplayShaders) {
            if (FlxG.save.data.glitching) glitch.AMT = glitchValues[randIndex];
            }
        } 
    }

    if (isGlitch2)
    {
        glitchTimer += elapsed;
        if (glitchTimer >= 0.15) {
            glitchTimer = 0;

            var randIndex2 = FlxG.random.int(0, glitchValues2.length - 1);
            if(Options.gameplayShaders) {
            if (FlxG.save.data.glitching) glitch2.AMT = glitchValues2[randIndex2];
            }
        } 
    }

    if (hate_vignette.alpha > 0) {
        alphaTimer += elapsed;
        if (alphaTimer >= fadeInterval) {
            alphaTimer = 0;
            hate_vignette.alpha -= fadeAmount;
        }
    }
}

function beatHit() {
    if (Options.gameplayShaders && itslikeprettywarpedtoo != null && starthittingthegriddy) {
        itslikeprettywarpedtoo.distortion = 1.6;

        FlxTween.num(1.6, 1, 0.5, {
            ease: FlxEase.quadOut}, 
            function(val:Float) {
                itslikeprettywarpedtoo.distortion = val;}

        );
    }
}


function turnCam() {
    if (!FlxG.save.data.mechanics) return;
    camGame.shake(0.01, 0.2);
    camHUD.shake(0.01, 0.2);
    if (up == true) {
        // should be from 4 to 0, a quadOut, then from 0 to 184 a quadIn
        desiredCamAngle = 0;
        desiredCamAngle = 184;
        up = false;
    }
    else {
        // should be from 184 to 180, a quadOut, then from 180 to 4 a quadIn
        desiredCamAngle = 180;
        desiredCamAngle = 4;
        up = true;
    }
}

function shootBlast() {
    if (!FlxG.save.data.mechanics) return;
    gasterBlaster.visible = true;
    gasterBlaster.playAnim("shoot");
    

    new FlxTimer().start(0.2, function(tmr:FlxTimer) {
        FlxG.sound.play(Paths.sound("blaster_shoot"), 1);
    });

    

    new FlxTimer().start(0.4, function(tmr:FlxTimer) {
        if (player != null) {

            if (health <= 0.3) {
                health = 0;
            } else
            {
                health = 0.1;
            }
            
        }
    });


}


function stepHit(step:Int) {
    if (step == 16) {
        isGlitch = false;
        if(Options.gameplayShaders) glitch.AMT = 0;
        shootBlast();
        
    }

    if (step == 2828 || step == 528 || step == 848 || step == 976 || step == 1040 || step == 1936 || step == 2224 || step == 2448 || step == 1936 || step == 2624 || step == 2656 || step == 2676 || step == 2696) {
        shootBlast();
    }

    if (step == 784) {
        isGlitch = true;
        isAngle = false;

        bg.visible = false;
        fg.visible = false;

        hitbox.buttonLeft.color = 0xFFC24B99;
        hitbox.buttonDown.color = 0xFF00FFFF;
        hitbox.buttonUp.color = 0xFF12FA05;
        hitbox.buttonRight.color = 0xFFF9393F;
        
        bg_legacy.visible = true;
        il_legacy.visible = true;
        cinematic_bars_vin.visible = true;

    }

    if (step == 1040) {
        isAngle = true;
        isGlitch = false;
        if(Options.gameplayShaders) glitch.AMT = 0;

        bg.visible = true;
        fg.visible = true;

        hitbox.buttonLeft.color = 0xFF00FFFF;
        hitbox.buttonDown.color = 0xFF00FFFF;
        hitbox.buttonUp.color = 0xFF00FFFF;
        hitbox.buttonRight.color = 0xFF00FFFF;
        
        bg_legacy.visible = false;
        il_legacy.visible = false;
        cinematic_bars_vin.visible = false;
    }

    if (step == 1680) {
        isGlitch = true;
        isGlitch2 = true;
    }

    if (step == 1936) {
        isGlitch = false;
        isGlitch2 = false;
        if(Options.gameplayShaders) {
        glitch.AMT = 0;
        glitch2.AMT = 0;
        }
    }

    if (step == 2192) {
        isGlitch = true;
        isGlitch2 = true;
        sanses_bg.visible = true;
        sanses_front.visible = true;
    }

    if (step == 2448) {
        isGlitch = true;
        isGlitch2 = true;
        
    }

    if (step == 2432 || step == 2704) {
         isGlitch = false;
         isGlitch2 = false;
        if(Options.gameplayShaders) {
        glitch.AMT = 0;
        glitch2.AMT = 0;
        }
    }

    if (step == 1296) {
        FlxTween.tween(fg, {alpha: 0}, 3, {ease: FlxEase.quadOut});
        FlxTween.tween(bg, {alpha: 0}, 3, {ease: FlxEase.quadOut});
        FlxTween.tween(dad, {alpha: 0}, 3, {ease: FlxEase.quadOut});
        cinematic_bars_vin.visible = true;
    }

    if (step == 1424) {
        FlxTween.tween(fg, {alpha: 1}, 10, {ease: FlxEase.quadOut});
        FlxTween.tween(bg, {alpha: 1}, 10, {ease: FlxEase.quadOut});
        FlxTween.tween(dad, {alpha: 1}, 10, {ease: FlxEase.quadOut});
    }

    if (step == 1552 || step == 1680 || step == 2192 || step == 2448) {
        FlxG.camera.shake(0.01, 0.2);
    }

    if (step == 528 || step == 1040 || step == 1680 || step == 2448) {
        starthittingthegriddy = true;
    }

    if (step == 783 || step == 1296 || step == 1936 || step == 2703) {
        starthittingthegriddy = false;

    }

    if (step == 1552 || step == 1616)
    {
        cinematic_bars_vin.visible = false;
        itslikeprettywarpedtoo.distortion = 2;

        FlxTween.num(2, 1, 0.5, {
            ease: FlxEase.quadOut}, 
            function(val:Float) {
                itslikeprettywarpedtoo.distortion = val;}

        );
    }

    if (step == 2444)
    {
        FlxTween.num(1, 3, 0.5, {
            ease: FlxEase.quadOut}, 
            function(val:Float) {
                itslikeprettywarpedtoo.distortion = val;}

        );
    }

    if (step == 1520)
    {
        thero_appear.visible = true;
        thero_appear.playAnim("thero_appear");
    }

    if (step == 1547)
    {
        gf.alpha = 1;
    }

    if (step == 272)
    {
        showTitleCard();
        cinematic_bars_vin.visible = false;

    }

    if (step == 272 || step == 304 || step == 336 || step == 368 || step == 400 || step == 432 || step == 464 || step == 496 || step == 576 || step == 592 || step == 704 || step == 720 || step == 2064 || step == 2192 || step == 2448 || step == 2480 || step == 2512 || step == 2544 || step == 2560 || step == 2569 || step == 2608 || step == 2640 || step == 2696) 
    {
        turnCam();
    }

    if (step = 2704)
    {
        cinematic_bars_vin.visible = true;
    }

}
