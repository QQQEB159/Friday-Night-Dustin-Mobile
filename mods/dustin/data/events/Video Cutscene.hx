//
import hxvlc.flixel.FlxVideoSprite;
import haxe.MainLoop;

public var videoCam:FlxCamera;
public var preloadedVideos:Map<String, FlxVideoSprite> = [];

function create() {
    videoCam = new FlxCamera(0, 0);
    videoCam.bgColor = 0x00000000;
    insert_camera(videoCam, FlxG.cameras.list.indexOf(camHUD), false);

    for (event in PlayState.SONG.events) {
        if (event.name == "Video Cutscene" && !preloadedVideos.exists(event.params[0])) {
            var vid:FlxVideoSprite = new FlxVideoSprite();
            vid.bitmap.onFormatSetup.add(function() {
                final width = vid.bitmap.bitmapData.width;
                final height = vid.bitmap.bitmapData.height;
                final scale:Float = Math.min(videoCam.width / width, videoCam.height / height);
                vid.setGraphicSize(Std.int(width * scale), Std.int(height * scale));
                vid.updateHitbox();
                vid.screenCenter();
            });
            vid.autoPause = false; // in haxelib version but NOT git version??? -lunar
            vid.load(Assets.getPath(Paths.video(event.params[0], event.params[1])));
            vid.cameras = [videoCam]; vid.antialiasing = Options.antialiasing; vid.visible = false;

            vid.bitmap.onEndReached.add(function () {
                vid.visible = false;
                remove(vid);
                vid.destroy();
            });

            preloadedVideos.set(event.params[0], vid);
        }
    }
}

function onEvent(_) {
    var params:Array = _.event.params;
    if (_.event.name == "Video Cutscene") {
        var video:FlxVideoSprite = preloadedVideos.get(params[0]);
        if (video == null || video.visible == true) return;

        video.visible = true;
        video.play();
        insert(99999, video);
    }
}

function onGamePause(event) {
    for (name => vid in preloadedVideos) 
        if (vid.visible) vid.pause();
}

function onSubstateClose(event) {
    for (name => vid in preloadedVideos) 
        if (vid.visible) vid.resume();
}

function onFocus() {
    if (!FlxG.autoPause || paused) return;
    for (name => vid in preloadedVideos) 
        if (vid.visible) vid.resume();
}

function onFocusLost() {
    if (!FlxG.autoPause || paused) return;
    for (name => vid in preloadedVideos) 
        if (vid.visible) vid.pause();
}