//
function create()
    strumLines.members[1].onNoteUpdate.add(onNoteUpdate);

function onNoteUpdate(e:NoteUpdateEvent) {
    var note:Note = e.note;

    if (note.noteType != "STOLEN") return;

    note.extra["overrideRating"] = "bad";

    if (note.extra["wasMoved"]) {
        note.extra["wasMoved"] = false;
        e.__reposNote = false;
        return;
    }

    var finishedWindow:Float = hitWindow * 0.5 * 2.4 * 1.75;
    var startWindow:Float = finishedWindow * 2.6;
    var timeUntilNote:Float = note.strumTime - Conductor.songPosition;

    var strumTo:Strum = strumLines.members[1].members[note.noteData];
    var baseScrollFactor:Float = 0.45 * CoolUtil.quantize(scrollSpeed, 100);

    var posx:Float = strumTo.x + ((strumTo.width - note.width) / 2);
    var startX:Float = posx - ((FlxG.width * 0.75) - (FlxG.width * 0.25));

    var progress:Float = 1 - ((timeUntilNote - finishedWindow) / (startWindow - finishedWindow));
    progress = FlxEase.circInOut(FlxMath.bound(progress, 0, 1));
    if (!FlxG.save.data.mechanics) progress = 1; 

    var lerpedX:Float = 0;
    if (timeUntilNote >= startWindow) {
        lerpedX = startX;
    } else if (timeUntilNote <= finishedWindow) {
        lerpedX = posx;
    } else {
        lerpedX = FlxMath.lerp(startX, posx, progress);
    }

    e.__reposNote = false;
    note.extra["wasMoved"] = true;

    var posy:Float = timeUntilNote * baseScrollFactor;
    if (note.isSustainNote) posy += Strum.N_WIDTHDIV2;
    posy += strumTo.y;

    note.y = posy;
    note.x = lerpedX;

    var curTail:Note = note.nextNote;
    while (curTail != null && curTail.isSustainNote) {
        var tailOffset:Float = curTail.strumTime - Conductor.songPosition;
        var tailY:Float = tailOffset * baseScrollFactor;
        if (curTail.isSustainNote) tailY += Strum.N_WIDTHDIV2;
        tailY += strumTo.y;

        var centeredTailX:Float = lerpedX + ((note.width - curTail.width) / 2);

        curTail.y = tailY;
        curTail.x = centeredTailX;
        curTail.extra["wasMoved"] = true;

        curTail = curTail.nextNote;
    }
}
