function onCameraMove(camMoveEvent) {
    if (camMoveEvent.strumLine != null && camMoveEvent.strumLine?.characters[0] != null)
        if (!StringTools.contains(camMoveEvent.strumLine.characters[0].animation.name, "sing")) {
            if (__curMulti > 0) {
                camMoveEvent.position.x += Math.sin(time*(30/__curMulti))*__curMulti;
                camMoveEvent.position.y += (Math.sin((time*(30/__curMulti))*2)/2)*(__curMulti*.6);
            }

            if (__angleMulti > 0) camGame.angle = (-Math.sin(time)*.5)*__angleMulti;
        }
}

public var idleSpeed:Float = 1;
var __curMulti:Float = 0;
var __angleMulti:Float = 0;
var time:Float = 0;
function update(elapsed:Float) {
    time += elapsed*idleSpeed;
}

function onEvent(eventEvent) {
    var params:Array = eventEvent.event.params;
    if (eventEvent.event.name == "Idle Cam Movement") {
        __curMulti = params[0];
        __angleMulti = params[1];
    }
}