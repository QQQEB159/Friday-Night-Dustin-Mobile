//
function create()
    introSprites = ['game/ui/3', 'game/ui/2', "game/ui/1", "game/ui/go"];
/*
function onCountdown(event) {
    event.cancel();

    var sprite:FlxSprite = null;
    var sound:FlxSound = null;

    var spritePath:String = Paths.image(event.spritePath);
    if (Assets.exists(spritePath)) {
        var sprite:FlxSprite = new FlxSprite().loadGraphic(spritePath);
        sprite.scrollFactor.set(); sprite.scale.set(.7, .7);
        sprite.updateHitbox(); sprite.screenCenter();
        sprite.antialiasing = false;
        sprite.cameras = [camHUD];
        add(sprite);
    }

    if (event.soundPath != null) {
        var sfx = event.soundPath;
        if (!Assets.exists(sfx)) sfx = Paths.sound(sfx);
        var sound:FlxSound = FlxG.sound.play(sfx, event.volume);
    }
}
*/

function onPostCountdown(event)
    event.sprite?.cameras = [camHUD2];