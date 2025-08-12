import openfl.geom.Rectangle;
importClass("data.scripts.classes.DialogueBoxBG", __script__);
importClass("data.scripts.classes.FunkinTypeText", __script__);
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.text.FlxTextAlign;
import haxe.Json;
import flixel.FlxCamera;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxTweenType;
import flixel.tweens.FlxEase;

var optionBoxes:Array<DialogueBoxBG> = [];
var optionTexts:Array<FunkinTypeText> = [];
var curCat:Int = 0;
var prevCat:Int = -1;
var curChar:Int = 0;

var descText:FlxText;
var descLabel:FlxText;
var authorsLabel:FlxText;
var authorsText:FlxText;
var nameText:FlxText;
var charImage:FlxSprite;
var scrollCam:FlxCamera;
var aus:Array<Category>;
var leftArrow:FlxSprite;
var rightArrow:FlxSprite;
var upArrow:FlxSprite;
var downArrow:FlxSprite;
var exitText:FunkinText;

var changeCooldown:Float = 0;
var changeCooldownTime:Float = 0.3;

function create() {
    var raw = Assets.getText(Paths.json("config/charstuff"));
    aus = Json.parse(raw);

    scrollCam = new FlxCamera(0,0,FlxG.width,FlxG.height);
    scrollCam.bgColor = 0x00000000;
    FlxG.cameras.add(scrollCam, false);

    var baseX = 25, baseY = 25, spacingY = 75;
    for (i in 0...aus.length) {
        var yPos = baseY + i * spacingY;
        var box = createAuBox(baseX, yPos);
        optionBoxes.push(box);
        var txt = createAuText(baseX, yPos + 10, aus[i].name, 25);
        txt.ID = i;
        txt.updateHitbox();
        optionTexts.push(txt);
        box.cameras = [scrollCam];
        txt.cameras = [scrollCam];
    }
    scrollCam.setScrollBoundsRect(0,0,FlxG.width, baseY + aus.length * spacingY);

    add(createDescBox());
    add(createNameBox());

    var descLabel = new FlxText(230, 60, 500, "DESCRIPTION", 50, true);
    descLabel.setFormat(Paths.font("8bit-jve.ttf"), 50, FlxColor.WHITE, FlxTextAlign.LEFT);
    add(descLabel);

    var authorsLabel = new FlxText(230, 480, 500, "AUTHORS", 50, true);
    authorsLabel.setFormat(Paths.font("8bit-jve.ttf"), 50, FlxColor.WHITE, FlxTextAlign.LEFT);
    add(authorsLabel);

    descText = new FlxText(230, 130, 500, "", 25, true);
    descText.setFormat(Paths.font("8bit-jve.ttf"),25,FlxColor.WHITE,FlxTextAlign.LEFT);
    descText.wordWrap = true;
    add(descText);

    authorsText = new FlxText(230, 540, 500, "", 30, true);
    authorsText.setFormat(Paths.font("8bit-jve.ttf"), 30, FlxColor.WHITE, FlxTextAlign.LEFT);
    authorsText.wordWrap = true;
    add(authorsText);

    nameText = new FlxText(855, 70, 375, "", 50, true);
    nameText.setFormat(Paths.font("8bit-jve.ttf"),50,FlxColor.WHITE,FlxTextAlign.CENTER);
    nameText.wordWrap = true;
    add(nameText);

    leftArrow = new FlxText(860, 70, 50, "<", 50, true);
    leftArrow.setFormat(Paths.font("8bit-jve.ttf"), 50, FlxColor.WHITE, FlxTextAlign.CENTER);
    add(leftArrow);

    rightArrow = new FlxText(1180, 70, 50, ">", 50, true);
    rightArrow.setFormat(Paths.font("8bit-jve.ttf"), 50, FlxColor.WHITE, FlxTextAlign.CENTER);
    add(rightArrow);

    upArrow = new FlxText(1180, 160, 50, "^", 70, true);
    upArrow.setFormat(Paths.font("8bit-jve.ttf"), 70, FlxColor.WHITE, FlxTextAlign.CENTER);
    add(upArrow);

    downArrow = new FlxText(1180, 260, 50, "^", 70, true);
    downArrow.setFormat(Paths.font("8bit-jve.ttf"), 70, FlxColor.WHITE, FlxTextAlign.CENTER);
    downArrow.angle = 180;
    add(downArrow);

    exitText = new FunkinText(0, 660, FlxG.width, "< EXIT", 46);
    exitText.alignment = FlxTextAlign.RIGHT;
    exitText.x = 1100;
    exitText.fieldWidth = 150;
    exitText.fieldHeight = 50;
    exitText.setFormat(Paths.font("8bit-jve.ttf"), 46, FlxColor.WHITE, FlxTextAlign.RIGHT);
    add(exitText);

    charImage = null;

    changeSelection(0, true);
    animateCharacter(0, 0);
}

function createDescBox() return newDialogueBox(200,45,600,650);
function createNameBox() return newDialogueBox(845,45,395,110);
function newDialogueBox(x,y,w,h) {
    var b = new DialogueBoxBG(x,y,null,w,h,5);
    b.pixels.fillRect(new Rectangle(5,5,w-10,h-10),0xFF000000);
    b.visible = true;
    return b;
}
function createAuBox(x,y) {
    var b = new DialogueBoxBG(x,y,null,140,50,5);
    b.pixels.fillRect(new Rectangle(5,5,130,40),0xFF000000);
    b.visible = true; add(b);
    return b;
}
function createAuText(x,y,str,size) {
    var t = new FlxText(x,y,140,str,size,true);
    t.setFormat(Paths.font("8bit-jve.ttf"),size,FlxColor.WHITE,FlxTextAlign.CENTER);
    add(t);
    return t;
}

function changeSelection(amt:Int=0, force:Bool=false) {
    if (changeCooldown > 0) return;
    prevCat = curCat;
    curCat = force ? amt : FlxMath.wrap(curCat + amt, 0, aus.length - 1);
    curChar = 0;

    for (i in 0...optionBoxes.length) {
        var sel = i == curCat;
        optionBoxes[i].color = sel ? 0xFFFFFF00 : 0xFFFFFFFF;
        optionTexts[i].color = sel ? 0xFFFFFF00 : 0xFFFFFFFF;
    }

    if (prevCat != curCat) {
        FlxG.sound.play(Paths.sound("menu/scroll"), 0.5);
        animateCharacter(1, amt);
        changeCooldown = changeCooldownTime;
    }
}

function changeCharacter(amt:Int = 0) {
    if (changeCooldown > 0) return;
    animateCharacter(amt, 0);
    changeCooldown = changeCooldownTime;
}

function animateCharacter(charAmt:Int, catAmt:Int) {
    if (catAmt != 0) {
        curChar = 0;
    } else {
        curChar = FlxMath.wrap(curChar + charAmt, 0, aus[curCat].characters.length - 1);
    }

    var ch = aus[curCat].characters[curChar];
    var dir = (charAmt != 0 ? (charAmt > 0 ? 1 : -1) : (catAmt != 0 ? 1 : 0));
    var distance = dir * 400;
    var baseX = 980 + ch.offset.x;
    var baseY = 400 + ch.offset.y;

    if (charImage != null) {
        var old = charImage;
        FlxTween.tween(old, { x: old.x - distance, alpha: 0 }, 0.3, {
            type: FlxTween.ONESHOT, ease: FlxEase.quadIn,
            onComplete: function(t) {
                remove(old, true);
                old.destroy();
            }
        });
    }

    var newSprite = new FlxSprite(baseX + distance, baseY);
    newSprite.loadGraphic(Paths.image(ch.image));
    newSprite.scale.set(3,3);
    newSprite.alpha = 0;
    add(newSprite);

    // SPRITES BELOW UI PLAESE!!!!!!!
    var m = FlxG.state.members;
    m.remove(newSprite);
    m.insert(0, newSprite);

    FlxTween.tween(newSprite, { x: baseX, alpha: 1 }, 0.4, {
        type: FlxTween.ONESHOT, ease: FlxEase.quadOut
    });

    charImage = newSprite;
    descText.text = ch.desc;
    nameText.text = ch.name;
    authorsText.text = ch.authors;
}

function update(elapsed:Float):Void {
    if (changeCooldown > 0) changeCooldown -= elapsed;

    if (FlxG.mouse.justPressed) {
        var mouseX = FlxG.mouse.screenX;
        var mouseY = FlxG.mouse.screenY;

        if (leftArrow != null && mouseX >= leftArrow.x && mouseX <= leftArrow.x + leftArrow.width &&
            mouseY >= leftArrow.y && mouseY <= leftArrow.y + leftArrow.height) {
            changeCharacter(-1);
            animateArrow(leftArrow);
        }

        if (rightArrow != null && mouseX >= rightArrow.x && mouseX <= rightArrow.x + rightArrow.width &&
            mouseY >= rightArrow.y && mouseY <= rightArrow.y + rightArrow.height) {
            changeCharacter(1);
            animateArrow(rightArrow);
        }

        if (upArrow != null && mouseX >= upArrow.x && mouseX <= upArrow.x + upArrow.width &&
            mouseY >= upArrow.y && mouseY <= upArrow.y + upArrow.height) {
            changeSelection(-1);
            animateArrow(upArrow);
        }

        if (downArrow != null && mouseX >= downArrow.x && mouseX <= downArrow.x + downArrow.width &&
            mouseY >= downArrow.y && mouseY <= downArrow.y + downArrow.height) {
            changeSelection(1);
            animateArrow(downArrow);
        }

        if (exitText != null && mouseX >= exitText.x && mouseX <= exitText.x + exitText.width &&
            mouseY >= exitText.y && mouseY <= exitText.y + exitText.height) {
            FlxG.switchState(new ModState("gallery/GalleryState"));
        }
    }

    if (FlxG.keys.justPressed.ESCAPE)
        FlxG.switchState(new ModState("gallery/GalleryState"));
}

function postUpdate(elapsed:Float):Void {
    var cb = optionBoxes[curCat];
    var targetY = cb.y + cb.height/2 - FlxG.height/2;
    scrollCam.scroll.y = lerp(scrollCam.scroll.y, targetY, 0.1);
}

function animateArrow(sprite:FlxText):Void {
    FlxTween.cancelTweensOf(sprite);
    FlxG.sound.play(Paths.sound("menu/scroll"), 1);

    FlxTween.tween(sprite.scale, { x:1.2, y:1.2 }, 0.1, {
        type: FlxTweenType.PINGPONG,
        ease: FlxEase.quadOut,
        onComplete: function(tween:FlxTween):Void {
            if (tween.executions >= 2) tween.cancel();
        }
    });

    FlxTween.color(sprite, 0.1, FlxColor.WHITE, FlxColor.YELLOW, {
        type: FlxTweenType.PINGPONG,
        ease: FlxEase.quadOut,
        onComplete: function(tween:FlxTween):Void {
            if (tween.executions >= 2) tween.cancel();
        }
    });
}
