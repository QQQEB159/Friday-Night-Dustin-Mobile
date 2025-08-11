// IM GOING MENTALLY INSANE I DIDNT KNOW THIS WOULD BE SO FUCKING EASY TO CODE BYE  - NEX
#if (!sys)
disableScript();
#end

import lime.ui.Window;
import openfl.Lib;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.Sprite;
import openfl.system.Capabilities;

var canGo:Bool = false;
var app:Window = null;
var tottalTimer:Float = FlxG.random.float(100, 1000);
function postCreate() {
    /*var NYEHEHE = new Bitmap(BitmapData.fromBytes(Assets.getBytes(Paths.image("game/cutscenes/genocides/SWAG"))));

    new FlxTimer().start(0.1, () -> {
        app = Lib.application.createWindow({
            title: "DAME TU HUESITO",
            alwaysOnTop: true,
            width: Capabilities.screenResolutionX,
            height: Capabilities.screenResolutionY,
            frameRate: 1,
            borderless: true,
            //hidden: true
        });

        Lib.application.window.onClose.add(shouldClose);
        app.onFocusIn.add(() -> Lib.application.window?.focus());
        app.onClose.add(() -> if (!canGo) app.onClose.cancel());

        NYEHEHE.width = app.width;
        NYEHEHE.height = app.height;
        app.stage.addChild(new Sprite().addChild(NYEHEHE));

        app.opacity = 0;
        app.stage.color = FlxColor.BLACK;
    });*/

    autoTitleCard = false;
    dad.x -= 1000;
}

function onSongStart() {
    dad.playAnim("walk", true);
    FlxTween.tween(dad, {x: dad.x + 1000}, 3.8, {onComplete: () -> dad.dance()});
}

var tween:FlxTween = null;
function onEvent(_) if (_.event.name == "Play Animation" && _.event.params[1] == "swag" && app != null) {
    app.opacity = 1;
    tween?.cancel();
    FlxTween.tween(app, {opacity: 0}, 0.7);
}

function destroy() {
    shouldClose();
    Lib.application.window.onClose.remove(shouldClose);
}

function shouldClose() {
    canGo = true;
    app?.close();
}