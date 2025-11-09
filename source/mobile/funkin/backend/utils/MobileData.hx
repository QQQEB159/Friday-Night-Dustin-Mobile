/*
 * Copyright (C) 2025 Mobile Porting Team
 *
 * Permission is hereby granted, free of charge, to any person obtaining a
 * copy of this software and associated documentation files (the "Software"),
 * to deal in the Software without restriction, including without limitation
 * the rights to use, copy, modify, merge, publish, distribute, sublicense,
 * and/or sell copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
 * DEALINGS IN THE SOFTWARE.
 */

package mobile.funkin.backend.utils;

#if TOUCH_CONTROLS
import haxe.ds.Map;
import haxe.Json;
import haxe.io.Path;
import openfl.utils.Assets;

/**
 * ...
 * @author: Karim Akra
 */
class MobileData
{
	public static var actionModes:Map<String, TouchButtonsData> = new Map();
	public static var dpadModes:Map<String, TouchButtonsData> = new Map();

	public static var mode(get, set):Int;
	public static var forcedMode:Null<Int>;

	public static function init()
	{
		for (folder in [
			'${ModsFolder.modsPath}${ModsFolder.currentModFolder}/mobile',
			Paths.getPath('mobile')
		])
			if (FileSystem.exists(folder) && FileSystem.isDirectory(folder))
			{
				setMap('$folder/DPadModes', dpadModes);
				setMap('$folder/ActionModes', actionModes);
			}
	}

	public static function setMap(folder:String, map:Map<String, TouchButtonsData>)
	{
		for (file in FileSystem.readDirectory(folder))
		{
			if (Path.extension(file) == 'json')
			{
				file = Path.join([folder, Path.withoutDirectory(file)]);
				var str = File.getContent(file);
				var json:TouchButtonsData = cast Json.parse(str);
				var mapKey:String = Path.withoutDirectory(Path.withoutExtension(file));
				map.set(mapKey, json);
			}
		}
	}
	
	public static function setTouchPadCustom(touchPad:TouchPad):Void
	{
		if (FlxG.save.data.buttons == null)
		{
			FlxG.save.data.buttons = new Array();
			for (buttons in touchPad)
				FlxG.save.data.buttons.push(FlxPoint.get(buttons.x, buttons.y));
		}
		else
		{
			var tempCount:Int = 0;
			for (buttons in touchPad)
			{
				FlxG.save.data.buttons[tempCount] = FlxPoint.get(buttons.x, buttons.y);
				tempCount++;
			}
		}

		FlxG.save.flush();
	}

	public static function getTouchPadCustom(touchPad:TouchPad):TouchPad
	{
		var tempCount:Int = 0;

		if (FlxG.save.data.buttons == null)
			return touchPad;

		for (buttons in touchPad)
		{
			if (FlxG.save.data.buttons[tempCount] != null)
			{
				buttons.x = FlxG.save.data.buttons[tempCount].x;
				buttons.y = FlxG.save.data.buttons[tempCount].y;
			}
			tempCount++;
		}

		return touchPad;
	}
	
	static function set_mode(mode:Int = 3)
	{
		FlxG.save.data.mobileControlsMode = mode;
		FlxG.save.flush();
		return mode;
	}

	static function get_mode():Int
	{
		if (forcedMode != null)
			return forcedMode;

		if (FlxG.save.data.mobileControlsMode == null)
		{
			FlxG.save.data.mobileControlsMode = 3;
			FlxG.save.flush();
		}

		return FlxG.save.data.mobileControlsMode;
	}
}

typedef TouchButtonsData =
{
	buttons:Array<ButtonsData>
}

typedef ButtonsData =
{
	button:String, // what TouchButton should be used, must be a valid TouchButton var from TouchPad as a string.
	graphic:String, // the graphic of the button, usually can be located in the TouchPad xml .
	x:Float, // the button's X position on screen.
	y:Float, // the button's Y position on screen.
	color:String // the button color, default color is white.
}
#end
