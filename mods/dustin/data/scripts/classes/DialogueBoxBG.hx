//
import flixel.FlxSprite;

class DialogueBoxBG extends flixel.FlxSprite {
    public var bWidth:Float = 0;
    public var bHeight:Float = 0;

    public var border:Float = 5;

    public var realFuckingCamera:FlxCamera = null; //because there's a shitty bug with setting cameras

    public function new(x:Float, y:Float, sprite=null, width:Float, height:Float, border:Float) {
        super(x, y, null); makeSolid(1, 1, 0xFFFFFFFF);

        bWidth = width; bHeight = height; border = border;
        setBox(bWidth, bHeight, 0xFFFFFFFF);
    }

    public override function draw() {
        if (realFuckingCamera != null) camera = realFuckingCamera;
        setBox(bWidth, bHeight, color);

        super.draw();

        setBox(bWidth-(border*2), bHeight-(border*2), 0xFF000000);
        x += border; y += border;

        super.draw();

        x -= border; y -= border;
    }

    public function setBox(boxWidth:Float, boxHeight:Float, color:FlxColor) {
        colorTransform.color = color;
        scale.set(boxWidth, boxHeight);
        updateHitbox();
    }
}