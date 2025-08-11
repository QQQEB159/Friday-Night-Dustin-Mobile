//
import funkin.backend.utils.FlxInterpolateColor;
import flixel.ui.FlxBarFillDirection;
import flixel.math.FlxRect;
import flixel.ui.FlxBar;

public var noMissIconAnim:Bool = false;

static var dustinHealthBG:FlxSprite;
static var dustinHealthBar:FlxSprite;

static var dustiniconP1:FlxSprite;
static var dustiniconP2:FlxSprite;

static var ogHealthColors:Array<Int> = [0xFF000000, 0xFF000000];
static var healthBarColors:Array<Int> = [0xFF000000, 0xFF000000];
var __lerpColor:FlxInterpolateColor;
var cahceRect:FlxRect = new FlxRect();
public var reverseIcons:Bool = false;

function postCreate() {
    if(FlxG.save.data.botplay) {
         importScript("data/scripts/botplay");
    }
    for (spr in [healthBar, healthBarBG, iconP1, iconP2]) {
        remove(spr); spr.visible = spr.active = spr.exists = false;
    }

    var healthBarSkin:String = "snowdin";
    if (stage != null && stage.stageXML != null && stage.stageXML.exists("healthBarSkin"))
		healthBarSkin = stage.stageXML.get("healthBarSkin");

    dustinHealthBG = createHealthBG(healthBarSkin);

    var leftColor:Int = dad != null && dad.iconColor != null && Options.colorHealthBar ? dad.iconColor : (PlayState.opponentMode ? 0xFF66FF33 : 0xFFFF0000);
	var rightColor:Int = boyfriend != null && boyfriend.iconColor != null && Options.colorHealthBar ? boyfriend.iconColor : (PlayState.opponentMode ? 0xFFFF0000 : 0xFF66FF33); // switch the colors
    healthBarColors = [leftColor, rightColor];
    ogHealthColors = [leftColor, rightColor];

    var fillPath = Paths.image("game/ui/healthbar_fill_" + healthBarSkin);
    dustinHealthBar = new FlxSprite(dustinHealthBG.x+46, dustinHealthBG.y+(camHUD.downscroll ? 25 : 32));
    if(Assets.exists(fillPath)) dustinHealthBar.loadGraphic(fillPath);
    else dustinHealthBar.makeGraphic(dustinHealthBG.width-(46*2), 18, 0xFFFFFFFF);
    dustinHealthBar.cameras = [camHUD]; dustinHealthBar.scrollFactor.set();
    dustinHealthBar.screenCenter(FlxAxes.X);

    add(dustinHealthBar); hudElements.push(dustinHealthBar);
    add(dustinHealthBG); hudElements.push(dustinHealthBG);

    for (i => char in [boyfriend != null ? boyfriend.getIcon() : "face", dad != null ? dad.getIcon() : "face"]) {
        var icon:FlxSprite = createHealthIcon(char, i == 0);
        switch (i) {
            case 0: dustiniconP1 = icon;
            case 1: dustiniconP2 = icon;
        }
        add(icon); hudElements.push(icon);

        if (i == 1 || !Options.gameplayShaders) continue;
        icon.shader = new CustomShader("iconshader");
        icon.shader.minBrightness = .2;
        icon.shader.color = [.5, 0., 0.];
        icon.shader.ratio = 0;
    }

    dustinHealthBar.onDraw = () -> {
        for (i => color in healthBarColors) {
            var precentWidth:Float = dustinHealthBar.width * Math.abs(1-(healthPrecent/100));
            switch (i) {
                case 0: cahceRect.set(0, 2, precentWidth, dustinHealthBar.height-2);
                case 1: cahceRect.set(precentWidth, 2, dustinHealthBar.width-precentWidth, dustinHealthBar.height - 2);
            }

            dustinHealthBar.colorTransform.color = color;
            dustinHealthBar.clipRect = cahceRect;
            if (color == 0x00000000) continue;
            dustinHealthBar.draw();
        }
    };

    __lerpColor = new FlxInterpolateColor(ogHealthColors[1]);
}

static function createHealthBG(image:String):FlxSprite {
    var newHealthBG:FlxSprite = new FlxSprite(0, FlxG.height * 0.8 - 12).loadGraphic(Paths.image("game/ui/healthbar_" + image));
    newHealthBG.cameras = [camHUD]; newHealthBG.scrollFactor.set(); newHealthBG.antialiasing = Options.antialiasing; newHealthBG.screenCenter(FlxAxes.X);
    return newHealthBG;
}

static function createHealthIcon(image:String, flip:Bool):FlxSprite {
    var path = Paths.image("icons/" + image);
    if (!Assets.exists(path))
        path = Paths.image('icons/face');

    var icon:FlxSprite = new FlxSprite().loadGraphic(path, true, 150, 150);
    icon.animation.add(image, [for(i in 0...icon.frames.frames.length) i], 0, false, flip);
    icon.antialiasing = Options.antialiasing; icon.animation.play(image); icon.scrollFactor.set();
    icon.scale.set(.9,.9); icon.updateHitbox(); icon.cameras = [camHUD]; return icon;
}

var healthLossCooldown:Float = 0.2;
var healthLossTimer:Float = 0;
var __lastHealth:Float = health;

public var lerpedHealth:Float = health;
static var healthPrecent:Float = 50;
public var hurtColor:Float = 0xFF7F0000;
function update(elapsed:Float) {
    lerpedHealth = CoolUtil.fpsLerp(lerpedHealth, Math.min(health, maxHealth), 1/4);
    healthPrecent = (lerpedHealth/maxHealth) * 100;

    var healthBarX:Float = dustinHealthBar.x;
    var healthBarW:Float = dustinHealthBar.width;
    var hpPercent:Float = FlxMath.remapToRange(healthPrecent, 0, 100, reverseIcons ? 0 : 1, reverseIcons ? 1 : 0);

    var icon1 = reverseIcons ? dustiniconP2 : dustiniconP1;
    var icon2 = reverseIcons ? dustiniconP1 : dustiniconP2;

    icon1.x = healthBarX + (healthBarW * hpPercent) + 2;
    icon2.x = healthBarX + (healthBarW * hpPercent) - icon2.width - 2;

    for (icon in [icon1, icon2]) {
        icon.y = ((dustinHealthBar.y + dustinHealthBar.height/2) - icon.height/2) - (camHUD.downscroll ? 0 : 20);
    }

    icon1.animation.curAnim.curFrame = reverseIcons ? (healthPrecent > 65 ? 1 : 0) : (healthPrecent < 35 ? 1 : 0);
    icon2.animation.curAnim.curFrame = reverseIcons ? (healthPrecent < 35 ? 1 : 0) : (healthPrecent > 65 ? 1 : 0);

    if (icon1.shader != null) icon1.shader.ratio = __ratio;
    if (icon2.shader != null) icon2.shader.ratio = __ratio;

    __lerpColor.color = hurtColor; // same as icon.shader.color
    __lerpColor.lerpTo(ogHealthColors[1], Math.abs(1-__ratio));
    healthBarColors[1] = __lerpColor.color;

    __lastHealth = FlxMath.bound(health, 0, maxHealth);
}

var __healthTween:FlxTween;
var __ratio:Float = 0;
function postUpdate(elapsed:Float) {
    if(noMissIconAnim) return;

    if (__lastHealth > health) {
        healthLossTimer = healthLossCooldown;

        if (__healthTween != null) __healthTween.cancel();
        __healthTween = FlxTween.num(.75, 0, healthLossCooldown*4, {}, (val:Float) -> {__ratio = val;});
    }

    healthLossTimer -= elapsed;
    if (healthLossTimer > 0) {
        iconShake(dustiniconP1, healthLossTimer/healthLossCooldown);
        dustiniconP1.animation.curAnim.curFrame = 1;
    }
}

static function iconShake(icon:FlxSprite, amnt:Float) {
    var __healthShake:Float = FlxEase.circOut(Math.min(amnt, 1));
    icon.x += FlxG.random.float(-__healthShake * 4, __healthShake * 4);
    icon.y += FlxG.random.float(-__healthShake * 4, __healthShake * 4);
}