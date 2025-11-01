//
import StringTools;

var stageBloom:CustomShader = null;
var stageLerp:Float = 1;
var stageModulo = 1;

function set_stageModulo(mod:String) stageModulo = Std.parseInt(mod);

function postCreate() if (Options.gameplayShaders && FlxG.save.data.bloom) {
    stageBloom = new CustomShader("bloom");
    //for (i in stage.stageSprites.keys()) if (StringTools.startsWith(i, "stage")) stage.getSprite(i).shader = stageBloom;
    stageBloom.size = 40;
    stageBloom.brightness = 1;
    stageBloom.directions = 8;
    stageBloom.quality = 6;
}

function update() {
    stageLerp = lerp(stageLerp, 1, 0.1);

    if (!Options.gameplayShaders && FlxG.save.data.bloom) return;
    stageBloom.brightness = stageLerp;
    stageBloom.size = 40 * stageLerp;
}

function beatHit(curBeat:Int) if (Options.gameplayShaders && FlxG.save.data.bloom) {
    if (curBeat % stageModulo == 0) {
        for (i in stage.stageSprites.keys()) if (StringTools.startsWith(i, "stage")) {
            stage.getSprite(i).visible = false;
            stage.getSprite(i).shader = null;
        }

        var sprite = stage.getSprite("stage" + (Math.abs(curBeat) % 4));
        sprite.visible = true;
        sprite.shader = stageBloom;
        stageLerp = 2;
    }
}