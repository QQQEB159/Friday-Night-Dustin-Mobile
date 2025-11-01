// Prob a temp script, made it rq  - Nex
var idk = 0;
var mult;

function onStrumCreation(e) {
    finalNotesScale = 0.65;
    mult = 0;

    if (idk > 7) {
        if (e.__doAnimation) {
            e.cancelAnimation();
            e.strum.y -= 10;
            e.strum.alpha = 0;
            FlxTween.tween(e.strum, {y: e.strum.y + 10, alpha: 0.5}, 1, {ease: FlxEase.circOut, startDelay: 0.5 + (0.2 * e.strumID)});
        }
        else e.strum.alpha = 0.5;

        finalNotesScale = 0.5;
        mult = -20;
    }

    idk++;
}

function onPostStrumCreation(e)
    e.strum.x += mult * e.strumID;

function onNoteCreation(e) {
    finalNotesScale = e.strumLineID > 1 ? 0.5 : 0.65;
}

function postCreate()
    finalNotesScale = 0.65;