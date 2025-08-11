//

static function load_save() {
    // if (FlxG.save.data.dustinBoughtStuff == null) FlxG.save.data.dustinBoughtStuff = ["The CD"];
    if (FlxG.save.data.bloom == null) FlxG.save.data.bloom = true;
    if (FlxG.save.data.particles == null) FlxG.save.data.particles = true;
    if (FlxG.save.data.distortion == null) FlxG.save.data.distortion = true;
    if (FlxG.save.data.godrays == null) FlxG.save.data.godrays = true;
    if (FlxG.save.data.fogShader == null) FlxG.save.data.fogShader = true;
    if (FlxG.save.data.gradientShader == null) FlxG.save.data.gradientShader = true;
    if (FlxG.save.data.water == null) FlxG.save.data.water = true;
    if (FlxG.save.data.glitching == null) FlxG.save.data.glitching = true;
    if (FlxG.save.data.impact == null) FlxG.save.data.impact = true;
    if (FlxG.save.data.screenVignette2 == null) FlxG.save.data.screenVignette2 = true;
    if (FlxG.save.data.saturation == null) FlxG.save.data.saturation = true;
    if (FlxG.save.data.static == null) FlxG.save.data.static = true;
    if (FlxG.save.data.blackwhite == null) FlxG.save.data.blackwhite = true;
    if (FlxG.save.data.pixel == null) FlxG.save.data.pixel = true;
    if (FlxG.save.data.iconshader == null) FlxG.save.data.iconshader = true;
    if (FlxG.save.data.tapenoise == null) FlxG.save.data.tapenoise = true;
    if (FlxG.save.data.radial == null) FlxG.save.data.radial = true;
    if (FlxG.save.data.embers == null) FlxG.save.data.embers = true;
    if (FlxG.save.data.flames == null) FlxG.save.data.flames = true;
    if (FlxG.save.data.wi == null) FlxG.save.data.wi = true;
    if (FlxG.save.data.mechanics == null) FlxG.save.data.mechanics = true;

    if (FlxG.save.data.nh == null) FlxG.save.data.nh = false;
    if (FlxG.save.data.dev == null) FlxG.save.data.dev = false;

    FlxG.save.data.dustinBoughtStuff ??= [];
    FlxG.save.data.dustinSeenUnlockAnims ??= [];
    FlxG.save.data.dustinCash ??= 0;
    FlxG.save.data.dustinBeatEverything ??= false;
}

static var FULL_VOLUME:Bool = false;

static var weekPlaylist:Array<Dynamic> = [];
static var weekDifficulty:String = "";