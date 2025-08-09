#if !macro
#if TOUCH_CONTROLS
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import flixel.util.FlxDestroyUtil;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.sound.FlxSound;
import funkin.backend.assets.ModsFolder;
import funkin.backend.assets.Paths;
import funkin.backend.utils.CoolUtil;
import funkin.options.Options;
import mobile.objects.TouchButton;
import mobile.objects.TouchPad;
import mobile.flixel.system.FlxShader;
import mobile.funkin.backend.utils.MobileData;
import mobile.funkin.backend.system.input.MobileInputID;
import mobile.funkin.backend.system.input.MobileInputManager;
#end
import mobile.funkin.backend.utils.StorageUtil;
import funkin.backend.utils.NativeAPI;

#if android
import android.content.Context as AndroidContext;
import android.os.Environment as AndroidEnvironment;
import android.Permissions as AndroidPermissions;
import android.Settings as AndroidSettings;
import android.os.Build.VERSION as AndroidVersion;
import android.os.Build.VERSION_CODES as AndroidVersionCode;
#end

#if sys
import sys.FileSystem;
import sys.io.File;
#end

using StringTools;
#end