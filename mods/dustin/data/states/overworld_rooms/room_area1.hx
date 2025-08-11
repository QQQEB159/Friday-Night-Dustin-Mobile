//
__overworldResize();
__undertaleFrameRate();

importClass("data.scripts.classes.overworld.MainChara", __script__);
importClass("data.scripts.classes.overworld.RoomLoader", __script__);

public var room:RoomLoader;
public var player:MainChara;

public var bg:FlxSprite;

import flixel.util.FlxSpriteUtil;

function create() {
    room = new RoomLoader(Paths.file("data/overworld/room_area1.tmx"));

    bg = new FlxSprite().loadGraphic(room.imageLayer.image_path);
    add(bg);

    player = room.setupPlayer(NEXT_ENTERANCE == -1 ? 0 : NEXT_ENTERANCE);
    player.rect_rect_collision = rect_rect_collision;
    player.ellipse_line_collision = ellipse_line_collision;

    room.setupCameraBounds();
    //room.setupDebugLayer(bg.width, bg.height);

    overWorldTransition(false, null);
}

function update(elapsed:Float) {
    if (FlxG.keys.justPressed.ESCAPE) {
        exitOverworld();
        FlxG.switchState(new MainMenuState());
    }
}

function destroy() {
    if (NEXT_ROOM != null) return;

    __fnfResize();
    __fnfFrameRate();
}