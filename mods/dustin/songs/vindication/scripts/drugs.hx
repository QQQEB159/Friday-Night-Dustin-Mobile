//
var itslikeprettywarpedtoo:CustomShader = null;
function add_abberation() if (Options.gameplayShaders && FlxG.save.data.chromwarp) camGame.addShader(itslikeprettywarpedtoo);
function remove_abberation() if (Options.gameplayShaders && FlxG.save.data.chromwarp) camGame.removeShader(itslikeprettywarpedtoo);

function postCreate() {
    if (!Options.gameplayShaders) {
        disableScript();
        return;
    }

    itslikeprettywarpedtoo = new CustomShader("chromaticWarp");
}

function update()
    itslikeprettywarpedtoo.distortion = (stage.stageScript.get("stageLerp") - 1) / 1.3;