importClass("data.scripts.classes.DialogueBoxBG", __script__);
importClass("data.scripts.classes.FunkinTypeText", __script__);
import flixel.text.FlxText;
import flixel.text.FlxTextAlign;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxTweenType;
import openfl.geom.Rectangle;

static var creditsMusicStarted:Bool = false;
var infoVisible:Bool = false;
var imageDisplay:FlxSprite;
var transition:Bool = false;
var isAnimating:Bool = false;
var currentIndex:Int = 0;
var devs:Array<Dynamic>;
var images:Array<String>;
var sprites:Array<FlxSprite> = [];
var lineBox:DialogueBoxBG;
var spBox:DialogueBoxBG;
var door:FlxSprite;

var frame:FlxSprite;
final FRAME_W:Int = 350;
final FRAME_H:Int = 350;
final PADDING:Int = 16;

var roleText:FlxText;
var roleInfo:FlxText;
var spHeader:FlxText;
var spThanks:FlxText;
var nameText:FlxText;
var divLine:FlxSprite;
var leftArrow:FlxText;
var rightArrow:FlxText;

var lineText:FunkinTypeText;
var prevText:String;

var uiItems:Array<{obj:FlxBasic, finalX:Float}> = [];
var offscreenStartX:Float;
var offscreenStartY:Float;

var isTransitioning:Bool = false;
var transitionDuration:Float = 0.3;

var currentPanel:PanelType = null;

var spList = CoolUtil.coolTextFile(Paths.txt("config/specialthanks"));

var canClickSHText:Bool = true;

function create() {
    if (!creditsMusicStarted) {
        FlxG.sound.playMusic(Paths.music("credits_menu"), 0.3, true);
        creditsMusicStarted = true;
    }
    var raw = Assets.getText(Paths.json("config/creditLines"));
    var data = Json.parse(raw);
    var imageNames = [];
    devs = [];

    for (entry in data) {
        imageNames.push("menus/credits/sprites/" + entry.name);
        devs.push(entry);
    }

    images = imageNames;

    for (path in images) {
        var sp = new FlxSprite().loadGraphic(Paths.image(path), false);
        sp.visible = false;
        sprites.push(sp);
        add(sp);
    }

    background = new FunkinSprite(0, 0, Paths.image('menus/credits/echo_flower'));
    background.addAnim('idle', 'idle0', 24, true);
    background.playAnim('idle');
    background.antialiasing = false;
    background.scale.set(0.67, 0.67);
    background.updateHitbox();
    background.screenCenter();
    add(background);

    shText = new FlxText(0, 500, 500, "PRESS ENTER TO HEAR THE ECHOES", 40, true);
    shText.setFormat(Paths.font("8bit-jve.ttf"), 40, 0x00F7FF, FlxTextAlign.CENTER);
    if(controls.touchC)
    shText.text = "PRESS A TO HEAR THE ECHOES"
    else
    shText.text = "PRESS ENTER TO HEAR THE ECHOES";
    shText.x = FlxG.width / 2 - shText.width / 2;
    shText.y = FlxG.height - 30 - shText.height;
    add(shText);

    door = new FunkinSprite().loadGraphic(Paths.image('menus/credits/door'));
    door.x = FlxG.width - 75;
    door.y = 20;
    door.scale.set(1.5,1.5);
    add(door);

    overlay = new FlxSprite(0, 0);
    overlay.makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
    overlay.set_alpha(0);
    add(overlay);

    FlxTween.tween(
        shText,
        { alpha: 0.1 },
        1.5,
        {
            type: FlxTweenType.PINGPONG,
            ease: FlxEase.sineInOut
        }
    );

    frame = new FlxSprite();
    frame.makeGraphic(FRAME_W, FRAME_H, FlxColor.BLUE);
    frame.x = 150;
    frame.y = FlxG.height/2 - FRAME_H/2;
    frame.visible = false;
    frame.updateHitbox();
    add(frame);

    imageDisplay = new FlxSprite();
    imageDisplay.visible = false;
    imageDisplay.alpha = 0;
    add(imageDisplay);
    updateImage();

    lineBox = new DialogueBoxBG(0,0,null,550,500,5);
    lineBox.x = FlxG.width - 700;
    lineBox.y = (FlxG.height - lineBox.height) / 2;
    lineBox.pixels.fillRect(new Rectangle(5,5,130,40),0xFF000000);
    lineBox.visible = false;
    add(lineBox);

    spBox = new DialogueBoxBG(0,0,null,600,680,5);
    spBox.x = (FlxG.width - spBox.width) / 2;
    spBox.y = (FlxG.height - spBox.height) / 2;
    spBox.pixels.fillRect(new Rectangle(5,5,130,40),0xFF000000);
    spBox.visible = false;
    add(spBox);

    offscreenStartX = lineBox.x + lineBox.width + 50;
    offscreenStartY = spBox.y + spBox.height + 100;

    roleText = newText(lineBox.x + 50, lineBox.y + 40, 400,  "ROLES", 50, true, FlxTextAlign.LEFT);
    roleInfo = newText(lineBox.x + 50, lineBox.y + 110, 400, devs[0].roles, 33, true, FlxTextAlign.LEFT);
    nameText = newText(0, 0, 300, devs[0].name, 40, true, FlxTextAlign.CENTER);
    spHeader = newText(0, 0, 400, "SPECIAL THANKS", 60, true, FlxTextAlign.CENTER);
    var spNames = spList.join("\n");
    spThanks = newText(0, 0, 500, spNames, 25, true, FlxTextAlign.CENTER);
    nameText.alpha = 0;
    add(roleText);
    add(roleInfo);
    add(nameText);
    add(spHeader);
    add(spThanks);
    roleText.visible = false;
    roleInfo.visible = false;
    nameText.x = frame.x + (frame.width - nameText.width) / 2;
    nameText.y = frame.y + frame.height + 10;
    spHeader.x = spBox.x + (spBox.width - spHeader.width) / 2;
    spHeader.y = spBox.y + 30;
    spThanks.x = spBox.x + (spBox.width - spThanks.width) / 2;
    spThanks.y = spHeader.y + spHeader.height + 50;
    nameText.visible = false;
    spHeader.visible = false;
    spThanks.visible = false;

    leftArrow = new FlxText(0, 0, 50, "<", 40, true);
    leftArrow.setFormat(Paths.font("8bit-jve.ttf"), 40, FlxColor.WHITE, FlxTextAlign.CENTER);
    leftArrow.x = nameText.x - 20;
    leftArrow.y = nameText.y;
    leftArrow.visible = false;
    add(leftArrow);

    rightArrow = new FlxText(0, 0, 50, ">", 40, true);
    rightArrow.setFormat(Paths.font("8bit-jve.ttf"), 40, FlxColor.WHITE, FlxTextAlign.CENTER);
    rightArrow.x = nameText.x + (nameText.width - rightArrow.width) + 20;
    rightArrow.y = nameText.y;
    rightArrow.visible = false;
    add(rightArrow);

    divLine = new FlxSprite();
    divLine.makeGraphic(lineBox.width - 100, 4, FlxColor.WHITE);
    divLine.x = lineBox.x + (lineBox.width - divLine.width) / 2;
    divLine.y = lineBox.y + ((lineBox.height / 2) - divLine.height / 2) + 30;
    add(divLine);
    divLine.visible = false;

    lineText = new FunkinTypeText(lineBox.x + 50, divLine.y + 20, 480, devs[0].line, 25);
    lineText.setFormat(Paths.font("8bit-jve.ttf"), 25, FlxColor.WHITE, FlxTextAlign.LEFT);
    lineText.defaultSound = FlxG.sound.load(Paths.sound("default_text"));
    lineText.visible = false;
    add(lineText);

    addTouchPad('LEFT_RIGHT', 'A_B_C');
    addTouchPadCamera();

    uiItems = [
        { obj: lineBox, finalX: lineBox.x },
        { obj: roleText, finalX: roleText.x },
        { obj: roleInfo, finalX: roleInfo.x },
        { obj: divLine, finalX: divLine.x },
        { obj: lineText, finalX: lineText.x },
    ];

    spItems = [
        { obj: spBox, finalY: spBox.y },
        { obj: spHeader, finalY: spHeader.y },
        { obj: spThanks, finalY: spThanks.y },
    ];

    for (item in uiItems) {
        item.obj.x = offscreenStartX;
        item.obj.alpha = 0;
    }

    for (item in spItems) {
        item.obj.y = offscreenStartY;
        item.obj.alpha = 0;
    }
}

function update(elapsed:Float) {
    if ((FlxG.keys.justPressed.SPACE || touchPad.buttonC.justPressed) && lineText.isTyping) {
        lineText.skip();
    }

    if (controls.ACCEPT && !isAnimating) {
        if (!infoVisible && !spBox.visible) {
            showContent("credits");
            updateLine();
        } else if (!spBox.visible) {
            hideContent("credits");
        }
    }

    if (FlxG.mouse.justPressed && FlxG.mouse.overlaps(shText) && !isAnimating && canClickSHText) {
        showContent("credits");
        updateLine();
    }

    if (FlxG.mouse.justPressed && FlxG.mouse.overlaps(door) && !isAnimating && !infoVisible) {
        showContent("thanks");
        isTransitioning = true;
    }

    if (controls.BACK && !isAnimating) {
        if (infoVisible) {
            if (spBox.visible) {
                hideContent("thanks");
                isTransitioning = false;
            } else {
                hideContent("credits");
            }
        } else {
            creditsMusicStarted = false;
            FlxG.sound.music.stop();
            FlxG.switchState(new MainMenuState());
        }
    }

    if (infoVisible && (controls.LEFT || controls.RIGHT)) {
        var dir = controls.LEFT ? -1 : 1;
        if (!isTransitioning) {
            devTransition(dir);
            animateArrow(dir > 0 ? rightArrow : leftArrow);
        }
    }
}

function showContent(mode:String):Void {
    if (isAnimating) return;
    isAnimating = true;
    infoVisible = true;
    overlay.set_alpha(0);
    FlxTween.tween(overlay, { alpha:0.9 }, 0.4, { ease:FlxEase.quadInOut });

    shText.visible = false;
    door.visible = false;

    if (mode == "credits") {
        canClickSHText = false;

        nameText.visible = true;
        lineBox.visible = true;
        leftArrow.visible = true;
        rightArrow.visible = true;
        for (item in uiItems) item.obj.visible = true;
        infoVisible = true;
        updateImage();

        var delayBetween = 0.07;
        for (i in 0...uiItems.length) {
            var item = uiItems[i];
            item.obj.x = offscreenStartX;
            item.obj.alpha = 0;
            FlxTween.tween(item.obj, { x: item.finalX, alpha: 1 }, 0.4, {
            ease: FlxEase.backOut,
            startDelay: i * delayBetween,
            type: FlxTween.ONESHOT
            });
        }

        imageDisplay.alpha = 0;
        nameText.alpha = 0;
        leftArrow.alpha = 0;
        rightArrow.alpha = 0;

        FlxTween.tween(imageDisplay, { alpha: 1 }, 0.4, { ease: FlxEase.quadOut, type: FlxTween.ONESHOT });
        FlxTween.tween(nameText, { alpha: 1 }, 0.4, { ease: FlxEase.quadOut, type: FlxTween.ONESHOT });
        FlxTween.tween(leftArrow, { alpha: 1 }, 0.4, { ease: FlxEase.quadOut, type: FlxTween.ONESHOT });
        FlxTween.tween(rightArrow, { alpha: 1 }, 0.4, { ease: FlxEase.quadOut, type: FlxTween.ONESHOT });

    } else if (mode == "thanks") {
        infoVisible = true;
        shText.visible = false;
        door.visible = false;
        overlay.set_alpha(0);
        FlxTween.tween(overlay, { alpha: 0.9 }, 0.4, { ease: FlxEase.quadInOut });
        spBox.visible = true;
        spHeader.visible = true;
        spThanks.visible = true;

        var delayBetween = 0.07;
        for (i in 0...spItems.length) {
            var item = spItems[i];
            item.obj.y = offscreenStartY;
            item.obj.alpha = 0;
            FlxTween.tween(item.obj, { y: item.finalY, alpha: 1 }, 0.4, {
            ease: FlxEase.circOut,
            startDelay: i * delayBetween,
            type: FlxTween.ONESHOT
            });
        }
    }
    new FlxTimer().start(transitionDuration + 0.1, function(_) {isAnimating = false;});
}

function hideContent(mode:String):Void {
    if (isAnimating) return;
    isAnimating = true;
    FlxTween.tween(overlay, { alpha:0 }, 0.4, { ease:FlxEase.quadInOut });

    shText.visible = true;
    door.visible = true;
    
    if (mode == "credits") {
        canClickSHText = true;

        FlxTween.tween(overlay, { alpha: 0 }, 0.4, { ease: FlxEase.quadInOut });

        for (item in uiItems) {
            FlxTween.tween(item.obj, { x: offscreenStartX, alpha: 0 }, 0.3, { ease: FlxEase.circIn });
        }

        var t = new FlxTimer();
        t.start(0.4, function(_) {
            shText.visible = true;
            door.visible = true;
            imageDisplay.visible = false;
            for (item in uiItems) item.obj.visible = false;
        });

        lineText.resetText("");

        FlxTween.tween(imageDisplay, { alpha: 0 }, 0.3, { ease: FlxEase.circIn, type: FlxTween.ONESHOT });
        FlxTween.tween(nameText, { alpha: 0 }, 0.3, { ease: FlxEase.circIn, type: FlxTween.ONESHOT });
        FlxTween.tween(leftArrow, { alpha: 0 }, 0.3, { ease: FlxEase.circIn, type: FlxTween.ONESHOT });
        FlxTween.tween(rightArrow, { alpha: 0 }, 0.3, { ease: FlxEase.circIn, type: FlxTween.ONESHOT });
        infoVisible = false;

    } else if (mode == "thanks") {
        infoVisible = false;
        overlay.set_alpha(1);
        FlxTween.tween(overlay, { alpha: 0 }, 0.4, { ease: FlxEase.quadInOut });
        spBox.visible = false;
        spHeader.visible = false;
        spThanks.visible = false;

        for (item in spItems) {
            FlxTween.tween(item.obj, { y: offscreenStartY, alpha: 0 }, 0.4, { ease: FlxEase.circIn });
        }
    }
    new FlxTimer().start(transitionDuration + 0.1, function(_) {isAnimating = false;});
}

function updateLine():Void {
    lineText.resetText(devs[currentIndex].line);
    lineText.start();
    lineText.visible = true;
}

function updateImage():Void {
    var path = Paths.image(images[currentIndex]);
    imageDisplay.loadGraphic(path, false);
    imageDisplay.antialiasing = false;
    imageDisplay.scale.set(0.75, 0.75);
    imageDisplay.updateHitbox();

    var maxW = FRAME_W - PADDING*2;
    var maxH = FRAME_H - PADDING*2;
    var ratio = Math.min(
        maxW / Std.int(imageDisplay.frameWidth),
        maxH / Std.int(imageDisplay.frameHeight),
        1
    );
    imageDisplay.scale.set(ratio, ratio);
    imageDisplay.updateHitbox();

    imageDisplay.x = frame.x + (FRAME_W - imageDisplay.width) / 2;
    imageDisplay.y = frame.y + (FRAME_H - imageDisplay.height) / 2;

    imageDisplay.visible = infoVisible;
}

function newText(x:Float, y:Float, fieldWidth:Int, txt:String, size:Int, embedded:Bool, align:FlxTextAlign):FlxText {
    var f = new FlxText(x, y, fieldWidth, txt, size, embedded);
    f.setFormat(Paths.font("8bit-jve.ttf"), size, FlxColor.WHITE, align);
    return f;
}

function updateLine():Void {
    var txt = devs[currentIndex].line;
    if (txt == "") {
        txt = "* I'm kinda lazy and I didn't write a line";
    }

    lineText.resetText(txt);
    lineText.start();

    lineText.visible = infoVisible;
}

function devTransition(dir:Int):Void {
    isTransitioning = true;
    var buffer = FRAME_W + 50;
    var exitX = frame.x + FRAME_W/2 - dir * buffer;

    FlxTween.tween(imageDisplay, { x: exitX, alpha: 0 }, transitionDuration, {
        ease: FlxEase.circIn,
        type: FlxTweenType.ONESHOT,
        onComplete: function(_:FlxTween) {
        currentIndex = (currentIndex + devs.length + dir) % devs.length;
        nameText.text = devs[currentIndex].name;
        roleInfo.text = devs[currentIndex].roles;
        updateLine();
        updateImage();

        var entryX = frame.x + (FRAME_W - imageDisplay.width)/2 + dir * buffer;
        imageDisplay.x = entryX;
        imageDisplay.alpha = 0;

        FlxTween.tween(
            imageDisplay, {
            x: frame.x + (FRAME_W - imageDisplay.width)/2, alpha: 1
            },
            transitionDuration, {
            ease: FlxEase.backOut,
            type: FlxTweenType.ONESHOT
            }
        );

        FlxTween.tween(nameText, { alpha: 1 }, transitionDuration, {
            ease: FlxEase.backOut,
            type: FlxTweenType.ONESHOT,
            onComplete: function(_:FlxTween) {
            isTransitioning = false;
            }
        });
        }
    });
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
