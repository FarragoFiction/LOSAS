/*
    A scene form has the various scene information, as well as 0 or more triggers and actions (like sburbsim) which are nested forms.
    triggers and action subforms render themselves from their hashes.
 */
import 'dart:html';

import '../Scene.dart';
import 'GenericFormHelper.dart';

/*
    TODO have a simple scene builder that syncs name, before and after flavor text
    ability to set targetOne
    ability to pick bg image from list
    ability to add/remove filters/effects
 */
abstract class SceneFormHelper {
    static Scene scene;
    static Element dataStringElement;
    static Element nameElement;
    static Element beforeTextElement;
    static Element afterTextElement;

    static void makeSceneBuilder(Element parent) {
        DivElement formHolder = new DivElement()..classes.add("formHolder");
        parent.append(formHolder);
        scene = new Scene("Example Scene","The text before things happen. Uses markup like this [TARGET.STRINGMEMORY.name]. JR NOTE: make this insertable.","The text AFTER things happen. Any changes will reflect here, such as new names, or whatever.");

        dataStringElement = attachAreaElement(formHolder, "DataString:", "${scene.toDataString()}", (e) => syncSceneToDataString);
    }

    static void syncDataStringToScene(Event e) {
        throw("TODO");
    }

    static void syncSceneToDataString(Event e) {
        throw("TODO");
    }



}