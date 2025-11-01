var move:Bool = true;
var before:Float;
var heat2:CustomShader = null;
var boyfriendBaseY:Float = 0;
var floatTime:Float = 0;
var boyfriendTrails:Array<FlxSprite> = [];
var startMoving:Bool = false;
var modosexoactivado:Bool = false;

function onPostCountdown(event) event.sprite?.color = ratingColor;
function create() {
    heat2 = new CustomShader("waterDistortion");
    if (Options.gameplayShaders && FlxG.save.data.water) FlxG.camera.addShader(heat2);
    heat2.strength = 0;
}
function postCreate() {    
    before = strumLineBfZoom;
    strumLineBfZoom = 1.4;

    walls.visible = false;
    door.visible = false;
    table_back.visible = false;
    chair_back.visible = false;
    chair.visible = false;
    cup.visible = false;
    table.visible = false;

    bunny.visible = false;
    hoodie_bunnies.visible = false;
    muffet.visible = false;
    temmie.visible = false;

    //add(blackOverlay);
}

function sansSpeaks() {
    strumLineBfZoom = before;
    camZoomLerpMult = 0.2;
}


function papsWhat() {
    var kys = dad.getCameraPosition();
    FlxTween.tween(camFollow, {y: kys.y, x: kys.x}, ((Conductor.crochet / 4) / 1000) * 14, {onComplete: function(_) {
        camZoomLerpMult = 1;
        curCameraTarget = 0;
        move = true;
    }});
    move = false;
}

function onCameraMove(event) {
    event.cancelled = !move;
}

function stepHit(step:Int) {
    switch (step) {
        case 944:
            bg.visible = false;
            bg_spark.visible = false;
            shading.visible = false;

            walls.visible = true;
            door.visible = true;
            table_back.visible = true;
            chair_back.visible = true;
            chair.visible = true;
            cup.visible = true;
            table.visible = true;
            heat2.strength = 0.2;

            bunny.visible = true;
            hoodie_bunnies.visible = true;
            muffet.visible = true;
            temmie.visible = true;
            stage.getSprite("bunny").playAnim("idle");
            stage.getSprite("hoodie_bunnies").playAnim("idle");
            stage.getSprite("muffet").playAnim("idle");
            stage.getSprite("temmie").playAnim("idle");

        case 1456:
            bg.visible = true;
            bg_spark.visible = true;
            shading.visible = true;
            heat2.strength = 0;

            walls.visible = false;
            door.visible = false;
            table_back.visible = false;
            chair_back.visible = false;
            chair.visible = false;
            cup.visible = false;
            table.visible = false;

            bunny.visible = false;
            hoodie_bunnies.visible = false;
            muffet.visible = false;
            temmie.visible = false;

        case 2256:
            modosexoactivado = true;

            strumLines.members[0].notes.forEach((note:Note) -> {note.visible = true;});
            bg.visible = false;
            bg_spark.visible = false;
            shading.visible = false;
            for (element in [dustinHealthBG, dustinHealthBar, dustiniconP1, dustiniconP2, timeBarBG, timeBar])
                element.visible = false;

            for (element in [scoreTxt, missesTxt, accuracyTxt]) element.y -= 10;

            dad.alpha = 0.00000000001;

        case 2515:
            boyfriendBaseY = boyfriend.y;
            startMoving = true;


        case 1328:
            stage.getSprite("hoodie_bunnies").playAnim("die");
            FlxG.camera.shake(0.01, 0.2);

        case 1336:
            FlxTween.tween(hoodie_bunnies, {alpha: 0}, 0.5, {ease: FlxEase.quadOut});



        case 1360:
            stage.getSprite("muffet").playAnim("die");
            FlxG.camera.shake(0.01, 0.2);
            
        case 1368:
            FlxTween.tween(muffet, {alpha: 0}, 0.5, {ease: FlxEase.quadOut});



        case 1392:
            stage.getSprite("bunny").playAnim("die");
            FlxG.camera.shake(0.01, 0.2);

        case 1400:
            FlxTween.tween(bunny, {alpha: 0}, 0.5, {ease: FlxEase.quadOut});



        case 1424:
            stage.getSprite("temmie").playAnim("die");
            FlxG.camera.shake(0.01, 0.2);

        case 1430:
            FlxTween.tween(temmie, {alpha: 0}, 0.5, {ease: FlxEase.quadOut});
    }
}

var tottalTimer:Float = FlxG.random.float(50, 100);

function update(elapsed:Float){

    if (modosexoactivado == true) {
        health = 2.0;
    }

    heat2?.time = (tottalTimer += elapsed);
    if (startMoving) {
        floatTime += elapsed;
        var floatOffset = Math.sin(floatTime * Math.PI) * 20;
        boyfriend.y = boyfriendBaseY + floatOffset;

        if (FlxG.game.ticks % 3 == 0) {
            var trail = new FlxSprite(boyfriend.x, boyfriend.y);
            trail.frames = boyfriend.frames;
            trail.animation.copyFrom(boyfriend.animation);
            trail.animation.curAnim.curFrame = boyfriend.animation.curAnim.curFrame;

            trail.offset.set(boyfriend.offset.x, boyfriend.offset.y);
            trail.origin.set(boyfriend.origin.x, boyfriend.origin.y);

            trail.scale.set(boyfriend.scale.x, boyfriend.scale.y);
            trail.flipX = boyfriend.flipX;
            trail.alpha = 0.4;
            trail.color = boyfriend.color;
            trail.antialiasing = Options.antialiasing;
            trail.scrollFactor.set(boyfriend.scrollFactor.x, boyfriend.scrollFactor.y);
            trail.camera = boyfriend.camera;

            trail.setPosition(boyfriend.x, boyfriend.y);

            insert(members.indexOf(boyfriend), trail);
            boyfriendTrails.push(trail);


            if (trail != null) boyfriendTrails.push(trail);
        }

        for (trail in boyfriendTrails.copy()) {
            if (trail != null && !trail.destroyed) {
                trail.alpha -= elapsed * 2;
                trail.y += 100 * elapsed;
                if (trail.alpha <= 0) {
                    boyfriendTrails.remove(trail);
                    trail.destroy();
                }
            }
        }

    }
}