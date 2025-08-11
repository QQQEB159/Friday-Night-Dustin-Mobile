//
importClass("data.scripts.classes.DialogueBoxBG", __script__);
importClass("data.scripts.classes.FunkinTypeText", __script__);

var bottom:FunkinSprite;
var top:FunkinSprite;
var heart:FunkinSprite;
var statText:FunkinTypeText;

function create(_) {
	_.cancel();

	add(top = new DialogueBoxBG(-Math.floor(FlxG.width / 4.06), Math.floor(FlxG.height * 0.084), null, Math.floor(FlxG.width / 4.74), Math.floor(FlxG.height / 2.285), 5));
	add(bottom = new DialogueBoxBG(top.x, top.y + top.height + Math.floor(FlxG.height * 0.056), null, Math.floor(FlxG.width /1.765), Math.floor(FlxG.height / 3.2), 5));
	top.color = fullColor; bottom.color = fullColor;

	__offsets = [Math.floor(top.width * 0.2595), Math.floor(bottom.width * 0.049), bottom.width * 0.05863];

	var statsDescription:String = PlayState.SONG.meta?.customValues?.stats;
	statText = new FunkinTypeText(bottom.x + Math.floor(FlxG.width * 0.0395), bottom.y + Math.floor(FlxG.height * 0.043), bottom.width - bottom.border - 15, statsDescription != null ? statsDescription : "* GASTER ?? ATK, ?? DEF\n* Dark, yet darker.\n* You are not supposed to see this.");
	statText.setFormat(Paths.font("8bit-jve.ttf"), Math.floor(bottom.width / 19), fullColor);
	statText._defaultFormat.letterSpacing = Math.floor(bottom.width * 0.0042);
	statText._defaultFormat.leading = Math.floor(bottom.width / 36);
	statText.updateDefaultFormat();
	statText.sound = new FlxSound().loadEmbedded(Paths.sound("default_text"));

	statText.textField.antiAliasType = 0/*ADVANCED*/;
	statText.textField.sharpness = 400/*MAX ON OPENFL*/;

	statText.start();
	add(statText);

	add(grpMenuShit = new FlxTypedGroup());

	var fakeItems = [
		"RESUME",
		"RESTART",
		"CONTROLS",
		"OPTIONS",
		"EXIT"
	];

	for (i=>item in menuItems) {
		var itemTxt = new FlxText(top.x + __offsets[0], top.y + Math.floor(top.height * 0.09) + (Math.floor(top.height * 0.851) / menuItems.length) * i, 0, fakeItems[i] != null ? fakeItems[i] : item.toUpperCase());
		itemTxt.setFormat(Paths.font("8bit-jve.ttf"), Math.floor(top.width * 0.141), fullColor);
		itemTxt._defaultFormat.letterSpacing = Math.floor(top.width * 0.02);
		itemTxt.updateDefaultFormat();

		itemTxt.textField.antiAliasType = 0/*ADVANCED*/;
        itemTxt.textField.sharpness = 400/*MAX ON OPENFL*/;

		grpMenuShit.add(itemTxt);
	}

	var idk:Int = Math.floor(top.width * 0.093);
	heart = new FunkinSprite().loadGraphic(Paths.image("game/heart"));
	if (FlxG.width == 640) heart.scale.set(16/1024, 16/1024);
	else heart.scale.set(24/1024, 24/1024);
	heart.updateHitbox();
	heart.antialiasing = false;
	add(heart);

	var charName = PlayState.SONG.meta?.customValues?.character;
	if (charName == null) charName = PlayState.SONG.meta.name;
	var character = new FunkinSprite(FlxG.width, FlxG.height * 0.4515).loadGraphic(Paths.image("game/ui/pause/characterIcons/" + charName));
	add(character);
	idk = Math.floor(FlxG.width * 0.0032);
	if ((character.x + character.width) * idk > FlxG.width) idk = (character.x - character.width) * 0.0032;
	character.scale.set(idk, idk);

	var charOffsetX:Float = 0;
	var charOffsetY:Float = 0;
	if (PlayState.SONG.meta?.customValues?.characterX != null)
		charOffsetX = Std.parseFloat(PlayState.SONG.meta.customValues.characterX);
	if (PlayState.SONG.meta?.customValues?.characterY != null)
		charOffsetY = Std.parseFloat(PlayState.SONG.meta.customValues.characterY);

	camera = new FlxCamera();
	camera.bgColor = 0xAB000000;
	camera.pixelPerfectRender = true;
	FlxG.cameras.add(camera, false);

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

	//copy pasted cuz of the stupid __cancelDefault..
	var upP = controls.UP_P || touchPad.buttonUp.justPressed;
	var downP = controls.DOWN_P || touchPad.buttonDown.justPressed;
	var accepted = controls.ACCEPT || touchPad.buttonA.justPressed;

	if (upP)
		changeSelection(-1);
	if (downP)
		changeSelection(1);
	if (accepted)
		selectOption();

	for (i in grpMenuShit.members)
		i.x = top.x + __offsets[0];
	statText.x = bottom.x + __offsets[1];
	heart.x = grpMenuShit.members[curSelected]?.x - __offsets[2];

	statText.update(elapsed);

	// who did this >:(
	// dont evenr do this is stupid pls
	// ily but pls -lunar
	// for (i in members) if (i.color != null) i.color = fullColor;
}

function onChangeItem(e) {
	FlxTween.cancelTweensOf(heart);
	FlxTween.tween(heart, {y: grpMenuShit.members[e.value]?.y + (grpMenuShit.members[e.value].height - heart.height)/2}, 0.25, {ease: FlxEase.backOut});
	CoolUtil.playMenuSFX();
}

function onSelectOption(e)
	FlxG.sound.play(Paths.sound("menu/select"));