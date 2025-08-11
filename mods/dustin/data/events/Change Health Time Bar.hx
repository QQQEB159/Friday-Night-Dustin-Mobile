var cached:Array<String> = [];

function postCreate() {
    for (event in PlayState.SONG.events)
        if (event.name == "Change Health Time Bar" && cached.indexOf(event.params[0]) == -1) {
            graphicCache.cache(Paths.image("game/ui/healthbar_" + event.params[0]));
            if (Assets.exists(Paths.image("game/ui/healthbar_fill_" + event.params[0]))) 
                graphicCache.cache(Paths.image("game/ui/healthbar_fill_" + event.params[0]));
            graphicCache.cache(Paths.image("game/ui/timebar_" + event.params[0]));
            graphicCache.cache(Paths.image("game/ui/timebar_fill_" + event.params[0]));
        }
}

function onEvent(_) {
    var params:Array = _.event.params;
    if (_.event.name == "Change Health Time Bar") {
        var timeIndex:Int = members.indexOf(timeBarBG);
        var healthIndex:Int = members.indexOf(dustinHealthBG);

        remove(timeBarBG);
        remove(dustinHealthBG);

        hudElements.remove(timeBarBG);
        hudElements.remove(dustinHealthBG);

        timeBarBG = createTimeBG(params[0]);
        dustinHealthBG = createHealthBG(params[0]);

        insert(timeIndex, timeBarBG);
        insert(healthIndex, dustinHealthBG);

        hudElements.push(timeBarBG);
        hudElements.push(dustinHealthBG);
    }
}