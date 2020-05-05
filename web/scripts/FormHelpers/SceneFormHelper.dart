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
    static TextAreaElement beforeTextElement;
    static TextAreaElement afterTextElement;
    static CheckboxInputElement targetOneElement;

    static void makeSceneBuilder(Element parent) {
        DivElement formHolder = new DivElement()..classes.add("formHolder");
        parent.append(formHolder);
        scene = new Scene("Example Scene","The text before things happen. Uses markup like this [TARGET.STRINGMEMORY.name]. JR NOTE: make this insertable.","The text AFTER things happen. Any changes will reflect here, such as new names, or whatever.");

        dataStringElement = attachAreaElement(formHolder, "DataString:", "${scene.toDataString()}", (e) => syncSceneToDataString(e));
        nameElement = attachInputElement(formHolder, "Scene Name:", "${scene.name}", (e)
        {
            scene.name = e.target.value;
            syncDataStringToScene();
        });

        beforeTextElement = attachAreaElement(formHolder, "Before Text:", "${scene.beforeFlavorText}", (e)
        {
            scene.beforeFlavorText = e.target.value;
            syncDataStringToScene();
        });

        afterTextElement = attachAreaElement(formHolder, "After Text:", "${scene.afterFlavorText}", (e)
        {
            scene.afterFlavorText = e.target.value;
            syncDataStringToScene();
        });

        targetOneElement = attachCheckInputElement(formHolder, "Single Target", scene.targetOne, (e)
        {
            scene.targetOne = e.target.checked;
            syncDataStringToScene();
        });

    }

    static void syncDataStringToScene() {
        print("syncing datastring to scene");
        dataStringElement.value = scene.toDataString();
    }

    static void syncSceneToDataString(e) {
        print("syncing scene to datastring");
        try {
            scene.loadFromDataString(e.target.value);
        }catch(e) {
            window.alert("Look. Don't waste this. Either copy and paste in a valid datastring, or don't touch this.");
        }
        nameElement.value = scene.name;
        beforeTextElement.value = scene.beforeFlavorText;
        afterTextElement.value = scene.afterFlavorText;
        targetOneElement.checked = scene.targetOne;
    }



}