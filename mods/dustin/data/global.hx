//

importScript("data/global_collision");
importScript("data/global_overworld");
importScript("data/global_saves");
importScript("data/global_utils");
importScript("data/global_window");

import funkin.backend.utils.NativeAPI;
import funkin.backend.utils.WindowUtils;
import lime.graphics.Image;
import hxvlc.util.Handle;
import haxe.io.Path;

import Type;
import Sys;

function new() {
    Handle.init([]);

    if (!Assets.exists(Paths.image('DO_NOT_DELETE', null, false, 'jpg'))) {
        NativeAPI.showMessageBox('WHY', 'HOW DRE YOU!! >:((');
        Sys.exit(0);
    }

    load_save();

    // WindowUtils.winTitle = window.title = "Friday Night Dustin'";
    // window.setIcon(Image.fromBytes(Assets.getBytes(Paths.image('game/heart'))));
}

function preStateCreate() {
	FlxG.game.setFilters([]);
}