// imports
import flixel.text.FlxText.FlxTextFormat;
import funkin.savedata.FunkinSave;
import openfl.geom.Rectangle;
import StringTools;
importClass("data.scripts.classes.DialogueBoxBG", __script__);
importClass("data.scripts.classes.FunkinTypeText", __script__);
// "there must be a better way to do this!" ahh
var dialogue = [ // im so sorry for this
    // - INTRO DIALOGUES -
    "beforeStoryMode" => [
      //["dialogue", "anim"]
        ["WELCOME.", "talk"],
        ["DO NOT BE IMPATIENT.", "talk"],
        ["THE TIME FOR THIS WILL COME.", "focus"],
        ["FOR NOW,\nENJOY THE VESSEL I HAVE PREPARED.", "surprised"]
    ],
    "afterStoryMode" => [
        ["INTERESTING.\nTRULY INTERESTING.", "talk"],
        ["YOU ARE SEEKING MORE,\nARE YOU NOT?", "focus"],
        ["OF COURSE. OF COURSE.", "surprised"],
        ["THEN, THERE IS MORE THAT I CAN SHOW YOU. WHAT I HAVE DISCOVERED HERE.", "talk"],
        ["I AM SURE THAT MY FINDINGS\nWILL PROVE TO BE\nVERY, VERY INTERESTING.", "talk"]
    ],
    "bothEndings" => [
        ["INTERESTING, TRULY, INTERESTING.", "talk"],
        ["HOW FAR\nWILL CURIOSITY DRIVE YOU?", "surprised"],
        ["HOW DEEP\nWILL YOU GO?", "focus"]
    ],
    "boughtItAll" => [
        ["NOW.", "talk"],
        ["I HAVE NOTHING MORE TO OFFER YOU.", "talk"],
        ["ENJOY MY VESSELS.", "laugh"],
        ["I WILL BE WATCHING FROM THE DARK.", "focus"]
    ],
    // - KEY DIALOGUES -
    "mirror key" => [
        ["THE KEY TO A DIFFERENT WORLD.", "talk"],
        ["I HAVE DIFFERENT VESSELS WAITING.", "focus"],
        ["DO YOU WISH TO ACQUIRE THIS ITEM?", "talk"]
    ],
    "wrath key" => [
        ["THE KEY TO THE DEEPEST LEVEL OF HELL.", "talk"],
        ["ONLY PAIN AWAITS YOU THERE.", "surprised"],
        ["DO YOU WISH TO ACQUIRE THIS ITEM?", "talk"]
    ],
    "guilty key" => [
        ["A MISTAKE RESULTING IN A BRANCHING TIMELINE.", "talk"],
        ["SOME THINGS CAN ONLY CHANGE FOR THE WORST.", "focus"],
        ["DO YOU WISH TO ACQUIRE THIS ITEM?", "talk"]
    ],
    "virus key" => [
        ["AN INTERESTING OBJECT. IT SEEMS TO BREAK TIMELINES FROM WITHIN.", "talk"],
        ["PERHAPS YOU MAY FIND ITS VESSEL FAMILIAR?", "focus"],
        ["DO YOU WISH TO ACQUIRE THIS ITEM?", "talk"]
    ],
    // - CD DIALOGUES -
    "broken cd" => [
        ["IT COMES FROM A TIMELINE MULTIPLE YEARS IN THE FUTURE.", "talk"],
        ["ITS STATE OF DISREPAIR DOES NOT MIRROR THAT OF ITS FUNCTIONALITY.", "focus"],
        ["DO YOU WISH TO ACQUIRE THIS ITEM?", "talk"]
    ],
    "rad cd" => [
        ["IT WAS IN THE MIDDLE OF THE MULTIVERSE.", "talk"],
        ["STILL IN A PRETTY GOOD STATE.", "focus"],
        ["DO YOU WISH TO ACQUIRE THIS ITEM?", "talk"]
    ],
    "the cd" => [
        ["PLEASE TAKE IT.", "goofy"]
    ],
    "artistic cd" => [
        ["ANOTHER PIECE OF MULTIVERSE HISTORY.", "talk"],
        ["THE PAINT IS STILL FRESH.", "focus"],
        ["DO YOU WISH TO ACQUIRE THIS ITEM?", "talk"]
    ],
    "psycho cd" => [
        ["SOME ENTITIES SAY THIS EVENT CAN NEVER HAPPEN.", "focus"],
        ["BUT THE MULTIVERSE IS INFINITE\nAND HAS ENDLESS POSSIBILITIES", "surprised"],
        ["DO YOU WISH TO ACQUIRE THIS ITEM?", "talk"]
    ],
    "shopping cd" => [
        ["MY PERSONAL FAVORITE UNIVERSE", "talk"],
        ["BRINGS BACK MEMORIES.", "focus"],
        ["DO YOU WISH TO ACQUIRE THIS ITEM?", "talk"]
    ],
    "corrupted cd" => [
        ["THE HARDEST CD TO FIND.", "talk"],
        ["THE RESULT OF AN ENTITY COMING OUT OF ITS OWN UNIVERSE TO OTHERS.", "focus"],
        ["DO YOU WISH TO ACQUIRE THIS ITEM?", "talk"]
    ],
    // - OTHER DIALOGUES -
    "buySuccess" => [
        ["THANK YOU.", "surprised"]
    ],
    "buyCancel" => [
        ["YOUR CHOICE.", "focus"]
    ],
    "buyFail" => [
        ["IT SEEMS LIKE YOU DON'T HAVE ENOUGH EXP.", "focus"],
        ["DON'T WORRY,\nI'LL SAVE THIS ONE JUST FOR YOU.", "scary"]
    ]
];
static var shopMusicStarted:Bool = false;
// bg stuff
var bg:FunkinSprite = new FunkinSprite(0, 0, Paths.image("menus/shop/background_gaster"));
var gaster:FunkinSprite = new FunkinSprite(650, 85, Paths.image("menus/shop/gaster"));
// shop stuff
var kms:Array<String> = ["* Keys", "Mirror Key", "Wrath Key", "Guilty Key", "Virus Key", "* CDs", "Broken CD", "Rad CD", "The CD", "Artistic CD", "Psycho CD", "Shopping CD", "Corrupted CD"];
var heart:FunkinSprite = new FunkinSprite(80, 0, Paths.image("game/heart"));
var items:Array<FunkinText> = [];
var yesno:Array<FunkinText> = [new FunkinText(595, 575 + (43 / 2), 0, "Yes", 40, false), new FunkinText(1095, 575 + (43 / 2), 0, "No", 40, false)];
var curItem:Int = 0;
var curYesno:Int = 0;
// dialogue
var dialogueTxt:FunkinTypeText = new FunkinTypeText(540, 490, 670, "hawk tuah", 40);
var dialogues:Array<Array<String>>;
var dialogueEnded:Bool = false;
var curDialogue:Int = 0;
// stuff that changes visually idk
var itemKeys:FunkinSprite = new FunkinSprite(0, 0, Paths.image("menus/shop/keys"));
var itemCD:FunkinSprite = new FunkinSprite(0, 0, Paths.image("menus/shop/cds"));
var cost:FunkinText = new FunkinText(0, 0, 175, "Cost: ???", 40, false);
var money:FunkinText = new FunkinText(0, 0, 0, "EXP: " + FlxG.save.data.dustinCash, 40, false);

var itemmap = [
    "* keys" => ["* keys"],
    "* cds" => ["* cds"],

    "mirror key" => ["mirror key", 2000],
    "wrath key" => ["wrath key", 1500],
    "guilty key" => ["guilty key", 2000],
    "virus key" => ["virus key", 1500],

    "broken cd" => ["inopia", 700],
    "rad cd" => ["yolo", 400],
    "the cd" => ["genocides", 0],
    "artistic cd" => ["uncreate", 400],
    "psycho cd" => ["psychopath", 700],
    "shopping cd" => ["bargain", 300],
    "corrupted cd" => ["vindication", 1000]
];

var bgbox;

function create() {
    itemKeys.visible = itemCD.visible = !FlxG.save.data.dustinBeatEverything;
    dialogues = dialogue[FlxG.save.data.dustinBeatEverything ? "boughtItAll" : (FunkinSave.getWeekHighscore("dusttale-1", "hard").date != null ? "afterStoryMode" : "beforeStoryMode")];

    if (!shopMusicStarted) {
        FlxG.sound.music.stop();
        FlxG.sound.playMusic(Paths.music("gaster_shop"), 0.7, true);
        shopMusicStarted = true;
    }
    // bg stuff
    add(bg).screenCenter();
    if (Options.gameplayShaders) {
        bg.shader = new CustomShader("waterDistortion");
        bg.shader.strength = 0.5;
    }

    for (a in ["idle", "talk", "focus", "scary", "goofy", "surprised"])
        gaster.addAnim(a, a, 12, true);
    add(gaster).playAnim("idle");

    bg.scrollFactor.set();
    bg.antialiasing = gaster.antialiasing = Options.antialiasing;
    // box stuff

    add(new DialogueBoxBG(515, 470, null, 700, 210, 5)).pixels.fillRect(new Rectangle(5, 5, 690, 200), 0xFF000000); // text box
    add(bgbox = new DialogueBoxBG(65, 40, null, 400, 640, 5)).pixels.fillRect(new Rectangle(5, 5, 390, 640), 0xFF000000); // options box
    add(new DialogueBoxBG(1040, 60, null, 175, 175, 5)).pixels.fillRect(new Rectangle(5, 5, 785, 460), 0xFF000000); // item box
    // shop stuff
    var why:Int = 0;
    for (a in 0...kms.length)
        if (!FlxG.save.data.dustinBoughtStuff.contains(itemmap[kms[a].toLowerCase()][0])) { // conditional if bought
            if (!StringTools.startsWith(kms[a], "*")) (StringTools.endsWith(kms[a], "CD") ? itemCD : itemKeys).addAnim(kms[a].toLowerCase(), itemmap[kms[a].toLowerCase()][0], 1, false);
            why += (StringTools.startsWith(kms[a], "*") ? 58 : 46);
            var txt:FunkinText = new FunkinText(110, why, 0, kms[a], 40, false);
            if (StringTools.startsWith(kms[a], "*")) txt.alpha = 0.5;
            items.push(txt);
            add(txt).font = Paths.font("8bit-jve.ttf");
            textCrispy(txt);
        }
    kms.remove("* Keys");
    kms.remove("* CDs");
        
    for (a in yesno) {
        add(a).font = Paths.font("8bit-jve.ttf");
        a.visible = false;
    }

    if (items[0] != null) {
        heart.scale.set(24/1024, 24/1024);
        add(heart).updateHitbox();
        heart.alpha = 0;
        heart.setPosition(80, items[0]?.y + (items[0]?.height - heart.height) / 2);
    }

    add(itemKeys).setPosition(1040 + 175 / 2 - itemKeys.width / 2, 60 + 175 / 2 - itemKeys.height / 2);
    add(itemCD).setPosition(1040 + 175 / 2 - itemCD.width / 2 - 30, 60 + 175 / 2 - itemCD.height / 2 - 5);
    itemCD.origin.x += 25;
    itemCD.origin.y += 5;
    itemKeys.scale.set(0.875, 0.875);
    itemCD.scale.set(0.5, 0.5);
    itemKeys.antialiasing = itemCD.antialiasing = Options.antialiasing;

    cost.font = money.font = Paths.font("8bit-jve.ttf");
    money.antialiasing = false;
    textCrispy(cost); textCrispy(money);
    add(cost).setPosition(1040, 235);
    cost.alignment = "center";
    add(money).setPosition(1215 - money.width, 466 - money.height);

    add(dialogueTxt).setFormat(Paths.font("8bit-jve.ttf"), 40);
    dialogueTxt.letterSpacing = 8.0;
    dialogueTxt.resetText(" ");
    yap(dialogues[0]);

    updateItemList();
    changeSel(0);

    for (a in items) a.alpha = 0;
    bgbox.alpha = 0;

    FlxG.camera.scroll.x = 220;
    camOFFX = 220;
    leftAlpha = 0;
    
    addTouchPad('LEFT_FULL', 'A_B');
    addTouchPadCamera();
}

var camOFFX:Float = 220;
var leftAlpha:Float = 0;
var prevText:String;
var time:Float = FlxG.random.float(100, 1000);
function update(elapsed:Float) {
    FlxG.camera.scroll.x = FlxMath.lerp(FlxG.camera.scroll.x, camOFFX, 0.03); 
    bg.shader?.time = time += elapsed;

    for (a in items) {
        a.alpha = FlxMath.lerp(a.alpha, leftAlpha, 0.03);
    }
    bgbox.alpha = FlxMath.lerp(bgbox.alpha, leftAlpha, 0.03);

    if (dialogues[curDialogue] != null && (FlxG.keys.justPressed.Z || FlxG.keys.justPressed.X))
        if (dialogueEnded) yap(dialogues[curDialogue]); else dialogueTxt.skip();

     if (controls.ACCEPT || FlxG.keys.justPressed.Z) {
        if (dialogues[curDialogue] != null)
            if (dialogueEnded) yap(dialogues[curDialogue]); else dialogueTxt.skip();
        else if (!["", "DO YOU WISH TO ACQUIRE THIS ITEM?", "PLEASE TAKE IT."].contains(dialogueTxt.text)) {
            FlxG.sound.play(Paths.sound("menu/select"));
            if (dialogueTxt.text == "I WILL BE WATCHING FROM THE DARK.") FlxTween.tween(gaster, {alpha: 0}, 1);
            if (dialogueTxt.text == "FOR NOW,\nENJOY THE VESSEL I HAVE PREPARED.") FlxG.switchState(new ModState("NewMainMenu"));
            dialogueTxt.text = ["I WILL BE WATCHING FROM THE DARK.", " "].contains(dialogueTxt.text) ? " " : "";
            dialogues = [];
            gaster.playAnim("idle", !(yesno[0].visible = yesno[1].visible = false));
            changeSel(0);
        } else if (gaster.getAnimName() == "idle" && dialogueTxt.text == "") {
            camOFFX = 220;
            leftAlpha = 1;
            dialogues = dialogue[items[curItem].text.toLowerCase()] != null ? dialogue[items[curItem].text.toLowerCase()] : [["DO YOU WISH TO ACQUIRE THIS ITEM?", "talk"]];
            yap(dialogues[curDialogue = 0]);
        } else if (["PLEASE TAKE IT.", "DO YOU WISH TO ACQUIRE THIS ITEM?"].contains(dialogueTxt.text)) {
            FlxG.sound.play(Paths.sound("menu/select"));
            var hawktuah:String = curYesno == 0 ? (FlxG.save.data.dustinCash - itemmap[items[curItem].text.toLowerCase()][1] >= 0? "buySuccess" : "buyFail") : "buyCancel";
            dialogues = dialogue[hawktuah];
            if (hawktuah == "buySuccess") {
                FlxG.save.data.dustinCash -= itemmap[items[curItem].text.toLowerCase()][1];
                money.text = "EXP: " + FlxG.save.data.dustinCash;
                money.setPosition(1215 - money.width, 470 - money.height);
                if (!FlxG.save.data.dustinBoughtStuff.contains(itemmap[items[curItem].text.toLowerCase()][0])) FlxG.save.data.dustinBoughtStuff.push(itemmap[items[curItem].text.toLowerCase()][0]);
                updateItemList();
                if (hasItAll()) {
                    dialogues = dialogue["boughtItAll"];
                    yap(dialogues[curDialogue = 0]);
                }
            }
            yap(dialogues[curDialogue = 0]);
            changeSel(0);
        }
    }

    if (prevText != dialogueTxt.text) {
        if (dialogueTxt.text != "" && !StringTools.endsWith(dialogueTxt.text, " ") && !StringTools.endsWith(dialogueTxt.text, "\n")) FlxG.sound.play(Paths.sound("wing_oggster/snd_wngdng" + FlxG.random.int(1, 7)), 0.7);
        prevText = dialogueTxt.text;
    }

    if ((controls.UP_P || controls.DOWN_P) && dialogueTxt.text == "")
        changeSel(controls.UP_P ? -1 : 1);

    if ((controls.LEFT_P || controls.RIGHT_P) && ["PLEASE TAKE IT.", "DO YOU WISH TO ACQUIRE THIS ITEM?"].contains(dialogueTxt.text))
        changeYesno(controls.LEFT_P ? -1 : 1);

    if (controls.BACK){
        shopMusicStarted = false;
        FlxG.sound.music.stop();
        FlxG.switchState(new ModState("NewMainMenu"));
    }
}

function changeSel(_:Int, ?hello:Bool = true) {
    camOFFX = 0;
    leftAlpha = 1;
    if (_ != 0 && !hello) CoolUtil.playMenuSFX();
    curItem = FlxMath.wrap(curItem + _, 0, items.length - 1);

    if (items[curItem] != null) {
        if (hasItAll()) return;
        if (StringTools.startsWith(items[curItem].text, "*") || !items[curItem].visible) {
            changeSel(_ == 0 ? 1 : _, false);
            return;
        }
        if (items[curItem].visible) {
            itemKeys.visible = !(itemCD.visible = StringTools.endsWith(items[curItem].text, "CD"));
            (itemKeys.visible ? itemKeys : itemCD).playAnim(items[curItem].text.toLowerCase());
            cost.text = "Cost: " + itemmap[items[curItem].text.toLowerCase()][1];

            FlxTween.cancelTweensOf(heart);
            FlxTween.tween(heart, {x: 80, y: items[curItem].y + (items[curItem].height - heart.height) / 2, alpha: 1}, 0.25, {ease: FlxEase.backOut});
            for (a in 0...items.length) items[a].color = curItem == a ? FlxColor.YELLOW : FlxColor.WHITE;
        }
    }
}

function changeYesno(_:Int) {
	if (_ != 0) CoolUtil.playMenuSFX();
    curYesno = FlxMath.wrap(curYesno + _, 0, yesno.length - 1);
    FlxTween.cancelTweensOf(heart);

    FlxTween.tween(heart, {x: Std.int(yesno[curYesno].x - 25 - heart.width / 2), y: yesno[curYesno].y + (yesno[curYesno].height - heart.height) / 2}, 0.25, {ease: FlxEase.backOut});
    for (a in 0...yesno.length) yesno[a].color = curYesno == a ? FlxColor.YELLOW : FlxColor.WHITE;
}

function yap(_:Array<String>) {
    yesno[0].visible = yesno[1].visible = ["PLEASE TAKE IT.", "DO YOU WISH TO ACQUIRE THIS ITEM?"].contains(_[0]);
    if (["PLEASE TAKE IT.", "DO YOU WISH TO ACQUIRE THIS ITEM?"].contains(_[0])) changeYesno(curYesno = 0);

    dialogueEnded = false;
    gaster.playAnim(_[1], true);

    dialogueTxt.resetText(_[0]);
    dialogueTxt.start(0.08);
    dialogueTxt.completeCallback = () -> {
        dialogueEnded = true;
        curDialogue++;
    };
}

function updateItemList() {
    var why:Int = 0;
    for (a in items) {
        if (FlxG.save.data.dustinBoughtStuff.contains(itemmap[a.text.toLowerCase()][0])) {
            a.visible = false;
        } else {
            why += (StringTools.startsWith(a.text.toLowerCase(), "*") ? 58 : 46);
            a.y = why;
        }
    }
}

function hasItAll():Bool {
    for (a in kms)
        if(!FlxG.save.data.dustinBoughtStuff.contains(itemmap[a.toLowerCase()][0]))
            return false;
    cost.text = "Cost: ???";
    return FlxG.save.data.dustinBeatEverything = !(heart.visible = itemKeys.visible = itemCD.visible = false);
}

function textCrispy(target_text) {
    target_text.textField.antiAliasType = 0/*ADVANCED*/;
    target_text.textField.sharpness = 400/*MAX ON OPENFL*/;
}