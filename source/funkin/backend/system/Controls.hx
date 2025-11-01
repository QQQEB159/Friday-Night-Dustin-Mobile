package funkin.backend.system;

import flixel.input.FlxInput;
import flixel.input.actions.FlxAction;
import flixel.input.actions.FlxActionInput;
import flixel.input.actions.FlxActionManager;
import flixel.input.actions.FlxActionSet;
import flixel.input.gamepad.FlxGamepadInputID;
import flixel.input.keyboard.FlxKey;
#if TOUCH_CONTROLS
import mobile.funkin.backend.system.input.MobileInputID;
#end

#if !TOUCH_CONTROLS
typedef MobileInputID = Dynamic;
#end

enum abstract Action(String) to String from String {
	var UP = "up";
	var LEFT = "left";
	var RIGHT = "right";
	var DOWN = "down";
	var UP_P = "up-press";
	var LEFT_P = "left-press";
	var RIGHT_P = "right-press";
	var DOWN_P = "down-press";
	var UP_R = "up-release";
	var LEFT_R = "left-release";
	var RIGHT_R = "right-release";
	var DOWN_R = "down-release";

	var NOTE_UP = "note-up";
	var NOTE_LEFT = "note-left";
	var NOTE_RIGHT = "note-right";
	var NOTE_DOWN = "note-down";
	var NOTE_UP_P = "note-up-press";
	var NOTE_LEFT_P = "note-left-press";
	var NOTE_RIGHT_P = "note-right-press";
	var NOTE_DOWN_P = "note-down-press";
	var NOTE_UP_R = "note-up-release";
	var NOTE_LEFT_R = "note-left-release";
	var NOTE_RIGHT_R = "note-right-release";
	var NOTE_DOWN_R = "note-down-release";

	var ACCEPT = "accept";
	var ACCEPT_HOLD = "accept-press";
	var ACCEPT_R = "accept-release";

	var BACK = "back";
	var BACK_HOLD = "back-press";
	var BACK_R = "back-release";
	var PAUSE = "pause";
	var PAUSE_HOLD = "pause-press";
	var PAUSE_R = "pause-release";
	var RESET = "reset";
	var RESET_HOLD = "reset-press";
	var RESET_R = "reset-release";
	var CHANGE_MODE = "change-mode";
	var CHANGE_MODE_HOLD = "change-mode-press";
	var CHANGE_MODE_R = "change-mode-release";
	var SWITCHMOD = "switchmod";
	var SWITCHMOD_HOLD = "switchmod-press";
	var SWITCHMOD_R = "switchmod-release";
	var FPS_COUNTER = "fps-counter";
	var FPS_COUNTER_HOLD = "fps-counter-press";
	var FPS_COUNTER_R = "fps-counter-release";

	var DEV_ACCESS = "dev-access";
	var DEV_ACCESS_HOLD = "dev-access-press";
	var DEV_ACCESS_R = "dev-access-release";
	var DEV_CONSOLE = "dev-console";
	var DEV_CONSOLE_HOLD = "dev-console-press";
	var DEV_CONSOLE_R = "dev-console-release";
	var DEV_RELOAD = "dev-reload";
	var DEV_RELOAD_HOLD = "dev-reload-press";
	var DEV_RELOAD_R = "dev-reload-release";
}

enum Device
{
	Keys;
	Gamepad(id:Int);
}

/**
 * Since, in many cases multiple actions should use similar keys, we don't want the
 * rebinding UI to list every action. ActionBinders are what the user perceives as
 * an input so, for instance, they can't set jump-press and jump-release to different keys.
 */
enum Control
{
	UP;
	LEFT;
	RIGHT;
	DOWN;
	NOTE_UP;
	NOTE_LEFT;
	NOTE_RIGHT;
	NOTE_DOWN;
	RESET;
	ACCEPT;
	BACK;
	PAUSE;
	CHANGE_MODE;
	//CHEAT;
	SWITCHMOD;
	FPS_COUNTER;

	// Debugs
	DEV_ACCESS;
	DEV_CONSOLE;
	DEV_RELOAD;
}

enum KeyboardScheme
{
	Solo;
	Duo(first:Bool);
	None;
	Custom;
}

/**
 * A list of actions that a player would invoke via some input device.
 * Uses FlxActions to funnel various inputs to a single action.
 */
// A and B are swapped for switch
@:noCustomClass
class Controls extends FlxActionSet
{
	var _up = new FlxActionDigital(Action.UP);
	var _left = new FlxActionDigital(Action.LEFT);
	var _right = new FlxActionDigital(Action.RIGHT);
	var _down = new FlxActionDigital(Action.DOWN);
	var _upP = new FlxActionDigital(Action.UP_P);
	var _leftP = new FlxActionDigital(Action.LEFT_P);
	var _rightP = new FlxActionDigital(Action.RIGHT_P);
	var _downP = new FlxActionDigital(Action.DOWN_P);
	var _upR = new FlxActionDigital(Action.UP_R);
	var _leftR = new FlxActionDigital(Action.LEFT_R);
	var _rightR = new FlxActionDigital(Action.RIGHT_R);
	var _downR = new FlxActionDigital(Action.DOWN_R);

	var _noteUp = new FlxActionDigital(Action.NOTE_UP);
	var _noteLeft = new FlxActionDigital(Action.NOTE_LEFT);
	var _noteRight = new FlxActionDigital(Action.NOTE_RIGHT);
	var _noteDown = new FlxActionDigital(Action.NOTE_DOWN);
	var _noteUpP = new FlxActionDigital(Action.NOTE_UP_P);
	var _noteLeftP = new FlxActionDigital(Action.NOTE_LEFT_P);
	var _noteRightP = new FlxActionDigital(Action.NOTE_RIGHT_P);
	var _noteDownP = new FlxActionDigital(Action.NOTE_DOWN_P);
	var _noteUpR = new FlxActionDigital(Action.NOTE_UP_R);
	var _noteLeftR = new FlxActionDigital(Action.NOTE_LEFT_R);
	var _noteRightR = new FlxActionDigital(Action.NOTE_RIGHT_R);
	var _noteDownR = new FlxActionDigital(Action.NOTE_DOWN_R);

	var _accept = new FlxActionDigital(Action.ACCEPT);
	var _acceptHold = new FlxActionDigital(Action.ACCEPT_HOLD);
	var _acceptR = new FlxActionDigital(Action.ACCEPT_R);
	var _back = new FlxActionDigital(Action.BACK);
	var _backHold = new FlxActionDigital(Action.BACK_HOLD);
	var _backR = new FlxActionDigital(Action.BACK_R);
	var _pause = new FlxActionDigital(Action.PAUSE);
	var _pauseHold = new FlxActionDigital(Action.PAUSE_HOLD);
	var _pauseR = new FlxActionDigital(Action.PAUSE_R);
	var _reset = new FlxActionDigital(Action.RESET);
	var _resetHold = new FlxActionDigital(Action.RESET_HOLD);
	var _resetR = new FlxActionDigital(Action.RESET_R);
	var _changeMode = new FlxActionDigital(Action.CHANGE_MODE);
	var _changeModeHold = new FlxActionDigital(Action.CHANGE_MODE_HOLD);
	var _changeModeR = new FlxActionDigital(Action.CHANGE_MODE_R);
	//var _cheat = new FlxActionDigital(Action.CHEAT);
	var _switchMod = new FlxActionDigital(Action.SWITCHMOD);
	var _switchModHold = new FlxActionDigital(Action.SWITCHMOD_HOLD);
	var _switchModR = new FlxActionDigital(Action.SWITCHMOD_R);
	var _fpsCounter = new FlxActionDigital(Action.FPS_COUNTER);
	var _fpsCounterHold = new FlxActionDigital(Action.FPS_COUNTER_HOLD);
	var _fpsCounterR = new FlxActionDigital(Action.FPS_COUNTER_R);

	var _devAccess = new FlxActionDigital(Action.DEV_ACCESS);
	var _devAccessHold = new FlxActionDigital(Action.DEV_ACCESS_HOLD);
	var _devAccessR = new FlxActionDigital(Action.DEV_ACCESS_R);
	var _devConsole = new FlxActionDigital(Action.DEV_CONSOLE);
	var _devConsoleHold = new FlxActionDigital(Action.DEV_CONSOLE_HOLD);
	var _devConsoleR = new FlxActionDigital(Action.DEV_CONSOLE_R);
	var _devReload = new FlxActionDigital(Action.DEV_RELOAD);
	var _devReloadHold = new FlxActionDigital(Action.DEV_RELOAD_HOLD);
	var _devReloadR = new FlxActionDigital(Action.DEV_RELOAD_R);

	public var byName:Map<String, FlxActionDigital> = [];

	public var gamepadsAdded:Array<Int> = [];
	public var keyboardScheme = KeyboardScheme.None;

	public var UP(get, set):Bool;
	inline function get_UP() return _up.check() #if TOUCH_CONTROLS || mobileControlsPressed(MobileInputID.UP) #end;
	inline function set_UP(val) return @:privateAccess _up._checked = val;
	public var LEFT(get, set):Bool;
	inline function get_LEFT()return _left.check() #if TOUCH_CONTROLS || mobileControlsPressed(MobileInputID.LEFT) #end;
	inline function set_LEFT(val) return @:privateAccess _left._checked = val;
	public var RIGHT(get, set):Bool;
	inline function get_RIGHT() return _right.check() #if TOUCH_CONTROLS || mobileControlsPressed(MobileInputID.RIGHT) #end;
	inline function set_RIGHT(val) return @:privateAccess _right._checked = val;
	public var DOWN(get, set):Bool;
	inline function get_DOWN() return _down.check() #if TOUCH_CONTROLS || mobileControlsPressed(MobileInputID.DOWN) #end;
	inline function set_DOWN(val) return @:privateAccess _down._checked = val;
	public var UP_P(get, set):Bool;
	inline function get_UP_P() return _upP.check() #if TOUCH_CONTROLS || mobileControlsJustPressed(MobileInputID.UP) #end;
	inline function set_UP_P(val) return @:privateAccess _upP._checked = val;
	public var LEFT_P(get, set):Bool;
	inline function get_LEFT_P() return _leftP.check() #if TOUCH_CONTROLS || mobileControlsJustPressed(MobileInputID.LEFT) #end;
	inline function set_LEFT_P(val) return @:privateAccess _leftP._checked = val;
	public var RIGHT_P(get, set):Bool;
	inline function get_RIGHT_P() return _rightP.check() #if TOUCH_CONTROLS || mobileControlsJustPressed(MobileInputID.RIGHT) #end;
	inline function set_RIGHT_P(val) return @:privateAccess _rightP._checked = val;
	public var DOWN_P(get, set):Bool;
	inline function get_DOWN_P() return _downP.check() #if TOUCH_CONTROLS || mobileControlsJustPressed(MobileInputID.DOWN) #end;
	inline function set_DOWN_P(val) return @:privateAccess _downP._checked = val;
	public var UP_R(get, set):Bool;
	inline function get_UP_R() return _upR.check() #if TOUCH_CONTROLS || mobileControlsJustReleased(MobileInputID.UP) #end;
	inline function set_UP_R(val) return @:privateAccess _upR._checked = val;
	public var LEFT_R(get, set):Bool;
	inline function get_LEFT_R() return _leftR.check() #if TOUCH_CONTROLS || mobileControlsJustReleased(MobileInputID.LEFT) #end;
	inline function set_LEFT_R(val) return @:privateAccess _leftR._checked = val;
	public var RIGHT_R(get, set):Bool;
	inline function get_RIGHT_R() return _rightR.check() #if TOUCH_CONTROLS || mobileControlsJustReleased(MobileInputID.RIGHT) #end;
	inline function set_RIGHT_R(val) return @:privateAccess _rightR._checked = val;
	public var DOWN_R(get, set):Bool;
	inline function get_DOWN_R() return _downR.check() #if TOUCH_CONTROLS || mobileControlsJustReleased(MobileInputID.DOWN) #end;
	inline function set_DOWN_R(val) return @:privateAccess _downR._checked = val;

	public var NOTE_UP(get, set):Bool;
	inline function get_NOTE_UP() return _noteUp.check() #if TOUCH_CONTROLS || mobileControlsPressed(MobileInputID.NOTE_UP) #end;
	inline function set_NOTE_UP(val) return @:privateAccess _noteUp._checked = val;
	public var NOTE_LEFT(get, set):Bool;
	inline function get_NOTE_LEFT() return _noteLeft.check() #if TOUCH_CONTROLS || mobileControlsPressed(MobileInputID.NOTE_LEFT) #end;
	inline function set_NOTE_LEFT(val) return @:privateAccess _noteLeft._checked = val;
	public var NOTE_RIGHT(get, set):Bool;
	inline function get_NOTE_RIGHT() return _noteRight.check() #if TOUCH_CONTROLS || mobileControlsPressed(MobileInputID.NOTE_RIGHT) #end;
	inline function set_NOTE_RIGHT(val) return @:privateAccess _noteRight._checked = val;
	public var NOTE_DOWN(get, set):Bool;
	inline function get_NOTE_DOWN() return _noteDown.check() #if TOUCH_CONTROLS || mobileControlsPressed(MobileInputID.NOTE_DOWN) #end;
	inline function set_NOTE_DOWN(val) return @:privateAccess _noteDown._checked = val;
	public var NOTE_UP_P(get, set):Bool;
	inline function get_NOTE_UP_P() return _noteUpP.check() #if TOUCH_CONTROLS || mobileControlsJustPressed(MobileInputID.NOTE_UP) #end;
	inline function set_NOTE_UP_P(val) return @:privateAccess _noteUpP._checked = val;
	public var NOTE_LEFT_P(get, set):Bool;
	inline function get_NOTE_LEFT_P() return _noteLeftP.check() #if TOUCH_CONTROLS || mobileControlsJustPressed(MobileInputID.NOTE_LEFT) #end;
	inline function set_NOTE_LEFT_P(val) return @:privateAccess _noteLeftP._checked = val;
	public var NOTE_RIGHT_P(get, set):Bool;
	inline function get_NOTE_RIGHT_P() return _noteRightP.check() #if TOUCH_CONTROLS || mobileControlsJustPressed(MobileInputID.NOTE_RIGHT) #end;
	inline function set_NOTE_RIGHT_P(val) return @:privateAccess _noteRightP._checked = val;
	public var NOTE_DOWN_P(get, set):Bool;
	inline function get_NOTE_DOWN_P() return _noteDownP.check() #if TOUCH_CONTROLS || mobileControlsJustPressed(MobileInputID.NOTE_DOWN) #end;
	inline function set_NOTE_DOWN_P(val) return @:privateAccess _noteDownP._checked = val;
	public var NOTE_UP_R(get, set):Bool;
	inline function get_NOTE_UP_R() return _noteUpR.check() #if TOUCH_CONTROLS || mobileControlsJustReleased(MobileInputID.NOTE_UP) #end;
	inline function set_NOTE_UP_R(val) return @:privateAccess _noteUpR._checked = val;
	public var NOTE_LEFT_R(get, set):Bool;
	inline function get_NOTE_LEFT_R() return _noteLeftR.check() #if TOUCH_CONTROLS || mobileControlsJustReleased(MobileInputID.NOTE_LEFT) #end;
	inline function set_NOTE_LEFT_R(val) return @:privateAccess _noteLeftR._checked = val;
	public var NOTE_RIGHT_R(get, set):Bool;
	inline function get_NOTE_RIGHT_R() return _noteRightR.check() #if TOUCH_CONTROLS || mobileControlsJustReleased(MobileInputID.NOTE_RIGHT) #end;
	inline function set_NOTE_RIGHT_R(val) return @:privateAccess _noteRightR._checked = val;
	public var NOTE_DOWN_R(get, set):Bool;
	inline function get_NOTE_DOWN_R() return _noteDownR.check() #if TOUCH_CONTROLS || mobileControlsJustReleased(MobileInputID.NOTE_DOWN) #end;
	inline function set_NOTE_DOWN_R(val) return @:privateAccess _noteDownR._checked = val;

	public var ACCEPT(get, set):Bool;
	inline function get_ACCEPT() return _accept.check() #if TOUCH_CONTROLS || mobileControlsJustPressed(MobileInputID.A) #end;
	inline function set_ACCEPT(val) return @:privateAccess _accept._checked = val;
	public var ACCEPT_HOLD(get, set):Bool;
	inline function get_ACCEPT_HOLD() return _acceptHold.check() #if TOUCH_CONTROLS || mobileControlsPressed(MobileInputID.A) #end;
	inline function set_ACCEPT_HOLD(val:Bool) return @:privateAccess _acceptHold._checked = val;
	public var ACCEPT_R(get, set):Bool;
	inline function get_ACCEPT_R() return _acceptR.check() #if TOUCH_CONTROLS || mobileControlsJustReleased(MobileInputID.A) #end;
	inline function set_ACCEPT_R(val:Bool) return @:privateAccess _acceptR._checked = val;
	public var BACK(get, set):Bool;
	inline function get_BACK() return _back.check() #if TOUCH_CONTROLS || mobileControlsJustPressed(MobileInputID.B) #end;
	inline function set_BACK(val) return @:privateAccess _back._checked = val;
	public var BACK_HOLD(get, set):Bool;
	inline function get_BACK_HOLD() return _backHold.check() #if TOUCH_CONTROLS || mobileControlsPressed(MobileInputID.B) #end;
	inline function set_BACK_HOLD(val:Bool) return @:privateAccess _backHold._checked = val;
	public var BACK_R(get, set):Bool;
	inline function get_BACK_R() return _backR.check() #if TOUCH_CONTROLS || mobileControlsJustReleased(MobileInputID.B) #end;
	inline function set_BACK_R(val:Bool) return @:privateAccess _backR._checked = val;
	public var PAUSE(get, set):Bool;
	inline function get_PAUSE() return _pause.check() #if TOUCH_CONTROLS || mobileControlsJustPressed(MobileInputID.P) #end;
	inline function set_PAUSE(val) return @:privateAccess _pause._checked = val;
	public var PAUSE_HOLD(get, set):Bool;
	inline function get_PAUSE_HOLD() return _pauseHold.check() #if TOUCH_CONTROLS || mobileControlsPressed(MobileInputID.P) #end;
	inline function set_PAUSE_HOLD(val:Bool) return @:privateAccess _pauseHold._checked = val;
	public var PAUSE_R(get, set):Bool;
	inline function get_PAUSE_R() return _pauseR.check() #if TOUCH_CONTROLS || mobileControlsJustReleased(MobileInputID.P) #end;
	inline function set_PAUSE_R(val:Bool) return @:privateAccess _pauseR._checked = val;
	public var RESET(get, set):Bool;
	inline function get_RESET() return _reset.check();
	inline function set_RESET(val:Bool) return @:privateAccess _reset._checked = val;
	public var RESET_HOLD(get, set):Bool;
	inline function get_RESET_HOLD() return _resetHold.check();
	inline function set_RESET_HOLD(val:Bool) return @:privateAccess _resetHold._checked = val;
	public var RESET_R(get, set):Bool;
	inline function get_RESET_R() return _resetR.check();
	inline function set_RESET_R(val:Bool) return @:privateAccess _resetR._checked = val;
	public var CHANGE_MODE(get, set):Bool;
	inline function get_CHANGE_MODE() return _changeMode.check();
	inline function set_CHANGE_MODE(val) return @:privateAccess _changeMode._checked = val;
	public var CHANGE_MODE_HOLD(get, set):Bool;
	inline function get_CHANGE_MODE_HOLD() return _changeModeHold.check();
	inline function set_CHANGE_MODE_HOLD(val:Bool) return @:privateAccess _changeModeHold._checked = val;
	public var CHANGE_MODE_R(get, set):Bool;
	inline function get_CHANGE_MODE_R() return _changeModeR.check();
	inline function set_CHANGE_MODE_R(val:Bool) return @:privateAccess _changeModeR._checked = val;
	/*public var CHEAT(get, set):Bool;
	inline function get_CHEAT() return _cheat.check();
	inline function set_CHEAT(val) return @:privateAccess _cheat._checked = val;*/
	public var SWITCHMOD(get, set):Bool;
	inline function get_SWITCHMOD() return _switchMod.check();
	inline function set_SWITCHMOD(val) return @:privateAccess _switchMod._checked = val;
	public var SWITCHMOD_HOLD(get, set):Bool;
	inline function get_SWITCHMOD_HOLD() return _switchModHold.check();
	inline function set_SWITCHMOD_HOLD(val:Bool) return @:privateAccess _switchModHold._checked = val;
	public var SWITCHMOD_R(get, set):Bool;
	inline function get_SWITCHMOD_R() return _switchModR.check();
	inline function set_SWITCHMOD_R(val:Bool) return @:privateAccess _switchModR._checked = val;
	public var FPS_COUNTER(get, set):Bool;
	inline function get_FPS_COUNTER() return _fpsCounter.check();
	inline function set_FPS_COUNTER(val:Bool) return @:privateAccess _fpsCounter._checked = val;
	public var FPS_COUNTER_HOLD(get, set):Bool;
	inline function get_FPS_COUNTER_HOLD() return _fpsCounterHold.check();
	inline function set_FPS_COUNTER_HOLD(val:Bool) return @:privateAccess _fpsCounterHold._checked = val;
	public var FPS_COUNTER_R(get, set):Bool;
	inline function get_FPS_COUNTER_R() return _fpsCounterR.check();
	inline function set_FPS_COUNTER_R(val:Bool) return @:privateAccess _fpsCounterR._checked = val;

	public var DEV_ACCESS(get, set):Bool;
	inline function get_DEV_ACCESS() return _devAccess.check();
	inline function set_DEV_ACCESS(val:Bool) return @:privateAccess _devAccess._checked = val;
	public var DEV_ACCESS_HOLD(get, set):Bool;
	inline function get_DEV_ACCESS_HOLD() return _devAccessHold.check();
	inline function set_DEV_ACCESS_HOLD(val:Bool) return @:privateAccess _devAccessHold._checked = val;
	public var DEV_ACCESS_R(get, set):Bool;
	inline function get_DEV_ACCESS_R() return _devAccessR.check();
	inline function set_DEV_ACCESS_R(val:Bool) return @:privateAccess _devAccessR._checked = val;
	public var DEV_CONSOLE(get, set):Bool;
	inline function get_DEV_CONSOLE() return _devConsole.check();
	inline function set_DEV_CONSOLE(val:Bool) return @:privateAccess _devConsole._checked = val;
	public var DEV_CONSOLE_HOLD(get, set):Bool;
	inline function get_DEV_CONSOLE_HOLD() return _devConsoleHold.check();
	inline function set_DEV_CONSOLE_HOLD(val:Bool) return @:privateAccess _devConsoleHold._checked = val;
	public var DEV_CONSOLE_R(get, set):Bool;
	inline function get_DEV_CONSOLE_R() return _devConsoleR.check();
	inline function set_DEV_CONSOLE_R(val:Bool) return @:privateAccess _devConsoleR._checked = val;
	public var DEV_RELOAD(get, set):Bool;
	inline function get_DEV_RELOAD() return _devReload.check();
	inline function set_DEV_RELOAD(val:Bool) return @:privateAccess _devReload._checked = val;
	public var DEV_RELOAD_HOLD(get, set):Bool;
	inline function get_DEV_RELOAD_HOLD() return _devReloadHold.check();
	inline function set_DEV_RELOAD_HOLD(val:Bool) return @:privateAccess _devReloadHold._checked = val;
	public var DEV_RELOAD_R(get, set):Bool;
	inline function get_DEV_RELOAD_R() return _devReloadR.check();
	inline function set_DEV_RELOAD_R(val:Bool) return @:privateAccess _devReloadR._checked = val;

	public static var instance:Controls;

	public function new(name, scheme = None)
	{
		super(name);
		instance = this;

		add(_up);
		add(_left);
		add(_right);
		add(_down);
		add(_upP);
		add(_leftP);
		add(_rightP);
		add(_downP);
		add(_upR);
		add(_leftR);
		add(_rightR);
		add(_downR);

		add(_noteUp);
		add(_noteLeft);
		add(_noteRight);
		add(_noteDown);
		add(_noteUpP);
		add(_noteLeftP);
		add(_noteRightP);
		add(_noteDownP);
		add(_noteUpR);
		add(_noteLeftR);
		add(_noteRightR);
		add(_noteDownR);

		add(_accept);
		add(_acceptHold);
		add(_acceptR);
		add(_back);
		add(_backHold);
		add(_backR);
		add(_pause);
		add(_pauseHold);
		add(_pauseR);
		add(_reset);
		add(_resetHold);
		add(_resetR);
		// add(_cheat);
		add(_switchMod);
		add(_switchModHold);
		add(_switchModR);
		add(_fpsCounter);
		add(_fpsCounterHold);
		add(_fpsCounterR);

		add(_devAccess);
		add(_devAccessHold);
		add(_devAccessR);
		add(_devConsole);
		add(_devConsoleHold);
		add(_devConsoleR);
		add(_devReload);
		add(_devReloadHold);
		add(_devReloadR);

		for (action in digitalActions)
			byName[action.name] = action;

		setKeyboardScheme(scheme, false);
	}

	override function update()
	{
		super.update();
	}

	public var touchC(get, never):Bool;
	
	@:noCompletion
	private function get_touchC():Bool
		return #if TOUCH_CONTROLS Options.touchPadAlpha >= 0.1 #else false #end;

	// inline
	public function checkByName(name:Action):Bool
	{
		#if debug
		if (!byName.exists(name))
			throw 'Invalid name: $name';
		#end
		return byName[name].check();
	}

	public function getKeyName(control:Control):String
	{
		return getDialogueName(getActionFromControl(control));
	}

	public function getDialogueName(action:FlxActionDigital):String
	{
		var input = action.inputs[0];
		return switch input.device
		{
			case KEYBOARD: return '${(input.inputID : FlxKey)}';
			case GAMEPAD: return '${(input.inputID : FlxGamepadInputID)}';
			case device: throw 'unhandled device: $device';
		}
	}

	public function getDialogueNameFromToken(token:String):String
	{
		return getDialogueName(getActionFromControl(Control.createByName(token.toUpperCase())));
	}

	public function getActionFromControl(control:Control):FlxActionDigital
	{
		return switch (control)
		{
			case UP: _up;
			case DOWN: _down;
			case LEFT: _left;
			case RIGHT: _right;
			case NOTE_UP: _noteUp;
			case NOTE_DOWN: _noteDown;
			case NOTE_LEFT: _noteLeft;
			case NOTE_RIGHT: _noteRight;
			case ACCEPT: _accept;
			case BACK: _back;
			case PAUSE: _pause;
			case RESET: _reset;
			case CHANGE_MODE: _changeMode;
			// case CHEAT: _cheat;
			case SWITCHMOD: _switchMod;
			case FPS_COUNTER: _fpsCounter;
			case DEV_ACCESS: _devAccess;
			case DEV_CONSOLE: _devConsole;
			case DEV_RELOAD: _devReload;
		}
	}

	static function init():Void
	{
		var actions = new FlxActionManager();
		FlxG.inputs.add(actions);
	}

	/**
	 * Calls a function passing each action bound by the specified control
	 * @param control
	 * @param func
	 * @return ->Void)
	 */
	function forEachBound(control:Control, func:FlxActionDigital->FlxInputState->Void)
	{
		switch (control)
		{
			case NOTE_UP:
				func(_noteUp, PRESSED);
				func(_noteUpP, JUST_PRESSED);
				func(_noteUpR, JUST_RELEASED);
			case NOTE_LEFT:
				func(_noteLeft, PRESSED);
				func(_noteLeftP, JUST_PRESSED);
				func(_noteLeftR, JUST_RELEASED);
			case NOTE_RIGHT:
				func(_noteRight, PRESSED);
				func(_noteRightP, JUST_PRESSED);
				func(_noteRightR, JUST_RELEASED);
			case NOTE_DOWN:
				func(_noteDown, PRESSED);
				func(_noteDownP, JUST_PRESSED);
				func(_noteDownR, JUST_RELEASED);
			case UP:
				func(_up, PRESSED);
				func(_upP, JUST_PRESSED);
				func(_upR, JUST_RELEASED);
			case LEFT:
				func(_left, PRESSED);
				func(_leftP, JUST_PRESSED);
				func(_leftR, JUST_RELEASED);
			case RIGHT:
				func(_right, PRESSED);
				func(_rightP, JUST_PRESSED);
				func(_rightR, JUST_RELEASED);
			case DOWN:
				func(_down, PRESSED);
				func(_downP, JUST_PRESSED);
				func(_downR, JUST_RELEASED);
			case ACCEPT:
				func(_accept, JUST_PRESSED);
				func(_acceptHold, PRESSED);
				func(_acceptR, JUST_RELEASED);
			case BACK:
				func(_back, JUST_PRESSED);
				func(_backHold, PRESSED);
				func(_backR, JUST_RELEASED);
			case PAUSE:
				func(_pause, JUST_PRESSED);
				func(_pauseHold, PRESSED);
				func(_pauseR, JUST_RELEASED);
			case RESET:
				func(_reset, JUST_PRESSED);
				func(_resetHold, PRESSED);
				func(_resetR, JUST_RELEASED);
			case CHANGE_MODE:
				func(_changeMode, JUST_PRESSED);
				func(_changeModeHold, PRESSED);
				func(_changeModeR, JUST_RELEASED);
			/*case CHEAT:
				func(_cheat, JUST_PRESSED); */
			case SWITCHMOD:
				func(_switchMod, JUST_PRESSED);
				func(_switchModHold, PRESSED);
				func(_switchModR, JUST_RELEASED);
			case FPS_COUNTER:
				func(_fpsCounter, JUST_PRESSED);
				func(_fpsCounterHold, PRESSED);
				func(_fpsCounterR, JUST_RELEASED);
			case DEV_ACCESS:
				func(_devAccess, JUST_PRESSED);
				func(_devAccessHold, PRESSED);
				func(_devAccessR, JUST_RELEASED);
			case DEV_CONSOLE:
				func(_devConsole, JUST_PRESSED);
				func(_devConsoleHold, PRESSED);
				func(_devConsoleR, JUST_RELEASED);
			case DEV_RELOAD:
				func(_devReload, JUST_PRESSED);
				func(_devReloadHold, PRESSED);
				func(_devReloadR, JUST_RELEASED);
		}
	}

	public function replaceBinding(control:Control, device:Device, ?toAdd:Int, ?toRemove:Int)
	{
		if (toAdd == toRemove)
			return;

		switch (device)
		{
			case Keys:
				if (toRemove != null)
					unbindKeys(control, [toRemove]);
				if (toAdd != null)
					bindKeys(control, [toAdd]);

			case Gamepad(id):
				if (toRemove != null)
					unbindButtons(control, id, [toRemove]);
				if (toAdd != null)
					bindButtons(control, id, [toAdd]);
		}
	}

	public function copyFrom(controls:Controls, ?device:Device)
	{
		for (name => action in controls.byName)
		{
			for (input in action.inputs)
			{
				if (device == null || isDevice(input, device))
					byName[name].add(cast input);
			}
		}

		switch (device)
		{
			case null:
				// add all
				for (gamepad in controls.gamepadsAdded)
					gamepadsAdded.pushOnce(gamepad);

				mergeKeyboardScheme(controls.keyboardScheme);

			case Gamepad(id):
				gamepadsAdded.push(id);
			case Keys:
				mergeKeyboardScheme(controls.keyboardScheme);
		}
	}

	inline public function copyTo(controls:Controls, ?device:Device)
	{
		controls.copyFrom(this, device);
	}

	function mergeKeyboardScheme(scheme:KeyboardScheme):Void
	{
		if (scheme != None)
		{
			switch (keyboardScheme)
			{
				case None:
					keyboardScheme = scheme;
				default:
					keyboardScheme = Custom;
			}
		}
	}

	/**
	 * Sets all actions that pertain to the binder to trigger when the supplied keys are used.
	 * If binder is a literal you can inline this
	 */
	public function bindKeys(control:Control, keys:Array<FlxKey>)
	{
		inline forEachBound(control, (action, state) -> addKeys(action, keys, state));
	}

	/**
	 * Sets all actions that pertain to the binder to trigger when the supplied keys are used.
	 * If binder is a literal you can inline this
	 */
	public function unbindKeys(control:Control, keys:Array<FlxKey>)
		inline forEachBound(control, (action, _) -> removeKeys(action, keys));

	inline public static function addKeys(action:FlxActionDigital, keys:Array<FlxKey>, state:FlxInputState)
	{
		for (key in keys)
			action.addKey(key, state);
	}

	public static function removeKeys(action:FlxActionDigital, keys:Array<FlxKey>)
	{
		var i = action.inputs.length;
		while (i-- > 0)
		{
			var input = action.inputs[i];
			if (input.device == KEYBOARD && keys.contains(cast input.inputID))
				action.remove(input);
		}
	}

	public function setKeyboardScheme(scheme:KeyboardScheme, reset = true)
	{
		if (reset)
			removeKeyboard();

		keyboardScheme = scheme;

		switch (scheme)
		{
			case Solo:
				inline bindKeys(Control.UP, Options.SOLO_UP);
				inline bindKeys(Control.DOWN, Options.SOLO_DOWN);
				inline bindKeys(Control.LEFT, Options.SOLO_LEFT);
				inline bindKeys(Control.RIGHT, Options.SOLO_RIGHT);
				inline bindKeys(Control.NOTE_UP, Options.SOLO_NOTE_UP);
				inline bindKeys(Control.NOTE_DOWN, Options.SOLO_NOTE_DOWN);
				inline bindKeys(Control.NOTE_LEFT, Options.SOLO_NOTE_LEFT);
				inline bindKeys(Control.NOTE_RIGHT, Options.SOLO_NOTE_RIGHT);
				inline bindKeys(Control.ACCEPT, Options.SOLO_ACCEPT);
				inline bindKeys(Control.BACK, Options.SOLO_BACK);
				inline bindKeys(Control.PAUSE, Options.SOLO_PAUSE);
				inline bindKeys(Control.RESET, Options.SOLO_RESET);
				inline bindKeys(Control.SWITCHMOD, Options.SOLO_SWITCHMOD);
				inline bindKeys(Control.FPS_COUNTER, Options.SOLO_FPS_COUNTER);
				inline bindKeys(Control.DEV_ACCESS, Options.SOLO_DEV_ACCESS);
				inline bindKeys(Control.DEV_CONSOLE, Options.SOLO_DEV_CONSOLE);
				inline bindKeys(Control.DEV_RELOAD, Options.SOLO_DEV_RELOAD);
			case Duo(true):
				inline bindKeys(Control.UP, Options.P1_UP);
				inline bindKeys(Control.DOWN, Options.P1_DOWN);
				inline bindKeys(Control.LEFT, Options.P1_LEFT);
				inline bindKeys(Control.RIGHT, Options.P1_RIGHT);
				inline bindKeys(Control.NOTE_UP, Options.P1_NOTE_UP);
				inline bindKeys(Control.NOTE_DOWN, Options.P1_NOTE_DOWN);
				inline bindKeys(Control.NOTE_LEFT, Options.P1_NOTE_LEFT);
				inline bindKeys(Control.NOTE_RIGHT, Options.P1_NOTE_RIGHT);
				inline bindKeys(Control.ACCEPT, Options.P1_ACCEPT);
				inline bindKeys(Control.BACK, Options.P1_BACK);
				inline bindKeys(Control.PAUSE, Options.P1_PAUSE);
				inline bindKeys(Control.RESET, Options.P1_RESET);
				inline bindKeys(Control.SWITCHMOD, Options.P1_SWITCHMOD);
				inline bindKeys(Control.FPS_COUNTER, Options.P1_FPS_COUNTER);
				inline bindKeys(Control.DEV_ACCESS, Options.P1_DEV_ACCESS);
				inline bindKeys(Control.DEV_CONSOLE, Options.P1_DEV_CONSOLE);
				inline bindKeys(Control.DEV_RELOAD, Options.P1_DEV_RELOAD);
			case Duo(false):
				inline bindKeys(Control.UP, Options.P2_UP);
				inline bindKeys(Control.DOWN, Options.P2_DOWN);
				inline bindKeys(Control.LEFT, Options.P2_LEFT);
				inline bindKeys(Control.RIGHT, Options.P2_RIGHT);
				inline bindKeys(Control.NOTE_UP, Options.P2_NOTE_UP);
				inline bindKeys(Control.NOTE_DOWN, Options.P2_NOTE_DOWN);
				inline bindKeys(Control.NOTE_LEFT, Options.P2_NOTE_LEFT);
				inline bindKeys(Control.NOTE_RIGHT, Options.P2_NOTE_RIGHT);
				inline bindKeys(Control.ACCEPT, Options.P2_ACCEPT);
				inline bindKeys(Control.BACK, Options.P2_BACK);
				inline bindKeys(Control.PAUSE, Options.P2_PAUSE);
				inline bindKeys(Control.RESET, Options.P2_RESET);
				inline bindKeys(Control.SWITCHMOD, Options.P2_SWITCHMOD);
				inline bindKeys(Control.FPS_COUNTER, Options.P2_FPS_COUNTER);
				inline bindKeys(Control.DEV_ACCESS, Options.P2_DEV_ACCESS);
				inline bindKeys(Control.DEV_CONSOLE, Options.P2_DEV_CONSOLE);
				inline bindKeys(Control.DEV_RELOAD, Options.P2_DEV_RELOAD);
			case None: // nothing
			case Custom: // nothing
		}
	}

	function removeKeyboard()
	{
		for (action in this.digitalActions)
		{
			var i = action.inputs.length;
			while (i-- > 0)
			{
				var input = action.inputs[i];
				if (input.device == KEYBOARD)
					action.remove(input);
			}
		}
	}

	public function addGamepad(id:Int, ?buttonMap:Map<Control, Array<FlxGamepadInputID>>):Void
	{
		gamepadsAdded.push(id);

		for (control => buttons in buttonMap)
			inline bindButtons(control, id, buttons);
	}

	inline function addGamepadLiteral(id:Int, ?buttonMap:Map<Control, Array<FlxGamepadInputID>>):Void
	{
		gamepadsAdded.push(id);

		for (control => buttons in buttonMap)
			inline bindButtons(control, id, buttons);
	}

	public function removeGamepad(deviceID:Int = FlxInputDeviceID.ALL):Void
	{
		for (action in this.digitalActions)
		{
			var i = action.inputs.length;
			while (i-- > 0)
			{
				var input = action.inputs[i];
				if (input.device == GAMEPAD && (deviceID == FlxInputDeviceID.ALL || input.deviceID == deviceID))
					action.remove(input);
			}
		}

		gamepadsAdded.remove(deviceID);
	}

	public function addDefaultGamepad(id):Void
	{
		#if !switch
		addGamepadLiteral(id, [
			Control.ACCEPT => [A],
			Control.BACK => [B],
			Control.UP => [DPAD_UP, LEFT_STICK_DIGITAL_UP],
			Control.DOWN => [DPAD_DOWN, LEFT_STICK_DIGITAL_DOWN],
			Control.LEFT => [DPAD_LEFT, LEFT_STICK_DIGITAL_LEFT],
			Control.RIGHT => [DPAD_RIGHT, LEFT_STICK_DIGITAL_RIGHT],
			Control.PAUSE => [START],
			Control.RESET => [Y],
			Control.SWITCHMOD => [FlxGamepadInputID.BACK],
			Control.CHANGE_MODE => [FlxGamepadInputID.BACK]
		]);
		#else
		addGamepadLiteral(id, [
			//Swap A and B for switch
			Control.ACCEPT => [B],
			Control.BACK => [A],
			Control.UP => [DPAD_UP, LEFT_STICK_DIGITAL_UP, RIGHT_STICK_DIGITAL_UP],
			Control.DOWN => [DPAD_DOWN, LEFT_STICK_DIGITAL_DOWN, RIGHT_STICK_DIGITAL_DOWN],
			Control.LEFT => [DPAD_LEFT, LEFT_STICK_DIGITAL_LEFT, RIGHT_STICK_DIGITAL_LEFT],
			Control.RIGHT => [DPAD_RIGHT, LEFT_STICK_DIGITAL_RIGHT, RIGHT_STICK_DIGITAL_RIGHT],
			Control.PAUSE => [START],
			//Swap Y and X for switch
			Control.RESET => [Y],
			//Control.CHEAT => [X],
			Control.SWITCHMOD => [FlxGamepadInputID.BACK],
			Control.CHANGE_MODE => [FlxGamepadInputID.BACK]
		]);
		#end
	}

	/**
	 * Sets all actions that pertain to the binder to trigger when the supplied keys are used.
	 * If binder is a literal you can inline this
	 */
	public function bindButtons(control:Control, id, buttons)
	{
		inline forEachBound(control, (action, state) -> addButtons(action, buttons, state, id));
	}

	/**
	 * Sets all actions that pertain to the binder to trigger when the supplied keys are used.
	 * If binder is a literal you can inline this
	 */
	public function unbindButtons(control:Control, gamepadID:Int, buttons)
	{
		inline forEachBound(control, (action, _) -> removeButtons(action, gamepadID, buttons));
	}

	inline static function addButtons(action:FlxActionDigital, buttons:Array<FlxGamepadInputID>, state, id)
	{
		for (button in buttons)
			action.addGamepad(button, state, id);
	}

	static function removeButtons(action:FlxActionDigital, gamepadID:Int, buttons:Array<FlxGamepadInputID>)
	{
		var i = action.inputs.length;
		while (i-- > 0)
		{
			var input = action.inputs[i];
			if (isGamepad(input, gamepadID) && buttons.contains(cast input.inputID))
				action.remove(input);
		}
	}

	public function getInputsFor(control:Control, device:Device, ?list:Array<Int>):Array<Int>
	{
		if (list == null)
			list = [];

		switch (device)
		{
			case Keys:
				for (input in getActionFromControl(control).inputs)
				{
					if (input.device == KEYBOARD)
						list.push(input.inputID);
				}
			case Gamepad(id):
				for (input in getActionFromControl(control).inputs)
				{
					if (input.deviceID == id)
						list.push(input.inputID);
				}
		}
		return list;
	}

	public function removeDevice(device:Device)
	{
		switch (device)
		{
			case Keys:
				setKeyboardScheme(None);
			case Gamepad(id):
				removeGamepad(id);
		}
	}

	static function isDevice(input:FlxActionInput, device:Device)
	{
		return switch device
		{
			case Keys: input.device == KEYBOARD;
			case Gamepad(id): isGamepad(input, id);
		}
	}

	inline static function isGamepad(input:FlxActionInput, deviceID:Int)
	{
		return input.device == GAMEPAD && (deviceID == FlxInputDeviceID.ALL || input.deviceID == deviceID);
	}

	#if TOUCH_CONTROLS
	public function mobileControlsJustPressed(id:MobileInputID):Bool
	{
		final state:MusicBeatState = MusicBeatState.getState();
		final substate:MusicBeatSubstate = MusicBeatSubstate.instance;
		var bools:Array<Bool> = [false, false, false, false];

		if (state != null)
		{
			if (state.touchPad != null)
				bools[0] = state.touchPad.buttonJustPressed(id);

			if (state.hitbox != null)
				bools[1] = state.hitbox.instance.buttonJustPressed(id);
				
			if (state.mobileControls != null)
				bools[1] = state.mobileControls.instance.buttonJustPressed(id);
		}

		if (substate != null)
		{
			if (substate.touchPad != null)
				bools[2] = substate.touchPad.buttonJustPressed(id);

			if (substate.hitbox != null)
				bools[3] = substate.hitbox.instance.buttonJustPressed(id);
				
			if (substate.mobileControls != null)
				bools[3] = substate.mobileControls.instance.buttonJustPressed(id);
		}	

		return bools.contains(true);
	}

	public function mobileControlsJustReleased(id:MobileInputID):Bool
	{
		final state:MusicBeatState = MusicBeatState.getState();
		final substate:MusicBeatSubstate = MusicBeatSubstate.instance;
		var bools:Array<Bool> = [false, false, false, false];

		if (state != null)
		{
			if (state.touchPad != null)
				bools[0] = state.touchPad.buttonJustReleased(id);

			if (state.hitbox != null)
				bools[1] = state.hitbox.instance.buttonJustReleased(id);
				
			if (state.mobileControls != null)
				bools[1] = state.mobileControls.instance.buttonJustReleased(id);
		}

		if (substate != null)
		{
			if (substate.touchPad != null)
				bools[2] = substate.touchPad.buttonJustReleased(id);

			if (substate.hitbox != null)
				bools[3] = substate.hitbox.instance.buttonJustReleased(id);
				
			if (substate.mobileControls != null)
				bools[3] = substate.mobileControls.instance.buttonJustReleased(id);
		}	

		return bools.contains(true);
	}

	public function mobileControlsPressed(id:MobileInputID):Bool
	{
		final state:MusicBeatState = MusicBeatState.getState();
		final substate:MusicBeatSubstate = MusicBeatSubstate.instance;
		var bools:Array<Bool> = [false, false, false, false];

		if (state != null)
		{
			if (state.touchPad != null)
				bools[0] = state.touchPad.buttonPressed(id);

			if (state.hitbox != null)
				bools[1] = state.hitbox.instance.buttonPressed(id);
				
			if (state.mobileControls != null)
				bools[1] = state.mobileControls.instance.buttonPressed(id);
		}

		if (substate != null)
		{
			if (substate.touchPad != null)
				bools[2] = substate.touchPad.buttonPressed(id);

			if (substate.hitbox != null)
				bools[3] = substate.hitbox.instance.buttonPressed(id);
				
			if (substate.mobileControls != null)
				bools[3] = substate.mobileControls.instance.buttonPressed(id);
		}	

		return bools.contains(true);
	}

	public function mobileControlsReleased(id:MobileInputID):Bool
	{
		final state:MusicBeatState = MusicBeatState.getState();
		final substate:MusicBeatSubstate = MusicBeatSubstate.instance;
		var bools:Array<Bool> = [false, false, false, false];

		if (state != null)
		{
			if (state.touchPad != null)
				bools[0] = state.touchPad.buttonReleased(id);

			if (state.hitbox != null)
				bools[1] = state.hitbox.instance.buttonReleased(id);
				
			if (state.mobileControls != null)
				bools[1] = state.mobileControls.instance.buttonReleased(id);
		}

		if (substate != null)
		{
			if (substate.touchPad != null)
				bools[2] = substate.touchPad.buttonReleased(id);

			if (substate.hitbox != null)
				bools[3] = substate.hitbox.instance.buttonReleased(id);
				
			if (substate.mobileControls != null)
				bools[3] = substate.mobileControls.instance.buttonReleased(id);
		}	

		return bools.contains(true);
	}
	#end

	public function getMobileIDFromControl(control:Control):MobileInputID
	{
		#if TOUCH_CONTROLS
		return switch (control)
		{
			case UP: MobileInputID.UP;
			case DOWN: MobileInputID.DOWN;
			case LEFT: MobileInputID.LEFT;
			case RIGHT: MobileInputID.RIGHT;
			case NOTE_UP: MobileInputID.NOTE_UP;
			case NOTE_DOWN: MobileInputID.NOTE_DOWN;
			case NOTE_LEFT: MobileInputID.NOTE_LEFT;
			case NOTE_RIGHT: MobileInputID.NOTE_RIGHT;
			case ACCEPT: MobileInputID.A;
			case BACK: MobileInputID.B;
			case PAUSE: MobileInputID.P;
			default: MobileInputID.NONE;
		}
		#else
		return null; // jumpscare
		#end
	}

	public inline function getJustPressed(name:String) {
		return ControlsUtil.getJustPressed(this, name);
	}

	public inline function getJustReleased(name:String) {
		return ControlsUtil.getJustReleased(this, name);
	}

	public inline function getPressed(name:String) {
		return ControlsUtil.getPressed(this, name);
	}
}
