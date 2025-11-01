//

import hscript.TemplateClass;
import Reflect;

static function scriptObject(script:Script):TemplateClass {
    var scriptClass:TemplateClass = new TemplateClass();
    Reflect.setField(scriptClass, "__interp", script.interp);

    return scriptClass;
}