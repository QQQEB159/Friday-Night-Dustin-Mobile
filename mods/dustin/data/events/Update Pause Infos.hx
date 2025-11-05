//
import funkin.backend.utils.FlxInterpolateColor;

var _originalInfos = [];
if (PlayState.SONG.meta.customValues == null) {
    disableScript();
    return;
}

function postCreate() {
    _originalInfos = [PlayState.SONG.meta.customValues.mainColor, PlayState.SONG.meta.customValues.character, PlayState.SONG.meta.customValues.stats, PlayState.SONG.meta.customValues.characterX, PlayState.SONG.meta.customValues.characterY];
}

function onEvent(eventEvent) {
    var params:Array = eventEvent.event.params;
    if (eventEvent.event.name == "Update Pause Infos") {
        PlayState.SONG.meta.customValues.character = params[1];
        PlayState.SONG.meta.customValues.stats = StringTools.replace(params[2], "\\n", "\n");

        // basically FlxColor.toWebString but its abstract so i cant use that func directly  - Nex
        var interp = new FlxInterpolateColor(params[0]);
        PlayState.SONG.meta.customValues.mainColor = "#" + StringTools.hex(interp.red * 255, 2) + StringTools.hex(interp.green * 255, 2) + StringTools.hex(interp.blue * 255, 2);

        PlayState.SONG.meta.customValues.characterX = params[3];
        PlayState.SONG.meta.customValues.characterY = params[4];
    }
}

function destroy() if (_originalInfos.length > 0 && PlayState.chartingMode) {
    PlayState.SONG.meta.customValues.mainColor = _originalInfos[0];
    PlayState.SONG.meta.customValues.character = _originalInfos[1];
    PlayState.SONG.meta.customValues.stats = _originalInfos[2];
    PlayState.SONG.meta.customValues.characterX = _originalInfos[3];
    PlayState.SONG.meta.customValues.characterY = _originalInfos[4];
}
