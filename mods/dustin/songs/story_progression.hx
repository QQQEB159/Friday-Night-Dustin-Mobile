//
import funkin.savedata.FunkinSave;
if (!PlayState.isStoryMode) disableScript();

public var weekToLoad:Dynamic = null;

function create() {
    PlayState.validScore = true;

    FunkinSave.setSongHighscore(PlayState.SONG.meta.name, PlayState.difficulty, null, {
        score: 1,
        misses: misses,
        accuracy: accuracy,
        hits: [],
        date: ""
    }, []);

    FunkinSave.setWeekHighscore(PlayState.storyWeek.id, PlayState.difficulty, {
        score: 1,
        misses: PlayState.campaignMisses,
        accuracy: PlayState.campaignAccuracy,
        hits: [],
        date: ""
    });

    if (PlayState.storyPlaylist.length - 1 <= 0)
        weekToLoad = weekPlaylist[0];
}

function onSongEnd() {
    if (weekToLoad != null)
        for (e in weekToLoad.songs)
            PlayState.storyPlaylist.push(e.name);

    if (weekToLoad != null) weekPlaylist.shift();
}