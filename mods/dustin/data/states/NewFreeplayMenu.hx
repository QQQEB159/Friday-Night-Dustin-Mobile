//

import funkin.menus.FreeplayState.FreeplaySonglist;
import flixel.math.FlxRect;
import flixel.text.FlxText.FlxTextFormat;
import flixel.text.FlxText.FlxTextFormatMarkerPair;
import flixel.addons.util.FlxSimplex;
import funkin.savedata.FunkinSave;

var boxes:Array<Dynamic> = [];
var portraits:Array<FunkinSprite> = [];
var outlineSize:Float = 10;

var bloom = new CustomShader("bloom");
bloom.size = 40;
bloom.brightness = 5;
bloom.directions = 8;
bloom.quality = 10;

var glitch = new CustomShader("glitching");
glitch.SPEED = 1;
glitch.AMT = 0.7;

var curSelected:Int = 0;
var allowInput:Bool = true;
var portrait;
public var tvScreen:FlxCamera;
var cds:Array<FunkinSprite> = [];

var cdSpinSpeed:Float = 0;
var spinningCD:FunkinSprite = null;
var bg;
var bgtv;
var fg;

var ink:FunkinSprite = null;
var genocidesText:FunkinText = null;

var seedeeznuts:FunkinSprite = new FunkinSprite(0, 0, Paths.image("menus/shop/cds"));

function create() {
    FlxG.camera.bgColor = 0xFF050505;
    CoolUtil.playMenuSong();
    if (FlxG.save.data.dustinBoughtStuff.contains("overthrone")) FlxG.save.data.dustinBoughtStuff.push("red-demon-o");
    if (FlxG.save.data.dustinBoughtStuff.contains("perseverance")) FlxG.save.data.dustinBoughtStuff.push("perseverance v2");
    if (FlxG.save.data.dustinBoughtStuff.contains("cornered")) FlxG.save.data.dustinBoughtStuff.push("cornered v2");
    if (FlxG.save.data.dustinBoughtStuff.contains("you-are")) FlxG.save.data.dustinBoughtStuff.push("you-are v2");
    if (FlxG.save.data.dustinBoughtStuff.contains("thermal-shock")) FlxG.save.data.dustinBoughtStuff.push("thermal-shock-gf-mix");
    if (FlxG.save.data.dustinBoughtStuff.contains("inopia")) FlxG.save.data.dustinBoughtStuff.push("inopia-spooky-mix");
    FlxG.save.flush();

    // RIGHT PORTRAITS
    for (i => song in FreeplaySonglist.get().songs) {
        var name = song.displayName.toLowerCase();
        name = StringTools.replace(name, ' ', '-');

        portrait = new FunkinSprite(0, 0, Paths.image('menus/freeplay/portraits/' + name));
        portrait.addAnim('idle', 'idle0', 24, true);
        portrait.addAnim('start', 'start0', 24, false);
        portrait.playAnim('idle');
        portrait.scale.set(0.61, 0.61);
        portrait.updateHitbox();
        portrait.screenCenter();
        portrait.x = FlxG.width * 0.75 - portrait.width / 2;
        portrait.scrollFactor.set();
        portrait.ID = i;
        portrait.antialiasing = Options.antialiasing;
        portraits.push(portrait);
        portrait.y = portrait.y + 3;
        add(portrait);

        #if desktop
        if (name == "genocides" && genocidesText == null) {
            genocidesText = new FunkinText(portrait.x - 100, portrait.y - 130, portrait.width + 200, "If the song is bugged for you, uncheck Options > Miscellaneous > Genocides Swag.");
            genocidesText.setFormat(Paths.font("fallen-down.ttf"), 14, 0xFFFFFFFF);
            genocidesText.scrollFactor.set();
            genocidesText.textField.antiAliasType = 0/*ADVANCED*/;
            genocidesText.textField.sharpness = 400/*MAX ON OPENFL*/;
        }
        #end

        if (name == "uncreate" && ink == null) {
            ink = new FunkinSprite(0, 0, Paths.image('menus/freeplay/Inks_artWork'));
            ink.addAnim('paint', 'Inks_handWork0', 24, true);
            ink.visible = false;
            ink.scrollFactor.set();
            ink.scale.set(0.61, 0.61);
            ink.updateHitbox();
            ink.screenCenter();
            ink.x += 767;
            ink.y -= 225;
        }
    }

    bg = new FunkinSprite().loadGraphic(Paths.image('menus/freeplay/bg_freeplay'));
    bg.antialiasing = false;
    bg.scale.set(0.67, 0.67);
    bg.updateHitbox();
    bg.screenCenter();
    bg.scrollFactor.set();
    add(bg);

    bgtv = new FunkinSprite().loadGraphic(Paths.image('menus/freeplay/bg_freeplay_tv'));
    bgtv.antialiasing = false;
    bgtv.scale.set(0.67, 0.67);
    bgtv.updateHitbox();
    bgtv.screenCenter();
    bgtv.scrollFactor.set();
    add(bgtv);

    if (ink != null) add(ink);
    if (genocidesText != null) add(genocidesText);

    fg = new FunkinSprite().loadGraphic(Paths.image('menus/freeplay/fg_freeplay'));
    fg.antialiasing = false;
    fg.scale.set(0.67, 0.67);
    fg.updateHitbox();
    fg.screenCenter();
    fg.scrollFactor.set();
    add(fg);

    tvScreen = new FlxCamera(0, 0, 1280, 720);
    tvScreen.bgColor = 0xFF000000;
    for (portrait in portraits) {
        portrait.camera = tvScreen;
    }

    oldstatic = new CustomShader("static");
    oldstatic.time = 0; oldstatic.strength = 5;
    if (Options.gameplayShaders && FlxG.save.data.static) tvScreen.addShader(oldstatic);
    FlxG.cameras.remove(FlxG.camera, false);
    FlxG.cameras.add(tvScreen, false);
    FlxG.cameras.add(FlxG.camera, true);

    tape_noise = new CustomShader("tapenoise");
    tape_noise.res = [FlxG.width, FlxG.height];
    tape_noise.time = 0; tape_noise.strength = 1;
    if (Options.gameplayShaders && FlxG.save.data.static) tvScreen.addShader(tape_noise);


    FlxG.camera.bgColor = 0x00000000;

    seedeeznuts.scale.set(0.5, 0.5);
    seedeeznuts.updateHitbox();
    seedeeznuts.screenCenter();
    seedeeznuts.x = FlxG.width * 0.9 - seedeeznuts.width / 2;
    seedeeznuts.scrollFactor.set();
    seedeeznuts.y = seedeeznuts.y + 270;
    add(seedeeznuts).antialiasing = Options.antialiasing;

    seedeeznuts.origin.x += 25; seedeeznuts.origin.y += 5;

    // LEFT BOXES
    for (i => song in FreeplaySonglist.get().songs) {
        seedeeznuts.addAnim(song.name.toLowerCase(), song.name.toLowerCase(), 1, false);

        var boxOutline = new FunkinSprite().makeSolid(600, 95, 0xFFFFFFFF);
        boxOutline.setPosition(10, 10 + 220 * i);
        add(boxOutline);

        var boxBG = new FunkinSprite().makeSolid(boxOutline.width - outlineSize / 2, boxOutline.height - outlineSize / 2, 0xFF000000);
        boxBG.setPosition(boxOutline.x + boxOutline.width / 2 - boxBG.width / 2, boxOutline.y + boxOutline.height / 2 - boxBG.height / 2);
        add(boxBG);

        var nameTxt = new FunkinText(0, 0, boxBG.width, FlxG.save.data.dustinBoughtStuff.contains(song.name.toLowerCase()) ? song.displayName : hideStr(song.displayName), 36, false);
        nameTxt.setFormat(Paths.font("fallen-down.ttf"), 36, 0xFFFFFFFF);
        nameTxt.setPosition(boxBG.x + boxBG.width / 2 - nameTxt.width / 2, boxBG.y);
        nameTxt.alignment = "center";
        add(nameTxt);

        var divider = new FunkinSprite().makeSolid(boxBG.width - 40, 2, 0xFFFFFFFF);
        divider.setPosition(boxBG.x + 20, boxBG.y + nameTxt.height + 10);
        add(divider);

        // === CREDITS DISPLAY (split by category) ===
        var creditData = song.customValues != null && FlxG.save.data.dustinBoughtStuff.contains(song.name.toLowerCase()) ? song.customValues.credits : null;

        var creditLabels = ["SONG", "SPRITES", "BACKGROUND", "CHART"];
        var creditColors = [0xFF1db2f0, 0xFFf50334, 0xFFbe2879, 0xFFa31be0];

        var labelTexts:Array<FunkinText> = [];
        var valueTexts:Array<FunkinText> = [];

        var currentY = divider.y + divider.height + 10;

        if (creditData != null) {
            for (j in 0...creditLabels.length) {
                var label = creditLabels[j];
                var color = creditColors[j];

                if (Reflect.hasField(creditData, label)) {
                    var textLabel = label.toLowerCase().charAt(0).toUpperCase() + label.substr(1);
                    var creditValue = Reflect.field(creditData, label);

                    var labelMargin:Float = 30;
                    var valueMargin:Float = 40;  

                    // LABEL ITSELF
                    var labelTxt = new FunkinText(0, 0, boxBG.width, textLabel + ":", 35, false);
                    labelTxt.setFormat(Paths.font("8bit-jve.ttf"), 35, color);
                    labelTxt.setPosition(boxBG.x + labelMargin, currentY);
                    add(labelTxt);

                    // THE CREDITS THING
                    var valueTxtWidth = boxBG.width - valueMargin - 10;

                    var valueTxt = new FunkinText(0, 0, valueTxtWidth, creditValue, 29, true);
                    valueTxt.setFormat(Paths.font("8bit-jve.ttf"), 29, 0xFFFFFFFF);
                    valueTxt.wordWrap = true;
                    valueTxt.alignment = "left";
                    valueTxt.setPosition(boxBG.x + valueMargin, currentY);
                    add(valueTxt);

                    labelTexts.push(labelTxt);
                    valueTexts.push(valueTxt);

                    currentY += labelTxt.height + 4;
                    currentY += valueTxt.height + 6;
                }
            }
        } else {
            var noCreds = new FunkinText(0, 0, boxBG.width, "This vessel isn't ready yet.", 28, false);
            noCreds.setFormat(Paths.font("8bit-jve.ttf"), 28);
            noCreds.setPosition(boxBG.x + 30, currentY);
            labelTexts.push(noCreds);
            add(noCreds).alpha = 0.5;
            valueTexts.push(new FunkinText(0, 0, 0, "fungus tuah", 28, false));
            currentY += noCreds.height + 4;
        }

        boxes.push({
            song: song,
            outline: boxOutline,
            bg: boxBG,
            title: nameTxt,
            divider: divider,
            labelDescs: labelTexts,
            valueDescs: valueTexts

        });

    }

    changeSelection(0, true);

    whiteFlash = new FunkinSprite(0, 0).makeSolid(FlxG.width, FlxG.height, 0xFFFFFFFF);
    whiteFlash.alpha = 0;
    whiteFlash.scrollFactor.set();
    add(whiteFlash);

    var barHeight = FlxG.height / 2;

    barTop = new FunkinSprite(0, -barHeight).makeSolid(FlxG.width, barHeight, 0xFF000000);
    barTop.scrollFactor.set();
    add(barTop);

    barBottom = new FunkinSprite(0, FlxG.height).makeSolid(FlxG.width, barHeight, 0xFF000000);
    barBottom.scrollFactor.set();
    add(barBottom);
    
    addTouchPad('UP_DOWN', 'A_B');
    addTouchPadCamera();
}

var iTime:Float = 0;
function update(elapsed:Float) {
    oldstatic.time += elapsed;
    tape_noise.time += elapsed;
    iTime += elapsed;
    glitch.iTime = iTime;
    var change = !allowInput ? 0 : ((controls.UP_P ? -1 : 0) + (controls.DOWN_P ? 1 : 0) - FlxG.mouse.wheel);
    if (change != 0) changeSelection(change, false);

    seedeeznuts?.angle += cdSpinSpeed * elapsed;

    var yPos = 10;
    for (i => box in boxes) {
        var _ = i == curSelected;
        var outline = box.outline;
        var title = box.title;

        outline.y = yPos;
        yPos += outline.height + 20;

        var wantedScale = _ ? [600, 475] : [600, title.height + 15];
        outline.scale.x = lerp(outline.scale.x, wantedScale[0], 0.3);
        outline.scale.y = lerp(outline.scale.y, wantedScale[1], 0.3);
        outline.updateHitbox();

        var bg = box.bg;
        bg.setPosition(outline.x + outline.width / 2 - bg.width / 2, outline.y + outline.height / 2 - bg.height / 2);
        bg.scale.x = outline.scale.x - outlineSize / 2;
        bg.scale.y = outline.scale.y - outlineSize / 2;
        bg.updateHitbox();

        title.setPosition(bg.x + bg.width / 2 - title.width / 2, bg.y);
        title.alpha = lerp(title.alpha, _ ? 1 : 0.5, 0.4);

        var divider = box.divider;
        divider.setPosition(bg.x + 20, bg.y + title.height + 10);


       var descY = box.bg.y + box.title.height + 25;

        for (i in 0...box.labelDescs.length) {
            var label = box.labelDescs[i];
            var value = box.valueDescs[i];

            label.setPosition(box.bg.x + 20, descY);
            descY += label.height + 2;

            value.setPosition(box.bg.x + 40, descY);
            descY += value.height + 4;
        }


        if (box.labelDescs.length > 0 || box.valueDescs.length > 0) {
            var firstDesc = box.labelDescs.length > 0 ? box.labelDescs[0] : box.valueDescs[0];

            if (box.descClip == null) {
                box.descClip = new FlxRect(0, 0, 0, 0);
            }

            var descClipRect = box.descClip;

            descClipRect.x = box.bg.x - firstDesc.x;
            descClipRect.y = box.bg.y - firstDesc.y;
            descClipRect.width = box.bg.width;
            descClipRect.height = box.bg.height;

            for (desc in box.labelDescs)
                desc.clipRect = descClipRect;

            for (desc in box.valueDescs)
                desc.clipRect = descClipRect;
        }
    }

    var curBox = boxes[curSelected];
    FlxG.camera.scroll.y = lerp(FlxG.camera.scroll.y, curBox.outline.y + curBox.outline.height / 2 - FlxG.height / 2, 0.1);

    if (allowInput && (controls.BACK || FlxG.keys.justPressed.ESCAPE)) {
        FlxG.switchState(new MainMenuState());
    }

    if (allowInput && controls.ACCEPT) {
        allowInput = false;
        selectSong();
    }

    var curPortrait = portraits[curSelected];
    /*if (!allowInput && curPortrait.animation.curAnim.name == 'start' && curPortrait.isAnimFinished()) {
        FlxG.switchState(new PlayState());
    }*/
}

var prevSelected = 0;
function changeSelection(amt:Int, force:Bool = false) {
    prevSelected = curSelected;
    curSelected = force ? amt : FlxMath.wrap(curSelected + amt, 0, boxes.length - 1);

    if (prevSelected != curSelected) {
        FlxG.sound.play(Paths.sound("menu/scroll"), 0.5);

        oldstatic.strength = 260;
        tape_noise.strength = 4;

        if (FlxG.save.data.dustinBoughtStuff.contains(boxes[curSelected].song.name.toLowerCase())) {
            FlxTween.num(60, 5, 0.5, {ease: FlxEase.quadOut}, function(val:Float) {
                oldstatic.strength = val;
            });

            FlxTween.num(4, 1, 0.5, {ease: FlxEase.quadOut}, function(val:Float) {
                tape_noise.strength = val;
            });
        }
    }

    // who never cached the song or the name bruh, now im too lazy to do it  - Nex
    genocidesText?.visible = boxes[curSelected].song.name.toLowerCase() == "genocides" && FlxG.save.data.dustinBoughtStuff.contains(boxes[curSelected].song.name.toLowerCase());

    for (i => p in portraits)
        p.alpha = curSelected == p.ID && FlxG.save.data.dustinBoughtStuff.contains(boxes[curSelected].song.name.toLowerCase()) ? 1 : 0.0001;

    seedeeznuts.playAnim(boxes[curSelected].song.name.toLowerCase());
    seedeeznuts.visible = FlxG.save.data.dustinBoughtStuff.contains(boxes[curSelected].song.name.toLowerCase());
    FlxTween.cancelTweensOf(seedeeznuts);
    seedeeznuts.x = FlxG.width * 0.9 - seedeeznuts.width / 2 + 35;
    FlxTween.tween(seedeeznuts, {x: FlxG.width * 0.9 - seedeeznuts.width / 2 }, 0.4, {
        ease: FlxEase.quadOut
    });

}


var speedizer:Float = 0;
var xoffset:Float = 0;
var yoffset:Float = 0;
var angleoffset:Float = 0;


function selectSong() {
    if (!FlxG.save.data.dustinBoughtStuff.contains(boxes[curSelected].song.name.toLowerCase())) return allowInput = true;
    var curBox = boxes[curSelected];
    PlayState.loadSong(curBox.song.name, curBox.song.difficulties[0], false, false);

    var curPortrait = portraits[curSelected];
    if (curPortrait.animation.name != null) {
            if (boxes[curSelected].song.name.toLowerCase() == "you-are" || boxes[curSelected].song.name.toLowerCase() == "you-are v2") {
                FlxG.sound.music.stop();
                FlxG.sound.play(Paths.sound("menu/youare-select"), 1);
                bg.visible = false;
                bgtv.visible = false;
                fg.visible = false;
                seedeeznuts.visible = false;

                for (b in boxes) {
                    b.outline.visible = false;
                    b.bg.visible = false;
                    b.title.visible = false;
                    b.divider.visible = false;

                    for (label in b.labelDescs)
                        label.visible = false;

                    for (value in b.valueDescs)
                        value.visible = false;
                }

                tvScreen.removeShader(oldstatic);
                tvScreen.removeShader(tape_noise);

                new FlxTimer().start(0.25, function(_) {
                    curPortrait.playAnim('start', true);

                curPortrait.offset.set(319, 308);
                

                new FlxTimer().start(2.5, function() {

                    FlxTween.tween(barTop, { y: 0 }, 3.5, { ease: FlxEase.quadInOut });
                    FlxTween.tween(barBottom, { y: FlxG.height / 2 }, 3, { ease: FlxEase.quadInOut });

                    FlxTween.tween(whiteFlash, { alpha: 1 }, 2, { ease: FlxEase.sineOut });


                    FlxTween.num(0, 1, 2, {ease: FlxEase.sineInOut}, function(n) {
                        glitch.AMT = 0.01 + 0.01 * n;
                        glitch.SPEED = 1 + 1 * n; 
                    });

                    new FlxTimer().start(3.5, function() {
                        FlxG.switchState(new PlayState());
                    });
                });

                });
            } 

            else
            {
                if (Options.gameplayShaders && FlxG.save.data.bloom) FlxG.camera.addShader(bloom);
                if (Options.gameplayShaders && FlxG.save.data.glitch) FlxG.camera.addShader(glitch);
                if (Options.gameplayShaders && FlxG.save.data.bloom) tvScreen.addShader(bloom);
                if (Options.gameplayShaders && FlxG.save.data.glitch) tvScreen.addShader(glitch);

                cdSpinSpeed = 0;

                FlxTween.num(0, 1300, 3, {ease: FlxEase.sineInOut}, function(val:Float) {
                    cdSpinSpeed = val;
                });


                FlxTween.num(2, 0, 2, {ease: FlxEase.quintOut}, function(num) {
                    bloom.size = 20 * num;
                    bloom.brightness = 1 + (20 * num);
                    glitch.AMT = 0.1 * num;
                    glitch.SPEED = 2 * num;
                });

                FlxG.camera.shake(0.02, 0.2);
                tvScreen.shake(0.02, 0.2);
                FlxG.sound.play(Paths.sound("menu/select_freeplay"), 1);

                if (boxes[curSelected].song.name.toLowerCase() == "uncreate") {
                    ink.visible = true;
                    ink.playAnim("paint", true);
                }

                new FlxTimer().start(0.25, function(_) {
                    curPortrait.playAnim('start', true);

                new FlxTimer().start(1.5, function() {
                    FlxTween.tween(FlxG.camera, {zoom: 1.4}, 2, {ease: FlxEase.quadInOut});
                    FlxTween.tween(tvScreen, {zoom: 1.4}, 2, {ease: FlxEase.quadInOut});

                    FlxTween.tween(barTop, { y: 0 }, 2, { ease: FlxEase.quadInOut });
                    FlxTween.tween(barBottom, { y: FlxG.height / 2 }, 1.5, { ease: FlxEase.quadInOut });

                    FlxTween.tween(whiteFlash, { alpha: 1 }, 2, { ease: FlxEase.sineOut });


                    FlxTween.num(0, 1, 2, {ease: FlxEase.sineInOut}, function(n) {
                        glitch.AMT = 0.01 + 0.01 * n;
                        glitch.SPEED = 1 + 1 * n; 
                    });

                    new FlxTimer().start(2, function() {
                        FlxG.switchState(new PlayState());
                    });
                });

                });
            }
    } else {
        FlxG.switchState(new PlayState());
    }
}

function destroy() {
    FlxG.camera.bgColor = 0xFF000000;
}

function hideStr(_:String):String {
    var temp:String = "";
    for (a in _.split())
        temp += a == " " ? " " : "?";
    return temp;
}