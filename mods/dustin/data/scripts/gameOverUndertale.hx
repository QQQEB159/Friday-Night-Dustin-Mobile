//
import Reflect;
importClass("data.scripts.classes.FunkinTypeText", __script__);

var game_over:FunkinText;
var heart:FlxSprite;
var heartbroken:FlxSprite;
var quoteText:FunkinTypeText;
var quoteString:String = PlayState.SONG.meta?.customValues?.gameover?.quote;
var songName:String = PlayState.SONG.meta?.customValues?.gameover?.song;
var soundName:String = PlayState.SONG.meta?.customValues?.gameover?.sound;

var gameOverEnd:Bool = false;

var heartbrokenBaseX;
var heartbrokenBaseY;

var glitch:CustomShader;
var bloom:CustomShader;

function create(e) {
    for (cam in FlxG.cameras.list) {
        cam.visible = false;
    }

    if(Options.gameplayShaders) {
    bloom = new CustomShader("bloom");
    bloom.size = 40;
    bloom.brightness = 5;
    bloom.directions = 8;
    bloom.quality = 10;

    glitch = new CustomShader("glitching");
    glitch.SPEED = 1;
    glitch.AMT = 0.7;
    }

    FlxG.sound.play(Paths.sound('startBreak'), 1);
    e.cancel();
    FlxG.cameras.add(gameOverCam = new FlxCamera(), false);

    var textSpeach;
    var textSound;
    switch(soundName) {
        case "gf": textSpeach = "8bit-jve.ttf"; textSound = "gf_talk";
        case "paps": textSpeach = "papyrus.ttf"; textSound = "papyrus_talk";
        case "sans": textSpeach = "pixel-comic.ttf"; textSound = "sans_talk";
        case "swapsans": textSpeach = "pixel-comic.ttf"; textSound = "swapsans_talk";
        case "swappaps": textSpeach = "papyrus.ttf"; textSound = "swappaps_talk";
        case "fellsans": textSpeach = "pixel-comic.ttf"; textSound = "fellsans_talk";
        default: textSpeach = "8bit-jve.ttf"; textSound = "gf_talk";
    }

    game_over = new FunkinSprite().loadGraphic(Paths.image("game/gameover/gay_over"));
    game_over.scale.set(0.7, 0.7);
    game_over.updateHitbox();
    game_over.antialiasing = false;
    game_over.alpha = 0;
    game_over.cameras = [gameOverCam];
    add(game_over);
    game_over.screenCenter();

    quoteText = new FunkinTypeText(0, 500, FlxG.width, quoteString != null ? quoteString : "Don't lose hope!");
    quoteText.setFormat(Paths.font(textSpeach), 34, FlxColor.WHITE);
    quoteText.x = 0;
    quoteText.fieldWidth = FlxG.width;
    quoteText.cameras = [gameOverCam];
    quoteText.realFuckingCamera = gameOverCam;
    Reflect.setProperty(quoteText, "alignment", "center"); // weird workaround -lunar
    quoteText.letterSpacing = 8;
    add(quoteText);
    quoteText.y = 530;
    quoteText.defaultSound = FlxG.sound.load(Paths.sound('talk/' + textSound));

    if (soundName == "fellsans") {
        var fellColor:Int = FlxColor.fromString("#B93B3E");

        quoteText.color = fellColor;
        game_over.color = fellColor;
    }
    else if (soundName == "swapsans" || soundName == "swappaps") {
        var fellColor:Int = FlxColor.fromString("#FFADD5");

        quoteText.color = fellColor;
        game_over.color = fellColor;
    }
    
    var soulType:Bool = PlayState.SONG.meta?.customValues?.gameover?.isMonster == true;
    var heartPath:String = soulType ? "game/gameover/monster_heart" : "game/gameover/heart";
    heart = new FunkinSprite().loadGraphic(Paths.image(heartPath));
    heart.scale.set(0.05, 0.05);
    heart.updateHitbox();
    heart.antialiasing = false;
    heart.cameras = [gameOverCam];
    add(heart);
    heart.screenCenter();

    var positionToTween = heart.y + 80;
    heart.y = heart.y + 400;

    var heartPath2:String = soulType ? "game/gameover/monster_heart_broken" : "game/gameover/heart_broken";
    heartbroken = new FunkinSprite().loadGraphic(Paths.image(heartPath2));
    heartbroken.scale.set(0.05, 0.05);
    heartbroken.updateHitbox();
    heartbroken.antialiasing = false;
    heartbroken.cameras = [gameOverCam];
    heartbroken.visible = false;
    add(heartbroken);
    heartbroken.screenCenter();
    heartbroken.y = heartbroken.y + 80;

    heartbrokenBaseX = heartbroken.x;
    heartbrokenBaseY = heartbroken.y;

    whiteFlash = new FunkinSprite(0, 0).makeSolid(FlxG.width, FlxG.height, 0xFFFFFFFF);
    whiteFlash.alpha = 0;
    whiteFlash.scrollFactor.set();
    whiteFlash.scale.set(1920, 1080);
    whiteFlash.cameras = [gameOverCam];
    add(whiteFlash);

    FlxTween.tween(heart, {y: positionToTween}, 2, {
            ease: FlxEase.quartInOut,
        });

    new FlxTimer().start(1.5, function() {
        gameOverCam.shake(0.005, 0.5);
    });

    new FlxTimer().start(2, function() {
        FlxG.sound.playMusic(Paths.music('gameovers/' + songName), 0.8);
        FlxG.sound.play(Paths.sound('endBreak'), 0.8);

        if (songName == "kinemorto" && FlxG.random.float() < 0.1)
            FlxG.sound.play(Paths.sound('umano'), 0.8);


        if(Options.gameplayShaders) {
        if (FlxG.save.data.bloom) gameOverCam.addShader(bloom);
        if (FlxG.save.data.glitching) gameOverCam.addShader(glitch);
        }

        FlxTween.num(2, 0, 2, {ease: FlxEase.quintOut}, function(num) {
            if(Options.gameplayShaders) {
            bloom.size = 20 * num;
            bloom.brightness = 1 + (20 * num);
            glitch.AMT = 0.1 * num;
            glitch.SPEED = 2 * num;
            }
        });

        gameOverCam.shake(0.04, 0.2);
        heartbroken.visible = true;
        heart.visible = false;

        FlxTween.tween(game_over, {alpha: 1}, 2, {
            ease: FlxEase.linear,
            onComplete: function(_) {
                quoteText.start();
                gameOverEnd = true;
            }
        });
    });
    if(PlayState.SONG.meta.name == "genocides") {
	addTouchPad('NONE', 'A_B_Q');
	addTouchPadCamera();
	} else {
	addTouchPad('NONE', 'A_B');
    addTouchPadCamera();
	}
}

var iTime:Float = 0;
function update(elapsed:Float){
    iTime += elapsed;
    if(Options.gameplayShaders) glitch.iTime = iTime;

    if (controls.ACCEPT && gameOverEnd){
        endGameOver();
    }
    if (controls.BACK && gameOverEnd){
        FlxG.switchState(new FreeplayState());
    }

    if (heartbroken.visible) {
        heartbroken.x = heartbrokenBaseX + FlxG.random.float(-1.5, 1.5);
        heartbroken.y = heartbrokenBaseY + FlxG.random.float(-1.5, 1.5);
    }
}

function endGameOver() {
    if (!gameOverEnd) return;

    gameOverEnd = false;

    FlxG.sound.music.stop();
    FlxG.sound.play(Paths.sound('gameovers/' + songName), 0.8);

    FlxTween.num(2, 0, 2, {ease: FlxEase.quintOut}, function(num) {
        if(Options.gameplayShaders) {
        bloom.size = 20 * num;
        bloom.brightness = 1 + (20 * num);
        glitch.AMT = 0.1 * num;
        glitch.SPEED = 2 * num;
        }
    });

    gameOverCam.shake(0.04, 0.2);
    heartbroken.visible = false;
    heart.visible = true;

    new FlxTimer().start(2, function() {
        FlxTween.tween(gameOverCam, {zoom: 1.8}, 3, {ease: FlxEase.quadIn});
        FlxTween.tween(whiteFlash, { alpha: 1 }, 3, { ease: FlxEase.sineOut });

        new FlxTimer().start(4, function() {
            FlxG.switchState(new PlayState());
        });
    });
}
