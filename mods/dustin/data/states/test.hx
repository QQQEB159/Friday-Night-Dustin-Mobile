import flixel.text.FlxText.FlxTextFormat;
var text:FlxText;
function create() {
	text = new FlxText(0, 0, 0, "hello");
	text.setFormat(Paths.font("8bit-jve.ttf"), 32, 0xFFFFFF00);
	add(text);
}

function update(elapsed:Float) {
	for (i in 0...text.text.length) {
		var textFormat:FlxTextFormat = new FlxTextFormat();
		textFormat.format.letterSpacing = FlxG.random.float(0, 60);
		text.addFormat(textFormat, i, i + 1);
	}
}