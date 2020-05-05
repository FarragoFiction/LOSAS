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
    static TextAreaElement dataStringElement;
    static InputElement nameElement;
    static InputElement beforeTextElement;
    static InputElement afterTextElement;

    static void makeSceneBuilder(Element parent) {
        DivElement formHolder = new DivElement()..classes.add("formHolder");
        parent.append(formHolder);
        scene = new Scene("Example Scene","The text before things happen. Uses markup like this [TARGET.STRINGMEMORY.name]. JR NOTE: make this insertable.","The text AFTER things happen. Any changes will reflect here, such as new names, or whatever.");

        dataStringElement = attachAreaElement(formHolder, "DataString:", "${scene.toDataString()}", (e) => syncSceneToDataString);
        nameElement = attachInputElement(formHolder, "Scene Name:", "${scene.name}", (e)
        {
            scene.name = e.target.value;
            syncDataStringToScene();
        });

    }

    static void syncDataStringToScene() {
        print("syncing datastring to scene");
        dataStringElement.value = scene.toDataString();
    }

    //TODO boy i really hope this doesn't trigger syncDataStringToScene
    static void syncSceneToDataString(e) {
        print("syncing scene to datastring");
        scene.loadFromSerialization(e.target.value);
        nameElement.value = scene.name;
    }



}