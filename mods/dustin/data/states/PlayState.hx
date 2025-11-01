//
import funkin.game.cutscenes.VideoCutscene;

var name:String = null;
function onOpenSubState(e) if (e.substate is VideoCutscene) {
    e.cancelled = true;
    subState = null;

    FULL_VOLUME = true;

    script = importScript("data/scripts/skippableVideoUndertale");
    dustCall = e.substate.__callback;
    name = e.substate.path;
    script.call("startVideo", [name, finishDustin]);
}

function finishDustin() {
    script.destroy();
    if (dustCall != null) dustCall();

    if (name == "assets/videos/the-uprising-end-cutscene.mp4")
        FlxG.switchState(new ModState("EndingCredits", "genocide"));

    if (name == "assets/videos/you-are-end-cutscene.mp4")
        FlxG.switchState(new ModState("EndingCredits", "pacifist"));
}