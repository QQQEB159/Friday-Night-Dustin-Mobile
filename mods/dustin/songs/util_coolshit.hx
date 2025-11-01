//
static var hudElements:Array<FlxBasic> = [];
static var camHUD2:FlxCamera = null;

function create() {
    downscroll = Options.downscroll;
    hudElements = []; allowGitaroo = false;
    PauseSubState.script = "data/states/UndertalePause.hx";
    GameOverSubstate.script = "data/scripts/gameOverUndertale";
    camHUD2 = new FlxCamera();
    camHUD2.bgColor = 0x00000000;
    camHUD2.visible = true;
    FlxG.cameras.add(camHUD2, false);
}

function update(elapsed:Float) {
    camHUD2.visible = true;
    for (strumLine in strumLines) {
        strumLine.notes.forEachAlive(function (note:Note) {
            note.alpha = strumLine.members[note.noteData%4].alpha * (note.isSustainNote ? 0.6 : 1);
            if (note.health != -1) note.angle = strumLine.members[note.noteData%4].angle;
        });
    }
}

// cause sojas flixel is brainrot
public function insert_camera(newCamera:FlxCamera, position:Int, defaultDrawTarget = true):T {
    if (position < 0)
        position += FlxG.cameras.list.length;
    
    if (position >= FlxG.cameras.list.length)
        return FlxG.cameras.add(newCamera);
    
    final childIndex = FlxG.game.getChildIndex(FlxG.cameras.list[position].flashSprite);
    FlxG.game.addChildAt(newCamera.flashSprite, childIndex);
    
    FlxG.cameras.list.insert(position, newCamera);
    if (defaultDrawTarget)
        FlxG.cameras.defaults.push(newCamera);
    
    for (i in position...(FlxG.cameras.list.length))
        FlxG.cameras.list[i].ID = i;
    
    FlxG.cameras.cameraAdded.dispatch(newCamera);
    return newCamera;
}

function draw(e) {
    FlxG.camera.zoom = Math.floor(FlxG.camera.zoom * 10000) / 10000;
    camHUD.zoom = Math.floor(camHUD.zoom * 10000) / 10000;
}

function onEvent(eventEvent) {
    var params:Array = eventEvent.event.params;
    if (eventEvent.event.name == "Scroll Speed Change") {
        if (!FlxG.save.data.mechanics) eventEvent.cancel(true);
    }
}