//
import flixel.text.FlxTextBorderStyle;

function onStartSong() {
    inst.onComplete = bazinga;
}

public function bazinga() {
    var gainAmount:Int = Std.int(switch (curRating.rating) {
        case "S++" | "=)": 700;
        case "S": 650;
        case "A": 600;
        case "B": 550;
        case "[N/A]": 0;
        default: 500;
    });
    if (!FlxG.save.data.mechanics) gainAmount = Math.floor(gainAmount/2);
    FlxG.save.data.dustinCash += gainAmount;

    var cutsceneCamera = new FlxCamera();
    cutsceneCamera.bgColor = 0xFF000000;
    FlxG.cameras.add(cutsceneCamera, false);

    var target_text = new FlxText(0, 0, 0, "+ 0 EXP");
    target_text.setFormat(Paths.font("DTM-Mono.ttf"), 48, 0xFFFFFFFF);

    target_text.borderStyle = FlxTextBorderStyle.OUTLINE;
    target_text.borderSize = 2;
    target_text.borderColor = 0xFF000000;

    target_text.textField.antiAliasType = 0/*ADVANCED*/;
    target_text.textField.sharpness = 400/*MAX ON OPENFL*/;

    target_text.alpha = 0;
    target_text.cameras = [cutsceneCamera];
    add(target_text);

    target_text.screenCenter(0x11);
    FlxTween.tween(target_text, {alpha: 1}, .2);

    FlxTween.num(0, gainAmount, .7, {ease: FlxEase.sineOut}, (val:Float) -> {
        target_text.text = "+ " + Std.string(Math.floor(val)) + " EXP";
        target_text.screenCenter(0x11);
    });

    FlxG.sound.play(Paths.sound("levelup"), 1, false, null, true);

    new FlxTimer().start(2.6, (_) -> {
        FlxG.cameras.remove(cutsceneCamera);
        endSong();
    });
}