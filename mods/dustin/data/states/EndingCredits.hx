//
import funkin.backend.MusicBeatState;

FULL_VOLUME = true;

var script = importScript("data/scripts/skippableVideoUndertale");
PlayState.isStoryMode = false;

function create() {
    script.call("startVideo", [data + "_ending", () -> {
        MusicBeatState.skipTransOut = true;
        FlxG.switchState(new StoryMenuState());
    }, "mp4", false]);
}