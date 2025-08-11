import flixel.text.FlxText.FlxTextFormat;
import flixel.text.FlxText.FlxTextFormatMarkerPair;
import flixel.text.FlxTextBorderStyle;
import funkin.backend.system.framerate.Framerate;

function postCreate() {
    // trace(disclaimer.text);
    if(controls.touchC) {
    disclaimer.text = "Okay so haha so basically\ntheres a bit of *LAG* for low end devices\nbecause *SOMEBODY* who starts with \"*l*\" and ends in \"*unarcleint*\"\ndecided to add shaders to everything\nthrow #tomatoes# at him.\n\nThis is lunar this mod has heavy *flashing lights*,  continue with caution.\n\n_Tap Your Screen to continue._";
    } else {
    disclaimer.text = "Okay so haha so basically\ntheres a bit of *LAG* for low end devices\nbecause *SOMEBODY* who starts with \"*l*\" and ends in \"*unarcleint*\"\ndecided to add shaders to everything\nthrow #tomatoes# at him.\n\nThis is lunar this mod has heavy *flashing lights*,  continue with caution.\n\n_Press ENTER to continue._";
    }
    disclaimer.applyMarkup(disclaimer.text, [
        new FlxTextFormatMarkerPair(new FlxTextFormat(0xFFFF0000), "*"),
        new FlxTextFormatMarkerPair(new FlxTextFormat(0xFF0011FF), "#"),
        new FlxTextFormatMarkerPair(new FlxTextFormat(0xFFFFFF00), "_")
    ]);
    disclaimer.font = Paths.font("8bit-jve.ttf");
    disclaimer.textField.antiAliasType = 0/*ADVANCED*/;
    disclaimer.textField.sharpness = 400/*MAX ON OPENFL*/;

    var newWarningFont = new FlxText(0, 220, FlxG.width, "WARNING");
    newWarningFont.setFormat(Paths.font("fallen-down.ttf"), 48, 0xFFFFFFFF);
    newWarningFont.borderStyle = FlxTextBorderStyle.OUTLINE;
    newWarningFont.borderSize = 2;
    newWarningFont.borderColor = 0xFF000000;
    newWarningFont.textField.antiAliasType = 0/*ADVANCED*/;
    newWarningFont.textField.sharpness = 400/*MAX ON OPENFL*/;
    newWarningFont.alignment = "center";
    add(newWarningFont);

    titleAlphabet.visible = false;


    var freakingLunarBro = new FunkinSprite().loadGraphic(Paths.image('menus/credits/sprites/Lunarcleint'));
    add(freakingLunarBro);
    freakingLunarBro.scale.set(12, 12);
    freakingLunarBro.updateHitbox();
    freakingLunarBro.screenCenter();
    freakingLunarBro.x -= 675;
    freakingLunarBro.alpha = 0;

    new FlxTimer().start(20, function() {
        FlxTween.tween(freakingLunarBro, {alpha: 0.075, x: freakingLunarBro.x + 25}, 10);
    });
}

function destroy() {
    Framerate.debugMode = 0;
}