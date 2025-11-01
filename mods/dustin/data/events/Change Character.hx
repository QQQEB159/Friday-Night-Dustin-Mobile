var preloadedCharacters:Map<String, Character> = [];

function postCreate() {
    for (event in PlayState.SONG.events)
        if (event.name == "Change Character" && !preloadedCharacters.exists(event.params[1])) {
            // Look for character that alreadly exists
            /*var foundPreExisting:Bool = false;  // sorry lunar but this can lead to several bugs and kinda breaks easily since youre not copying the character but literally stealing it  - Nex
            for (strum in strumLines)
                for (char in strum.characters)
                    if (char.curCharacter == event.params[1]) {
                        preloadedCharacters.set(event.params[1], char);
                        graphicCache.cache(Paths.image("icons/" + char.getIcon()));
                        foundPreExisting = true; break;
                    }
            if (foundPreExisting) continue;*/

            // Create New Character
            var strumLine = strumLines.members[event.params[0]];
            var oldCharacter = strumLine.characters[0];
            var newCharacter = new Character(oldCharacter.x, oldCharacter.y, event.params[1], stage.isCharFlipped(event.params[1], oldCharacter.isPlayer));
            stage.applyCharStuff(newCharacter, strumLine.data.position == null ? (switch(strumLine.data.type) {
				case 0: "dad";
				case 1: "boyfriend";
				case 2: "girlfriend";
			}) : strumLine.data.position, 0);
            newCharacter.active = newCharacter.visible = false;
            newCharacter.drawComplex(FlxG.camera); // Push to GPU
            preloadedCharacters.set(event.params[1], newCharacter);
            graphicCache.cache(Paths.image("icons/" + newCharacter.getIcon()));
        }
}

function onEvent(_) {
    var params:Array = _.event.params;
    if (_.event.name == "Change Character") {
        // Change Character
        var oldCharacter = strumLines.members[params[0]].characters[0];
        var newCharacter = preloadedCharacters.get(params[1]);  // ehhh this breaks if there were two same preloaded character, for now its not an issue though  - Nex
        if (oldCharacter.curCharacter == newCharacter.curCharacter) return;

        insert(members.indexOf(oldCharacter), newCharacter);
        newCharacter.active = newCharacter.visible = true;
        remove(oldCharacter);

        if (stage.characterPoses[params[1]] == null) newCharacter.setPosition(oldCharacter.x, oldCharacter.y);
        if (newCharacter.hasAnim(oldCharacter.getAnimName())) newCharacter.playAnim(oldCharacter.getAnimName(), true, oldCharacter.lastAnimContext, false, oldCharacter.animation?.curAnim?.curFrame);
        strumLines.members[params[0]].characters[0] = newCharacter;

        // Change Icon
        if (params[0] <= 1) {
            var oldIcon = params[0] == 1 ? dustiniconP1 : dustiniconP2;
            oldIcon.loadGraphicFromSprite(createHealthIcon(newCharacter.getIcon(), params[0] == 1));
            if(Options.colorHealthBar && healthBarColors != null && newCharacter.iconColor != null) {
                var i:Int = params[0] == 1 ? 1 : 0;
                ogHealthColors[i] = healthBarColors[i] = newCharacter.iconColor;
            }
        }   
    }
}