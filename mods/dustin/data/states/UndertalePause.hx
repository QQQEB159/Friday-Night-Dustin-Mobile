//
import funkin.backend.chart.Chart;

PlayState.instance.scripts.importScript("data/scripts/DialogueBoxBG");
PlayState.instance.scripts.importScript("data/scripts/FunkinTypeText");

var bottom:FunkinSprite;
var top:FunkinSprite;
var heart:FunkinSprite;
var statTextObj;
var statText:FunkinTypeText;

var meta:ChartData = PlayState.SONG.meta;
var utItems:Array<FlxSprite> = [];
function create(_) {
	_.cancel();
	add(top = newDialogueBoxBG(-Math.floor(FlxG.width / 4.06), Math.floor(FlxG.height * 0.084), null, Math.floor(FlxG.width / 4.74), Math.floor(FlxG.height / 2.285), 5));
	add(bottom = newDialogueBoxBG(top.x, top.y + top.extra["bHeight"] + Math.floor(FlxG.height * 0.056), null, Math.floor(FlxG.width /1.765), Math.floor(FlxG.height / 3.2), 5));
	top.color = fullColor; bottom.color = fullColor;

	__offsets = [Math.floor(top.extra["bWidth"] * 0.2595), Math.floor(bottom.extra["bWidth"] * 0.049), bottom.extra["bWidth"] * 0.05863];

	var statsDescription:String = meta?.customValues?.stats;
	statTextObj = newFunkinTypeText(bottom.x + Math.floor(FlxG.width * 0.0395), bottom.y + Math.floor(FlxG.height * 0.043), bottom.extra["bWidth"] - bottom.extra["border"] - 15, statsDescription != null ? statsDescription : "* GASTER ?? ATK, ?? DEF\n* Dark, yet darker.\n* You are not supposed to see this.");
	statText = statTextObj.flxtext;
	statText.setFormat(Paths.font("8bit-jve.ttf"), Math.floor(bottom.extra["bWidth"] / 19), fullColor);
	statText._defaultFormat.letterSpacing = Math.floor(bottom.extra["bWidth"] * 0.0042);
	statText._defaultFormat.leading = Math.floor(bottom.extra["bWidth"] / 36);
	statText.updateDefaultFormat();
	statTextObj.sound = new FlxSound().loadEmbedded(Paths.sound("default_text"));

	statTextObj.start(null, statTextObj);
	add(statText);

	add(grpMenuShit = new FlxGroup());

	var fakeItems = [
		"RESUME",
		"RESTART",
		"CONTROLS",
		"OPTIONS",
		"EXIT"
	];

	for (i=>item in menuItems) {
		var itemTxt = new FlxText(top.x + __offsets[0], top.y + Math.floor(top.extra["bHeight"] * 0.09) + (Math.floor(top.extra["bHeight"] * 0.851) / menuItems.length) * i, 0, fakeItems[i] != null ? fakeItems[i] : item.toUpperCase());
		itemTxt.setFormat(Paths.font("8bit-jve.ttf"), Math.floor(top.extra["bWidth"] * 0.141), fullColor);
		itemTxt._defaultFormat.letterSpacing = Math.floor(top.extra["bWidth"] * 0.02);
		itemTxt.updateDefaultFormat();

		itemTxt.textField.antiAliasType = 0;
        itemTxt.textField.sharpness = 400;

		add(itemTxt);
		utItems.push(itemTxt);
	}

	var soulType:Bool = PlayState.SONG.meta?.customValues?.gameover?.isMonster == true;
    var heartPath:String = soulType ? "game/gameover/monster_heart" : "game/gameover/heart";

	var idk:Int = Math.floor(top.extra["bWidth"] * 0.093);
	heart = new FunkinSprite().loadGraphic(Paths.image(heartPath));
	if (FlxG.width == 640) heart.scale.set(16/1024, 16/1024);
	else heart.scale.set(24/1024, 24/1024);
	heart.updateHitbox();
	heart.antialiasing = false;
	add(heart);

	var charName = PlayState.SONG.meta?.customValues?.character;
	if (charName == null) charName = meta.name;
	var character = new FunkinSprite(FlxG.width, FlxG.height * 0.4515).loadGraphic(Paths.image("game/ui/pause/characterIcons/" + charName));
	add(character);
	idk = Math.floor(FlxG.width * 0.0032);
	if ((character.x + character.width) * idk > FlxG.width) idk = (character.x - character.width) * 0.0032;
	character.scale.set(idk, idk);

	var charOffsetX:Float = 0;
	var charOffsetY:Float = 0;
	if (PlayState.SONG.meta?.customValues?.characterX != null)
		charOffsetX = Std.parseFloat(meta.customValues.characterX);
	if (PlayState.SONG.meta?.customValues?.characterY != null)
		charOffsetY = Std.parseFloat(meta.customValues.characterY);

	camera = new FlxCamera();
	camera.bgColor = 0xAB000000;
	camera.pixelPerfectRender = true;
	FlxG.cameras.add(camera, false);

	top.cameras = [camera];
	bottom.cameras = [camera];

	changeSelection(0);
	FlxTween.tween(top, {x: top.y}, 0.5, {ease: FlxEase.backOut});
	FlxTween.tween(bottom, {x: top.y}, 0.6, {ease: FlxEase.backOut});
	character.y += charOffsetY;
	FlxTween.tween(character, {x: switch (charName.toLowerCase()) {
		case "homiecide": 900;
		default: Math.floor(FlxG.width / 1.312);
	} + charOffsetX}, 0.6, {ease: FlxEase.backOut, startDelay: 0.1});
	
	if(PlayState.SONG.meta.name == "genocides") {
	addTouchPad('UP_DOWN_Q', 'A_Q');
	addTouchPadCamera();
	} else {
	addTouchPad('UP_DOWN', 'A');
	addTouchPadCamera();
	}
}

var __offsets:Array<Int>;
function update(elapsed:Float) {
	var upP = controls.UP_P || (touchPad.buttonUp.justPressed && touchPad.buttonUp != null);
	var downP = controls.DOWN_P || (touchPad.buttonDown.justPressed && touchPad.buttonDown != null);
	var accepted = controls.ACCEPT || (touchPad.buttonA.justPressed && touchPad.buttonA != null);

	var change = (upP ? -1 : 0) + (downP ? 1 : 0) - FlxG.mouse.wheel;
    if (change != 0) changeSelection(change, false);

	if (accepted)
		selectOption();

	for (i in utItems) 
		i.x = top.x + __offsets[0];
	statText.x = bottom.x + __offsets[1];
	heart.x = utItems[curSelected]?.x - __offsets[2];

	updateFunkinTypeText(elapsed, statTextObj);
}

function onChangeItem(e) {
	FlxTween.cancelTweensOf(heart);
	FlxTween.tween(heart, {y: utItems[e.value]?.y + (utItems[e.value].height - heart.height)/2}, 0.25, {ease: FlxEase.backOut});
	CoolUtil.playMenuSFX();

	for (i in 0...utItems.length)
		utItems[i].alpha = (i == e.value) ? 1 : 0.6;
}

function onSelectOption(e)
	FlxG.sound.play(Paths.sound("menu/select"));