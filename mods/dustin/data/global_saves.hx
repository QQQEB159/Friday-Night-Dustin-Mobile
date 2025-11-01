//
import Lambda;
import String;
import StringTools;
import Type;
import flixel.util.FlxSave;
import funkin.savedata.FunkinSave;
import haxe.Unserializer;
import haxe.ds.StringMap;
import lime.system.System;
import openfl.net.SharedObject;
#if sys
import sys.FileSystem;
import sys.io.File;
#end


static function load_save() {
    // cuz only windows users had the old build accessible, if someone used a compatibility layer it was inside another path anyways, also this potentially crashes in mac, soo  - Nex
    #if windows
    migrate_save();
    #end

    FlxG.save.data.dustinBoughtStuff ??= [];
    FlxG.save.data.mechanics ??= true;
    FlxG.save.data.nh ??= false;
    FlxG.save.data.dustinSeenUnlockAnims ??= [];
    FlxG.save.data.dustinCash ??= 0;
    FlxG.save.data.dustinBeatEverything ??= false;
    FlxG.save.data.gSwag ??= true;

    FlxG.save.data.dustinMigrated = true;

    load_shaders_data();

    Options.devMode = false;

    // CAUSES ISSUES WITH MEMORY
    Options.streamedMusic = false;
    Options.streamedVocals = false;

    // Chezz killed me
    Options.colorHealthBar = true;
}

static function migrate_save() {
    if (!FlxG.save.data.dustinMigrated || FlxG.save.data.dustinMigrated == null) {
        trace("No Dustin' PATCH save data found, checking for Dustin' V1 save data...");
        var oldSave:FlxSave = new FlxSave();
        oldSave.bind("dustin", "Chezzar");
        if (!oldSave.isEmpty()) {
            trace("Dustin' V1 save data found, migrating...");

            // resetting the shaders cuz theres a whole new menu for that now  - Nex
            oldSave.data.bloom = null;
            oldSave.data.particles = null;
            oldSave.data.godrays = null;
            oldSave.data.distortion = null;
            FlxG.save.mergeData(oldSave.data, true);

            // silly solutions for backwards compat -lunar
            var savePath:String = StringTools.replace(System.applicationStorageDirectory, "Chezzar\\dustin\\", "") + "YoshiCrafter29/CodenameEngine" + "\\" + "save-default" + ".sol";
            var encodedData:String = null;

            savePath = StringTools.replace(savePath, "//", "/");
            savePath = StringTools.replace(savePath, "\\", "/");

            trace("Searching " + savePath + " for high scores...");

            if (FileSystem.exists(savePath)) encodedData = File.getContent(savePath);
            var rawData:Dynamic = null;

            if (encodedData != null) {
                try {
                    buf = encodedData;
                    length = buf.length;
                    pos = 0;

                    scache = [];
		            cache = [];

                    resolver = {resolveEnum: Type.resolveEnum, resolveClass: SharedObject.__resolveClass};
                    rawData = unserialize();
                } catch (e:Dynamic) {}
            }

            if (rawData != null && Lambda.count(rawData.highscores) > 0) {
                trace("HIGH SCORES FOUND!!!", rawData.highscores);

                FunkinSave.highscores = rawData.highscores;
                FunkinSave.flush();

                update_dustin_scores();
                FlxG.save.flush();

                trace("Migrated EXP and purchases, finished migrating.");
            } else {
                FlxG.save.data.dustinBeatEverything = false;
                trace("Migrated EXP and purchases but couldn't migrate highscores data, finished migrating.");
            }
        } else {
            trace("No Dustin' V1 save data found.");
            oldSave.close();
        }
    }
}

static function load_shaders_data() {
    FlxG.save.data.bloom ??= true;
    FlxG.save.data.particles ??= true;
    FlxG.save.data.godrays ??= true;
    FlxG.save.data.glitch ??= true;

    FlxG.save.data.fog ??= true;
    FlxG.save.data.water ??= true;
    FlxG.save.data.chromwarp ??= true;
    FlxG.save.data.warp ??= true;
    FlxG.save.data.fire ??= true;

    FlxG.save.data.static ??= true;
    FlxG.save.data.pixel ??= true;
    FlxG.save.data.saturation ??= true;
    FlxG.save.data.impact ??= true;
}

static function set_shaders_high() {
    Options.gameplayShaders = true;

    FlxG.save.data.bloom = true;
    FlxG.save.data.particles = true;
    FlxG.save.data.godrays = true;
    FlxG.save.data.glitch = true;

    FlxG.save.data.fog = true;
    FlxG.save.data.water = true;
    FlxG.save.data.chromwarp = true;
    FlxG.save.data.warp = true;
    FlxG.save.data.fire = true;

    FlxG.save.data.static = true;
    FlxG.save.data.pixel = true;
    FlxG.save.data.saturation = true;
    FlxG.save.data.impact = true;
}

static function set_shaders_low() {
    Options.gameplayShaders = false;

    FlxG.save.data.bloom = false;
    FlxG.save.data.particles = false;
    FlxG.save.data.godrays = false;
    FlxG.save.data.glitch = false;

    FlxG.save.data.fog = false;
    FlxG.save.data.water = false;
    FlxG.save.data.chromwarp = false;
    FlxG.save.data.warp = false;
    FlxG.save.data.fire = false;

    FlxG.save.data.static = false;
    FlxG.save.data.pixel = false;
    FlxG.save.data.saturation = false;
    FlxG.save.data.impact = false;
}

static function update_dustin_scores() {
    var songsList:Array<String> = [for (song in Paths.getFolderDirectories('songs', false, 1)) song.toLowerCase()];

    for (song in FunkinSave.highscores.keys()) {
		var enumParams:Array<Dynamic> = Type.enumParameters(song);
        if (songsList.contains((enumParams[0])) && !FlxG.save.data.dustinBoughtStuff.contains((enumParams[0]))) 
            FlxG.save.data.dustinBoughtStuff.push(enumParams[0]);
	}
}

static var FULL_VOLUME:Bool = false;

static var weekPlaylist:Array<Dynamic> = [];
static var weekDifficulty:String = "";

#if windows
// REIMPLEMENTED SERIALIZER 
function get(p:Int):Int {
    return StringTools.fastCodeAt(buf, p);
}

function readDigits() {
    var k = 0;
    var s = false;
    var fpos = pos;
    while (true) {
        var c = get(pos);
        if (StringTools.isEof(c))
            break;
        if (c == 45) {
            if (pos != fpos)
                break;
            s = true;
            pos++;
            continue;
        }
        if (c < 48 || c > 57)
            break;
        k = k * 10 + (c - 48);
        pos++;
    }
    if (s)
        k *= -1;
    return k;
}

function readFloat() {
    var p1 = pos;
    while (true) {
        var c = get(pos);
        if (StringTools.isEof(c))
            break;
        // + - . , 0-9
        if ((c >= 43 && c < 58) || c == 101 || c == 69)
            pos++;
        else
            break;
    }
    return Std.parseFloat(fastSubstr(buf, p1, pos - p1));
}

function unserializeObject(o:{}) {
    while (true) {
        if (pos >= length)
            throw "Invalid object";
        if (get(pos) == 103)
            break;
        var k:Dynamic = unserialize();
        if (!Std.isOfType(k, String))
            throw "Invalid object key";
        var v = unserialize();
        Reflect.setField(o, k, v);
    }
    pos++;
}

function unserializeEnum(edecl:Enum, tag:String) {
    if (get(pos++) != 58)
        throw "Invalid enum format";
    var nargs = readDigits();
    if (nargs == 0)
        return Type.createEnum(edecl, tag);
    var args = [];
    while (nargs-- > 0)
        args.push(unserialize());
    // !! ADDED FOR DUSTIN
    if (edecl == "funkin.savedata.HighscoreEntry" && tag == "HSongEntry" && args.length <= 3) {
        args.insert(2, null);
    }
    return Type.createEnum(edecl, tag, args);
}

var buf:String;
var pos:Int;
var length:Int;
var cache:Array<Dynamic>;
var scache:Array<String>;
var resolver:TypeResolver;
function unserialize():Dynamic {
    switch (get(pos++)) {
        case 110:
            return null;
        case 116:
            return true;
        case 102:
            return false;
        case 122:
            return 0;
        case 105:
            return readDigits();
        case 100:
            return readFloat();
        case 121:
            var len = readDigits();
            if (get(pos++) != 58 || length - pos < len)
                throw "Invalid string length";
            var s = fastSubstr(buf, pos, len);
            pos += len;
            s = StringTools.urlDecode(s);
            scache.push(s);
            return s;
        case 107:
            return Math.NaN;
        case 109:
            return Math.NEGATIVE_INFINITY;
        case 112:
            return Math.POSITIVE_INFINITY;
        case 97:
            var buf = buf;
            var a = [];
            cache.push(a);
            while (true) {
                var c = get(pos);
                if (c == 104) {
                    pos++;
                    break;
                }
                if (c == 117) {
                    pos++;
                    var n = readDigits();
                    a[a.length + n - 1] = null;
                } else
                    a.push(unserialize());
            }
            return a;
        case 111:
            var o = {};
            cache.push(o);
            unserializeObject(o);
            return o;
        case 114:
            var n = readDigits();
            if (n < 0 || n >= cache.length)
                throw "Invalid reference";
            return cache[n];
        case 82:
            var n = readDigits();
            if (n < 0 || n >= scache.length)
                throw "Invalid string reference";
            return scache[n];
        case 120:
            throw unserialize();
        case 99:
            var name = unserialize();
            var cl = resolver.resolveClass(name);
            if (cl == null)
                throw "Class not found " + name;
            var o = Type.createEmptyInstance(cl);
            cache.push(o);
            unserializeObject(o);
            return o;
        case 119:
            var name = unserialize();
            var edecl = resolver.resolveEnum(name);
            if (edecl == null)
                throw "Enum not found " + name;
            var e = unserializeEnum(edecl, unserialize());
            cache.push(e);
            return e;
        case 106:
            var name = unserialize();
            var edecl = resolver.resolveEnum(name);
            if (edecl == null)
                throw "Enum not found " + name;
            pos++; /* skip ':' */
            var index = readDigits();
            var tag = Type.getEnumConstructs(edecl)[index];
            if (tag == null)
                throw "Unknown enum index " + name + "@" + index;
            var e = unserializeEnum(edecl, tag);
            cache.push(e);
            return e;
        case 108:
            var l = new List();
            cache.push(l);
            var buf = buf;
            while (get(pos) != 104)
                l.add(unserialize());
            pos++;
            return l;
        case 98:
            var h = new StringMap();
            cache.push(h);
            var buf = buf;
            while (get(pos) != 104) {
                var s = unserialize();
                h.set(s, unserialize());
            }
            pos++;
            return h;
        case 113:
            var h = new haxe.ds.IntMap();
            cache.push(h);
            var buf = buf;
            var c = get(pos++);
            while (c == 58) {
                var i = readDigits();
                h.set(i, unserialize());
                c = get(pos++);
            }
            if (c != 104)
                throw "Invalid IntMap format";
            return h;
        case 77:
            var h = new haxe.ds.ObjectMap();
            cache.push(h);
            var buf = buf;
            while (get(pos) != 104) {
                var s = unserialize();
                h.set(s, unserialize());
            }
            pos++;
            return h;
        case 118:
            var d;
            if (get(pos) >= 48 && get(pos) <= 57 && get(pos + 1) >= 48 && get(pos + 1) <= 57 && get(pos + 2) >= 48
                && get(pos + 2) <= 57 && get(pos + 3) >= 48 && get(pos + 3) <= 57 && get(pos + 4) == 45) {
                // Included for backwards compatibility
                d = Date.fromString(fastSubstr(buf, pos, 19));
                pos += 19;
            } else
                d = Date.fromTime(readFloat());
            cache.push(d);
            return d;
        case 115:
            var len = readDigits();
            var buf = buf;
            if (get(pos++) != 58 || length - pos < len)
                throw "Invalid bytes length";
            var codes = Unserializer.CODES;
            if (codes == null) {
                codes = Unserializer.initCodes();
                Unserializer.CODES = codes;
            }
            var i = pos;
            var rest = len & 3;
            var size = (len >> 2) * 3 + ((rest >= 2) ? rest - 1 : 0);
            var max = i + (len - rest);
            var bytes = haxe.io.Bytes.alloc(size);
            var bpos = 0;
            while (i < max) {
                var c1 = codes[StringTools.fastCodeAt(buf, i++)];
                var c2 = codes[StringTools.fastCodeAt(buf, i++)];
                bytes.set(bpos++, (c1 << 2) | (c2 >> 4));
                var c3 = codes[StringTools.fastCodeAt(buf, i++)];
                bytes.set(bpos++, (c2 << 4) | (c3 >> 2));
                var c4 = codes[StringTools.fastCodeAt(buf, i++)];
                bytes.set(bpos++, (c3 << 6) | c4);
            }
            if (rest >= 2) {
                var c1 = codes[StringTools.fastCodeAt(buf, i++)];
                var c2 = codes[StringTools.fastCodeAt(buf, i++)];
                bytes.set(bpos++, (c1 << 2) | (c2 >> 4));
                if (rest == 3) {
                    var c3 = codes[StringTools.fastCodeAt(buf, i++)];
                    bytes.set(bpos++, (c2 << 4) | (c3 >> 2));
                }
            }
            pos += len;
            cache.push(bytes);
            return bytes;
        case 67:
            var name = unserialize();
            var cl = resolver.resolveClass(name);
            if (cl == null)
                throw "Class not found " + name;
            var o:Dynamic = Type.createEmptyInstance(cl);
            cache.push(o);
            o.hxUnserialize(this);
            if (get(pos++) != 103)
                throw "Invalid custom data";
            return o;
        case 65:
            var name = unserialize();
            var cl = resolver.resolveClass(name);
            if (cl == null)
                throw "Class not found " + name;
            return cl;
        case 66:
            var name = unserialize();
            var e = resolver.resolveEnum(name);
            if (e == null)
                throw "Enum not found " + name;
            return e;
        default:
    }
    pos--;
    throw "Invalid char " + fastCharAt(buf, pos) + " at position " + pos;
}

#if neko
static var base_decode = neko.Lib.load("std", "base_decode", 2);
#end

function fastLength(s:String):Int {
    #if php
    return php.Global.strlen(s);
    #else
    return s.length;
    #end
}

function fastCharCodeAt(s:String, pos:Int):Int {
    #if php
    return php.Global.ord((s:php.NativeString)[pos]);
    #else
    return s.charCodeAt(pos);
    #end
}

function fastCharAt(s:String, pos:Int):String {
    #if php
    return (s:php.NativeString)[pos];
    #else
    return s.charAt(pos);
    #end
}

function fastSubstr(s:String, pos:Int, length:Int):String {
    #if php
    return php.Global.substr(s, pos, length);
    #else
    return s.substr(pos, length);
    #end
}
#end