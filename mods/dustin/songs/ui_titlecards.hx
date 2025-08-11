//
import StringTools;
import flixel.text.FlxTypeText;

importClass("data.scripts.classes.DialogueBoxBG", __script__);
importClass("data.scripts.classes.FunkinTypeText", __script__);

class BasicCard extends flixel.FlxObject {
	public var members:Array<FlxBasic> = [];
	public var camera:FlxCamera;
	public var downscroll:Bool = false;

	public var cardBG:FlxSprite;
	public var title:FlxText;
	public var LINE:FlxSprite;
	public var credit:FunkinTypeText;

	public var color:FlxColor = 0xFFFFFFFF;
	public var onComplete:Void->Void;
	public var startingPos:Float = 0;

	public var speedy:Bool = false;

	public function new(x:Int, y:Int, width:Int, height:Int, _title:String, _credit:String, camera:FlxCamera = FlxG.camera, downscroll:Bool = false) {
		this.camera = camera;
		super(x, y);

		cardBG = new DialogueBoxBG(0, 0, null, Math.ceil(camera.width / 1.994), Math.ceil(camera.height / 4.3), 5);
		cardBG.setPosition((camera.width - cardBG.width)/2, startingPos = ((this.downscroll = downscroll) ? -30 -cardBG.height  : camera.height + 30));
		cardBG.realFuckingCamera = camera;
		members.push(cardBG);

		// the capital o for the heart inside  - Nex
		title = new FlxText(0, 0, 0, _title);
		title.setFormat(Paths.font("fallen-down.ttf"), Math.floor(cardBG.width / 20)+2, color);
		title.textField.antiAliasType = 0/*ADVANCED*/;
    	title.textField.sharpness = 400/*MAX ON OPENFL*/;
		title.cameras = [camera];
		title.updateHitbox();
		members.push(title);

		LINE = new FlxSprite().makeSolid(cardBG.width - 100, Math.round(cardBG.height / 33.6), color);
		LINE.cameras = [camera];
		LINE.scale.x = 0;
		members.push(LINE);

		credit = new FunkinTypeText(cardBG.x, cardBG.y + cardBG.height/2 + 100, cardBG.width, _credit);

		// FIX CUSTOM CLASSES
		// credit.alignment = "center";
		Reflect.setProperty(credit, "alignment", "center");

		credit.setFormat(Paths.font("8bit-jve.ttf"), Math.floor(cardBG.width / 20), color);
		credit._defaultFormat.letterSpacing = 1;
		credit.updateDefaultFormat();
		credit.realFuckingCamera = camera;
		credit.sound = new FlxSound().loadEmbedded(Paths.sound("default_text"));
		members.push(credit);
	}

	var oldLength = 0;
	public override function update(elapsed:Float) {
		super.update(elapsed);

		title.setPosition(cardBG.x + 5 + (cardBG.width/2) - (title.width/2), cardBG.y + 4);
		LINE.setPosition(cardBG.x + 50, title.y + title.height);

		credit.setPosition(cardBG.x, title.y + title.height + 5);
		credit.update(elapsed);

		credit.color = title.color = LINE.color = cardBG.color = color;
	}

	public override function draw() {
		for (member in members) member.draw();
	}

	public function start() {
		var daY:FLoat = camera.height / 1.6;
		if(downscroll) daY = camera.height - daY - cardBG.height;
		FlxTween.tween(cardBG, {y: daY}, (Conductor.crochet/1000) * 3, {ease: FlxEase.quartOut});
		new FlxTimer().start((Conductor.crochet/1000) * (speedy ? 1.5 : 3), function(tmr:FlxTimer) {
			credit.visible = true;
			credit.start(((Conductor.stepCrochet/1000)/2));
			FlxTween.tween(LINE.scale, {x: cardBG.width - 100}, (Conductor.crochet/1000) * 4, {ease: FlxEase.circOut});
			credit.completeCallback = function() FlxTween.tween(cardBG, {y: startingPos}, 1, {ease: FlxEase.quadIn, startDelay: 3 * (speedy ? .5 : 1), onComplete: onComplete});
 		});
	}
}

static var titleCard:BasicCard;
static var oldAlphas:Array<Float> = [];
static var fullColor:FlxColor = null;
static var doHealthbarFade:Bool = true;

static var autoTitleCard:Bool = true;

function create() {
	autoTitleCard = true;
	fullColor = null; doHealthbarFade = true;

	fullColor = FlxColor.fromString(PlayState.SONG.meta?.customValues?.mainColor);
	if (fullColor == null) fullColor = 0xFFFFFFFF;
}

function postCreate() {
	var credit:String = "* Someone made this song/pause(0.5)/\n  but you dont know who";
	if (SONG.meta?.customValues?.titleCardSubtext != null)
		credit = SONG.meta.customValues.titleCardSubtext;

	titleCard = new BasicCard(0, 0, 0, 0, SONG.meta?.customValues?.customName != null ? SONG.meta.customValues.customName : SONG.meta.name, credit, camHUD2, downscroll);
	titleCard.screenCenter(FlxAxes.XY); titleCard.color = fullColor;
	insert(members.indexOf(accuracyTxt)+1, titleCard);
}

function onSongStart() {
	if (!autoTitleCard) return;

	showTitleCard();
}

public function showTitleCard() {
	oldAlphas = [for (item in [dustinHealthBG, dustinHealthBar, dustiniconP1, dustiniconP2]) item.alpha];
	if (doHealthbarFade) {
		for (item in [dustinHealthBG, dustinHealthBar, dustiniconP1, dustiniconP2])
			if (item.alpha > 0) FlxTween.tween(item, {alpha: 0}, .5, {ease: FlxEase.circOut});
	}

	titleCard.onComplete = (_) -> {
		if (doHealthbarFade) {
			for (i=>item in [dustinHealthBG, dustinHealthBar, dustiniconP1, dustiniconP2])
				FlxTween.tween(item, {alpha: oldAlphas[i]}, .3, {ease: FlxEase.circIn});
		}
		remove(titleCard);
	};
	titleCard.start();
}