//
import sys.FileSystem;
import funkin.options.type.TextOption;
import funkin.options.type.Checkbox;
import funkin.options.TreeMenuScreen;
import funkin.savedata.FunkinSave;
import funkin.backend.assets.ModsFolder;

function postCreate() {
    bg.visible = false;

    titleLabel.font = Paths.font("8bit-jve.ttf");
    descLabel.font = Paths.font("8bit-jve.ttf");

    titleLabel.size = 48;
    descLabel.size = 24;

    titleLabel.x += 10;
    descLabel.x += 10;
}

function update(elapsed:Float) {
    for (menu in tree) {
        if (menu.health != -1) {
            menu.health = -1;
            switch (menu.rawName) {
                case "optionsTree.gameplay-name":
                    menu.members.remove(menu.members[9]); // remove stream vocals due to issues with memory
                    var noHitCheckbox:Checkbox = null;
                    var mechanicsHitCheckbox:Checkbox = null;
                    var botplayCheckbox:Checkbox = null;

                    menu.insert(1, noHitCheckbox = new Checkbox("No Hit Mode", "Don't miss a note or you lose!!! Effects exp gained after songs (1X Multipler -> 2X Multipler).", "nh", null, FlxG.save.data));
                    menu.insert(1, mechanicsHitCheckbox = new Checkbox("Mechanics", "Enable/Disable Gameplay Mechanics, effects exp gained after songs (1X Multipler -> .5X Multipler).", "mechanics", null, FlxG.save.data));
                    menu.add(botplayCheckbox = new Checkbox("botplay", "If you have poor manual dexterity, just turn this on.", "botplay", null, FlxG.save.data));

                    noHitCheckbox.color = 0xFFC9FEFF;
                    mechanicsHitCheckbox.color = 0xFF8CDBFF;

                    menu.members.remove(menu.members[4]); // remove naughtyness
                case "optionsTree.appearance-name":
                    for (i in 1...5) menu.members.remove(menu.members[1]);
                    menu.members[1].suffix = "/Shaders >";
                case "optionsMenu.advanced":
                    menu.members[0].changedCallback = (val:String) -> {
                        var qualitly:Int = Std.parseInt(val);
                        switch (qualitly) {
                            case 0: // LOW
                                set_shaders_low();
                            case 1: // HIGH
                                set_shaders_high();
                        }

                        if (qualitly <= 1) Options.antialiasing = true;
                        menu.members[1].checked = Options.antialiasing;
                        menu.members[2].checked = Options.gameplayShaders;

                        for (member in 0...menu.members.length) 
                            menu.members[member].locked = false;
                        
                        menu.members[3].locked = qualitly <= 1;
                        menu.members[2].locked = qualitly <= 1;

                        var antialiasing = qualitly == 0 ? false : (qualitly == 1 ? true : Options.antialiasing);
                        FlxG.game.stage.quality = (FlxG.enableAntialiasing = antialiasing) ? 0/*BEST*/ : 2/*LOW*/;
                    };

                    var shaderOption = menu.members[3];
                    menu.members.remove(shaderOption);
                    menu.members.insert(4, shaderOption);

                    menu.members.remove(menu.members[2]); // remove low memory mode
                    menu.members.remove(menu.members[2]); // remove vram sprites option

                    shaderOption.selectCallback = () -> {
                        menu.members[3].locked = !shaderOption.checked;
                    };

                    menu.add(new TextOption("Specific Shaders ", "Change more advanced Shader options.", ">", () -> {
                        var spefShadersTree:TreeMenuScreen = new TreeMenuScreen("Specific Shaders", "Change more advanced Shader options (HIGH END being shaders that lag the most, MEDIUM being shaders that kinda lag, and LOW END being shaders that don't cause issues on most systems).");
                        var highEndText:TextOption = null;
                        spefShadersTree.add(highEndText = new TextOption("High End Shaders ", "", ">", () -> {
                            var intShadersTree:TreeMenuScreen = new TreeMenuScreen("Intensive Shaders", "Change INTENSIVE Shader options (Hardest to run -> easiest to run, top to bottom).");
                            intShadersTree.add(new Checkbox("Bloom Effects", "Enable/Disable Bloom Shaders.", "bloom", null, FlxG.save.data));
                            intShadersTree.add(new Checkbox("God Rays Shaders", "Enable/Disable God Rays Shaders.", "godrays", null, FlxG.save.data));
                            intShadersTree.add(new Checkbox("Particles Shaders", "Enable/Disable Particles Shaders.", "particles", null, FlxG.save.data));
                            intShadersTree.add(new Checkbox("Glitch Shaders", "Enable/Disable Glitch Shaders.", "glitch", null, FlxG.save.data));
                            spefShadersTree.parent.addMenu(intShadersTree);

                            for (i => member in intShadersTree.members)
                                member.color = FlxColor.interpolate(0xFFFE2323, 0xFFFFE3E3, i/intShadersTree.members.length);
                        }));
                        highEndText.color = 0xFFFFACAC;
                        var medEndText:TextOption = null;
                        spefShadersTree.add(medEndText = new TextOption("Medium Shaders ", "", ">", () -> {
                            var medShadersTree:TreeMenuScreen = new TreeMenuScreen("Medium Shaders", "Change MEDIUM Shader options (Hardest to run -> easiest to run, top to bottom).");
                            medShadersTree.add(new Checkbox("Fog Shaders", "Enable/Disable Fog Shaders.", "fog", null, FlxG.save.data));
                            medShadersTree.add(new Checkbox("Water Shaders", "Enable/Disable Water Shaders.", "water", null, FlxG.save.data));
                            medShadersTree.add(new Checkbox("Chromatic Shaders", "Enable/Disable Chromatic Shaders.", "chromwarp", null, FlxG.save.data));
                            medShadersTree.add(new Checkbox("Warp Shaders", "Enable/Disable Warp Shaders.", "warp", null, FlxG.save.data));
                            medShadersTree.add(new Checkbox("Fire Shaders", "Enable/Disable Fire Shaders.", "fire", null, FlxG.save.data));
                            spefShadersTree.parent.addMenu(medShadersTree);

                            for (i => member in medShadersTree.members)
                                member.color = FlxColor.interpolate(0xFFFFF97D, 0xFFFFFFFF, i/medShadersTree.members.length);
                        }));
                        medEndText.color = 0xFFFFF5AC;
                        var lowEndText:TextOption = null;
                        spefShadersTree.add(lowEndText = new TextOption("Low End Shaders ", "", ">", () -> {
                            var lowShadersTree:TreeMenuScreen = new TreeMenuScreen("Low Shaders", "Change LOW Shader options (Hardest to run -> easiest to run, top to bottom).");
                            lowShadersTree.add(new Checkbox("Static Shaders", "Enable/Disable Static Shaders.", "static", null, FlxG.save.data));
                            lowShadersTree.add(new Checkbox("Pixel Shaders", "Enable/Disable Pixel Shaders.", "pixel", null, FlxG.save.data));
                            lowShadersTree.add(new Checkbox("Saturation Shaders", "Enable/Disable Saturation Shaders.", "saturation", null, FlxG.save.data));
                            lowShadersTree.add(new Checkbox("Impact Shaders", "Enable/Disable Impact Shaders.", "impact", null, FlxG.save.data));
                            spefShadersTree.parent.addMenu(lowShadersTree);
                            
                            for (i => member in lowShadersTree.members)
                                member.color = FlxColor.interpolate(0xFF88FF5D, 0xFFFFFFFF, i/lowShadersTree.members.length);
                        }));
                        lowEndText.color = 0xFFC2FFAC;
                        menu.parent.addMenu(spefShadersTree);
                    }));

                    menu.members[0].changedCallback(Std.string(Options.quality));
                    shaderOption.selectCallback();
                case "optionsTree.miscellaneous-name":
                    for (member in 1...5) // get rid of some cne stuff that will mess with the build
                        menu.members.remove(menu.members[1]);

                    #if desktop
                    menu.add(new Checkbox("Genocides Swag", "Uncheck this if you cannot play Genocides. You'll loose a VERY swag surprise....", "gSwag", null, FlxG.save.data));
                    #end

                    if (!FileSystem.exists("dev.txt")) menu.members.shift();

                    for (member in menu.members)
                        if (member.rawText == "MiscOptions.resetSaveData-name") {
                            member.selectCallback = () -> {
                                FunkinSave.save.erase();
                                FunkinSave.highscores.clear();
                                FunkinSave.flush();

                                FlxG.save.erase();
			                    FlxG.save.data.dustinMigrated = true;
                                FlxG.save.flush();

                                ModsFolder.switchMod(ModsFolder.currentModFolder);
                            }
                        }
            }
        }
    }
}