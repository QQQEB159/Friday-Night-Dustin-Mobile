//

import hscript.TemplateClass;
import Reflect;

static function importClass(file:String, ?script:Script = null):CustomClassHandler {
    var hscript:HScript = importScript(StringTools.replace(file, ".", "/"));
    if (hscript == null) return null;

    var split:Array<String> = file.split(".");
    var className:String = split[split.length-1];

    var _class = hscript.interp.customClasses.get(className);
    if (script != null) script.interp.variables.set(className, _class);

    return _class;
}

static function scriptObject(script:Script):TemplateClass {
    var scriptClass:TemplateClass = new TemplateClass();
    Reflect.setField(scriptClass, "__interp", script.interp);

    return scriptClass;
}