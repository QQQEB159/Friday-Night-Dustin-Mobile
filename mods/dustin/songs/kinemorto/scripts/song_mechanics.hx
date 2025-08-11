//
public var bones:FlxSprite;

function create() {
    bones = new FunkinSprite(0, 0, Paths.image("game/mechanics/strum_covering_bones"));
    bones.addAnim('paps', 'bone', 18, true);
    bones.addAnim('sans', 'evil', 18, true);
    bones.animation.play("paps");
    bones.updateHitbox();
    bones.antialiasing = Options.antialiasing;
    bones.cameras = [camHUD];
    bones.x = FlxG.width + bones.width;
    bones.scrollFactor.set();
}

function postCreate() {
    insert(members.indexOf(timeBarBG)-1, bones);
}

var boner:FlxTween = null; // peak var name -lunar
function moveBones(direction:String) {
    if (!FlxG.save.data.mechanics) return;
    
    boner?.cancel();
    var isPaps:Bool = bones.animation.curAnim.name == "paps";

    if(isPaps) bones.screenCenter(FlxAxes.Y);
    else bones.y = -100;
    boner = FlxTween.tween(bones, {x: direction == "appear" ? FlxG.width - (bones.width * (isPaps ? .78 : .95)) : FlxG.width + bones.width}, (Conductor.stepCrochet / 1000) * (direction == "appear" ? 32 : 14), {ease: FlxEase.sineInOut});
}