//
public var contrast:CustomShader;

function create() {
    if(!Options.gameplayShaders || !FlxG.save.data.saturation) {
        disableScript();
        return;
    }

    contrast = new CustomShader("saturation");
    contrast.contrast = 1;
    contrast.sat = 1;
    FlxG.camera.addShader(contrast);
    camHUD.addShader(contrast);
}


var contrastTween:FlxTween = null;
var curcontrast:Float = 1;

function onEvent(eventEvent) {
    var params:Array = eventEvent.event.params;
    if (eventEvent.event.name == "Contrast Effect") {
        if (params[0] == false)
            contrast.contrast = curcontrast = params[1];
        else {
            if (contrastTween != null) contrastTween.cancel();
            var flxease:String = params[3] + (params[3] == "linear" ? "" : params[4]);

            contrastTween = FlxTween.num(curcontrast, params[1], ((Conductor.crochet / 4) / 1000) * params[2], 
            {ease: Reflect.field(FlxEase, flxease)}, (val:Float) -> {contrast.contrast = curcontrast = val;});
        }
    }
}