/*
看什么膳食？
给我看
🟦🟦🟦🟦🟦🟦🟦
🟦🟦🟫🟫🟫🟦🟦
🟦🟦⬛️🟫⬛️🟦🟦
🟦🟦🟫🟫🟫🟦🟦
🟦🟫🟨🟨🟨🟫🟦
🟦🟫🟨24 🟨🟫🟦
🟦🟦🟨🟨🟨🟦🟦
🟦🟦🟫🟦🟫🟦🟦
🟦🟦🟫🟦🟫🟦🟦
🟦🟦🟦🟦🟦🟦🟦
*/
import funkin.savedata.FunkinSave;
import funkin.menus.StoryMenuState.StoryWeeklist;
import flixel.addons.util.FlxSimplex;
import funkin.savedata.FunkinSave;
import funkin.ui.FunkinText;

var exittext:FunkinText;

var weeks = StoryWeeklist.get();
var thoseWhoKnow = [
    "dusttale" => [125, 55, 1, []],
    "dustswap" => [130, 405, 1, [], "mirror key"],
    "dustfell" => [395, 400, 1, [], "wrath key"],
    "dustbelief" => [670, 405, 1, [], "guilty key"],
    "dustshift" => [925, 400, 1, [], "virus key"]
];
var thoseWhoKnowTemp = [];
var selectScreens = [];
var thoseWhoKnowGroup:FlxTypedGroup = new FlxTypedGroup();

var keys:Array<FunkinSprite> = [];
var lockAnimQueue:Array<String> = [];
var doneUnlock:Bool = false;

var pillars1:FlxSprite = null;
var pillars2:FlxSprite = null;
var text:FlxSprite = null;

var blackFlash = new CustomShader("impact_frames");
var bloom = new CustomShader("bloom");
bloom.size = 40;
bloom.brightness = 5;
bloom.directions = 8;
bloom.quality = 10;

var glitch = new CustomShader("glitching");
glitch.SPEED = 1;
glitch.AMT = 0.7;

var canInput:Bool = true;

function create() {
    CoolUtil.playMenuSong();
    FlxG.save.flush();
    for (week in weeks.weeks) {
        var idk = thoseWhoKnow[week.id.split("-")[0]];
        if (idk != null) idk[3].push(week);
    }

    FlxG.mouse.visible = !controls.touchC;
    var usefulFrames = Paths.getFrames("menus/freeplay/characters");
    add(pillars1 = new FlxSprite().loadGraphic(Paths.image("menus/freeplay/background 1")));
    add(pillars2 = new FlxSprite().loadGraphic(Paths.image("menus/freeplay/background 2")));
    add(thoseWhoKnowGroup);
    pillars1.antialiasing = pillars2.antialiasing = Options.antialiasing;

    for (i in thoseWhoKnow.keys()) {
        var spritet = new FunkinSprite(thoseWhoKnow[i][0], thoseWhoKnow[i][1]);
        spritet.frames = usefulFrames;
        spritet.addAnim("idle", i + "0", true);
        spritet.addAnim("selected", i + " select", true);
        thoseWhoKnowGroup.add(spritet);
        spritet.playAnim("idle");
        spritet.updateHitbox();
        thoseWhoKnowTemp.push(i);
        spritet.ID = thoseWhoKnowTemp.indexOf(i);
        spritet.origin.y = spritet.height;
        spritet.antialiasing = Options.antialiasing;

        var screen = new FlxSprite().loadGraphic(Paths.image("menus/freeplay/select screens/" + i));
        add(screen);
        screen.visible = false;
        screen.antialiasing = Options.antialiasing;
        selectScreens.push(screen);

        if (FunkinSave.getWeekHighscore(i + "-1", "hard").date == null && !FlxG.save.data.dustinSeenUnlockAnims.contains(i) && i != "dusttale") { // FunkinSave.getWeekHighscore(i + "-1", "hard").date == null && 
            spritet.color = FlxColor.BLACK;
            
            var offset:Array<Int> = switch (i) {
                case "dustswap": [25, -15];
                case "dustfell": [-5, -15];
                case "dustbelief": [5, -10];
                case "dustshift": [-30, -30];
                default: [0, 0];
            };
            var lock:FunkinSprite = new FunkinSprite(0, 0, Paths.image("menus/freeplay/locks"));
            lock.setPosition(spritet.getMidpoint().x - lock.width / 2 + offset[0], spritet.getMidpoint().y - lock.height / 2 + offset[1]);
            lock.addAnim(thoseWhoKnow[i][4].split(" ")[0], thoseWhoKnow[i][4].split(" ")[0], 0, false);
            lock.playAnim(thoseWhoKnow[i][4].split(" ")[0], true, null, true);
            add(lock).antialiasing = Options.antialiasing;
            thoseWhoKnow[i][5] = lock;

            if (FlxG.save.data.dustinBoughtStuff.contains(thoseWhoKnow[i][4])) {
                FlxG.sound.music.volume = 0;
                var key:FunkinSprite = new FunkinSprite(0, 0, Paths.image("menus/shop/keys"));
                key.setPosition(FlxG.width / 2 - key.width / 2, -key.height);
                key.scale.set(0.5, 0.5);
                key.addAnim(thoseWhoKnow[i][4], thoseWhoKnow[i][4]);
                key.playAnim(thoseWhoKnow[i][4], true, null, true);
                keys.push(key);

                lockAnimQueue.push(i);
            }
        }
    }

    add(text = new FlxSprite().loadGraphic(Paths.image("menus/freeplay/text")));
    text.antialiasing = Options.antialiasing;

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

    exittext = new FunkinText(0, 660, FlxG.width, "< EXIT", 46);
    exittext.alignment = "left";
    exittext.fieldWidth = 110;
    exittext.fieldHeight = 50;
    exittext.font = Paths.font("8bit-jve.ttf");
    add(exittext);

    for (a in 0...keys.length) {
        add(keys[a]).antialiasing = Options.antialiasing;
        FlxTween.tween(keys[a], {x: FlxG.width / (keys.length + 1) * (a + 1) - keys[a].width / 2, y: FlxG.height / 2 - keys[a].height / 2, 'scale.x': 1, 'scale.y': 1}, 1, {
            ease: FlxEase.circInOut, onComplete: (_) -> // this is so ass im sorry i got the sounds so last minute
                FlxTween.tween(keys[a], {x: thoseWhoKnow[lockAnimQueue[a]][5].getMidpoint().x - keys[a].width / 2, y: thoseWhoKnow[lockAnimQueue[a]][5].getMidpoint().y - keys[a].height / 2}, 1, {
                    ease: FlxEase.circInOut, startDelay: a * 5, onComplete: (_) -> {
                        FlxG.sound.play(Paths.sound("unlocks/" + lockAnimQueue[a]));
                        thoseWhoKnow[lockAnimQueue[a]][5].animation.curAnim.curFrame = 1;
                        FlxTween.tween(thoseWhoKnow[lockAnimQueue[a]][5], {'scale.x': 1.1, 'scale.y': 1.1}, 1.2, {ease: FlxEase.circInOut});
                        new FlxTimer().start(0.6, () -> thoseWhoKnow[lockAnimQueue[a]][5].animation.curAnim.curFrame = 2);
                        FlxTween.tween(keys[a], {'scale.x': 0.1, 'scale.y': 0.1, alpha: 0}, 1.2, {ease: FlxEase.circInOut, onComplete: (_) -> {
                            thoseWhoKnow[lockAnimQueue[a]][5].animation.curAnim.curFrame = 3;
                            thoseWhoKnowGroup.members[thoseWhoKnowTemp.indexOf(lockAnimQueue[a])].color = FlxColor.WHITE;
                            if(Options.gameplayShaders) {
                            if (FlxG.save.data.bloom) FlxG.camera.addShader(bloom);
                            }
                            FlxTween.num(2, 0, 2, {ease: FlxEase.quintOut, onComplete: () -> {FlxG.camera.removeShader(bloom); doneUnlock = a == keys.length - 1; FlxG.save.data.dustinSeenUnlockAnims.push(lockAnimQueue[a]);}}, (num) -> {bloom.size = 20 * num; bloom.brightness = 1 + (20 * num);});
                            FlxTween.tween(thoseWhoKnow[lockAnimQueue[a]][5], {alpha: 0}, 2, {ease: FlxEase.quintOut});
                        }});
                    }
                })
        });
    }
    doneUnlock = keys.length == 0;
}

var iTime:Float = 0;
var firstTouch:Bool = false;
var exitClicked:Bool = false;

function update(elapsed) {
    if (doneUnlock) {
        iTime += elapsed;
        FlxG.sound.music.volume = lerp(FlxG.sound.music.volume, 1, 0.04);
        var mouseInHalf = FlxG.mouse.y >= 400;
        for (i in thoseWhoKnowGroup.members) {
            thoseWhoKnow[thoseWhoKnowTemp[i.ID]][2] = (!mouseInHalf && i.y > 300) || (mouseInHalf && i.y < 300) ? 0.95 : 1;

            if (FlxG.mouse.overlaps(i)) {
                if (i.color != FlxColor.BLACK) {
                    thoseWhoKnow[thoseWhoKnowTemp[i.ID]][2] += 0.05;
                    i.playAnim("selected");
                    if (FlxG.mouse.justReleased && Main.timeSinceFocus > 0.25 && canInput) {
                        if (!firstTouch) {
                            firstTouch = true;
                            FlxG.sound.play(Paths.sound("menu/hover"), 0.5);
                            new FlxTimer().start(1, function() {
                                firstTouch = false;
                            });
                        } else {
                            select(i.ID);
                            firstTouch = false;
                        }
                    }
                }
            } else {
                i.playAnim("idle");
            }

            i.scale.x = i.scale.y = lerp(i.scale.y, thoseWhoKnow[thoseWhoKnowTemp[i.ID]][2], 0.2);
        }

        pillars1.scale.x = pillars1.scale.y = lerp(pillars1.scale.y, !mouseInHalf ? 1 : 1.01, 0.2);
        pillars2.scale.x = pillars2.scale.y = lerp(pillars2.scale.y, !mouseInHalf ? 1.01 : 1, 0.2);

        FlxG.camera.scroll.set();
        FlxG.camera.angle = 0;
        updateShake(elapsed);
        glitch.iTime = iTime;

        if (FlxG.mouse.justReleased && FlxG.mouse.overlaps(exittext) && canInput) {
            if (!exitClicked) {
                exitClicked = true;
                CoolUtil.playMenuSFX(2, 0.7);
                new FlxTimer().start(0.4, function() {
                    FlxG.switchState(new MainMenuState());
                    exitClicked = false;
                });
            }
        } else if (FlxG.mouse.justReleased && exitClicked) {
            exitClicked = false;
        }
    }
}

var speedizer:Float = 0;
var xoffset:Float = 0;
var yoffset:Float = 0;
var angleoffset:Float = 0;
static function shake(traumatizerr:Float = 0.3, speedizerr:Float = 0.02) {
    t = traumatizerr;
    speedizer = speedizerr;
    xoffset = FlxG.random.float(-100, 100);
    yoffset = FlxG.random.float(-100, 100);
    angleoffset = FlxG.random.float(-100, 100);
}

var t:Float = 0;
var peakAngle:Float = 0;
function updateShake(elapsed:Float) {
    t = FlxMath.bound(t - (speedizer * elapsed), 0, 1);
    FlxG.camera.angle += 4 * (t * t) * FlxSimplex.simplex(t * 25.5, t * 25.5 + angleoffset);
    FlxG.camera.scroll.x += 50 * (t * t) * FlxSimplex.simplex(t * 100 + xoffset, 10);
    FlxG.camera.scroll.y += 50 * (t * t) * FlxSimplex.simplex(10, t * 100 + yoffset);

    if (peakAngle < Math.abs(FlxG.camera.angle))
        peakAngle = Math.abs(FlxG.camera.angle);
}

function select(id:Int) {
    canInput = false;
    FlxG.sound.play(Paths.sound("menu/select_freeplay"), 1);
    var ut = thoseWhoKnow[thoseWhoKnowTemp[id]][3];
    var locked = FunkinSave.getWeekHighscore(ut[0].id, ut[0].difficulties[0]).date == null;
    if (locked)
        PlayState.loadWeek(ut[0], ut[0].difficulties[0]);

    weekPlaylist = ut;
    weekDifficulty = ut[0].difficulties[0];

    pillars1.visible = pillars2.visible = text.visible = exittext.visible = false;
    for (a in thoseWhoKnow) a[5]?.visible = false;
    for (j in thoseWhoKnowGroup.members) if (j.ID != id) j.visible = false;
    var curScreen = selectScreens[id];
    curScreen.visible = true;
    if(Options.gameplayShaders) {
    if (FlxG.save.data.bloom) FlxG.camera.addShader(bloom);
    if (FlxG.save.data.impact) FlxG.camera.addShader(blackFlash);
    }
    blackFlash.threshold = 0.2;

    new FlxTimer().start(0.05, function() {
        blackFlash.threshold = 1;

        new FlxTimer().start(0.2, function() {
            FlxG.camera.removeShader(blackFlash);
            if(Options.gameplayShaders) {
            if (FlxG.save.data.glitching) FlxG.camera.addShader(glitch);
            }

            FlxTween.num(2, 0, 2, {
                ease: FlxEase.quintOut,
                onComplete: () -> {
                    new FlxTimer().start(2.5, function() {
                        whiteFlash.kill();
                        whiteFlash.destroy(); 

                        if (locked) {
                            weekPlaylist.shift();
                            FlxG.switchState(new PlayState());
                        } else
                            FlxG.switchState(new ModState("ChapterSelectionMenu", ut));
                    });
                }
            }, function(num) {
                bloom.size = 20 * num;
                bloom.brightness = 1 + (20 * num);
                glitch.AMT = 0.1 * num;
                glitch.SPEED = 2 * num;

                new FlxTimer().start(1.5, function() {
                    FlxTween.tween(barTop, { y: 0 }, 2, { ease: FlxEase.quadInOut });
                    FlxTween.tween(barBottom, { y: FlxG.height / 2 }, 1.5, { ease: FlxEase.quadInOut });
                    FlxTween.tween(whiteFlash, { alpha: 1 }, 2, { ease: FlxEase.sineOut });

                    FlxTween.num(0, 1, 2, { ease: FlxEase.sineInOut }, function(n) {
                        glitch.AMT = 0.01 + 0.01 * n;
                        glitch.SPEED = 1 + 1 * n;
                    });
                });
            });

            shake(0.6, 0.85);
        });
    });
}