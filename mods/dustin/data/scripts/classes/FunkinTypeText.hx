import StringTools;
import EReg;
class FunkinTypeText extends flixel.text.FlxText {
	public var delay:Float = 0.04;
	public var isTyping:Bool = false;
	public var eventsCallbacks:Map<String, Void> = [
		"pause" => function(txt, param) {
			txt.delay = Std.parseFloat(param);
		},
		"changeDelay" => function(txt, param) {
			txt._realDelay = Std.parseFloat(param);
		},
		"changePitchModule" => function(txt, param) {
			txt.pitchModule = Std.parseFloat(param);
		},
		"changeSound" => function(txt, param) {
			txt.sound = FlxG.sound.load(Paths.sound(StringTools.replace(param, ".", "/")));
		}
	];
	public var completeCallback:()->Void = null;

	public var sound:FlxSound;
	public var defaultSound:FlxSound;
	public var excludeKeys:Array = [" ", "*", "\n"];

	public var _finalText:String = "";
	public var _curLength:Int = 0;
	public var _timer:Float = 0;
	public var _realDelay:Float = 0;

	public var pitchModule:Float = 0;
	public var defaultPitchModule:Float = 0;

	public var realFuckingCamera:FlxCamera = null; //because there's a shitty bug with setting cameras

	public function new(X:Float = 0, Y:Float = 0, FieldWidth:Float = 0, ?Text:String, Size:Int = 8, EmbeddedFont:Bool = true) {
		super(X, Y);
		_finalText = text;
		text = "";
	}

	public function update(elapsed:Float) {
		if (realFuckingCamera != null) camera = realFuckingCamera;
		_timer += elapsed;
		if (isTyping) {
			if (_timer > delay) {
				if (_curLength < _finalText.length) {
					delay = _realDelay;
					if (_finalText.charAt(_curLength) == "/" && !StringTools.contains(_finalText, "https://")) {
						var events = _finalText.substring(_curLength + 1, _finalText.indexOf("/", _curLength + 1));
						
						for (i in events.split(",")) {
							var eventName = i.substring(0, i.indexOf("(") != -1 ? i.indexOf("(") : i.length);
							var eventParam = i.indexOf("(") != -1 ? i.substring(i.indexOf("(") + 1, i.length - 1) : null;
							if (eventsCallbacks[eventName] != null) eventsCallbacks[eventName](this, eventParam);
						}

						_finalText = StringTools.replace(_finalText, "/" + events + "/", "");
						return;
					}
					text += _finalText.charAt(_curLength);
					if (sound != null && !excludeKeys.contains(_finalText.charAt(_curLength))) {
						sound.pitch = FlxG.random.float(1-pitchModule, 1+pitchModule);
						sound.play(true);
					}

					_curLength++;
					_timer = 0;
				}
				else {
					isTyping = false;
					_timer = 0;
					if (completeCallback != null) completeCallback();
					completeCallback = null;
				}
			}
		}
	}

	public function start(?newDelay:Float) {
		pitchModule = defaultPitchModule;
		sound = defaultSound;
		delay = newDelay != null ? newDelay : delay;
		_realDelay = delay;
		isTyping = true;
	}

	public function resetText(newText:String) {
		text = "";
		_finalText = newText;
		_curLength = 0;
		_timer = 0;
	}

	public function skip() {
		delay = _realDelay;
		_curLength = _finalText.length;
		trace(regexMatch(_finalText, new EReg("\\/([^\\/]+)\\/", "")));
		for (i in regexMatch(_finalText, new EReg("\\/([^\\/]+)\\/", "")))
			_finalText = StringTools.replace(_finalText, "/" + i + "/", "");
		text = _finalText;
	}

	public static function regexMatch(str:String, regex:EReg):Array<String> {    
		var matches:Array<String> = [];
		while (regex.match(str)) {
			matches.push(regex.matched(1));
			str = regex.matchedRight();
		}
	
		return matches;
	}
}