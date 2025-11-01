import funkin.ui.FunkinText;
import flixel.tweens.FlxTweenType;

function postCreate() {
    strumLines.members[1].forEach(function(obj:Strum) {
        obj.cpu = true;
    });

    strumLines.members[1].onNoteUpdate.add(function(event) {
        event.cancel();

        var sl = strumLines.members[1];

        var ignoredNoteTypes:Array<String> = ["Madness_NOTE_assets", "NOTE_karma", "NOTE_hate"];

        if (ignoredNoteTypes.indexOf(event.note.noteType) != -1) {
            if (event.__autoCPUHit && event.note.strumTime < sl.__updateNote_songPos) {
                event.note.tooLate = true;
            }
        } else {
            if (event.__updateHitWindow) {
                event.note.canBeHit = (event.note.strumTime > sl.__updateNote_songPos - (PlayState.instance.hitWindow * event.note.latePressWindow)
                    && event.note.strumTime < sl.__updateNote_songPos + (PlayState.instance.hitWindow * event.note.earlyPressWindow));

                if (event.note.strumTime < sl.__updateNote_songPos - PlayState.instance.hitWindow && !event.note.wasGoodHit)
                    event.note.tooLate = true;
            }

            if (event.__autoCPUHit && !event.note.avoid && !event.note.wasGoodHit && event.note.strumTime < sl.__updateNote_songPos) {
                PlayState.instance.goodNoteHit(sl, event.note);
            }

            if (event.note.wasGoodHit && event.note.isSustainNote && event.note.strumTime + (event.note.sustainLength) < sl.__updateNote_songPos) {
                deleteNote(event.note);
                return;
            }

            if (event.strum == null) return;

            if (event.__reposNote) event.strum.updateNotePosition(event.note);
            if (event.note.isSustainNote)
                event.note.updateSustain(event.strum);
        }
    });

    strumLines.members[1].onHit.add(function(event) {
        event.preventStrumGlow();
        
        if (event.note.__strum != null && event.note.__strum.press != null) {
            event.note.__strum.press(event.note.strumTime - (event.note.isSustainNote ? (event.note.nextSustain != null ? 0 : Conductor.crochet / 6.1) : (event.note.nextNote.isSustainNote ? 0 : Conductor.crochet / 6.1)));
        } else {
            trace("Error: __strum or press method is not defined.");
        }
    });
}

function onInputUpdate(event) {
    event.cancel();
}

function onNoteCreation(event:NoteCreationEvent) {
    var ignoredNoteTypes:Array<String> = ["Madness_NOTE_assets", "NOTE_karma", "NOTE_hate"];

    if (!FlxG.save.data.mechanics && ignoredNoteTypes.indexOf(event.note.noteType) != -1) {
        event.note.strumTime -= 999999;
        event.note.exists = event.note.active = event.note.visible = false;
        return;
    }
}

function onPlayerMiss(event) {
    var ignoredNoteTypes:Array<String> = ["Madness_NOTE_assets", "NOTE_karma", "NOTE_hate"];

    if (ignoredNoteTypes.indexOf(event.noteType) != -1) {
        event.cancel(true); 
        event.note.strumLine.deleteNote(event.note);
    }
}

function onPlayerHit(event) {
    var ignoredNoteTypes:Array<String> = ["Madness_NOTE_assets", "NOTE_karma", "NOTE_hate"];

    if (ignoredNoteTypes.indexOf(event.noteType) != -1) {
        event.cancel(true);
    }
}