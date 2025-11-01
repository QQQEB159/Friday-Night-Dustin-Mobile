// 
function onEvent(eventEvent) {
    if (eventEvent.event.name == "Camera Speed") 
	    camGame.followLerp = eventEvent.event.params[0];
}