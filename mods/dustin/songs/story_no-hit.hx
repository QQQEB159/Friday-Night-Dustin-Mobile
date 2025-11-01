//
if (!FlxG.save.data.nh) {
    disableScript();
    return;
}

function postUpdate() {
    if (misses > 0) gameOver();
}