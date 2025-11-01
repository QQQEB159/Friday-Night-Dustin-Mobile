//
static function newDialogueBoxBG(x:Float, y:Float, sprite=null, width:Float, height:Float, border:Float) {
    var dialogueBox = new FunkinSprite(x, y, null);
    dialogueBox.makeSolid(1, 1, 0xFFFFFFFF);
    dialogueBox.extra["bWidth"] = width;
    dialogueBox.extra["bHeight"] = height;
    dialogueBox.extra["border"] = border;
    dialogueBox.colorTransform.color = dialogueBox.color;
    dialogueBox.scale.set(dialogueBox.extra["bWidth"], dialogueBox.extra["bHeight"]);
    dialogueBox.updateHitbox();
    dialogueBox.onDraw = (spr:FlxSprite) -> {
        spr.colorTransform.color = spr.color;
        spr.scale.set(spr.extra["bWidth"], spr.extra["bHeight"]);
        spr.updateHitbox();

        spr.draw();

        var border:Float = spr.extra["border"];
        spr.colorTransform.color = 0xFF000000;
        spr.scale.set(spr.extra["bWidth"]-(border*2), spr.extra["bHeight"]-(border*2));
        spr.updateHitbox();

        spr.x += border; spr.y += border;

        spr.draw();

        spr.x -= border; spr.y -= border;
    }
    return dialogueBox;
}