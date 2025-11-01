//
import funkin.backend.scripting.Script;
import funkin.backend.MusicBeatState;
import flixel.util.FlxSpriteUtil;
import Xml;

importClass("data.scripts.classes.overworld.MainChara", __script__);

class RoomLoader {
    public var LAYER_UNKNOWN:Int = -1;
    public var LAYER_COLLISION:Int = 0;
    public var LAYER_OBJECTS:Int = 1;
    public var LAYER_IMAGE:Int = 2;

    public var xml:Xml = null;
    public var layers:Array<{name:String, type:Int, data:Dynamic}> = [];

    public var imageLayer:Dynamic = null;
    public var collisionLayer:Dynamic = null;
    public var objectsLayer:Dynamic = null;

    public var player:MainChara = null;

    public function new(path:String) {
        if (path != null && Assets.exists(path))
            parse(Xml.parse(Assets.getText(path)).firstElement());
    }

    public function parse(xml:Xml) {
        var tmxObjects:Array<Xml> = [for (i in 0...Std.int(Std.parseFloat(xml.get("nextobjectid")))) null];
        
        for (xmllayer in xml.elements()) {
            for (xmlobject in xmllayer.elements())
                if (xmlobject.nodeName == "object")
                    tmxObjects[Std.int(Std.parseFloat(xmlobject.get("id")))-1] = xmlobject;

            switch (xmllayer.nodeName) {
                case "objectgroup":
                    var layer:{name:String, type:Int, objects:Array<Dynamic>} = {
                        name: xmllayer.get("name"),
                        type: LAYER_UNKNOWN,
                        data: null
                    };

                    switch (xmllayer.get("name")) {
                        case "collision":
                            layer.type = LAYER_COLLISION;
                            layer.data = {rects: [], lines: []};

                            for (xmlobject in xmllayer.elements())
                                if (xmlobject.exists("width")) {
                                    layer.data.rects.push({
                                        x: Std.parseFloat(xmlobject.get("x")),
                                        y: Std.parseFloat(xmlobject.get("y")),
                                        w: Std.parseFloat(xmlobject.get("width")),
                                        h: Std.parseFloat(xmlobject.get("height"))
                                    });
                                } else {
                                    var line:{x1:Float, y1:Float, x2:Float, y2:Float, slope:Bool} = {
                                        x1: 0, y1: 0, x2: 0, y2: 0,
                                        slope: false
                                    };

                                    for (element in xmlobject.elements()) {
                                        switch (element.nodeName) {
                                            case "polyline":
                                                var points:Array<Array<Float>> = [
                                                    for (xystring in element.get("points").split(" "))
                                                        for (num in xystring.split(",")) Std.parseFloat(num)
                                                ];

                                                line.x1 = Std.parseFloat(xmlobject.get("x")) + points[0];
                                                line.y1 = Std.parseFloat(xmlobject.get("y")) + points[1];
                                                line.x2 = Std.parseFloat(xmlobject.get("x")) + points[2];
                                                line.y2 = Std.parseFloat(xmlobject.get("y")) + points[3];
                                            case "properties": line.slope = true;
                                        }
                                    }
                                    layer.data.lines.push(line);
                                }
                        case "objects":
                            layer.type = LAYER_OBJECTS;
                            layer.data = {
                                player_enterances: [],
                                room_exits: []
                            }

                            for (xmlobject in xmllayer.elements()) {
                                switch (xmlobject.get("name")) {
                                    case "player":
                                        var player_enterance_id:Int = 0;
                                        var player_enterance:{x:Float, y:Float} = {
                                            x: Std.parseFloat(xmlobject.get("x")),
                                            y: Std.parseFloat(xmlobject.get("y")),
                                            facing: null
                                        };
                                        for (xmlproperty in xmlobject.firstElement().elements()) {
                                            switch (xmlproperty.get("name")) {
                                                case "enterance_id": player_enterance_id = Std.int(Std.parseFloat(xmlproperty.get("value")));
                                                case "enterance_facing": player_enterance.facing = xmlproperty.get("value");
                                            }
                                        }
                                        layer.data.player_enterances[player_enterance_id] = player_enterance;
                                    case "bounds": // nothing, will be grabbed later
                                    case "room_exit":
                                        var room_exit:Dynamic = {
                                            x: Std.parseFloat(xmlobject.get("x")),
                                            y: Std.parseFloat(xmlobject.get("y")),
                                            w: Std.parseFloat(xmlobject.get("width")),
                                            h: Std.parseFloat(xmlobject.get("height")),

                                            next_room: null,
                                            next_enterance_id: -1
                                        };

                                        for (xmlproperty in xmlobject.firstElement().elements()) {
                                            switch (xmlproperty.get("name")) {
                                                case "next_room": room_exit.next_room = xmlproperty.get("value");
                                                case "next_enterance_id": room_exit.next_enterance_id = Std.int(Std.parseFloat(xmlproperty.get("value")));
                                            }
                                        }
                                        layer.data.room_exits.push(room_exit);
                                    default: trace("UNNAMED OBJECT IN OBJECTS LAYER: " + xmlobject);
                                }
                            }
  
                    }

                    layers.push(layer);
                case "imagelayer":
                    var layer:{name:String, type:Int, objects:Array<Dynamic>} = {
                        name: xmllayer.get("name"),
                        type: LAYER_IMAGE,
                        data: {
                            image_path: null,
                            camera_bounds: {x: 0, y: 0, w: 0, h: 0},
                            camera_bounds_id: -1,
                            camera_zoom: -1
                        }
                    };

                    for (xmlobject in xmllayer.elements())
                        switch (xmlobject.nodeName) {
                            case "image":
                                layer.data.image_path = xmlobject.get("source");

                                while (layer.data.image_path .indexOf("../") == 0)
                                    layer.data.image_path = layer.data.image_path.substring(3);
                                layer.data.image_path = "assets/" + layer.data.image_path;
                            case "properties":
                                for (xmlproperty in xmlobject.elements())
                                    switch (xmlproperty.get("name")) {
                                        case "camerazoom":
                                            layer.data.camera_zoom = xmlproperty.get("value");
                                        case "camerabounds":
                                            layer.data.camera_bounds_id = Std.int(Std.parseFloat(xmlproperty.get("value")));
                                    }

                        }

                    layers.push(layer);
            }
        }

        for (layer in layers)
            if (layer.type == LAYER_IMAGE) {
                var xmlobject:Xml = tmxObjects[layer.data.camera_bounds_id-1];
                layer.data.camera_bounds = {
                    x: Std.parseFloat(xmlobject.get("x")),
                    y: Std.parseFloat(xmlobject.get("y")),
                    w: Std.parseFloat(xmlobject.get("width")),
                    h: Std.parseFloat(xmlobject.get("height"))
                };
            }

        for (layer in layers)
            switch (layer.type) {
                case LAYER_COLLISION: if (collisionLayer == null) collisionLayer = layer.data;
                case LAYER_OBJECTS: if (objectsLayer == null) objectsLayer = layer.data;
                case LAYER_IMAGE: if (imageLayer == null) imageLayer = layer.data;
            }
    }

    public function setupPlayer(enterance:Int):MainChara {
        var playerData:{x:Float, y:Float, facing:String} = objectsLayer.player_enterances[enterance];

        player = new MainChara(playerData.x, playerData.y, null, playerData.facing == null ? "d" : playerData.facing);
        FlxG.state.add(player);

        var rects:Array<{x:Float, y:Float, w:Float, h:Float, callback:()->Void}> = collisionLayer.rects;
        for (room_exit in objectsLayer.room_exits)
            rects.push({
                x: room_exit.x,
                y: room_exit.y,
                w: room_exit.w,
                h: room_exit.h,
                callback: () -> {
                    switchRoom(room_exit.next_room, room_exit.next_enterance_id);
                }
            });
    
        player.collisionRects = rects;
        player.collisionLines = collisionLayer.lines;

        return player;
    }

    public function setupCameraBounds() {
        if (imageLayer == null) return;

        FlxG.camera.zoom = imageLayer.camera_zoom;
        FlxG.camera.setScrollBoundsRect(
            imageLayer.camera_bounds.x, 
            imageLayer.camera_bounds.y, 
            imageLayer.camera_bounds.w, 
            imageLayer.camera_bounds.h
        );
    }

    public function setupDebugLayer(width:Int, height:Int) {
        var collisionDebug:FlxSprite = new FlxSprite().makeGraphic(width, height, 0x00FFFFFF);
        FlxG.state.add(collisionDebug);
    
        for (rect in collisionLayer.rects)
            FlxSpriteUtil.drawRect(collisionDebug, rect.x, rect.y, rect.w, rect.h, 0x00FFFFFF, {color: 0xFFFF0000}, {smoothing: false});
    
        for (rect in objectsLayer.room_exits)
            FlxSpriteUtil.drawRect(collisionDebug, rect.x, rect.y, rect.w, rect.h, 0x00FFFFFF, {color: 0xFFFFB300}, {smoothing: false});
    
        for (line in collisionLayer.lines) {
            if (line.slope) {
                var rect:{x:Float, y:Float, w:Float, h:Float} = {
                    x: (line.x1 - (line.x2 < line.x1 ? Math.abs(line.x1 - line.x2) : 0)),
                    y: (line.y1 - (line.y2 < line.y1 ? Math.abs(line.y1 - line.y2) : 0)),
                    w: Math.abs(line.x1 - line.x2),
                    h: Math.abs(line.y1 - line.y2)
                };
                FlxSpriteUtil.drawRect(collisionDebug, rect.x, rect.y, rect.w, rect.h, 0x00FFFFFF, {color: 0xFF00FF00}, {smoothing: false});
            }
            FlxSpriteUtil.drawLine(collisionDebug, line.x1, line.y1, line.x2, line.y2, {color: 0xFFFF0000}, {smoothing: false});
        }
    }

    public function switchRoom(room:String, enterance:Int) {
        if (room == null || room == "null") room = "room_area1";
        if (enterance == null || enterance == -1) enterance = 0;

        Script.staticVariables.set("NEXT_ROOM", room);
        Script.staticVariables.set("NEXT_ENTERANCE", enterance);

        MusicBeatState.skipTransIn = MusicBeatState.skipTransOut = true;
        player.allowCollisions = player.active = false;

        Script.staticVariables["overWorldTransition"](true, () -> {
            FlxG.switchState(new ModState("overworld_rooms/" + room));
        });
    }
}