import flixel.addons.util.FlxSimplex;
import funkin.editors.EditorPicker;
import funkin.menus.ModSwitchMenu;
import funkin.menus.credits.CreditsMain;
import funkin.options.OptionsMenu;
import funkin.savedata.FunkinSave;

var background:FunkinSprite;
var logo:FunkinSprite;

var _list = CoolUtil.coolTextFile(Paths.txt("config/menuItems"));
var options:Array<Dynamic> = [];
var curSelected:Int = 0;

var intro:Bool = true;
static var firstIntro:Bool = true;

function create() {
    snow = importScript("data/scripts/light-shader");
    snow.set("initIndex", members.length);

    FlxG.camera.bgColor = 0xFF000000;
    FlxG.mouse.visible = !controls.touchC;
    CoolUtil.playMenuSong();

    background = new FunkinSprite().loadGraphic(Paths.image('menus/main/background'));
    background.antialiasing = false;
    background.scale.set(0.35, 0.35);
    background.updateHitbox();
    background.screenCenter();
    background.scrollFactor.set(0.5, 0.5);
    add(background);

    logo = new FunkinSprite().loadGraphic(Paths.image('menus/main/logo'));
    logo.scale.set(0.25, 0.25);
    logo.updateHitbox();
    logo.screenCenter();
    logo.x -= 10;
    logo.y = FlxG.height * 0.25 - logo.height / 2;
    logo.antialiasing = Options.antialiasing;
    add(logo);

    if (!FlxG.save.data.dustinBeatEverything) _list.remove("GALLERY");

    for (k => v in _list) {
        var txt = new FunkinText(0, 0, 0, v, 24, false);
        txt.setFormat(Paths.font("8bit-jve.ttf"), 48, 0xFFFFFF00);
        txt.ID = k;
        add(txt);
        options.push(txt);
    }

    changeSelection(0, true);

    logo.alpha = 0;
    for (a in options) {
        a.alpha = 0;
    }
    background.alpha = 0;
    FlxG.save.flush();
}
var fadeInTimer:Float = 0;
var fadeInDuration:Float = 2.5;

function update(elapsed:Float):Void {
    var change = (FlxG.keys.justPressed.UP ? -1 : 0) + (FlxG.keys.justPressed.DOWN ? 1 : 0) - FlxG.mouse.wheel;
    if (change != 0) changeSelection(change, false);

    if (FlxG.mouse.justMoved) {
        for (a in options) {
            if (FlxG.mouse.overlaps(a)) {
                changeSelection(a.ID, true);
                break;
            }
        }
    }

    if ((firstIntro ? !intro : true) && FlxG.mouse.justPressed) {
        for (a in options) {
            if (FlxG.mouse.overlaps(a)) {
                select();
                break;
            }
        }
    }

    if (FlxG.save.data.dev && FlxG.keys.justPressed.SEVEN) {
        persistentUpdate = false;
        persistentDraw = true;
        openSubState(new EditorPicker());
    }

    if (FlxG.save.data.dev && controls.SWITCHMOD) {
        openSubState(new ModSwitchMenu());
        persistentUpdate = false;
        persistentDraw = true;
    }

    FlxG.camera.scroll.x = lerp(FlxG.camera.scroll.x, FlxSimplex.simplex(Conductor.songPosition / 3000, 0) * 4, 0.05);
    FlxG.camera.scroll.y = lerp(FlxG.camera.scroll.y, FlxSimplex.simplex(Conductor.songPosition / 3000, 1) * 4 + 2 * curSelected, 0.05);
    logo.y = lerp(logo.y, FlxG.height * 0.25 - logo.height / 2 + 5 * curSelected, 0.05);

    if (background.alpha < 1) {
        background.alpha += elapsed / fadeInDuration;
        if (background.alpha > 1) background.alpha = 1;
    }

    if (fadeInTimer < 1) {
        fadeInTimer += elapsed;
    } else if (fadeInTimer < 1 + fadeInDuration) {
        fadeInTimer += elapsed;
        var t = (fadeInTimer - 1) / fadeInDuration;
        t = Math.min(t, 1);

        logo.alpha = t;
        for (a in options) {
            a.alpha = t;
        }
    } else {
        logo.alpha = 1;
        for (a in options) {
            a.alpha = 1;
        }
    }

    intro = !(fadeInTimer > fadeInDuration * 0.8);
    if (firstIntro && !intro) firstIntro = false;
}

var prevSelected = 0;
function changeSelection(amt:Int = 0, force:Bool = false) {
    prevSelected = curSelected;
    curSelected = force ? amt : FlxMath.wrap(curSelected + amt, 0, options.length - 1);

    for (a in options) a.color = (a.ID == curSelected) ? 0xFFFFFF00 : 0xFFFFFFFF;

    if (prevSelected != curSelected) FlxG.sound.play(Paths.sound("menu/scroll"), 0.5);
}

function postUpdate(elapsed:Float) {
    for (a in options) {
        var s = 1.0 + (a.ID == curSelected ? 0.2 : 0);
        a.scale.x = lerp(a.scale.x, s, 0.25);
        a.scale.y = lerp(a.scale.y, s, 0.25);
        a.updateHitbox();
    }

    var minY = FlxG.height * 0.5;
    var maxY = FlxG.height * 0.8;

    var totalLeftoverHeight = maxY - minY;
    for (a in options) totalLeftoverHeight -= a.height;

    var gapSize = totalLeftoverHeight / (options.length - 1);
    var cursorY = minY;
    for (a in options) {
        a.x = FlxG.width / 2 - a.width / 2;
        a.y = cursorY;
        cursorY += gapSize + a.height;
    }
}

function select() {
    FlxG.sound.play(Paths.sound("menu/select"), 0.9);
    switch (_list[curSelected]) {
        case "STORY MODE": FlxG.switchState(new StoryMenuState());
        case "FREEPLAY": FlxG.switchState(new ModState("NewFreeplayMenu"));
        case "SHOP": FlxG.switchState(new ModState("shop/ShopState"));
        case "GALLERY": FlxG.switchState(new ModState("gallery/GalleryState"));
        case "OPTIONS": FlxG.switchState(new OptionsMenu());
        case "CREDITS": FlxG.switchState(new ModState("CreditsState"));
        default: trace('idk');
    }
}