//
import funkin.backend.utils.FlxInterpolateColor;

var _originalInfos = [];

function postCreate() if ((fuck = PlayState.SONG.meta?.customValues) != null)
    _originalInfos = [fuck.mainColor, fuck.character, fuck.stats, fuck.characterX, fuck.characterY];

function onEvent(eventEvent) {
    var params:Array = eventEvent.event.params;
    if (eventEvent.event.name == "Update Pause Infos" && (fuck = PlayState.SONG.meta?.customValues) != null) {
        fuck.character = params[1];
        fuck.stats = StringTools.replace(params[2], "\\n", "\n");

        // basically FlxColor.toWebString but its abstract so i cant use that func directly  - Nex
        var interp = new FlxInterpolateColor(params[0]);
        fuck.mainColor = "#" + StringTools.hex(interp.red * 255, 2) + StringTools.hex(interp.green * 255, 2) + StringTools.hex(interp.blue * 255, 2);

        fuck.characterX = params[3];
        fuck.characterY = params[4];
    }
}

function destroy() if (_originalInfos.length > 0 && (fuck = PlayState.SONG.meta?.customValues) != null) {
    fuck.mainColor = _originalInfos[0];
    fuck.character = _originalInfos[1];
    fuck.stats = _originalInfos[2];
    fuck.characterX = _originalInfos[3];
    fuck.characterY = _originalInfos[4];
}
