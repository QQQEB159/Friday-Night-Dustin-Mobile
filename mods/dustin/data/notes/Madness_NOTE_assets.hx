function onNoteCreation(event:NoteCreationEvent) {
    if (!FlxG.save.data.mechanics && event.note.noteType == "Madness_NOTE_assets") {
        event.note.strumTime -= 999999;
        event.note.exists = event.note.active = event.note.visible = false;
        return;
    }
}

function onPlayerMiss(event) {
    if (event.noteType == "Madness_NOTE_assets") {
        event.cancel(true); 
        event.note.strumLine.deleteNote(event.note);
    }
}


function onPlayerHit(event) {
    if (event.noteType == "Madness_NOTE_assets") {
        health -= 0.1;
        angryMode++;
        FlxG.camera.shake(0.01, 0.2);
        var randomPitch:Float = 0.95 + (Math.random() * 0.3);
        FlxG.sound.play(Paths.sound("insanity-note"), 1, false, null, true, randomPitch);
    }

}
