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
    static Element filterHolder;
    static Element actionHolder;

    static void makeSceneBuilder(Element parent) {
        DivElement formHolder = new DivElement()..classes.add("formHolder")..text = "TODO need a button to add markup to before and after flavor text, as well as a preview of it with replacement stuff, also nested filters/effects";
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

        makeFilters(formHolder);
        makeActions(formHolder);

    }

    static void makeFilters(Element parent) {
        filterHolder = new DivElement()..classes.add("subholder");
        Element header = HeadingElement.h1()..text = "Add TargetFilters";
        filterHolder.append(header);
        Element desc = new DivElement()..text = "Control what sorts of entities are valid targets of this scene (if there are no valid targets, the scene will not trigger).";
        filterHolder.append(desc);
        parent.append(filterHolder);
        //filterHolder.text = "TODO: NEED A DROP DOWN OF ALL POSSIBLE FILTERS. CHOOSING ONE ADDS A FILTER OF THAT TYPE TO THE SCENE, THEN RESYNCS. ";
    }

    static void makeActions(Element parent) {
        actionHolder = new DivElement()..classes.add("subholder");
        Element header = HeadingElement.h1()..text = "Add ActionEffects";
        actionHolder.append(header);
        Element desc = new DivElement()..text = "Controls the post trigger effects on the valid targets or owner.";
        actionHolder.append(desc);
        parent.append(actionHolder);
        //actionHolder.text = "TODO: NEED A DROP DOWN OF ALL POSSIBLE ACTIONS. CHOOSING ONE ADDS An action OF THAT TYPE TO THE SCENE, THEN RESYNCS. ";
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
        //TODO HANDLE LOADING FILTERS/ACTIONS
    }



}